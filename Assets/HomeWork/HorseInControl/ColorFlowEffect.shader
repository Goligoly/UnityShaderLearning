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

        sampler2D _MainTex, _CameraDepthTexture, _LastRender, _Buffer0, _Buffer1, _FlowNoise;
        float4 _MainTex_ST, _MainTex_TexelSize, _Direction, _TargetPosition;
        float _EdgeWidth;

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
            #pragma vertex vertEdge
            #pragma fragment fragEdge

            struct v2fEdge
            {
                float4 vertex : SV_POSITION;
                float2 uv[5] : TEXCOORD0;
            };

            v2fEdge vertEdge (appdata v)
            {
                v2fEdge o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float2 uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv[0] = uv;

                o.uv[1] = uv + _MainTex_TexelSize.xy * float2(1,1) * _EdgeWidth;
                o.uv[2] = uv + _MainTex_TexelSize.xy * float2(-1,-1) * _EdgeWidth;
                o.uv[3] = uv + _MainTex_TexelSize.xy * float2(1,-1) * _EdgeWidth;
                o.uv[4] = uv + _MainTex_TexelSize.xy * float2(-1,1) * _EdgeWidth;
                return o;
            }

            float CheckSame(float depth1, float depth2)
            {
                float diffDepth = abs(depth1-depth2) * 1;
                int isSameDepth = diffDepth < 0.1 * depth1;
                return isSameDepth;
            }

            float4 fragEdge (v2fEdge i) : SV_Target
            {
                float2 xy = ScreenToMiddle(i.uv[0]);
                float count = 5;
                float a = ceil(dot(normalize(xy), float2(-sin(_Time.x), cos(_Time.x))) * count)/count;
                float b = ceil(dot(normalize(xy), float2(-cos(_Time.x), sin(_Time.x))) * count)/count;
                float bias = getRandom(float2(a, b)) * 0.6 + sin(_Time.y) * 0.2 + 0.2;

                float sample0 = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv[0]));
                float sample1 = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv[1]));
                float sample2 = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv[2]));
                float sample3 = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv[3]));
                float sample4 = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv[4]));

                float edge = 1.0;
                edge *= CheckSame(sample1, sample2);
                edge *= CheckSame(sample3, sample4);

                float isObject = sample0 < 1;
                float3 color = lerp(tex2D(_MainTex, i.uv[0]).rgb, float3(0, 0, 0), edge) * smoothstep(0.4, 0.9, bias) * isObject;
                return float4(color, isObject);
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragFlow

            static const int kernelSampleCount = 9;
            static const float3 kernel[kernelSampleCount] = {
                float3(1, 0, 0.3),
                float3(2, 0, 0.2),
                float3(3, 0, 0.1),
                float3(1, 1, 0.1),
                float3(2, 1, 0.05),
                float3(3, 1, 0.05),
                float3(1, -1, 0.1),
                float3(2, -1, 0.05),
                float3(3, -1, 0.05)
            };

            float getFlowNoise(float2 uv)
            {
                uv += _Time.y * float2(0.05, 0.02);
                return tex2D(_FlowNoise, uv).r * 2 - 1;
            }

            float4 fragFlow (v2f i) : SV_Target
            {
                float2 xy = ScreenToMiddle(i.uv);
                float dist = length(xy);
                float2 weight = smoothstep(0.8, 1.5, dist);
                float2 dir = _Direction.xy;
                float2 norm = float2(_Direction.y, -_Direction.x);
                if(abs(_Direction.x) < 0.01 && abs(_Direction.y) < 0.01){
                    dir = -xy/dist;
                    norm = -float2(xy.y, -xy.x)/dist;
                }
                float noiseRadian = getFlowNoise(i.uv) * 3.14159/3;
                dir = cos(noiseRadian)*dir + sin(noiseRadian)*float2(dir.y, -dir.x);
                dir *= lerp(3, 1.5, weight);
                norm *= lerp(0.1, 0.5, weight);

                float3 color = 0;
                for(float m=0; m<kernelSampleCount; m++){
                    float3 kern = kernel[m];
                    float2 o = kern.x*dir + kern.y*norm;
                    color += kern.z * tex2D(_MainTex, MiddleToScreen(xy + o * _MainTex_TexelSize.y)).rgb;
                }
                return float4(color, 1) * lerp(float4(1,1,1,1), float4(0.97, 0.95, 0.96, 1), smoothstep(1, 2, dist)) ;
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

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragFinal

            float4 fragFinal (v2f i) : SV_Target
            {
                float isObject = tex2D(_Buffer0, i.uv).a;
                float4 color = tex2D(_MainTex, i.uv);
                return lerp(color + tex2D(_LastRender, i.uv), color, isObject);
            }
            ENDCG
        }
    }
}
