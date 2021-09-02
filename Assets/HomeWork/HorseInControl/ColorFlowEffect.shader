Shader "Unlit/ColorFlowEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        CGINCLUDE
        #include "UnityCG.cginc"

        sampler2D _MainTex, _Buffer0, _Buffer1;
        float4 _MainTex_ST, _MainTex_TexelSize, _Direction, _TargetPosition;

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

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }

        float2 ScreenToMiddle(float2 uv)
        {
            uv = uv - _TargetPosition.xy;
            return (uv * 2 - 1) * _ScreenParams.xy / _ScreenParams.y;
        }

        float2 MiddleToScreen(float2 xy)
        {
            return (xy * _ScreenParams.y / _ScreenParams.xy) * 0.5 + 0.5 + _TargetPosition.xy;
        }

        float getRandom(float2 xy)
        {
            return frac(sin(dot(xy, float2(12.9898, 78.233))) * 43758.5453);
        }

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 frag (v2f i) : SV_Target
            {
                float2 xy = ScreenToMiddle(i.uv);
                float count = 5;
                float a = ceil(dot(normalize(xy), float2(-sin(_Time.x), cos(_Time.x))) * count)/count;
                float b = ceil(dot(normalize(xy), float2(-cos(_Time.x), sin(_Time.x))) * count)/count;
                float bias = getRandom(float2(a, b)) * 0.5 + sin(_Time.y) * 0.25;

                return tex2D(_MainTex, i.uv) * bias;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragFlow

            float4 fragFlow (v2f i) : SV_Target
            {
                float scale = 0.001;
                float2 xy = ScreenToMiddle(i.uv);
                float2 weight = (length(xy) - 0.2)/1.2;
                float2 dir = _Direction.xy;
                float2 norm = _Direction.zw;
                if(_Direction.x < 0.01 && _Direction.y < 0.01){
                    dir = -xy/length(xy);
                    norm = -float2(xy.y, -xy.x)/length(xy);
                }
                dir *= lerp(5, 3, weight);
                norm *= lerp(3, 8, weight);

                float3 color = 0;
                for(float m=0; m<3; m++){
                    for(float n=-1; n<=1; n++){
                        float2 o = m*dir + n*norm;
                        color += tex2D(_MainTex, MiddleToScreen(xy + o * scale)).rgb;
                    }
                }
                color /= 9;
                return float4(color, 1);
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragCombine

            float4 fragCombine (v2f i) : SV_Target
            {
                return max(tex2D(_Buffer0, i.uv), tex2D(_Buffer1, i.uv));
            }
            ENDCG
        }
    }
}
