Shader "Unlit/ToneMapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
	SubShader {
		CGINCLUDE
		
        #include "UnityCG.cginc"
    
        sampler2D _MainTex, _ToneMap;
        float4 _MainTex_TexelSize;

        float _XRange;
		
		ENDCG
		
		ZTest Always Cull Off ZWrite Off
		
		Pass {  
			CGPROGRAM  
			#pragma vertex vert  
			#pragma fragment frag 

            struct v2f {
                float4 pos : SV_POSITION; 
                float2 uv : TEXCOORD0;
            };	 

            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;     
                return o;
            }

            float Luminance(float3 c)
            {
                return dot(c, float3(0.2126, 0.7152, 0.0722));
            }

            float3 Reinhard(float3 originColor)
            {
                return originColor / (originColor + 1);
            }

            float3 Reinhard_Jodie(float3 originColor)
            {
                float lum = Luminance(originColor);
                float3 tv = originColor / (originColor + 1);
                return lerp(originColor / (1 + lum), tv, tv);
            }

            float3 ACESToneMapping(float3 originColor)
            {
                return (originColor * (2.51 * originColor + 0.03)) / (originColor * (2.43 * originColor + 0.59) + 0.14);
            }

			float texToneMap(float c)
            {
                return tex2D(_ToneMap, float2(c, 0));
            }

			float3 customToneMapping(float3 originColor)
            {
                float3 color = originColor / (originColor + 1);
                return float3(texToneMap(color.r),texToneMap(color.g),texToneMap(color.b));
            }

            float4 frag(v2f i) : SV_Target {
                float4 sample = tex2D(_MainTex, i.uv);
                float3 color  = customToneMapping(sample.rgb);
                return float4(color, 1);
            }
			ENDCG  
		}
    }
}
