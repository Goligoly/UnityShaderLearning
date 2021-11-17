Shader "Unlit/MyPBR_IBL_Monte"
{
    Properties
    {
        _Albedo ("Albedo", color) = (1,1,1,1)
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
                float roughness = lerp(0.002, 1, _Roughness);
                float metallicness = _Metallic;

                float3 worldView = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 worldNormal = normalize(i.worldNormal);
                dotData dots = calDots(worldLight, worldView, worldNormal);

                //calculate BRDF
                //direct diffuse & specular
                float F0 = lerp(float3(0.04, 0.04, 0.04), albedo, metallicness);
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
                float3 indirectDiffuse = uniformSampler(worldNormal);
                indirectDiffuse = albedo * indirectDiffuse;

                //specular
                float3 indirectSpecular = 0;
                int num = 1024;
                float3x3 localCord = genTrans(worldNormal);
                for (int ii = 0; ii < num; ii++)
                {
                    float2 hammersley = hammersleySample(ii, num);
                    float4 sample = importanceSampleGGX(hammersley, roughness);
                    sample.xyz = mul(localCord, sample.xyz);
                    sample.xyz = reflect(-worldView, sample.xyz);
                    float3 radiance = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, sample.xyz);

                    dotData localDots = calDots(sample.xyz, worldView, worldNormal);
                    float localD = distributionFunc(localDots.ndoth, roughness);
                    float localG = geometryFunc(localDots.ndotv, localDots.ndotl, roughness * roughness * 0.5);
                    float3 localF = fresnelFunc(localDots.hdotl, F0);

                    float3 local_spec = localD * localG * localF * 0.25 / (localDots.ndotv * localDots.ndotl);
                    indirectSpecular += max(local_spec * radiance * localDots.ndotl, 0) / sample.w;
                }
                indirectSpecular = indirectSpecular / num;

                float3 kdDiffuse = lerp(fresnelRoughness(dots.ndotv, F0, roughness), 0, metallicness);
                float3 indirectResult = kdDiffuse * indirectDiffuse + indirectSpecular;
                float3 result = directResult + indirectResult;

                return float4(result, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}