Shader "Unlit/MyShadowReceiver_SSSM"
{
    Properties
    {
        _ShadowStrengthen ("Shadow Strengthen", Range(0,1)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float _ShadowStrengthen;

            sampler2D _ScreenSpaceShadowMap;
            float4 __ScreenSpaceShadowMap_TexelSize;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
                float3 worldNormal = i.normal;

                float shadowValue = max(tex2D(_ScreenSpaceShadowMap, i.vertex.xy/_ScreenParams.xy), _ShadowStrengthen);

                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                float3 abedo = shadowValue * _LightColor0.rgb;
                float3 diffuse = abedo * saturate(dot(worldLight, worldNormal));
                return float4(ambient + diffuse, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
