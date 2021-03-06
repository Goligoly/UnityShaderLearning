Shader "Unlit/MainCameraDepthCaster"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
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
                o.depth = -UnityObjectToViewPos(v.vertex).z/_ProjectionParams.z;
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
