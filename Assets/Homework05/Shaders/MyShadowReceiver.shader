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

            float _ShadowBias, _ShadowStrengthen, _PCF_Range;

            sampler2D _CustomShadowMap0, _CustomShadowMap1, _CustomShadowMap2;
            float4 _CustomShadowMap0_TexelSize;

            float _CascadedDistance[4];
            float4x4 _CustomLightSpaceMatrix[4];

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
                float viewDepth : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.viewDepth = -UnityObjectToViewPos(v.vertex).z/_ProjectionParams.z;
                return o;
            }

            float getLevel(float viewDepth)
            {
                for(int i = 0; i < 3; i++)
                {
                    if(viewDepth >= _CascadedDistance[i] && viewDepth < _CascadedDistance[i+1]) return i;
                }
                return 4;
            }

            float getDepth(float4 lightNdcPos, float cascadedLevel)
            {
                float2 uv = 0.5 * lightNdcPos.xy + 0.5;
                float depth = lightNdcPos.z;
                #if defined (SHADER_TARGET_GLSL) 
                    depth = depth * 0.5 + 0.5;
                #elif defined (UNITY_REVERSED_Z)
                    depth = 1 - depth;
                #endif
                depth = saturate(depth);
                
                float shadowValue;
                float samplerValue;
                for(float x = -_PCF_Range; x <= _PCF_Range; x++)
                {
                    for(float y = -_PCF_Range; y <= _PCF_Range; y++)
                    {
                        float2 o = float2(x, y) * _CustomShadowMap0_TexelSize;
                        if(cascadedLevel == 0) samplerValue = tex2D(_CustomShadowMap0, uv + o).r;
                        else if(cascadedLevel == 1) samplerValue = tex2D(_CustomShadowMap1, uv + o).r;
                        else samplerValue = tex2D(_CustomShadowMap2, uv + o).r;
                        shadowValue += samplerValue + _ShadowBias < depth ? 0 : 1;
                    }
                }
                shadowValue = shadowValue / ((2 * _PCF_Range + 1) * (2 * _PCF_Range + 1));
                return shadowValue;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
                float3 worldNormal = i.normal;

                float cascadedLevel = getLevel(i.viewDepth);

                float4 lightPos = mul(_CustomLightSpaceMatrix[cascadedLevel], i.worldPos);

                float shadowValue = getDepth(lightPos, cascadedLevel);

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
