Shader "Unlit/MyPBR_Direct"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //[NoScaleOffset] _NormalMap ("Normal Map", 2D) = "white" {}
        //[NoScaleOffset] _MetalMap ("Metal Map", 2D) = "white" {}
        //[NoScaleOffset] _RoughMap ("Rough Map", 2D) = "white" {}
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
                //float3 TtoWx : TEXCOORD3;
                //float3 TtoWy : TEXCOORD4;
                //float3 TtoWz : TEXCOORD5;
                float3 worldNormal : TEXCOORD3;
            };

            sampler2D _MainTex, _NormalMap, _MetalMap, _RoughMap;
            float4 _MainTex_ST;
            float _Roughness, _Metallic;

            v2f vert(appdata_tan v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                //float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                //float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                //float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                TRANSFER_SHADOW(o);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                //o.TtoWx = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
                //o.TtoWy = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
                //o.TtoWz = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                //float3 tanNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                //float3 worldNormal = float3(dot(i.TtoWx, tanNormal), dot(i.TtoWy, tanNormal), dot(i.TtoWz, tanNormal));
                //float3 albedo = tex2D(_MainTex, i.uv);
                //float roughness = tex2D(_RoughMap, i.uv);
                //float metallicness = tex2D(_MetalMap, i.uv);

                float3 albedo = tex2D(_MainTex, i.uv);
                float roughness = lerp(0.002, 1, _Roughness);
                float metallicness = _Metallic;

                float3 worldView = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 worldNormal = normalize(i.worldNormal);
                dotData dots = calDots(worldLight, worldView, worldNormal);

                //calculate BRDF
                float F0 = lerp(float3(0.04, 0.04, 0.04), albedo, metallicness);
                float distribute_term = distributionFunc(dots.ndoth, roughness);
                float geometry_term = geometryFunc(dots.ndotv, dots.ndotl, (roughness + 1) * (roughness + 1) * 0.125);
                float3 fresnel_term = fresnelFunc(dots.hdotl, F0);

                float3 f_cook_torrance = distribute_term * geometry_term * fresnel_term * 0.25 / (dots.ndotv * dots.
                    ndotl);
                float3 f_lambert = albedo / UNITY_PI;

                float3 ks = fresnel_term;
                float3 kd = lerp((1 - ks), 0, metallicness);

                float3 color = (kd * f_lambert + f_cook_torrance) * UNITY_PI * _LightColor0 * dots.ndotl;

                float3 shadow = SHADOW_ATTENUATION(i);

                return float4(color * shadow, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}