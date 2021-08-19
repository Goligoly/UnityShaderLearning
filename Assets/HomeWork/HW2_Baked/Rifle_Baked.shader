Shader "Unlit/Rifle_Baked"
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
    }
    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON

            #include "UnityCG.cginc"

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
                float2 uv : TEXCOORD0;
                float2 light_uv : TEXCOORD1;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 light_uv : TEXCOORD1;
                float3 worldView : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                float3 TtoWx : TEXCOORD4;
                float3 TtoWy : TEXCOORD5;
                float3 TtoWz : TEXCOORD6;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.light_uv = v.light_uv * unity_LightmapST.xy + unity_LightmapST.zw;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                o.worldView = WorldSpaceViewDir(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.TtoWx = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
                o.TtoWy = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
                o.TtoWz = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 tanNormal = _UseNormal == 1 ? UnpackNormal(tex2D(_NormalTex, i.uv)) : fixed3(0,0,1);
                fixed3 normal = fixed3(dot(i.TtoWx, tanNormal), dot(i.TtoWy, tanNormal), dot(i.TtoWz, tanNormal));
                fixed4 light = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, i.light_uv);
                fixed3 view = normalize(i.worldView);

                fixed3 lightCol = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.light_uv));

                //Blinn-Phong
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 albedo = _UseTexture == 1 ? _DiffuseColor.rgb * tex2D(_MainTex, i.uv) : _DiffuseColor.rgb;
                fixed3 diffuse = lightCol * albedo * saturate(dot(normal, light.xyz));

                fixed3 halfv = normalize(view + light.xyz);
                fixed3 specular = lightCol * _SpecularColor.rbg * pow(saturate(dot(halfv, normal)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}
