Shader "Unlit/SH12"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MetallicGlossMap ("MetallicGlossMap", 2D) = "white" {}
        _Color ("Color", color) = (1,1,1,1)
        _LightPower ("LightPower", Range(0, 1)) = 1.0
        _OcclusionStrength ("OcclusionStrength", Range(0, 1)) = 1.0
        _GIPower ("GIPower", vector) = (1,1,1,1)
        _SpecularColor ("SpecularColor", color) = (1,1,1,1)
        _SpecStrength ("SpecStrength", float) = 0.8
        _SpecShininess ("SpecShininess", Range(0, 1)) = 0.625
        _BumpScale ("BumpScale", Range(0, 1)) = 1.0
        _AmbientHighPos ("AmbientHighPos", Range(0, 1)) = 0.5
        _AlbedoMapScale ("AlbedoMapScale", Range(0, 1)) = 1.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }
            CULL OFF
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma muti_compile LIGHTMAP_OFF LIGHTMAP_ON

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex, _MetallicGlossMap, _unity_ShadowMask;
            float4 _MainTex_ST, _Color, _GIPower, _SpecularColor;
            float _AmbientHighPos, _SpecStrength, _BumpScale, _OcclusionStrength, _AlbedoMapScale, _SpecShininess,
                  _LightPower;

            //fog
            float4 _GlobalFogParam;
            float4 _GlobalFogDistColor;
            float4 _GlobalFogHeightColor;
            float _GlobalFogHeightDis;
            float _GlobalFogHeightDensity;
            float _FogLightRadius;
            float _FogLightSoft;
            float _FogLightHightAtten;
            float _HightFogLightRadius;
            float _HightFogLightSoft;
            float _HightFogLightHightAtten;
            float _FogLightPow;

            struct VS_INPUT
            {
                float4 _in_POSITION0 : POSITION;
                float3 _in_NORMAL0 : NORMAL;
                float2 _in_TEXCOORD0 : TEXCOORD0;
                float2 _in_TEXCOORD1 : TEXCOORD1;
                float4 _in_TANGENT0 : TANGENT;
            };

            struct VS_OUTPUT
            {
                float4 dx_Position : SV_Position;
                float4 gl_Position : TEXCOORD7;
                float4 TBN0 : TEXCOORD0;
                float4 TBN1 : TEXCOORD1;
                float4 TBN2 : TEXCOORD2;
                float4 v3 : TEXCOORD3;
                float4 v4 : TEXCOORD4;
                float4 fogParam : TEXCOORD5;
                float2 uv : TEXCOORD6;
            };

            VS_OUTPUT vert(VS_INPUT v)
            {
                VS_OUTPUT o;
                o.dx_Position = UnityObjectToClipPos(v._in_POSITION0);

                float3 normalWS = UnityObjectToWorldNormal(v._in_NORMAL0);
                float3 tangentWS = UnityObjectToWorldDir(v._in_TANGENT0);
                float biSign = v._in_TANGENT0.w * unity_WorldTransformParams.w;
                float3 bitangentWS = cross(normalWS, tangentWS) * biSign;

                float3 positionWS = mul(unity_ObjectToWorld, v._in_POSITION0);

                o.TBN0 = float4(tangentWS.x, bitangentWS.x, normalWS.x, positionWS.x);
                o.TBN1 = float4(tangentWS.y, bitangentWS.y, normalWS.y, positionWS.y);
                o.TBN2 = float4(tangentWS.z, bitangentWS.z, normalWS.z, positionWS.z);

                float2 uvBake = v._in_TEXCOORD1 * unity_LightmapST.xy + unity_LightmapST.zw;
                o.v3 = float4(uvBake, 0, 0);
                o.v4 = float4(uvBake, 0, 0);

                // Custom Fog ==================================
                o.fogParam.x = o.dx_Position.z * _GlobalFogParam.x + _GlobalFogParam.y;
                float fogParam = abs(_GlobalFogParam.z - _GlobalFogParam.w);
                fogParam = max(fogParam, 0.001);
                fogParam = (positionWS.y - _GlobalFogParam.w) / fogParam;

                float3 viewDirR = positionWS - _WorldSpaceCameraPos;
                float viewDist = sqrt(dot(viewDirR, viewDirR));
                fogParam = 1 + fogParam - _GlobalFogHeightDis / viewDist;
                o.fogParam.y = saturate(fogParam * _GlobalFogHeightDensity);

                viewDirR = normalize(viewDirR);
                float3 lightDir = normalize(UnityWorldSpaceLightDir(positionWS));
                float ldotv = dot(lightDir, viewDirR);

                float2 fog;
                fog.x = (ldotv - _FogLightRadius) / _FogLightSoft;
                fog.y = (ldotv - _HightFogLightRadius) / _HightFogLightSoft;
                fog = saturate(fog);

                float2 fogAtten;
                fogAtten.x = saturate(lightDir.y * 2 - _FogLightHightAtten);
                fogAtten.y = saturate(lightDir.y * 2 - _HightFogLightHightAtten);
                o.fogParam.zw = fogAtten * fog;
                //===============================================

                float2 uv = v._in_TEXCOORD0;
                o.uv = TRANSFORM_TEX(float2(uv.x, 1 - uv.y), _MainTex);
                return o;
            }

            fixed4 frag(VS_OUTPUT i, fixed facing : VFACE) : SV_Target
            {
                float3 positionWS = float3(i.TBN0.w, i.TBN1.w, i.TBN2.w);
                float3 normalWS = float3(i.TBN0.z, i.TBN1.z, i.TBN2.z);
                normalWS = normalize(normalWS);

                fixed isFacing = facing > 0 ? 1 : -1;
                float3 normal;
                normal.xz = float2(isFacing, isFacing) * normalWS.xz;
                normal.y = isFacing * normalWS.y + _AmbientHighPos;
                normal = normalize(normal);

                float3 metallicGloss = tex2D(_MetallicGlossMap, i.uv).yzw;

                float3 bumpTS;
                bumpTS.xy = metallicGloss.xy * 2 - 1;
                bumpTS.xy = bumpTS.xy * _BumpScale;
                bumpTS.z = sqrt(1 - min(dot(bumpTS.xy, bumpTS.xy), 1.0));
                bumpTS = normalize(bumpTS);

                float3 bumpWS;
                bumpWS.x = dot(i.TBN0.xyz, bumpTS);
                bumpWS.y = dot(i.TBN1.xyz, bumpTS);
                bumpWS.z = dot(i.TBN2.xyz, bumpTS);
                bumpWS = isFacing * normalize(bumpWS);

                float4 rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.v4.xy);
                float shadow = saturate(dot(rawOcclusionMask, unity_OcclusionMaskSelector));
                float aoFactor = lerp(shadow, 1, dot(normal, bumpWS));

                float4 mainTexCol = tex2D(_MainTex, i.uv * _AlbedoMapScale);
                float occlusion = lerp(1, mainTexCol.w, _OcclusionStrength);
                float3 lightBaked = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.v3.xy);
                lightBaked = lightBaked * unity_Lightmap_HDR.xxx;
                lightBaked = occlusion * lightBaked * _GIPower;

                float3 albedo = mainTexCol.xyz * _Color;
                float3 bakedCol = lightBaked * albedo * aoFactor;

                float3 viewDir = UnityWorldSpaceViewDir(positionWS);
                float3 halfDir = normalize(viewDir) + _WorldSpaceLightPos0;
                halfDir = normalize(halfDir);

                float ndoth = saturate(dot(halfDir, bumpWS));
                float ndotl = saturate(dot(_WorldSpaceLightPos0, bumpWS));

                float metallic = metallicGloss.z * _SpecStrength;
                metallic = metallic * metallic;
                float3 specularFactor = min(pow(ndoth, _SpecShininess * 128) * metallic, 8.0) * _SpecularColor;
                float3 lightColor = unity_LightColor0 * _LightPower * shadow;
                float3 directCol = (albedo * ndotl + specularFactor) * lightColor;

                float3 finalCol = directCol + bakedCol;

                // apply fog
                //Dist
                float2 fogParam = saturate(i.fogParam.xy);
                float3 fogDistCol = unity_LightColor0 - _GlobalFogDistColor;
                float2 fogAtten = saturate((1 - fogParam.x) * i.fogParam.zw * _FogLightPow);
                fogDistCol = fogAtten.xxx * fogDistCol + _GlobalFogDistColor;
                finalCol = fogParam.xxx * (finalCol - fogDistCol) + fogDistCol;

                //Height
                float3 fogHeightCol = unity_LightColor0 - _GlobalFogHeightColor;
                fogHeightCol = fogAtten.yyy * fogHeightCol + _GlobalFogHeightColor - finalCol;
                finalCol = fogParam.yyy * fogHeightCol + finalCol;

                return fixed4(finalCol, 1);
            }
            ENDCG
        }
    }
}