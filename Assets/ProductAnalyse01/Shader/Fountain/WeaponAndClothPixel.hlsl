struct PS_INPUT
{
    float4 dx_Position : SV_Position;
    float4 gl_Position : TEXCOORD6;
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float3 v5 : TEXCOORD5;
};

#pragma warning( disable: 3556 3571 )
float2 vec2_ctor(float x0)
{
    return float2(x0, x0);
}

float2 vec2_ctor(float x0, float x1)
{
    return float2(x0, x1);
}

float2 vec2_ctor(int2 x0)
{
    return float2(x0);
}

float3 vec3_ctor(float x0)
{
    return float3(x0, x0, x0);
}

float4 vec4_ctor(float x0)
{
    return float4(x0, x0, x0, x0);
}

int2 ivec2_ctor(uint2 x0)
{
    return int2(x0);
}

uint uint_ctor(int x0)
{
    return uint(x0);
}

uint uint_ctor(uint x0)
{
    return uint(x0);
}

// Uniforms

uniform float3 __WorldSpaceCameraPos : register(c0);
uniform float4 __WorldSpaceLightPos0 : register(c1);
uniform float4 _unity_SpecCube0_HDR : register(c2);
uniform float4 __LightColor0 : register(c3);
uniform float4 __GlobalRoleLight : register(c4);
uniform float __GlobalRoleLightPower : register(c5);
uniform float4 __GlobalRoleSecondLightColor : register(c6);
uniform float __GlobalRoleSecondLightPower : register(c7);
uniform float __GlobalRoleSecondLightYPostion : register(c8);
uniform float __GlobalRoleEnvLightPower : register(c9);
uniform float4 __GlobalRoleEnvLightColor : register(c10);
uniform float4 __GlobalFogDistColor : register(c11);
uniform float4 __GlobalFogHeightColor : register(c12);
uniform float __FogLightPow : register(c13);
uniform float4 _hlslcc_mtx4x4_csmWorld2Shadow[8] : register(c14);
uniform float4 __csmSetShadow : register(c22);
uniform int __csmShadowMapTexture0_Size : register(c23);
uniform float4 __Color : register(c24);
uniform float __Metallic : register(c25);
uniform float __Glossiness : register(c26);
uniform float __AOStrength : register(c27);
uniform float __RefPower : register(c28);
uniform float __IsRain : register(c29);
static const uint __MainTex = 0;
static const uint __MixMap = 1;
static const uint __csmShadowMapTexture0 = 2;
uniform Texture2D<float4> textures2D[3] : register(t0);
uniform SamplerState samplers2D[3] : register(s0);
static const uint _unity_SpecCube0 = 3;
static const uint textureIndexOffsetCube = 3;
static const uint samplerIndexOffsetCube = 3;
uniform TextureCube<float4> texturesCube[1] : register(t3);
uniform SamplerState samplersCube[1] : register(s3);
#ifdef ANGLE_ENABLE_LOOP_FLATTEN
#define LOOP [loop]
#define FLATTEN [flatten]
#else
#define LOOP
#define FLATTEN
#endif

#define ATOMIC_COUNTER_ARRAY_STRIDE 4

// Varyings
static float4 UV = {0, 0, 0, 0};
static float4 TBN1 = {0, 0, 0, 0};
static float4 TBN2 = {0, 0, 0, 0};
static float4 TBN3 = {0, 0, 0, 0};
static float3 ambientContrib = {0, 0, 0};
static float4 fogAttribute = {0, 0, 0, 0};

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
SamplerMetadata samplerMetadata[4] : packoffset(c4);
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
static bool4 _u_xlatb0 = {0, 0, 0, 0};
static float4 _u_xlat1 = {0, 0, 0, 0};
static float4 _u_xlat16_1 = {0, 0, 0, 0};
static float4 _u_xlat2 = {0, 0, 0, 0};
static float4 _u_xlat3 = {0, 0, 0, 0};
static float4 _u_xlat16_3 = {0, 0, 0, 0};
static float3 _u_xlat4 = {0, 0, 0};
static float3 _u_xlat5 = {0, 0, 0};
static float3 _u_xlat16_6 = {0, 0, 0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float3 _u_xlat16_8 = {0, 0, 0};
static float3 _u_xlat16_9 = {0, 0, 0};
static float3 _u_xlat16_10 = {0, 0, 0};
static float3 _u_xlat16_11 = {0, 0, 0};
static float3 _u_xlat16_12 = {0, 0, 0};
static float3 _u_xlat16_13 = {0, 0, 0};
static float _u_xlat14 = {0};
static uint2 _u_xlatu14 = {0, 0};
static float _u_xlat16_15 = {0};
static float3 _u_xlat16_20 = {0, 0, 0};
static float3 _u_xlat16_21 = {0, 0, 0};
static float3 _u_xlat16_22 = {0, 0, 0};
static float3 _u_xlat16_26 = {0, 0, 0};
static float2 _u_xlat28 = {0, 0};
static bool2 _u_xlatb28 = {0, 0};
static float _u_xlat16_35 = {0};
static float2 _u_xlat16_36 = {0, 0};
static float _u_xlat42 = {0};
static float _u_xlat16_48 = {0};
static float _u_xlat16_49 = {0};
static float _u_xlat16_50 = {0};
static float _u_xlat16_51 = {0};

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
    UV = input.v0;
    TBN1 = input.v1;
    TBN2 = input.v2;
    TBN3 = input.v3;
    fogAttribute = input.v4;
    ambientContrib = input.v5.xyz;

    (_u_xlat0.x = (__csmSetShadow.x + -0.44999999));
    (_u_xlat0.x = (_u_xlat0.x * 0.80000001));
    (_u_xlat0.x = clamp(_u_xlat0.x, 0.0, 1.0));
    (_u_xlat14 = ((_u_xlat0.x * -2.0) + 3.0));
    (_u_xlat0.x = (_u_xlat0.x * _u_xlat0.x));
    (_u_xlat0.x = (_u_xlat0.x * _u_xlat14));
    (_u_xlatu14.x = uint_ctor(max(__csmShadowMapTexture0_Size, 256)));
    (_u_xlatu14.y = uint_ctor((_u_xlatu14.x >> 8)));
    (_u_xlat16_1.xy = vec2_ctor(ivec2_ctor(_u_xlatu14.xy)));
    (_u_xlat14 = (0.012 / _u_xlat16_1.y));
    (_u_xlat14 = (_u_xlat14 + -0.0060000001));
    (_u_xlat14 = ((_u_xlat0.x * _u_xlat14) + 0.0060000001));
    (_u_xlat0.x = ((_u_xlat0.x * -0.79999995) + 2.0));
    float4 lightPos;
    (lightPos = (TBN2.wwww * _hlslcc_mtx4x4_csmWorld2Shadow[1]));
    (lightPos = ((_hlslcc_mtx4x4_csmWorld2Shadow[0] * TBN1.wwww) + lightPos));
    (lightPos = ((_hlslcc_mtx4x4_csmWorld2Shadow[2] * TBN3.wwww) + lightPos));
    (lightPos = (lightPos + _hlslcc_mtx4x4_csmWorld2Shadow[3]));
    (lightPos.xyz = (lightPos.xyz / lightPos.www));
    (lightPos.xyz = ((lightPos.xyz * float3(0.5, 0.5, 0.5)) + float3(0.5, 0.5, 0.5)));
    float lightDepth;
    (lightDepth.x = ((-lightPos.z) + 1.0));
    (lightDepth.x = max(lightDepth.x, 1e-07));
    (_u_xlat14 = (_u_xlat14 + lightDepth.x));
    (_u_xlat3.w = 1.0);
    float3 worldPos;
    (worldPos.x = TBN1.w);
    (worldPos.y = TBN2.w);
    (worldPos.z = TBN3.w);
    (_u_xlat5.xyz = (worldPos.xyz * float3(1000.0, 1000.0, 1000.0)));
    float3 worldViewDir;
    (worldViewDir.xyz = ((-worldPos.xyz) + __WorldSpaceCameraPos.xyz));
    (_u_xlat3.xyz = floor(_u_xlat5.xyz));
    (_u_xlat28.x = dot(_u_xlat3, float4(12.9898, 78.233002, 45.164001, 94.672997)));
    (_u_xlat28.x = sin(_u_xlat28.x));
    (_u_xlat28.x = (_u_xlat28.x * 43758.547));
    (_u_xlat28.x = frac(_u_xlat28.x));
    (_u_xlat16_15 = (_u_xlat28.x * 6.283185));
    (_u_xlat16_6.x = sin(_u_xlat16_15));
    (_u_xlat16_7.x = cos(_u_xlat16_15));
    (_u_xlat16_3 = (_u_xlat16_7.xxxx * float4(-0.38999999, 0.94, -0.75999999, -0.94)));
    (_u_xlat16_3 = ((_u_xlat16_6.xxxx * float4(-0.94, -0.38999999, 0.94, -0.75999999)) + _u_xlat16_3));
    (_u_xlat3 = (_u_xlat0.xxxx * _u_xlat16_3));
    (_u_xlat3 = (_u_xlat3 / _u_xlat16_1.xxxx));
    (_u_xlat3 = (_u_xlat2.xyxy + _u_xlat3));
    (_u_xlat28.x = gl_texture2D(__csmShadowMapTexture0, _u_xlat3.xy).x);
    (_u_xlat28.y = gl_texture2D(__csmShadowMapTexture0, _u_xlat3.zw).x);
    (_u_xlat28.xy = ((-_u_xlat28.xy) + float2(1.0, 1.0)));
    (_u_xlatb28.xy = (_u_xlat28.xyxy >= vec4_ctor(_u_xlat14)).xy);
    float sc11 = {0};
    if (_u_xlatb28.x)
    {
        (sc11 = 0.0);
    }
    else
    {
        (sc11 = 1.0);
    }
    (_u_xlat28.x = sc11);
    float sc12 = {0};
    if (_u_xlatb28.y)
    {
        (sc12 = -1.0);
    }
    else
    {
        (sc12 = -0.0);
    }
    (_u_xlat28.y = sc12);
    (_u_xlat28.x = (_u_xlat28.y + _u_xlat28.x));
    (_u_xlat28.x = (_u_xlat28.x + 1.0));
    (_u_xlat16_3 = (_u_xlat16_7.xxxx * float4(-0.92000002, 0.090000004, 0.28999999, -0.34)));
    (_u_xlat16_3 = ((_u_xlat16_6.xxxx * float4(-0.090000004, -0.92000002, 0.34, 0.28999999)) + _u_xlat16_3));
    (_u_xlat3 = (_u_xlat0.xxxx * _u_xlat16_3));
    (_u_xlat1 = (_u_xlat3 / _u_xlat16_1.xxxx));
    (_u_xlat1 = (_u_xlat1 + _u_xlat2.xyxy));
    (_u_xlat0.x = gl_texture2D(__csmShadowMapTexture0, _u_xlat1.xy).x);
    (_u_xlat0.w = gl_texture2D(__csmShadowMapTexture0, _u_xlat1.zw).x);
    (_u_xlat0.xw = ((-_u_xlat0.xw) + float2(1.0, 1.0)));
    (_u_xlatb0.xw = (_u_xlat0.xxxw >= vec4_ctor(_u_xlat14)).xw);
    float sc13 = {0};
    if (_u_xlatb0.x)
    {
        (sc13 = -1.0);
    }
    else
    {
        (sc13 = -0.0);
    }
    (_u_xlat0.x = sc13);
    float sc14 = {0};
    if (_u_xlatb0.w)
    {
        (sc14 = -1.0);
    }
    else
    {
        (sc14 = -0.0);
    }
    (_u_xlat0.w = sc14);
    (_u_xlat0.x = (_u_xlat0.x + _u_xlat28.x));
    (_u_xlat0.x = (_u_xlat0.x + 1.0));
    (_u_xlat0.x = (_u_xlat0.w + _u_xlat0.x));
    (_u_xlat0.x = (_u_xlat0.x + 1.0));
    (_u_xlat16_6.x = (_u_xlat0.x * 0.25));
    (_u_xlat16_20.xyz = ((-ambientContrib.xyz) + __GlobalRoleEnvLightColor.xyz));
    (_u_xlat16_20.xyz = ((vec3_ctor(__GlobalRoleEnvLightPower) * _u_xlat16_20.xyz) + ambientContrib.xyz));
    (_u_xlat0.x = TBN1.z);
    (_u_xlat0.y = TBN2.z);
    (_u_xlat0.z = TBN3.z);
    (_u_xlat16_7.x = dot(_u_xlat0.xyz, _u_xlat0.xyz));
    (_u_xlat16_7.x = rsqrt(_u_xlat16_7.x));
    (_u_xlat16_7.xyz = ((_u_xlat0.xyz * _u_xlat16_7.xxx) + float3(0.0, 0.99000001, 0.0)));
    (_u_xlat16_49 = dot(_u_xlat16_7.xyz, _u_xlat16_7.xyz));
    (_u_xlat16_49 = rsqrt(_u_xlat16_49));
    (_u_xlat16_7.xyz = (vec3_ctor(_u_xlat16_49) * _u_xlat16_7.xyz));
    (_u_xlat16_0 = gl_texture2D(__MixMap, UV.xy));
    (_u_xlat16_8.xy = ((_u_xlat16_0.yz * float2(2.0, 2.0)) + float2(-1.0, -1.0)));
    (_u_xlat16_49 = dot(_u_xlat16_8.xy, _u_xlat16_8.xy));
    (_u_xlat16_49 = min(_u_xlat16_49, 1.0));
    (_u_xlat16_49 = ((-_u_xlat16_49) + 1.0));
    (_u_xlat16_8.z = sqrt(_u_xlat16_49));
    (_u_xlat16_49 = dot(_u_xlat16_8.xyz, _u_xlat16_8.xyz));
    (_u_xlat16_49 = rsqrt(_u_xlat16_49));
    (_u_xlat16_8.xyz = (vec3_ctor(_u_xlat16_49) * _u_xlat16_8.xyz));
    (_u_xlat2.x = dot(TBN1.xyz, _u_xlat16_8.xyz));
    (_u_xlat2.y = dot(TBN2.xyz, _u_xlat16_8.xyz));
    (_u_xlat2.z = dot(TBN3.xyz, _u_xlat16_8.xyz));
    (_u_xlat16_49 = dot(_u_xlat2.xyz, _u_xlat2.xyz));
    (_u_xlat16_49 = rsqrt(_u_xlat16_49));
    (_u_xlat16_8.xyz = (_u_xlat2.xyz * vec3_ctor(_u_xlat16_49)));
    (_u_xlat16_7.x = dot(_u_xlat16_7.xyz, _u_xlat16_8.xyz));
    (_u_xlat16_7.x = ((_u_xlat16_7.x * 0.5) + 0.5));
    (_u_xlat16_20.xyz = (_u_xlat16_20.xyz * _u_xlat16_7.xxx));
    (_u_xlat16_7.x = ((-__AOStrength) + 1.0));
    (_u_xlat16_1 = gl_texture2D(__MainTex, UV.xy));
    (_u_xlat16_7.x = (_u_xlat16_7.x + _u_xlat16_1.w));
    (_u_xlat16_7.x = clamp(_u_xlat16_7.x, 0.0, 1.0));
    (_u_xlat16_20.xyz = (_u_xlat16_20.xyz * _u_xlat16_7.xxx));
    (_u_xlat16_21.x = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_21.x = rsqrt(_u_xlat16_21.x));
    (_u_xlat16_9.xyz = (_u_xlat16_21.xxx * __WorldSpaceLightPos0.xyz));
    (_u_xlat16_35 = dot(_u_xlat16_8.xyz, _u_xlat16_9.xyz));
    (_u_xlat16_35 = clamp(_u_xlat16_35, 0.0, 1.0));
    (_u_xlat16_9.xyz = (__GlobalRoleLight.xyz * vec3_ctor(__GlobalRoleLightPower)));
    (_u_xlat16_9.xyz = (_u_xlat16_9.xyz * __LightColor0.xyz));
    (_u_xlat16_10.xyz = (vec3_ctor(_u_xlat16_35) * _u_xlat16_9.xyz));
    (_u_xlat16_10.xyz = ((_u_xlat16_10.xyz * _u_xlat16_6.xxx) + _u_xlat16_20.xyz));
    (_u_xlat14 = dot(worldViewDir.xyz, worldViewDir.xyz));
    (_u_xlat14 = rsqrt(_u_xlat14));
    float3 worldViewDirNormalized;
    (worldViewDirNormalized.xyz = (vec3_ctor(_u_xlat14) * worldViewDir.xyz));
    (_u_xlat16_11.y = ((worldViewDir.y * _u_xlat14) + __GlobalRoleSecondLightYPostion));
    (_u_xlat16_12.xyz = ((__WorldSpaceLightPos0.xyz * _u_xlat16_21.xxx) + worldViewDirNormalized.xyz));
    (_u_xlat14 = dot(_u_xlat16_12.xyz, _u_xlat16_12.xyz));
    (_u_xlat14 = max(_u_xlat14, 0.001));
    (_u_xlat14 = rsqrt(_u_xlat14));
    (_u_xlat4.xyz = (vec3_ctor(_u_xlat14) * _u_xlat16_12.xyz));
    (_u_xlat16_21.x = dot(_u_xlat16_8.xyz, _u_xlat4.xyz));
    (_u_xlat16_21.x = clamp(_u_xlat16_21.x, 0.0, 1.0));
    (_u_xlat14 = (((-_u_xlat16_21.x) * _u_xlat16_21.x) + 1.0));
    (_u_xlat16_49 = (((-_u_xlat16_0.w) * __Glossiness) + 0.60000002));
    (_u_xlat16_12.xy = (_u_xlat16_0.xw * vec2_ctor(__Metallic, __Glossiness)));
    (_u_xlat16_49 = ((__IsRain * _u_xlat16_49) + _u_xlat16_12.y));
    (_u_xlat0.x = ((-_u_xlat16_49) + 1.0));
    (_u_xlat28.x = max(_u_xlat0.x, 0.089000002));
    (_u_xlat28.x = (_u_xlat28.x * _u_xlat28.x));
    (_u_xlat42 = (_u_xlat28.x * _u_xlat16_21.x));
    (_u_xlat14 = ((_u_xlat42 * _u_xlat42) + _u_xlat14));
    (_u_xlat14 = (_u_xlat28.x / _u_xlat14));
    (_u_xlat16_21.x = (_u_xlat14 * _u_xlat14));
    (_u_xlat16_21.x = (_u_xlat16_35 * _u_xlat16_21.x));
    (_u_xlat14 = (_u_xlat16_21.x * 0.25));
    (_u_xlat14 = min(_u_xlat14, 12.0));
    (_u_xlat16_6.x = (_u_xlat16_6.x * _u_xlat14));
    (_u_xlat16_9.xyz = (_u_xlat16_9.xyz * _u_xlat16_6.xxx));
    (_u_xlat16_26.xyz = ((_u_xlat16_1.xyz * __Color.xyz) + float3(-0.039999999, -0.039999999, -0.039999999)));
    (_u_xlat16_13.xyz = (_u_xlat16_1.xyz * __Color.xyz));
    (_u_xlat16_26.xyz = ((_u_xlat16_12.xxx * _u_xlat16_26.xyz) + float3(0.039999999, 0.039999999, 0.039999999)));
    (_u_xlat16_6.x = (((-_u_xlat16_12.x) * 0.95999998) + 0.95999998));
    (_u_xlat16_9.xyz = (_u_xlat16_9.xyz * _u_xlat16_26.xyz));
    (_u_xlat16_13.xyz = (_u_xlat16_6.xxx * _u_xlat16_13.xyz));
    (_u_xlat16_6.x = ((-_u_xlat16_6.x) + _u_xlat16_49));
    (_u_xlat16_6.x = (_u_xlat16_6.x + 1.0));
    (_u_xlat16_6.x = clamp(_u_xlat16_6.x, 0.0, 1.0));
    (_u_xlat16_21.xyz = ((-_u_xlat16_26.xyz) + _u_xlat16_6.xxx));
    (_u_xlat16_9.xyz = ((_u_xlat16_13.xyz * _u_xlat16_10.xyz) + _u_xlat16_9.xyz));
    (_u_xlat16_11.xz = worldViewDirNormalized.xz);
    (_u_xlat14 = dot(_u_xlat16_11.xyz, _u_xlat16_11.xyz));
    (_u_xlat14 = max(_u_xlat14, 0.001));
    (_u_xlat14 = rsqrt(_u_xlat14));
    (_u_xlat4.xyz = (vec3_ctor(_u_xlat14) * _u_xlat16_11.xyz));
    (_u_xlat16_10.xyz = ((_u_xlat16_11.xyz * vec3_ctor(_u_xlat14)) + worldViewDirNormalized.xyz));
    (_u_xlat5.xyz = (_u_xlat16_10.xyz + float3(9.9999997e-05, 9.9999997e-05, 9.9999997e-05)));
    (_u_xlat16_6.x = dot(_u_xlat16_8.xyz, _u_xlat4.xyz));
    (_u_xlat16_6.x = clamp(_u_xlat16_6.x, 0.0, 1.0));
    (_u_xlat16_10.xyz = (__GlobalRoleSecondLightColor.xyz * vec3_ctor(__GlobalRoleSecondLightPower)));
    (_u_xlat16_10.xyz = (_u_xlat16_6.xxx * _u_xlat16_10.xyz));
    (_u_xlat16_10.xyz = (_u_xlat16_13.xyz * _u_xlat16_10.xyz));
    (_u_xlat16_9.xyz = ((_u_xlat16_10.xyz * _u_xlat16_20.xyz) + _u_xlat16_9.xyz));
    (_u_xlat14 = dot(_u_xlat5.xyz, _u_xlat5.xyz));
    (_u_xlat14 = rsqrt(_u_xlat14));
    (_u_xlat4.xyz = (vec3_ctor(_u_xlat14) * _u_xlat5.xyz));
    (_u_xlat16_50 = dot(_u_xlat16_8.xyz, _u_xlat4.xyz));
    (_u_xlat16_50 = clamp(_u_xlat16_50, 0.0, 1.0));
    (_u_xlat14 = (((-_u_xlat16_50) * _u_xlat16_50) + 1.0));
    (_u_xlat42 = (_u_xlat28.x * _u_xlat16_50));
    (_u_xlat14 = ((_u_xlat42 * _u_xlat42) + _u_xlat14));
    (_u_xlat14 = (_u_xlat28.x / _u_xlat14));
    (_u_xlat16_50 = ((_u_xlat28.x * _u_xlat28.x) + 1.0));
    (_u_xlat16_50 = (1.0 / _u_xlat16_50));
    (_u_xlat16_51 = (_u_xlat14 * _u_xlat14));
    (_u_xlat16_6.x = (_u_xlat16_6.x * _u_xlat16_51));
    (_u_xlat14 = (_u_xlat16_6.x * 0.25));
    (_u_xlat14 = min(_u_xlat14, 8.0));
    (_u_xlat16_10.xyz = (_u_xlat16_26.xyz * vec3_ctor(_u_xlat14)));
    (_u_xlat16_6.xyz = ((_u_xlat16_10.xyz * _u_xlat16_20.xyz) + _u_xlat16_9.xyz));
    (_u_xlat16_48 = (((-_u_xlat0.x) * 0.69999999) + 1.7));
    (_u_xlat16_48 = (_u_xlat0.x * _u_xlat16_48));
    (_u_xlat16_48 = (_u_xlat16_48 * 6.0));
    (_u_xlat16_9.x = dot((-worldViewDirNormalized.xyz), _u_xlat16_8.xyz));
    (_u_xlat16_9.x = (_u_xlat16_9.x + _u_xlat16_9.x));
    (_u_xlat16_9.xyz = ((_u_xlat16_8.xyz * (-_u_xlat16_9.xxx)) + (-worldViewDirNormalized.xyz)));
    (_u_xlat16_8.x = dot(_u_xlat16_8.xyz, worldViewDirNormalized.xyz));
    (_u_xlat16_8.x = clamp(_u_xlat16_8.x, 0.0, 1.0));
    (_u_xlat16_8.x = ((-_u_xlat16_8.x) + 1.0));
    (_u_xlat16_22.x = dot(_u_xlat16_9.xyz, _u_xlat16_9.xyz));
    (_u_xlat16_22.x = rsqrt(_u_xlat16_22.x));
    (_u_xlat16_9.xyz = (_u_xlat16_22.xxx * _u_xlat16_9.xyz));
    (_u_xlat16_0 = gl_textureCubeLod(_unity_SpecCube0, _u_xlat16_9.xyz, _u_xlat16_48));
    (_u_xlat16_48 = (_u_xlat16_0.w + -1.0));
    (_u_xlat16_48 = ((_unity_SpecCube0_HDR.w * _u_xlat16_48) + 1.0));
    (_u_xlat16_48 = log2(_u_xlat16_48));
    (_u_xlat16_48 = (_u_xlat16_48 * _unity_SpecCube0_HDR.y));
    (_u_xlat16_48 = exp2(_u_xlat16_48));
    (_u_xlat16_48 = (_u_xlat16_48 * _unity_SpecCube0_HDR.x));
    (_u_xlat16_9.xyz = (_u_xlat16_0.xyz * vec3_ctor(_u_xlat16_48)));
    (_u_xlat16_48 = ((-__RefPower) + 2.0));
    (_u_xlat16_48 = ((__IsRain * _u_xlat16_48) + __RefPower));
    (_u_xlat16_9.xyz = (vec3_ctor(_u_xlat16_48) * _u_xlat16_9.xyz));
    (_u_xlat16_9.xyz = (_u_xlat16_7.xxx * _u_xlat16_9.xyz));
    (_u_xlat16_22.xyz = (vec3_ctor(_u_xlat16_50) * _u_xlat16_9.xyz));
    (_u_xlat16_48 = (_u_xlat16_8.x * _u_xlat16_8.x));
    (_u_xlat16_48 = (_u_xlat16_48 * _u_xlat16_48));
    (_u_xlat16_48 = (_u_xlat16_8.x * _u_xlat16_48));
    (_u_xlat16_7.xyz = ((vec3_ctor(_u_xlat16_48) * _u_xlat16_21.xyz) + _u_xlat16_26.xyz));
    (_u_xlat16_6.xyz = ((_u_xlat16_22.xyz * _u_xlat16_7.xyz) + _u_xlat16_6.xyz));
    (_u_xlat16_7.xyz = (__LightColor0.xyz + (-__GlobalFogDistColor.xyz)));
    (_u_xlat16_8.xy = fogAttribute.xy);
    (_u_xlat16_8.xy = clamp(_u_xlat16_8.xy, 0.0, 1.0));
    (_u_xlat16_48 = ((-_u_xlat16_8.x) + 1.0));
    (_u_xlat16_36.xy = (vec2_ctor(_u_xlat16_48) * fogAttribute.zw));
    (_u_xlat16_36.xy = (_u_xlat16_36.xy * vec2_ctor(__FogLightPow)));
    (_u_xlat16_36.xy = clamp(_u_xlat16_36.xy, 0.0, 1.0));
    (_u_xlat16_7.xyz = ((_u_xlat16_36.xxx * _u_xlat16_7.xyz) + __GlobalFogDistColor.xyz));
    (_u_xlat16_6.xyz = (_u_xlat16_6.xyz + (-_u_xlat16_7.xyz)));
    (_u_xlat16_6.xyz = ((_u_xlat16_8.xxx * _u_xlat16_6.xyz) + _u_xlat16_7.xyz));
    (_u_xlat16_7.xyz = (__LightColor0.xyz + (-__GlobalFogHeightColor.xyz)));
    (_u_xlat16_7.xyz = ((_u_xlat16_36.yyy * _u_xlat16_7.xyz) + __GlobalFogHeightColor.xyz));
    (_u_xlat16_7.xyz = ((-_u_xlat16_6.xyz) + _u_xlat16_7.xyz));
    (_u_xlat16_6.xyz = ((_u_xlat16_8.yyy * _u_xlat16_7.xyz) + _u_xlat16_6.xyz));
    (out_SV_Target0.xyz = min(_u_xlat16_6.xyz, float3(5.0, 5.0, 5.0)));
    (out_SV_Target0.w = 1.0);
    return generateOutput();
}
