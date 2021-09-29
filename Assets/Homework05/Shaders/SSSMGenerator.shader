Shader "Unlit/SSSMGenerator"
{
    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                half2 uv_depth : TEXCOORD1;
                float4 interpolatedRay : TEXCOORD2;
            };

            float _PCF_Range;

            sampler2D _CustomShadowMap0;
            float4 _CustomShadowMap0_TexelSize;
            float4x4 _CustomLightSpaceMatrix;

            sampler2D _MainCameraDepthTexture;
            float4x4 _FrustumCornersRay;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                o.uv_depth = v.texcoord;

                int index = 0;
                if (v.texcoord.x < 0.5 && v.texcoord.y < 0.5) {
                    index = 0;
                } else if (v.texcoord.x > 0.5 && v.texcoord.y < 0.5) {
                    index = 1;
                } else if (v.texcoord.x > 0.5 && v.texcoord.y > 0.5) {
                    index = 2;
                } else {
                    index = 3;
                }
                
                o.interpolatedRay = _FrustumCornersRay[index];

                return o;
            }

            float getDepth(float4 lightClipPos)
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
                        samplerValue = tex2D(_CustomShadowMap0, uv + float2(x, y) * _CustomShadowMap0_TexelSize).r;
                        shadowValue += samplerValue < depth ? 0 : 1;;
                    }
                }
                return shadowValue / ((2 * _PCF_Range + 1) * (2 * _PCF_Range + 1));
            }

            float4 frag (v2f i) : SV_Target
            {
                float linearDepth = tex2D(_MainCameraDepthTexture, i.uv_depth).r * _ProjectionParams.z;
                float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;
                float4 lightPos = mul(_CustomLightSpaceMatrix, float4(worldPos, 1));
                return float4(getDepth(lightPos).xxx, 1);
            }
            ENDCG
        }
    }
}
