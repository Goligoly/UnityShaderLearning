Shader "Unlit/MyShadowReceiver"
{
    Properties
    {
        _ShadowBias ("Bias", Range(0, 0.1)) = 0.05
        _ShadowStrengthen ("Shadow Strengthen", Range(0,1)) = 0.3
        [IntRange] _PCF_Range ("PCF range", Range(0, 5)) = 1
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

            float _ShadowBias;
            float _PCF_Range;

            sampler2D _CustomShadowMap;
            float4 _CustomShadowMap_TexelSize;
            float4x4 _CustomLightSpaceMatrix;
            float _ShadowStrengthen;

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
                float4 lightClipPos : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.lightClipPos = mul(_CustomLightSpaceMatrix, o.worldPos);
                return o;
            }

            float getDepth(float4 lightClipPos)
            {
                float2 uv = 0.5 * lightClipPos.xy/lightClipPos.w + 0.5;
                float depth = -0.5 * lightClipPos.z/lightClipPos.w + 0.5;
                float shadowValue;
                for(float x = -_PCF_Range; x <= _PCF_Range; x++)
                {
                    for(float y = -_PCF_Range; y <= _PCF_Range; y++)
                    {
                        shadowValue += tex2D(_CustomShadowMap, uv + float2(x, y) * _CustomShadowMap_TexelSize).r + _ShadowBias < depth ? _ShadowStrengthen : 1;
                    }
                }
                return shadowValue / ((2 * _PCF_Range + 1) * (2 * _PCF_Range + 1));
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
                float3 worldNormal = i.normal;

                float shadowValue = getDepth(i.lightClipPos);

                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                float3 abedo = shadowValue * _LightColor0.rgb;
                float3 diffuse = abedo * saturate(dot(worldLight, worldNormal));
                return float4(ambient + diffuse, 1);
            }
            ENDCG
        }
    }
}
