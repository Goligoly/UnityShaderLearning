Shader "Unlit/Water"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset]_NormalTex ("Normal", 2D) = "bump" {}
        _ShallowCol ("Shallow Color", Color) = (1,1,1,1)
        _DeepCol ("Deep Color", Color) = (1,1,1,1)
        _tranDepth("Transition Depth", Range(0,1)) = 0.5
        _tranFactor("Transition Factor", Range(0,2)) = 0.5
        _refractFactor("Refraction Factor", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent" "RenderType"="Transparent"
        }
        LOD 100

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }
            Zwrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float3 worldLight : TEXCOORD2;
                float3 worldView : TEXCOORD3;
            };

            sampler2D _MainTex, _NormalTex, _CameraDepthTexture;
            float4 _MainTex_ST, _ShallowCol, _DeepCol;
            float _tranDepth, _tranFactor, _refractFactor;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex) + float2(sin(_Time.x + worldPos.z), _Time.x);
                o.uv.zw = TRANSFORM_TEX(v.uv, _MainTex) + float2(_Time.x, 2 * _Time.x);
                o.screenPos = ComputeScreenPos(o.vertex);
                o.worldLight = UnityWorldSpaceLightDir(worldPos);
                o.worldView = UnityWorldSpaceViewDir(worldPos);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 light = normalize(i.worldLight);
                float3 view = normalize(i.worldView);

                float3 normal = UnpackNormal(tex2D(_NormalTex, i.uv.xy)).xzy;
                normal += UnpackNormal(tex2D(_NormalTex, i.uv.zw)).xzy;
                normal += float3(0, -1.5, 0);
                normal = normalize(normal);

                float3 halfVec = normalize(light + view);
                float3 reflectCol = 2 * _LightColor0.rgb * pow(saturate(dot(normal, halfVec)), 16);
                float depthValue = Linear01Depth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
                depthValue = pow(saturate(depthValue / _tranDepth), _tranFactor);

                float4 refractCol = lerp(_ShallowCol, _DeepCol, depthValue);
                fixed4 col = float4(lerp(reflectCol, refractCol.xyz, _refractFactor), refractCol.w);
                // fixed4 col = float4(depthValue - Linear01Depth(i.vertex.z) < 0.5, 0, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}