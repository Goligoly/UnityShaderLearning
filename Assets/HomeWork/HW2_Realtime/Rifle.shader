Shader "Unlit/Rifle"
{
    Properties
    {
        [Toggle] _UseTexture("use Texture", int) = 1
        _MainTex ("Texture", 2D) = "white" {}
        _DiffuseColor ("Diffuse", color) = (1,1,1,1)
        _SpecularColor ("Specular", color) = (1,1,1,1)
        [IntRange] _Gloss ("Gloss", Range(8, 128)) = 16
        [Toggle] _UseNormal("use Normal", int) = 1
        [NoScaleOffset]_NormalTex ("Normal", 2D) = "bump" {}
        _ReflectAmount ("Reflect Amount", Range(0, 1)) = 0.5
        [NoScaleOffset]_Background ("Background", Cube) = "white" {}
    }
    SubShader
    {
        
        Pass
        {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            float _UseTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _DiffuseColor;
            float4 _SpecularColor;
            float _Gloss;
            float _UseNormal;
            sampler2D _NormalTex;
            float _ReflectAmount;
            samplerCUBE _Background;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldLight : TEXCOORD1;
                float3 worldView : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                SHADOW_COORDS(4)
                float3 TtoWx : TEXCOORD5;
                float3 TtoWy : TEXCOORD6;
                float3 TtoWz : TEXCOORD7;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.worldLight = WorldSpaceLightDir(v.vertex);
                o.worldView = WorldSpaceViewDir(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.TtoWx = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
                o.TtoWy = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
                o.TtoWz = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 tanNormal = _UseNormal == 1 ? UnpackNormal(tex2D(_NormalTex, i.uv)) : fixed3(0,0,1);
                fixed3 normal = fixed3(dot(i.TtoWx, tanNormal), dot(i.TtoWy, tanNormal), dot(i.TtoWz, tanNormal));
                fixed3 light = normalize(i.worldLight);
                fixed3 view = normalize(i.worldView);

                //environment reflection
                fixed3 reflect = - i.worldView + 2 * dot(normal, i.worldView) * normal;
                fixed3 reflection = texCUBE(_Background, normalize(reflect));

                //Blinn-Phong in tangent space
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 albedo = _UseTexture == 1 ? _DiffuseColor.rgb * tex2D(_MainTex, i.uv) : _DiffuseColor.rgb;
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal, light));

                fixed3 halfv = normalize(view + light);
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rbg * pow(saturate(dot(halfv, normal)), _Gloss);

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                return fixed4(ambient + (lerp(diffuse, reflection, _ReflectAmount) + specular) * atten, 1);
            }
            ENDCG
        }

        Pass
        {
            Tags {"LightMode"="ForwardAdd"}

            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdadd

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            float _UseTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _DiffuseColor;
            float4 _SpecularColor;
            float _Gloss;
            float _UseNormal;
            sampler2D _NormalTex;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldLight : TEXCOORD1;
                float3 worldView : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                SHADOW_COORDS(4)
                float3 TtoWx : TEXCOORD5;
                float3 TtoWy : TEXCOORD6;
                float3 TtoWz : TEXCOORD7;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.worldLight = WorldSpaceLightDir(v.vertex);
                o.worldView = WorldSpaceViewDir(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.TtoWx = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
                o.TtoWy = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
                o.TtoWz = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 tanNormal = _UseNormal == 1 ? UnpackNormal(tex2D(_NormalTex, i.uv)) : fixed3(0,0,1);
                fixed3 normal = fixed3(dot(i.TtoWx, tanNormal), dot(i.TtoWy, tanNormal), dot(i.TtoWz, tanNormal));
                fixed3 light = normalize(i.worldLight);
                fixed3 view = normalize(i.worldView);

                //Blinn-Phong in tangent space
                fixed3 albedo = _UseTexture == 1 ? _DiffuseColor.rgb * tex2D(_MainTex, i.uv) : _DiffuseColor.rgb;
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal, light));

                fixed3 halfv = normalize(view + light);
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rbg * pow(saturate(dot(halfv, normal)), _Gloss);

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                return fixed4((diffuse + specular) * atten, 1);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}
