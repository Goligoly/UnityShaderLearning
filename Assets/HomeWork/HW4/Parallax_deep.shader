Shader "Unlit/Parallax"
{
	Properties{
		_MainTex("Main Tex", 2d) = "white" {}
		[NoScaleOffset]_NormalMap("Normal", 2d) = "white" {}
		[NoScaleOffset]_HeightMap("Height", 2d) = "white" {}
		_HeightScale("Height Scale", Range(0, 0.3)) = 0.1
	}
	SubShader {
		pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			#include "unitycg.cginc"
			#include "lighting.cginc"
		
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalMap;
			sampler2D _HeightMap;
			float _HeightScale;
		
			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 tangentLight : TEXCOORD1;
				float3 tangentView : TEXCOORD2;
			};
		
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

				float3x3 worldToTangent = float3x3(worldTangent, worldBinormal, worldNormal);

				float3 worldLight = WorldSpaceLightDir(v.vertex);
				float3 worldView = WorldSpaceViewDir(v.vertex);

				o.tangentLight = mul(worldToTangent, worldLight);
				o.tangentView = mul(worldToTangent, worldView);

				return o;
			}

			float2 parallaxMapping(fixed2 tex, fixed3 view)
			{
				// Parallax Mapping Base
				// fixed height = tex2D(_HeightMap, tex).r;
				// fixed2 p = view.xy * (height * _HeightScale) / view.z;
				// return tex - p;

				// Steep Parallax Mapping
				float stepSize = 20;
				float3 p = view * _HeightScale;
				float deltaDepth = 1 / stepSize;
				float2 deltaTexcoods = p.xy / stepSize;

				float currentLayerDepth = 0;
				float2 currentTex = tex;
				float currentDepthValue = tex2D(_HeightMap, currentTex).r;
				for(float i = 0; i < stepSize; i++)
				{
					if(currentDepthValue <= currentLayerDepth) break;
					currentTex -= deltaTexcoods;
					currentDepthValue = tex2D(_HeightMap, currentTex).r;
					currentLayerDepth += deltaDepth;
				}

				// Parallax Occlusion Mapping
				float2 preTex = currentTex + deltaTexcoods;
				float curDepth = currentLayerDepth - currentDepthValue;
				float preDepth = tex2D(_HeightMap, preTex).r - currentLayerDepth + deltaDepth;
				float weight = curDepth / (curDepth + preDepth);
				return lerp(currentTex, preTex, weight);
			}
		
			float4 frag(v2f i) :SV_TARGET
			{
				float3 tangentLight = normalize(i.tangentLight);
				float3 tangentView = normalize(i.tangentView);

				float2 texCoord = parallaxMapping(i.uv, tangentView);
				if (texCoord.x > 1 || texCoord.y > 1 || texCoord.x < 0 || texCoord.y < 0) clip(-1);

				float3 tangentNormal = UnpackNormal(tex2D(_NormalMap, texCoord));

				float3 albedo = tex2D(_MainTex, texCoord);

				float3 diffuse = _LightColor0 * albedo * saturate(dot(tangentLight, tangentNormal));

				return fixed4(diffuse, 1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
