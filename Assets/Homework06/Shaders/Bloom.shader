Shader "Unlit/Bloom"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_Bloom ("Bloom (RGB)", 2D) = "black" {}
		_LuminanceThreshold ("Luminance Threshold", Float) = 0.5
		_BlurSize ("Blur Size", Float) = 1.0
    }
	SubShader {
		CGINCLUDE
		
        #include "UnityCG.cginc"
    
        sampler2D _MainTex;
        half4 _MainTex_TexelSize;
        sampler2D _Bloom;
        float _LuminanceThreshold;
        float _BlurSize;

        struct v2f_gauss {
            float4 pos : SV_POSITION;
            half2 uv[5]: TEXCOORD0;
        };

        fixed4 fragGauss(v2f_gauss i) : SV_Target {
            float weight[3] = {0.4026, 0.2442, 0.0545};
            
            fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
            
            for (int it = 1; it < 3; it++) {
                sum += tex2D(_MainTex, i.uv[it*2-1]).rgb * weight[it];
                sum += tex2D(_MainTex, i.uv[it*2]).rgb * weight[it];
            }
            
            return fixed4(sum, 1.0);
        }
		
		ENDCG
		
		ZTest Always Cull Off ZWrite Off
		
		Pass {  
			CGPROGRAM  
			#pragma vertex vertExtractBright  
			#pragma fragment fragExtractBright 

            struct v2f {
                float4 pos : SV_POSITION; 
                float2 uv : TEXCOORD0;
            };	 

            v2f vertExtractBright(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;     
                return o;
            }

            fixed luminance(fixed4 color) {
                return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
            }

            fixed4 fragExtractBright(v2f i) : SV_Target {
                fixed4 c = tex2D(_MainTex, i.uv);
                fixed4 val = clamp(c - _LuminanceThreshold, 0.0, 1.0);
                
                return val;
            }

			ENDCG  
		}

        Pass {
            CGPROGRAM
            #pragma vertex vertGaussVertical
            #pragma fragment fragGauss

            v2f_gauss vertGaussVertical(appdata_img v) {
                v2f_gauss o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                half2 uv = v.texcoord;
                
                o.uv[0] = uv;
                o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
                o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
                o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
                o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
                        
                return o;
            }

            ENDCG
        }

        Pass {
            CGPROGRAM
            #pragma vertex vertGaussHorizontal
            #pragma fragment fragGauss

            v2f_gauss vertGaussHorizontal(appdata_img v) {
                v2f_gauss o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                half2 uv = v.texcoord;
                
                o.uv[0] = uv;
                o.uv[1] = uv + float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
                o.uv[2] = uv - float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
                o.uv[3] = uv + float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
                o.uv[4] = uv - float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
                        
                return o;
            }

            ENDCG
        }

        Pass {
            CGPROGRAM
            #pragma vertex vertBloom
            #pragma fragment fragBloom

            struct v2f {
                float4 pos : SV_POSITION; 
                float2 uv : TEXCOORD0;
            };	 

            v2f vertBloom(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;     
                return o;
            }

            fixed4 fragBloom(v2f i) : SV_Target {
                float3 color = tex2D(_MainTex, i.uv) + tex2D(_Bloom, i.uv);
                return float4(color, 1);
            }

            ENDCG
        }
	}
}
