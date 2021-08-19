Shader "Unlit/MySkyBox"
{
    Properties
    {
        _MainTex ("Texture", Cube) = "white" {}
        _Degree ("Degree", Range(0,360)) = 0
    }
    SubShader
    {
        Pass
        {
            Cull Off
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
                float3 dir : TEXCOORD0;
            };

            samplerCUBE _MainTex;
            float _Degree;

            v2f vert (appdata v)
            {
                v2f o;
                float3 center = UnityObjectToViewPos(float3(0,0,0));
                o.vertex = UnityViewToClipPos(UnityObjectToViewPos(v.vertex) - center);
                o.dir = normalize(v.vertex);

                float radian = _Degree * 2 * 3.14 / 360;
                o.dir.xz = cos(radian) * o.dir.xz + sin(radian) * float2(o.dir.z, - o.dir.x);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return texCUBE(_MainTex, i.dir);
            }
            ENDCG
        }
    }
}
