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
            float _ShadowStrengthen;
            float _PCF_Range;

            sampler2D _CustomShadowMap0;
            float4 _CustomShadowMap0_TexelSize;
            float4x4 _CustomLightSpaceMatrix0;

            sampler2D _CustomShadowMap1;
            float4x4 _CustomLightSpaceMatrix1;

            sampler2D _CustomShadowMap2;
            float4x4 _CustomLightSpaceMatrix2;

            float _CascadedLevels;

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
                float4 lightClipPos0 : TEXCOORD2;
                float4 lightClipPos1 : TEXCOORD3;
                float4 lightClipPos2 : TEXCOORD4;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.lightClipPos0 = mul(_CustomLightSpaceMatrix0, o.worldPos);
                o.lightClipPos1 = mul(_CustomLightSpaceMatrix1, o.worldPos);
                o.lightClipPos2 = mul(_CustomLightSpaceMatrix2, o.worldPos);
                return o;
            }

            float getDepth(float4 lightClipPos, sampler2D shadowMap)
            {
                float2 uv = 0.5 * lightClipPos.xy/lightClipPos.w + 0.5;
                float depth = saturate(lightClipPos.z/lightClipPos.w);
                #if defined (SHADER_TARGET_GLSL) 
                    depth = depth * 0.5 + 0.5;
                #elif defined (UNITY_REVERSED_Z)
                    depth = 1 - depth;
                #endif
                float shadowValue;
                float samplerValue;
                for(float x = -_PCF_Range; x <= _PCF_Range; x++)
                {
                    for(float y = -_PCF_Range; y <= _PCF_Range; y++)
                    {
                        samplerValue = tex2D(shadowMap, uv + float2(x, y) * _CustomShadowMap0_TexelSize).r;
                        shadowValue += samplerValue + _ShadowBias < depth ? 0 : 1;
                    }
                }
                return shadowValue / ((2 * _PCF_Range + 1) * (2 * _PCF_Range + 1));
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
                float3 worldNormal = i.normal;

                float shadowValue = 1;
                if(_CascadedLevels > 0) shadowValue *= getDepth(i.lightClipPos0, _CustomShadowMap0);
                if(_CascadedLevels > 1) shadowValue *= getDepth(i.lightClipPos1, _CustomShadowMap1);
                if(_CascadedLevels > 2) shadowValue *= getDepth(i.lightClipPos2, _CustomShadowMap2);
                shadowValue = max(_ShadowStrengthen, shadowValue);

                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                float3 abedo = shadowValue * _LightColor0.rgb;
                float3 diffuse = abedo * saturate(dot(worldLight, worldNormal));
                return float4(ambient + diffuse, 1);
            }
            ENDCG
        }
    }
}
