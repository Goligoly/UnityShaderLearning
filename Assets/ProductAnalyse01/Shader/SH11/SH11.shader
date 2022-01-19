Shader "Unlit/SH11"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MetallicGlossMap ("MetallicGlossMap", 2D) = "white" {}
        _Color ("Color", color) = (1,1,1,1)
        _BumpScale ("BumpScale", Range(0, 1)) = 1.0
        _Metallic ("Metallic", Range(0, 1)) = 0.5
        _Glossiness ("Glossiness", Range(0, 1)) = 0.5
        _OcclusionStrength ("OcclusionStrength", Range(0, 1)) = 1.0
        _LightPower ("LightPower", Range(0, 1)) = 1.0
        _AmbientSpCol ("AmbientSpCol", color) = (1,1,1,1)
        _AmbientHighPos ("AmbientHighPos", Range(0, 1)) = 0.5
        _ReflectionPower ("ReflectionPower", float) = 1.0
        _GIPower ("GIPower", vector) = (1,1,1,1)
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
            #include "Lighting.cginc"

            sampler2D _MainTex, _MetallicGlossMap;
            float4 _MainTex_ST, _Color, _GIPower, _AmbientSpCol;
            float _AmbientHighPos, _BumpScale, _OcclusionStrength, _AlbedoMapScale,
                  _LightPower, _Metallic, _Glossiness, _ReflectionPower;

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
                float3 viewDir = UnityWorldSpaceViewDir(positionWS);
                viewDir = normalize(viewDir);

                float3 normalWS = float3(i.TBN0.z, i.TBN1.z, i.TBN2.z);
                normalWS = normalize(normalWS);

                float4 mainTexCol = tex2D(_MainTex, i.uv * _AlbedoMapScale);
                float3 albedo = mainTexCol.xyz * _Color;

                float4 metallicGloss = tex2D(_MetallicGlossMap, i.uv);

                float3 bumpTS;
                bumpTS.xy = metallicGloss.yz * 2 - 1;
                bumpTS.xy = bumpTS.xy * _BumpScale;
                bumpTS.z = sqrt(1 - min(dot(bumpTS.xy, bumpTS.xy), 1.0));

                float3 bumpWS;
                bumpWS.x = dot(i.TBN0.xyz, bumpTS);
                bumpWS.y = dot(i.TBN1.xyz, bumpTS);
                bumpWS.z = dot(i.TBN2.xyz, bumpTS);
                bumpWS = normalize(bumpWS);

                float metallic = metallicGloss.x * _Metallic;

                float occlusion = lerp(1, mainTexCol.w, _OcclusionStrength);

                float4 rawOcclusionMask = UNITY_SAMPLE_TEX2D(unity_ShadowMask, i.v4.xy);
                float shadow = saturate(dot(rawOcclusionMask, unity_OcclusionMaskSelector));

                float3 metallCol = lerp(0.04, mainTexCol.xyz * _Color, metallic);
                float kd = 0.96 * (1 - metallic);

                float3 lightColor = unity_LightColor0 * _LightPower * shadow;

                float3 lightBaked = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.v3.xy);
                lightBaked = lightBaked * unity_Lightmap_HDR.xxx;
                lightBaked = occlusion * lightBaked * _GIPower;

                float glossiness = 1 - _Glossiness * metallicGloss.w;

                float3 reflectDir = reflect(-viewDir, bumpWS);
                reflectDir = normalize(reflectDir);
                reflectDir = BoxProjectedCubemapDirection(reflectDir, positionWS, unity_SpecCube0_ProbePosition,
                                                          unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);

                float roughness = (1.7 - 0.7 * glossiness) * glossiness * 6;

                float4 reflectCol = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectDir, roughness);

                float3 iblSpecular = DecodeHDR(reflectCol, unity_SpecCube0_HDR);

                float3 halfDir = viewDir + _WorldSpaceLightPos0;

                float ndoth = saturate(dot(halfDir, bumpWS));
                float ndotl = saturate(dot(_WorldSpaceLightPos0, bumpWS));
                float ldoth = saturate(dot(_WorldSpaceLightPos0, halfDir));

                float3 normal;
                normal.xz = normalWS.xz;
                normal.y = normalWS.y + _AmbientHighPos;
                normal = normalize(normal);
                float aoFactor = lerp(shadow, 1, dot(normal, bumpWS));

                float3 directDiffuse = kd * albedo * (lightColor * ndotl + lightBaked * aoFactor);

                float ndotv = abs(dot(viewDir, bumpWS));
                float ndotv4 = min(ndotv * 4, 1);

                float gloss = max(glossiness * glossiness, 0.008);
                float spec0 = ndotl * lerp(ndotv, 1, gloss);
                float spec1 = ndotv * lerp(ndotl, 1, gloss);
                float geometry = min(0.5 / (spec0 + spec1 + 0.001), 8);
                float distribution = gloss * ndoth;
                distribution = gloss / (distribution * distribution + 1 - ndoth * ndoth);
                distribution = min(distribution * distribution, 8);
                float3 fresnel = (1 - metallCol.xyz) * pow(1 - ldoth, 5) + metallCol.xyz;
                float3 directSpecular = fresnel * distribution * geometry * ndotl * ndotv4 * lightColor;

                float3 directCol = directSpecular + directDiffuse;

                //ambient
                metallic = saturate(metallicGloss.w * _Glossiness - metallic + 1);
                fresnel = (metallic - metallCol.xyz) * pow(1 - ndotv, 5) + metallCol.xyz;

                // float normaldotv = saturate(dot(normalWS, viewDir));
                // float3 ambientSpecular = metallic * distribution * (iblSpecular * _AmbientSpCol + _AmbientSpCol);
                // ambientSpecular = ambientSpecular * normaldotv;

                float3 ambientDiffuse = _ReflectionPower * fresnel * iblSpecular * ndotv4 / (gloss * gloss + 1);
                float3 ambientCol = ambientDiffuse; // + ambientSpecular;

                float3 finalCol = min(ambientCol + directCol, 5);

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