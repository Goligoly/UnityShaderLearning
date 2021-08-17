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
        _ReflectAmount ("Reflect Amount", Range(0, 1)) = 0.5
        [NoScaleOffset]_Background ("Background", Cube) = "white" {}
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
            float _ReflectAmount;
            samplerCUBE _Background;

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
                float3 view : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                float3 worldReflect : TEXCOORD4;
                float2 light_uv : TEXCOORD5;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                float3x3 worldToTangent = float3x3(worldTangent, worldBinormal, worldNormal);

                float3 worldView = WorldSpaceViewDir(v.vertex);
                o.view = mul(worldToTangent, worldView);

                o.worldReflect = - worldView + 2 * dot(worldNormal, worldView) * worldNormal;

                o.light_uv = v.light_uv * unity_LightmapST.xy + unity_LightmapST.zw;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normal = _UseNormal == 1 ? UnpackNormal(tex2D(_NormalTex, i.uv)) : fixed3(0,0,1);
                fixed3 view = normalize(i.view);
                fixed3 lightCol = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.light_uv));
                // fixed3 light = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, i.light_uv);

                //environment reflection
                fixed3 reflection = texCUBE(_Background, normalize(i.worldReflect));

                //Blinn-Phong in tangent space
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 albedo = _UseTexture == 1 ? _DiffuseColor.rgb * tex2D(_MainTex, i.uv) : _DiffuseColor.rgb;
                fixed3 diffuse = lightCol * albedo;

                // fixed3 halfv = normalize(view + light);
                // fixed3 specular = lightCol * _SpecularColor.rbg * pow(saturate(dot(halfv, normal)), _Gloss);

                return fixed4(ambient + diffuse + reflection * _ReflectAmount, 1);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}
