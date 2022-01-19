struct PS_INPUT
{
    float4 dx_Position : SV_Position;
    float4 gl_Position : TEXCOORD7;
    float4 v0 : TEXCOORD0; //color0
    float4 v1 : TEXCOORD1; //UVs
    float4 v2 : TEXCOORD2; //FogParam
    float4 v3 : TEXCOORD3; //TBN0
    float4 v4 : TEXCOORD4; //TBN1
    float4 v5 : TEXCOORD5; //TBN2
    float3 v6 : TEXCOORD6; //CameraDirNormlized
};

#pragma warning( disable: 3556 3571 )
float2 vec2_ctor(float x0)
{
    return float2(x0, x0);
}

float3 vec3_ctor(float x0)
{
    return float3(x0, x0, x0);
}

float3 vec3_ctor(float x0, float x1, float x2)
{
    return float3(x0, x1, x2);
}

float3 vec3_ctor(float3 x0)
{
    return float3(x0);
}

// Uniforms

uniform float4 __Time : register(c0);
uniform float4 __LightColor0 : register(c1);
uniform float4 __GlobalFogDistColor : register(c2);
uniform float4 __GlobalFogHeightColor : register(c3);
uniform float __FogLightPow : register(c4);
uniform float __BumpScale : register(c5);
uniform float4 __TintColor : register(c6);
uniform float __RefIntensity : register(c7);
uniform float4 __RefColor : register(c8);
uniform float4 __Vector : register(c9);
uniform float __foam : register(c10);
uniform float4 __foamCol : register(c11);
static const uint __MainTex = 0;
static const uint __BumpMap = 1;
uniform Texture2D<float4> textures2D[2] : register(t0);
uniform SamplerState samplers2D[2] : register(s0);
#ifdef ANGLE_ENABLE_LOOP_FLATTEN
#define LOOP [loop]
#define FLATTEN [flatten]
#else
#define LOOP
#define FLATTEN
#endif

#define ATOMIC_COUNTER_ARRAY_STRIDE 4

// Varyings
static float4 _vs_COlOR0 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD0 = {0, 0, 0, 0};
static float3 _vs_TEXCOORD1 = {0, 0, 0};
static float4 _vs_TEXCOORD2 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD4 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD5 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD6 = {0, 0, 0, 0};

static float4 out_SV_Target0 = {0, 0, 0, 0};

cbuffer DriverConstants : register(b1)
{
struct SamplerMetadata
{
    int baseLevel;
    int internalFormatBits;
    int wrapModes;
    int padding;
    int4 intBorderColor;
};
SamplerMetadata samplerMetadata[2] : packoffset(c4);
};

float4 gl_texture2D(uint samplerIndex, float2 t)
{
    return textures2D[samplerIndex].Sample(samplers2D[samplerIndex], float2(t.x, t.y));
}

static float4 _u_xlat0 = {0, 0, 0, 0};
static float3 _u_xlat16_0 = {0, 0, 0};
static float3 _u_xlat16_1 = {0, 0, 0};
static bool4 _u_xlatb1 = {0, 0, 0, 0};
static float3 _u_xlat16_2 = {0, 0, 0};
static float3 _u_xlat16_3 = {0, 0, 0};
static float3 _u_xlat16_4 = {0, 0, 0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float2 _u_xlat10 = {0, 0};
static float2 _u_xlat16_14 = {0, 0};
static float _u_xlat15 = {0};
static float _u_xlat16_17 = {0};

struct PS_OUTPUT
{
    float4 out_SV_Target0 : SV_TARGET0;
};

PS_OUTPUT generateOutput()
{
    PS_OUTPUT output;
    output.out_SV_Target0 = out_SV_Target0;
    return output;
}


PS_OUTPUT main(PS_INPUT input)
{
    float4 MainTexAndBumpUVs;
    float4 FogParam;
    float4 TBN0;
    float4 TBN1;
    float4 TBN2;
    float3 CameraDirNormlized;
    
    _vs_COlOR0 = input.v0;
    MainTexAndBumpUVs = input.v1;
    FogParam = input.v2;
    TBN0 = input.v3;
    TBN1 = input.v4;
    TBN2 = input.v5;
    CameraDirNormlized = input.v6.xyz;

    (_u_xlat0 = (__Time.xxxx * __Vector));
    (_u_xlatb1 = (_u_xlat0 >= (-_u_xlat0)));
    (_u_xlat0 = frac(abs(_u_xlat0)));
    {
        float4 _hlslcc_movcTemp3055 = _u_xlat0;
        float sbf0 = {0};
        if (_u_xlatb1.x)
        {
            (sbf0 = _u_xlat0.x);
        }
        else
        {
            (sbf0 = (-_u_xlat0.x));
        }
        (_hlslcc_movcTemp3055.x = sbf0);
        float sbf1 = {0};
        if (_u_xlatb1.y)
        {
            (sbf1 = _u_xlat0.y);
        }
        else
        {
            (sbf1 = (-_u_xlat0.y));
        }
        (_hlslcc_movcTemp3055.y = sbf1);
        float sbf2 = {0};
        if (_u_xlatb1.z)
        {
            (sbf2 = _u_xlat0.z);
        }
        else
        {
            (sbf2 = (-_u_xlat0.z));
        }
        (_hlslcc_movcTemp3055.z = sbf2);
        float sbf3 = {0};
        if (_u_xlatb1.w)
        {
            (sbf3 = _u_xlat0.w);
        }
        else
        {
            (sbf3 = (-_u_xlat0.w));
        }
        (_hlslcc_movcTemp3055.w = sbf3);
        (_u_xlat0 = _hlslcc_movcTemp3055);
    }
    float4 bumpUV, bumpUVReverseY;
    (bumpUVReverseY.xy = (MainTexAndBumpUVs.zw * float2(1.0, -1.0)));
    (bumpUVReverseY.xy = ((bumpUVReverseY.xy * vec2_ctor(__BumpScale)) + _u_xlat0.zw));
    (bumpUV.xy = ((MainTexAndBumpUVs.zw * vec2_ctor(__BumpScale)) + _u_xlat0.xy));
    
    float4 bump0, bump1, bump;
    (bump0.xyz = gl_texture2D(__BumpMap, bumpUV.xy).xyz);
    (bump1.xyz = gl_texture2D(__BumpMap, bumpUVReverseY.xy).xyz);
    (bump.xyz = (bump1.xyz + bump0.xyz));
    (_u_xlat15 = (bump0.y + bump0.x));
    (bump.xyz = (bump.xyz + float3(-1.0, -1.0, -2.0)));
    
    float4 maintex;
    (maintex.xy = gl_texture2D(__MainTex, MainTexAndBumpUVs.xy).xy);
    (_u_xlat16_17 = (maintex.x * __BumpScale));
    float foamParam;
    (foamParam = (_u_xlat15 * maintex.y));
    (foamParam = (_u_xlat15 * foamParam));
    (foamParam = (foamParam * __foam));
    
    float4 tangentNormal, worldNormal, worldNormalNormalized;
    (tangentNormal.xyz = ((vec3_ctor(_u_xlat16_17) * bump.xyz) + float3(0.0, 0.0, 1.0)));
    (worldNormal.x = dot(TBN0.xyz, tangentNormal.xyz));
    (worldNormal.y = dot(TBN1.xyz, tangentNormal.xyz));
    (worldNormal.z = dot(TBN2.xyz, tangentNormal.xyz));
    (_u_xlat16_2.x = dot(worldNormal.xyz, worldNormal.xyz));
    (_u_xlat16_2.x = rsqrt(_u_xlat16_2.x));
    (worldNormalNormalized.xyz = (_u_xlat16_2.xxx * worldNormal.xyz));
    (_u_xlat16_17 = (worldNormalNormalized.y * worldNormalNormalized.x));
    
    float camNormCos, oneMinusCamNormCos;
    (camNormCos = dot(worldNormalNormalized.xyz, CameraDirNormlized.xyz));
    (camNormCos = clamp(camNormCos, 0.0, 1.0));
    (oneMinusCamNormCos = ((-camNormCos) + 1.0));
    (_u_xlat16_7.xyz = ((vec3_ctor(_u_xlat16_17) * float3(0.0, 0.099999994, 0.19999999)) + float3(
        0.30000001, 0.40000001, 0.5)));
    (_u_xlat16_7.xyz = (_u_xlat16_7.xyz * vec3_ctor(vec3_ctor(__RefIntensity, __RefIntensity, __RefIntensity))));
    (_u_xlat16_7.xyz = ((_u_xlat16_7.xyz * __RefColor.xyz) + __TintColor.xyz));
    (_u_xlat16_7.xyz = ((_u_xlat16_3.xxx * __foamCol.xyz) + _u_xlat16_7.xyz));
    float waterTransparency;
    (waterTransparency = (oneMinusCamNormCos * (foamParam * __foamCol.w + __TintColor.w)));
    (out_SV_Target0.w = (waterTransparency * _vs_COlOR0.w));
    float4 fogColor, fogParamXY, fogParamZW, oneMinusFogParamXY;
    (fogColor.xyz = (__LightColor0.xyz + (-__GlobalFogDistColor.xyz)));
    (fogParamXY.xy = FogParam.xy);
    (fogParamXY.xy = clamp(fogParamXY.xy, 0.0, 1.0));
    (oneMinusFogParamXY.x = ((-fogParamXY.x) + 1.0));
    (fogParamZW.xy = (oneMinusFogParamXY.xx * FogParam.zw));
    (fogParamZW.xy = (fogParamZW.xy * vec2_ctor(__FogLightPow)));
    (fogParamZW.xy = clamp(fogParamZW.xy, 0.0, 1.0));
    (_u_xlat16_3.xyz = ((fogParamZW.xxx * fogColor.xyz) + __GlobalFogDistColor.xyz));
    (_u_xlat16_2.xyz = (_u_xlat16_7.xyz + (-_u_xlat16_3.xyz)));
    (_u_xlat16_2.xyz = ((fogParamXY.xxx * _u_xlat16_2.xyz) + _u_xlat16_3.xyz));
    (_u_xlat16_3.xyz = (__LightColor0.xyz + (-__GlobalFogHeightColor.xyz)));
    (_u_xlat16_3.xyz = ((fogParamZW.yyy * _u_xlat16_3.xyz) + __GlobalFogHeightColor.xyz));
    (_u_xlat16_3.xyz = ((-_u_xlat16_2.xyz) + _u_xlat16_3.xyz));
    (out_SV_Target0.xyz = ((fogParamXY.yyy * _u_xlat16_3.xyz) + _u_xlat16_2.xyz));
    return generateOutput();
}
