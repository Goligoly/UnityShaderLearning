// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Test"
{
	Properties{
		_MainTex("Main Tex",2d) = ""{}
	}
	SubShader {
		pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			struct v2f {
				float4 pos:POSITION;
				float2 uv0:TEXCOORD0;
				float2 uv1:TEXCOORD1;
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv1 = v.texcoord1.xy*unity_LightmapST.xy + unity_LightmapST.zw;
				return o;
			}
			fixed4 frag(v2f IN) :COLOR
			{
				fixed4 col = tex2D(_MainTex,IN.uv0);
				float3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.uv1));
				col.rgb *= lm*2;
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
