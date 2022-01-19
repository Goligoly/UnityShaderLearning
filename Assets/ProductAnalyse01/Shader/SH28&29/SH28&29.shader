Shader "Unlit/SH28&29"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("BumpMap", 2D) = "white" {}
        _BumpScale ("BumpScale", float) = 1.0
        _Mip ("Mip", Range(0, 1)) = 0.625
        _TintColor ("Tint Color", color) = (1,1,1,1)
        _Smoothness ("Smoothness", Range(0, 1)) = 0.625
        _RefIntensity ("RefIntensity", float) = 0.8
        _RefColor ("Reflect Color", color) = (1,1,1,1)
        _Vector ("Vector", vector) = (1,1,1,1)
        _Foam ("FoamFactor", Range(0, 1)) = 0.625
        _FoamCol ("Foam Color", color) = (1,1,1,1)
        _SpecularColor ("SpecularColor", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent" "Queue"="Transparent"
        }
        LOD 100

        CGINCLUDE
        #include "UnityCG.cginc"
        #include "AutoLight.cginc"

        sampler2D _MainTex, _BumpMap;
        float4 _MainTex_ST, _BumpMap_ST, _SpecularColor, _Vector, _RefColor, _TintColor, _FoamCol;
        float _BumpScale, _Foam, _Mip, _RefIntensity, _Smoothness;

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
            float4 _in_TANGENT0 : TANGENT;
        };

        struct VS_OUTPUT
        {
            float4 dx_Position : SV_Position;
            float4 uv : TEXCOORD0;
            float4 fogParam : TEXCOORD1;
            float4 TBN0 : TEXCOORD2;
            float4 TBN1 : TEXCOORD3;
            float4 TBN2 : TEXCOORD4;
            float3 viewDir : TEXCOORD5;
            float3 lightDir : TEXCOORD6;
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

            float2 uv = v._in_TEXCOORD0;
            o.uv.xy = TRANSFORM_TEX(float2(uv.x, 1 - uv.y), _MainTex);
            o.uv.zw = TRANSFORM_TEX(float2(uv.x, 1 - uv.y), _BumpMap);

            o.viewDir = UnityWorldSpaceViewDir(positionWS);
            o.lightDir = UnityWorldSpaceLightDir(positionWS);

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
            return o;
        }

        fixed4 frag(VS_OUTPUT i) : SV_Target
        {
            float4 time = _Time.xxxx * _Vector;
            bool4 boolean = time >= -time;
            time = frac(abs(time));
            float4 timeStep = boolean ? time : -time;

            float2 bumpUVReverse = i.uv.zw * float2(1.0, -1.0);
            float3 bump0 = tex2D(_BumpMap, bumpUVReverse.xy * _BumpScale + timeStep.zw).xyz;
            float3 bump1 = tex2D(_BumpMap, i.uv.zw * _BumpScale + timeStep.xy).xyz;
            float3 bump = bump0 + bump1 + float3(-1.0, -1.0, -2.0);

            float foam = bump1.y + bump1.x;

            float2 mainTex = tex2D(_MainTex, i.uv.xy).xy;
            float bumpFactor = mainTex.x * _BumpScale;
            float foamFactor = foam * foam * mainTex.y * _Foam;

            float3 normalTS = bumpFactor * bump + float3(0, 0, 1);
            float3 normalWS;
            normalWS.x = dot(i.TBN0.xyz, normalTS.xyz);
            normalWS.y = dot(i.TBN1.xyz, normalTS.xyz);
            normalWS.z = dot(i.TBN2.xyz, normalTS.xyz);
            normalWS = normalize(normalWS);

            float3 reflectDir = normalize(reflect(-i.viewDir, normalWS));
            float mip = 6 * _Mip * (1.7 - 0.6999 * _Mip);
            float4 reflectCol = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectDir, mip);
            float3 iblSpecular = DecodeHDR(reflectCol, unity_SpecCube0_HDR);

            float transparency = dot(iblSpecular, float3(0.3, 0.6, 0.1));
            transparency = transparency + foamFactor * _FoamCol.w + _TintColor.w;

            iblSpecular = iblSpecular * _RefIntensity * _RefColor + _TintColor;

            float3 halfDir = normalize(i.viewDir + i.lightDir);
            float ndoth = saturate(dot(normalWS, halfDir));
            float ndotv = saturate(dot(normalWS, i.viewDir));
            float oneMinusNdotv = 1.3 - ndotv;
            float ldoth = saturate(dot(i.lightDir, halfDir));
            ldoth = max(ldoth * ldoth, 0.1);

            float a = 1 - _Smoothness;
            float b = a * a;
            a = a * a + 0.5;
            float c = a * ldoth;
            a = b * b - 1;
            float d = ndoth * ndoth * a + 1.00001;
            float specular = min(b * b / 4 * c * d * d, 5.0);

            float3 finalCol = foamFactor * _FoamCol + specular * _SpecularColor + iblSpecular;
            transparency = saturate(transparency * oneMinusNdotv + specular);

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

            return fixed4(finalCol, transparency);
        }
        ENDCG

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CULL Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CULL Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}