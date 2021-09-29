Shader "Unlit/MyPBR_IBL_Simple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Roughness ("Roughness", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.5
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
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
                float3 albedo = tex2D(_MainTex, i.uv);
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
                float3 ambientContrib = ShadeSH9(float4(worldNormal, 1));
                float3 ambient = 0.03 * albedo;
                float3 indirectDiffuse = max(float3(0, 0, 0), ambient + ambientContrib) * albedo;

                //specular
                float3 reflectDir = reflect(-worldView, worldNormal);
                float mipRoughness = roughness * (1.7 - 0.7 * roughness);
                float mip = mipRoughness * UNITY_SPECCUBE_LOD_STEPS;
                float3 indSpecRadiance = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectDir, mip);

                float surfaceReduction = 1.0 / (roughness * roughness + 1.0);
                float oneMinusReflectivity = 1 - max(max(f_cook_torrance.r, f_cook_torrance.g), f_cook_torrance.b);
                float grazingTerm = saturate((1 - roughness) + (1 - oneMinusReflectivity));
                float3 indirectSpecular = indSpecRadiance * surfaceReduction * FresnelLerp(F0, grazingTerm, dots.ndotv);

                float3 indirectResult = kd * indirectDiffuse + indirectSpecular;
                float3 result = directResult + indirectResult;

                return float4(result, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}