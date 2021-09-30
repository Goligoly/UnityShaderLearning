Shader "Unlit/MyPBR_IBL_Pre"
{
    Properties
    {
        _Albedo ("Albedo", color) = (1,1,1,1)
        _Roughness ("Roughness", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.5
        [NoScaleOffset] _LUT ("BRDF pre texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque" "LightMode"="ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "pbrbase.cginc"
            #pragma multi_compile_fwdbase

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1)
                float4 worldPos : TEXCOORD2;
                float3 worldNormal : TEXCOORD3;
                float3 worldTangent : TEXCOORD4;
            };

            sampler2D _MainTex, _IndirectIrradianceMap, _PreFilterEnvMap, _LUT;
            float4 _MainTex_ST, _Albedo;
            float _Roughness, _Metallic;

            v2f vert(appdata_tan v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                TRANSFER_SHADOW(o);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldTangent = UnityObjectToWorldDir(v.tangent);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float3 albedo = _Albedo;
                float roughness = lerp(0.002, 0.99, _Roughness);
                float metallicness = _Metallic;

                float3 worldView = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 worldNormal = normalize(i.worldNormal);
                dotData dots = calDots(worldLight, worldView, worldNormal);

                //calculate BRDF
                //direct diffuse & specular
                float3 F0 = lerp(float3(0.04, 0.04, 0.04), albedo, metallicness);
                float distribute_term = distributionFunc(dots.ndoth, roughness);
                float geometry_term = geometryFunc(dots.ndotv, dots.ndotl, (roughness + 1) * (roughness + 1) * 0.125);
                float3 fresnel_term = fresnelFunc(dots.hdotl, F0);

                float3 f_cook_torrance = distribute_term * geometry_term * fresnel_term * 0.25 / (dots.ndotv * dots.
                    ndotl);
                float3 f_lambert = albedo / UNITY_PI;

                float3 shadow = SHADOW_ATTENUATION(i);
                float3 lightRadiance = UNITY_PI * _LightColor0 * shadow;

                float3 ks = fresnel_term;
                float3 kd = lerp((1 - ks), 0, metallicness);

                float3 directResult = saturate((kd * f_lambert + f_cook_torrance) * lightRadiance * dots.ndotl);

                //indirect
                //diffuse
                float4 uv;
                uv.xy = vec2uv(worldNormal);
                float3 indirectDiffuse = tex2D(_IndirectIrradianceMap, uv.xy);
                indirectDiffuse = albedo * indirectDiffuse;

                //specular
                uv.w = roughness / 0.2;
                uv.xy = vec2uv(reflect(-worldView, worldNormal));
                float3 indSpecRadiance = tex2Dlod(_PreFilterEnvMap, uv);

                float2 envBRDF = tex2D(_LUT, float2(dots.ndotv, roughness));
                float3 indirectSpecular = indSpecRadiance * (F0 * envBRDF.r + envBRDF.g);

                float3 indirectResult = kd * indirectDiffuse + indirectSpecular;
                float3 result = directResult + indirectResult;

                return float4(result, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}