Shader "Unlit/MyShadowCaster"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float depth : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.depth = o.vertex.z / o.vertex.w;
                #if defined (SHADER_TARGET_GLSL) 
                    o.depth = o.depth * 0.5 + 0.5;
                #elif defined (UNITY_REVERSED_Z)
                    o.depth = 1 - o.depth;
                #endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.depth.xxx, 1);
            }
            ENDCG
        }
    }
}
