struct VS_OUTPUT
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
float4 vec4_ctor(float x0)
{
    return float4(x0, x0, x0, x0);
}

// Uniforms

uniform float3 __WorldSpaceCameraPos : register(c1);
uniform float4 __WorldSpaceLightPos0 : register(c2);
uniform float4 _unity_SHAr : register(c3);
uniform float4 _unity_SHAg : register(c4);
uniform float4 _unity_SHAb : register(c5);
uniform float4 _unity_SHBr : register(c6);
uniform float4 _unity_SHBg : register(c7);
uniform float4 _unity_SHBb : register(c8);
uniform float4 _unity_SHC : register(c9);
uniform float4 _hlslcc_mtx4x4unity_ObjectToWorld[4] : register(c10);
uniform float4 _hlslcc_mtx4x4unity_WorldToObject[4] : register(c14);
uniform float4 _unity_WorldTransformParams : register(c18);
uniform float4 _hlslcc_mtx4x4unity_MatrixVP[4] : register(c19);
uniform float4 __GlobalFogParam : register(c23);
uniform float __GlobalFogHeightDis : register(c24);
uniform float __GlobalFogHeightDensity : register(c25);
uniform float __FogLightRadius : register(c26);
uniform float __FogLightSoft : register(c27);
uniform float __FogLightHightAtten : register(c28);
uniform float __HightFogLightRadius : register(c29);
uniform float __HightFogLightSoft : register(c30);
uniform float __HightFogLightHightAtten : register(c31);
uniform float4 __MainTex_ST : register(c32);
#ifdef ANGLE_ENABLE_LOOP_FLATTEN
#define LOOP [loop]
#define FLATTEN [flatten]
#else
#define LOOP
#define FLATTEN
#endif

#define ATOMIC_COUNTER_ARRAY_STRIDE 4

// Attributes
static float4 _in_POSITION0 = {0, 0, 0, 0};
static float4 _in_TANGENT0 = {0, 0, 0, 0};
static float3 _in_NORMAL0 = {0, 0, 0};
static float4 _in_TEXCOORD0 = {0, 0, 0, 0};

static float4 gl_Position = float4(0, 0, 0, 0);

// Varyings
static float4 UV = {0, 0, 0, 0};
static float4 TBN1 = {0, 0, 0, 0};
static float4 TBN2 = {0, 0, 0, 0};
static float4 TBN3 = {0, 0, 0, 0};
static float3 ambientContrib = {0, 0, 0};
static float4 fogAttribute = {0, 0, 0, 0};

cbuffer DriverConstants : register(b1)
{
float4 dx_ViewAdjust : packoffset(c1);
float2 dx_ViewCoords : packoffset(c2);
float2 dx_ViewScale : packoffset(c3);
};

static float4 _u_xlat0 = {0, 0, 0, 0};
static float4 _u_xlat16_0 = {0, 0, 0, 0};
static float4 _u_xlat1 = {0, 0, 0, 0};
static float4 _u_xlat2 = {0, 0, 0, 0};
static bool _u_xlatb2 = {0};
static float4 _u_xlat3 = {0, 0, 0, 0};
static float3 _u_xlat16_4 = {0, 0, 0};
static float3 _u_xlat16_5 = {0, 0, 0};
static float _u_xlat8 = {0};
static float3 _u_xlat16_10 = {0, 0, 0};
static float _u_xlat16_16 = {0};
static float _u_xlat18 = {0};
static float _u_xlat19 = {0};

struct VS_INPUT
{
    float4 _in_POSITION0 : TEXCOORD0;
    float4 _in_TANGENT0 : TEXCOORD1;
    float3 _in_NORMAL0 : TEXCOORD2;
    float4 _in_TEXCOORD0 : TEXCOORD3;
};

void initAttributes(VS_INPUT input)
{
    _in_POSITION0 = input._in_POSITION0;
    _in_TANGENT0 = input._in_TANGENT0;
    _in_NORMAL0 = input._in_NORMAL0;
    _in_TEXCOORD0 = input._in_TEXCOORD0;
}


VS_OUTPUT generateOutput(VS_INPUT input)
{
    VS_OUTPUT output;
    output.gl_Position = gl_Position;
    output.dx_Position.x = gl_Position.x;
    output.dx_Position.y = - gl_Position.y;
    output.dx_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
    output.dx_Position.w = gl_Position.w;
    output.v0 = UV;
    output.v1 = TBN1;
    output.v2 = TBN2;
    output.v3 = TBN3;
    output.v4 = fogAttribute;
    output.v5 = ambientContrib;

    return output;
}

VS_OUTPUT main(VS_INPUT input)
{
    initAttributes(input);

    float4 worldPosTemp;
    (worldPosTemp = (_in_POSITION0.yyyy * _hlslcc_mtx4x4unity_ObjectToWorld[1]));
    (worldPosTemp = ((_hlslcc_mtx4x4unity_ObjectToWorld[0] * _in_POSITION0.xxxx) + worldPosTemp));
    (worldPosTemp = ((_hlslcc_mtx4x4unity_ObjectToWorld[2] * _in_POSITION0.zzzz) + worldPosTemp));
    float4 worldPos;
    (worldPos = (worldPosTemp + _hlslcc_mtx4x4unity_ObjectToWorld[3]));
    (_u_xlat0.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * _in_POSITION0.www) + worldPosTemp.xyz));
    float4 clipPos;
    (clipPos = (worldPos.yyyy * _hlslcc_mtx4x4unity_MatrixVP[1]));
    (clipPos = ((_hlslcc_mtx4x4unity_MatrixVP[0] * worldPos.xxxx) + clipPos));
    (clipPos = ((_hlslcc_mtx4x4unity_MatrixVP[2] * worldPos.zzzz) + clipPos));
    (clipPos = ((_hlslcc_mtx4x4unity_MatrixVP[3] * worldPos.wwww) + clipPos));
    (gl_Position = clipPos);
    (fogAttribute.x = (clipPos.z * __GlobalFogParam.x) + __GlobalFogParam.y);
    (UV.xy = ((_in_TEXCOORD0.xy * __MainTex_ST.xy) + __MainTex_ST.zw));
    (UV.zw = float2(0.0, 0.0));
    (TBN1.w = _u_xlat0.x);
    float4 worldTangent;
    (worldTangent.xyz = (_in_TANGENT0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].yzx));
    (worldTangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * _in_TANGENT0.xxx) + worldTangent.xyz));
    (worldTangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * _in_TANGENT0.zzz) + worldTangent.xyz));
    float temp;
    (temp = dot(worldTangent.xyz, worldTangent.xyz));
    (temp = rsqrt(temp));

    float4 worldTangentNormlized;
    (worldTangentNormlized.xyz = (temp.xxx * worldTangent.xyz));
    (TBN1.x = worldTangentNormlized.z);
    (_u_xlat0.x = (_in_TANGENT0.w * _unity_WorldTransformParams.w));
    float4 worldNormal;
    (worldNormal.x = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[0].xyz));
    (worldNormal.y = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[1].xyz));
    (worldNormal.z = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[2].xyz));
    (temp = dot(worldNormal.xyz, worldNormal.xyz));
    (temp = rsqrt(temp));
    float4 worldNormalNormalized;
    (worldNormalNormalized = (vec4_ctor(temp) * worldNormal.xyzz));
    float4 worldBitangentNormalized;
    (worldBitangentNormalized.xyz = ((worldNormalNormalized.yzx * worldTangentNormlized.yzx) - (worldTangentNormlized.xyz * worldNormalNormalized.zxy)));
    (worldBitangentNormalized.xyz = (_u_xlat0.xxx * worldBitangentNormalized.xyz));
    (TBN1.y = worldBitangentNormalized.x);
    (TBN1.z = worldNormalNormalized.x);
    (TBN2.x = worldTangentNormlized.x);
    (TBN3.x = worldTangentNormlized.y);
    (TBN2.w = _u_xlat0.y);
    (TBN3.w = _u_xlat0.z);
    (TBN2.y = worldBitangentNormalized.y);
    (TBN3.y = worldBitangentNormalized.z);
    (TBN2.z = worldNormalNormalized.y);
    (TBN3.z = worldNormalNormalized.z);
    (_u_xlat16_4.x = (worldNormalNormalized.y * worldNormalNormalized.y));
    (_u_xlat16_4.x = ((worldNormalNormalized.x * worldNormalNormalized.x) + (-_u_xlat16_4.x)));
    (_u_xlat16_0 = (worldNormalNormalized.yzwx * worldNormalNormalized.xywz));
    (_u_xlat16_5.x = dot(_unity_SHBr, _u_xlat16_0));
    (_u_xlat16_5.y = dot(_unity_SHBg, _u_xlat16_0));
    (_u_xlat16_5.z = dot(_unity_SHBb, _u_xlat16_0));
    (_u_xlat16_4.xyz = ((_unity_SHC.xyz * _u_xlat16_4.xxx) + _u_xlat16_5.xyz));
    (worldNormalNormalized.w = 1.0);
    (_u_xlat16_5.x = dot(_unity_SHAr, worldNormalNormalized));
    (_u_xlat16_5.y = dot(_unity_SHAg, worldNormalNormalized));
    (_u_xlat16_5.z = dot(_unity_SHAb, worldNormalNormalized));
    (_u_xlat16_4.xyz = (_u_xlat16_4.xyz + _u_xlat16_5.xyz));
    (ambientContrib.xyz = max(_u_xlat16_4.xyz, float3(0.0, 0.0, 0.0)));
    (_u_xlat19 = (worldPos.y + (-__GlobalFogParam.w)));
    (_u_xlat1.xyz = (worldPos.xyz + (-__WorldSpaceCameraPos.xyz)));
    (_u_xlat16_4.x = ((-__GlobalFogParam.w) + __GlobalFogParam.z));
    (_u_xlatb2 = (0.001 < abs(_u_xlat16_4.x)));
    float sbfb = {0};
    if (_u_xlatb2)
    {
        (sbfb = _u_xlat16_4.x);
    }
    else
    {
        (sbfb = 0.001);
    }
    (_u_xlat16_4.x = sbfb);
    (_u_xlat19 = (_u_xlat19 / _u_xlat16_4.x));
    (_u_xlat2.x = dot(_u_xlat1.xyz, _u_xlat1.xyz));
    (_u_xlat8 = sqrt(_u_xlat2.x));
    (_u_xlat2.x = rsqrt(_u_xlat2.x));
    (_u_xlat1.xyz = (_u_xlat1.xyz * _u_xlat2.xxx));
    (_u_xlat2.x = (__GlobalFogHeightDis / _u_xlat8));
    (_u_xlat19 = (_u_xlat19 + (-_u_xlat2.x)));
    (_u_xlat16_4.x = (_u_xlat19 + 1.0));
    (fogAttribute.y = (_u_xlat16_4.x * __GlobalFogHeightDensity));
    (fogAttribute.y = clamp(fogAttribute.y, 0.0, 1.0));
    (_u_xlat16_4.x = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_4.x = rsqrt(_u_xlat16_4.x));
    (_u_xlat16_4.xyz = (_u_xlat16_4.xxx * __WorldSpaceLightPos0.xyz));
    (_u_xlat1.x = dot(_u_xlat16_4.xyz, _u_xlat1.xyz));
    (_u_xlat16_4.x = (_u_xlat1.x + (-__FogLightRadius)));
    (_u_xlat16_16 = (_u_xlat1.x + (-__HightFogLightRadius)));
    (_u_xlat16_4.z = (_u_xlat16_16 / __HightFogLightSoft));
    (_u_xlat16_4.z = clamp(_u_xlat16_4.z, 0.0, 1.0));
    (_u_xlat16_4.x = (_u_xlat16_4.x / __FogLightSoft));
    (_u_xlat16_4.x = clamp(_u_xlat16_4.x, 0.0, 1.0));
    (_u_xlat16_10.z = ((_u_xlat16_4.y * 2.0) + (-__FogLightHightAtten)));
    (_u_xlat16_10.z = clamp(_u_xlat16_10.z, 0.0, 1.0));
    (_u_xlat16_10.x = ((_u_xlat16_4.y * 2.0) + (-__HightFogLightHightAtten)));
    (_u_xlat16_10.x = clamp(_u_xlat16_10.x, 0.0, 1.0));
    (fogAttribute.zw = (_u_xlat16_10.zx * _u_xlat16_4.xz));
    return generateOutput(input);
}
