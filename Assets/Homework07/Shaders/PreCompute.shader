Shader "Unlit/PreCompute"
{
    Properties
    {
        _MainTex ("Texture", cube) = "white" {}
        _Roughness ("Roughness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        CGINCLUDE
        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "pbrbase.cginc"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        samplerCUBE _MainTex;
        float4 _MainTex_ST;
        float _Roughness;

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }

        float4 genIrradianceFrag(v2f i) : SV_Target
        {
            float phi = UNITY_TWO_PI * i.uv.x;
            float theta = UNITY_PI * (1 - i.uv.y);
            float3 mainDir = float3(sin(theta) * cos(phi), cos(theta), sin(theta) * sin(phi));
            float3 col = uniformSampler(mainDir);
            return float4(col, 1);
        }

        float4 genPreEnvFrag(v2f i) : SV_Target
        {
            float phi = UNITY_TWO_PI * i.uv.x;
            float theta = UNITY_PI * (1 - i.uv.y);
            float3 mainDir = float3(sin(theta) * cos(phi), cos(theta), sin(theta) * sin(phi));

            float3 color = 0;
            float weight = 0;
            int num = 2048;
            float3x3 localCord = genTrans(mainDir);
            for (int ii = 0; ii < num; ii++)
            {
                float2 hammersley = hammersleySample(ii, num);
                float3 dir = importanceSampleGGX(hammersley, _Roughness);
                dir = mul(localCord, dir);
                float3 L = normalize(2 * dot(dir, mainDir) * dir - mainDir);

                float ndotl = dot(mainDir, L);
                if (ndotl > 0)
                {
                    color += UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, L) * ndotl;
                    weight += ndotl;
                }
            }
            color = color / weight;
            return float4(color, 1);
        }
        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment genIrradianceFrag
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment genPreEnvFrag
            ENDCG
        }
    }
}