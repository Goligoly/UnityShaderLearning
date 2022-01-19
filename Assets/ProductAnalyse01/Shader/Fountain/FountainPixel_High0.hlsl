struct PS_INPUT
{
    float4 dx_Position : SV_Position;
    float4 gl_Position : TEXCOORD8;
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float3 v6 : TEXCOORD6;
    float3 v7 : TEXCOORD7;
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
uniform float4 _unity_SpecCube0_HDR : register(c1);
uniform float4 __LightColor0 : register(c2);
uniform float4 __GlobalFogDistColor : register(c3);
uniform float4 __GlobalFogHeightColor : register(c4);
uniform float __FogLightPow : register(c5);
uniform float __BumpScale : register(c6);
uniform float __Mip : register(c7);
uniform float4 __TintColor : register(c8);
uniform float __Smoothness : register(c9);
uniform float __RefIntensity : register(c10);
uniform float4 __RefColor : register(c11);
uniform float4 __Vector : register(c12);
uniform float __foam : register(c13);
uniform float4 __foamCol : register(c14);
uniform float4 __SpecularColor : register(c15);
static const uint __MainTex = 0;
static const uint __BumpMap = 1;
uniform Texture2D<float4> textures2D[2] : register(t0);
uniform SamplerState samplers2D[2] : register(s0);
static const uint _unity_SpecCube0 = 2;
static const uint textureIndexOffsetCube = 2;
static const uint samplerIndexOffsetCube = 2;
uniform TextureCube<float4> texturesCube[1] : register(t2);
uniform SamplerState samplersCube[1] : register(s2);
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
static float3 _vs_TEXCOORD7 = {0, 0, 0};

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
SamplerMetadata samplerMetadata[3] : packoffset(c4);
};

float4 gl_texture2D(uint samplerIndex, float2 t)
{
    return textures2D[samplerIndex].Sample(samplers2D[samplerIndex], float2(t.x, t.y));
}

float4 gl_textureCubeLod(uint samplerIndex, float3 t, float lod)
{
    const uint textureIndex = samplerIndex - textureIndexOffsetCube;
    const uint samplerArrayIndex = samplerIndex - samplerIndexOffsetCube;
    return texturesCube[textureIndex].SampleLevel(samplersCube[samplerArrayIndex], float3(t.x, t.y, t.z), lod);
}

static float4 _u_xlat0 = {0, 0, 0, 0};
static float4 _u_xlat16_0 = {0, 0, 0, 0};
static float3 _u_xlat16_1 = {0, 0, 0};
static bool4 _u_xlatb1 = {0, 0, 0, 0};
static float3 _u_xlat16_2 = {0, 0, 0};
static float3 _u_xlat16_3 = {0, 0, 0};
static float3 _u_xlat16_4 = {0, 0, 0};
static float _u_xlat5 = {0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float3 _u_xlat16_8 = {0, 0, 0};
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
    float4 MainTexBumpUVs;
    float4 FogParam;
    float4 TBN0;
    float4 TBN1;
    float4 TBN2;
    float3 CameraDir;
    float3 LightDir;
    _vs_COlOR0 = input.v0;
    MainTexBumpUVs = input.v1;
    FogParam = input.v2;
    TBN0 = input.v3;
    TBN1 = input.v4;
    TBN2 = input.v5;
    CameraDir = input.v6.xyz;
    LightDir = input.v7.xyz;

    (_u_xlat0 = (__Time.xxxx * __Vector));
    (_u_xlatb1 = (_u_xlat0 >= (-_u_xlat0)));
    (_u_xlat0 = frac(abs(_u_xlat0)));
    {
        float4 _hlslcc_movcTemp3063 = _u_xlat0;
        float sbf8 = {0};
        if (_u_xlatb1.x)
        {
            (sbf8 = _u_xlat0.x);
        }
        else
        {
            (sbf8 = (-_u_xlat0.x));
        }
        (_hlslcc_movcTemp3063.x = sbf8);
        float sbf9 = {0};
        if (_u_xlatb1.y)
        {
            (sbf9 = _u_xlat0.y);
        }
        else
        {
            (sbf9 = (-_u_xlat0.y));
        }
        (_hlslcc_movcTemp3063.y = sbf9);
        float sbfa = {0};
        if (_u_xlatb1.z)
        {
            (sbfa = _u_xlat0.z);
        }
        else
        {
            (sbfa = (-_u_xlat0.z));
        }
        (_hlslcc_movcTemp3063.z = sbfa);
        float sbfb = {0};
        if (_u_xlatb1.w)
        {
            (sbfb = _u_xlat0.w);
        }
        else
        {
            (sbfb = (-_u_xlat0.w));
        }
        (_hlslcc_movcTemp3063.w = sbfb);
        (_u_xlat0 = _hlslcc_movcTemp3063);
    }
    float4 bumpUVReverse, bump0, bump1;
    (bumpUVReverse.xy = (MainTexBumpUVs.zw * float2(1.0, -1.0)));
    (bump0.xy = ((bumpUVReverse.xy * vec2_ctor(__BumpScale)) + _u_xlat0.zw));
    (bump1.xy = ((MainTexBumpUVs.zw * vec2_ctor(__BumpScale)) + _u_xlat0.xy));
    (bump1.xyz = gl_texture2D(__BumpMap, bump1.xy).xyz);
    (bump0.xyz = gl_texture2D(__BumpMap, bump0.xy).xyz);
    (_u_xlat0.xyz = (bump0.xyz + bump1.xyz));
    (_u_xlat15 = (bump1.y + bump1.x));
    (_u_xlat16_2.xyz = (_u_xlat0.xyz + float3(-1.0, -1.0, -2.0)));

    float4 mainTex, foamParam;
    (mainTex.xy = gl_texture2D(__MainTex, MainTexBumpUVs.xy).xy);
    (_u_xlat16_17 = (mainTex.x * __BumpScale));
    (foamParam.x = (_u_xlat15 * mainTex.y));
    (foamParam.x = (_u_xlat15 * foamParam.x));
    (foamParam.x = (foamParam.x * __foam));

    float4 tangentNormal, worldNormal;
    (tangentNormal.xyz = ((vec3_ctor(_u_xlat16_17) * _u_xlat16_2.xyz) + float3(0.0, 0.0, 1.0)));
    (worldNormal.x = dot(TBN0.xyz, tangentNormal.xyz));
    (worldNormal.y = dot(TBN1.xyz, tangentNormal.xyz));
    (worldNormal.z = dot(TBN2.xyz, tangentNormal.xyz));
    (_u_xlat16_2.x = dot(worldNormal.xyz, worldNormal.xyz));
    (_u_xlat16_2.x = rsqrt(_u_xlat16_2.x));
    (worldNormal.xyz = (_u_xlat16_2.xxx * worldNormal.xyz));

    float4 camNormCos;
    (camNormCos = dot((-CameraDir.xyz), worldNormal.xyz));
    (_u_xlat16_17 = (camNormCos + camNormCos));

    float4 sampleDir, sampleColor, indirectLight;
    (sampleDir.xyz = ((worldNormal.xyz * (-vec3_ctor(_u_xlat16_17))) + (-CameraDir.xyz)));
    (_u_xlat16_17 = dot(sampleDir.xyz, sampleDir.xyz));
    (_u_xlat16_17 = rsqrt(_u_xlat16_17));
    (sampleDir.xyz = (vec3_ctor(_u_xlat16_17) * sampleDir.xyz));
    (_u_xlat16_17 = (((-__Mip) * 0.69999999) + 1.7));
    (_u_xlat16_17 = (_u_xlat16_17 * __Mip));
    (_u_xlat16_17 = (_u_xlat16_17 * 6.0));
    (sampleColor = gl_textureCubeLod(_unity_SpecCube0, sampleDir.xyz, _u_xlat16_17));
    (_u_xlat16_17 = (sampleColor.w + -1.0));
    (_u_xlat16_17 = ((_unity_SpecCube0_HDR.w * _u_xlat16_17) + 1.0));
    (_u_xlat16_17 = log2(_u_xlat16_17));
    (_u_xlat16_17 = (_u_xlat16_17 * _unity_SpecCube0_HDR.y));
    (_u_xlat16_17 = exp2(_u_xlat16_17));
    (_u_xlat16_17 = (_u_xlat16_17 * _unity_SpecCube0_HDR.x));
    
    (sampleColor.xyz = (sampleColor.xyz * vec3_ctor(_u_xlat16_17)));
    (indirectLight.x = dot(sampleColor.xyz, float3(0.30000001, 0.60000002, 0.1)));
    (sampleColor.xyz = (sampleColor.xyz * vec3_ctor(vec3_ctor(__RefIntensity, __RefIntensity, __RefIntensity))));
    (sampleColor.xyz = ((sampleColor.xyz * __RefColor.xyz) + __TintColor.xyz));
    (_u_xlat16_17 = ((foamParam.x * __foamCol.w) + __TintColor.w));
    (indirectLight.x = (indirectLight.x + _u_xlat16_17));

    float4 halfDir, normalDotHalf, normalDotCam, oneMinusNormalDotCam, lightDotHalf;
    (halfDir.xyz = (CameraDir.xyz + LightDir.xyz));
    (_u_xlat16_17 = dot(halfDir.xyz, halfDir.xyz));
    (_u_xlat16_17 = rsqrt(_u_xlat16_17));
    (halfDir.xyz = (vec3_ctor(_u_xlat16_17) * halfDir.xyz));
    
    (normalDotHalf = dot(worldNormal.xyz, halfDir.xyz));
    (normalDotHalf = clamp(normalDotHalf, 0.0, 1.0));
    
    (normalDotCam.x = dot(worldNormal.xyz, CameraDir.xyz));
    (normalDotCam.x = clamp(normalDotCam.x, 0.0, 1.0));
    (oneMinusNormalDotCam.x = ((-normalDotCam.x) + 1.0));
    
    (lightDotHalf.x = dot(LightDir.xyz, halfDir.xyz));
    (lightDotHalf.x = clamp(lightDotHalf.x, 0.0, 1.0));
    (lightDotHalf.x = (lightDotHalf.x * lightDotHalf.x));
    (lightDotHalf = max(lightDotHalf.x, 0.1));

    float smoothness, directLight;
    (smoothness.x = ((-__Smoothness) + 1.0));
    (smoothness.y = (smoothness.x * smoothness.x));
    (smoothness.x = ((smoothness.x * smoothness.x) + 0.5));
    (_u_xlat5 = (smoothness.x * lightDotHalf));
    (smoothness.x = ((smoothness.y * smoothness.y) + -1.0));
    (_u_xlat10.x = (((normalDotHalf * normalDotHalf) * smoothness.x) + 1.00001));
    (_u_xlat16_7.xy = (_u_xlat10.xy * _u_xlat10.xy));
    (_u_xlat5 = (_u_xlat5 * _u_xlat16_7.x));
    (_u_xlat5 = (_u_xlat5 * 4.0));
    (_u_xlat5 = (_u_xlat16_7.y / _u_xlat5));
    (directLight.x = min(_u_xlat5, 5.0));

    float transparency, finalColor;
    (transparency.x = ((indirectLight.x * oneMinusNormalDotCam.x) + directLight.x));
    (transparency.x = clamp(transparency.x, 0.0, 1.0));
    (finalColor.xyz = ((directLight.xxx * __SpecularColor.xyz) + sampleColor.xyz));
    (finalColor.xyz = ((foamParam.xxx * __foamCol.xyz) + finalColor.xyz));
    (out_SV_Target0.w = (transparency.x * _vs_COlOR0.w));
    (_u_xlat16_3.xyz = (__LightColor0.xyz + (-__GlobalFogDistColor.xyz)));
    (_u_xlat16_4.xy = FogParam.xy);
    (_u_xlat16_4.xy = clamp(_u_xlat16_4.xy, 0.0, 1.0));
    (_u_xlat16_2.x = ((-_u_xlat16_4.x) + 1.0));
    (_u_xlat16_14.xy = (_u_xlat16_2.xx * FogParam.zw));
    (_u_xlat16_14.xy = (_u_xlat16_14.xy * vec2_ctor(__FogLightPow)));
    (_u_xlat16_14.xy = clamp(_u_xlat16_14.xy, 0.0, 1.0));
    (_u_xlat16_3.xyz = ((_u_xlat16_14.xxx * _u_xlat16_3.xyz) + __GlobalFogDistColor.xyz));
    (_u_xlat16_2.xyz = (finalColor.xyz + (-_u_xlat16_3.xyz)));
    (_u_xlat16_2.xyz = ((_u_xlat16_4.xxx * _u_xlat16_2.xyz) + _u_xlat16_3.xyz));
    (_u_xlat16_3.xyz = (__LightColor0.xyz + (-__GlobalFogHeightColor.xyz)));
    (_u_xlat16_3.xyz = ((_u_xlat16_14.yyy * _u_xlat16_3.xyz) + __GlobalFogHeightColor.xyz));
    (_u_xlat16_3.xyz = ((-_u_xlat16_2.xyz) + _u_xlat16_3.xyz));
    (out_SV_Target0.xyz = ((_u_xlat16_4.yyy * _u_xlat16_3.xyz) + _u_xlat16_2.xyz));
    return generateOutput();
}
