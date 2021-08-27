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

            sampler2D _CustomShadowMap0;
            float4 _CustomShadowMap0_TexelSize;
            float4x4 _CustomLightSpaceMatrix0;

            sampler2D _CameraDepthTexture;
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
                float samplerValue = tex2D(_CustomShadowMap0, uv).r;
                return samplerValue < depth ? 0 : 1;
                // return samplerValue;
            }

            float4 frag (v2f i) : SV_Target
            {
                float linearDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth));
                float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;
                float4 lightPos = mul(_CustomLightSpaceMatrix0, float4(worldPos, 1));
                return float4(getDepth(lightPos).xxx, 1);
            }
            ENDCG
        }
    }
}
