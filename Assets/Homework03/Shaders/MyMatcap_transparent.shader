Shader "Unlit/MyMatcap_transparent"
{
    Properties
    {
        _Matcap ("Matcap", 2D) = "white" {}
        _Bias ("MatBallBias", Range(0,0.2)) = 0.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Pass
        {
            ZWrite Off
            Blend SrcColor OneMinusSrcColor
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 matcap_uv : TEXCOORD0;
            };

            sampler2D _Matcap;
            float4 _Matcap_ST;
            float _Bias;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.matcap_uv = normalize(mul(UNITY_MATRIX_IT_MV, v.normal).xyz).xy * (0.5 - _Bias) + 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_Matcap, i.matcap_uv);
                return col;
            }
            ENDCG
        }
    }
}
