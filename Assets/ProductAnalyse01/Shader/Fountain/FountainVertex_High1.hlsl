struct VS_OUTPUT
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
float3 vec3_ctor(float x0)
{
    return float3(x0, x0, x0);
}

// Uniforms

uniform float3 __WorldSpaceCameraPos : register(c1);
uniform float4 __WorldSpaceLightPos0 : register(c2);
uniform float4 _hlslcc_mtx4x4unity_ObjectToWorld[4] : register(c3);
uniform float4 _hlslcc_mtx4x4unity_WorldToObject[4] : register(c7);
uniform float4 _unity_WorldTransformParams : register(c11);
uniform float4 _hlslcc_mtx4x4unity_MatrixVP[4] : register(c12);
uniform float4 __GlobalFogParam : register(c16);
uniform float __GlobalFogHeightDis : register(c17);
uniform float __GlobalFogHeightDensity : register(c18);
uniform float __FogLightRadius : register(c19);
uniform float __FogLightSoft : register(c20);
uniform float __FogLightHightAtten : register(c21);
uniform float __HightFogLightRadius : register(c22);
uniform float __HightFogLightSoft : register(c23);
uniform float __HightFogLightHightAtten : register(c24);
uniform float4 __MainTex_ST : register(c25);
uniform float4 __BumpMap_ST : register(c26);
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
static float4 _in_COLOR0 = {0, 0, 0, 0};

static float4 gl_Position = float4(0, 0, 0, 0);

// Varyings
static float4 _vs_COlOR0 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD0 = {0, 0, 0, 0};
static float3 _vs_TEXCOORD1 = {0, 0, 0};
static float4 _vs_TEXCOORD2 = {0, 0, 0, 0};
static float2 _vs_TEXCOORD3 = {0, 0};
static float4 _vs_TEXCOORD4 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD5 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD6 = {0, 0, 0, 0};
static float3 _vs_TEXCOORD7 = {0, 0, 0};

cbuffer DriverConstants : register(b1)
{
float4 dx_ViewAdjust : packoffset(c1);
float2 dx_ViewCoords : packoffset(c2);
float2 dx_ViewScale : packoffset(c3);
};

static float4 _u_xlat0 = {0, 0, 0, 0};
static float4 _u_xlat1 = {0, 0, 0, 0};
static float4 _u_xlat2 = {0, 0, 0, 0};
static float3 _u_xlat16_3 = {0, 0, 0};
static float _u_xlat16_7 = {0};
static float2 _u_xlat16_11 = {0, 0};
static float _u_xlat12 = {0};
static float _u_xlat13 = {0};
static bool _u_xlatb13 = {0};

struct VS_INPUT
{
    float4 _in_POSITION0 : TEXCOORD0;
    float4 _in_TANGENT0 : TEXCOORD1;
    float3 _in_NORMAL0 : TEXCOORD2;
    float4 _in_TEXCOORD0 : TEXCOORD3;
    float4 _in_COLOR0 : TEXCOORD4;
};

void initAttributes(VS_INPUT input)
{
    _in_POSITION0 = input._in_POSITION0;
    _in_TANGENT0 = input._in_TANGENT0;
    _in_NORMAL0 = input._in_NORMAL0;
    _in_TEXCOORD0 = input._in_TEXCOORD0;
    _in_COLOR0 = input._in_COLOR0;
}


VS_OUTPUT generateOutput(VS_INPUT input)
{
    VS_OUTPUT output;
    output.gl_Position = gl_Position;
    output.dx_Position.x = gl_Position.x;
    output.dx_Position.y = - gl_Position.y;
    output.dx_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
    output.dx_Position.w = gl_Position.w;
    output.v0 = _vs_COlOR0;
    output.v1 = _vs_TEXCOORD0;//MaintexAndBumpUVs
    output.v2 = _vs_TEXCOORD2;//FogParam
    output.v3 = _vs_TEXCOORD4;//TBN0 w:worldPos
    output.v4 = _vs_TEXCOORD5;//TBN1
    output.v5 = _vs_TEXCOORD6;//TBN2
    output.v6 = _vs_TEXCOORD1;//CameraDirNormalized
    output.v7 = _vs_TEXCOORD7;//LightDir

    return output;
}

VS_OUTPUT main(VS_INPUT input)
{
    initAttributes(input);

    (_vs_COlOR0 = _in_COLOR0);
    (_u_xlat0 = (_in_POSITION0.yyyy * _hlslcc_mtx4x4unity_ObjectToWorld[1]));
    (_u_xlat0 = ((_hlslcc_mtx4x4unity_ObjectToWorld[0] * _in_POSITION0.xxxx) + _u_xlat0));
    (_u_xlat0 = ((_hlslcc_mtx4x4unity_ObjectToWorld[2] * _in_POSITION0.zzzz) + _u_xlat0));
    (_u_xlat1 = (_u_xlat0 + _hlslcc_mtx4x4unity_ObjectToWorld[3]));
    (_u_xlat0.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * _in_POSITION0.www) + _u_xlat0.xyz));
    (_u_xlat2 = (_u_xlat1.yyyy * _hlslcc_mtx4x4unity_MatrixVP[1]));
    (_u_xlat2 = ((_hlslcc_mtx4x4unity_MatrixVP[0] * _u_xlat1.xxxx) + _u_xlat2));
    (_u_xlat2 = ((_hlslcc_mtx4x4unity_MatrixVP[2] * _u_xlat1.zzzz) + _u_xlat2));
    (_u_xlat2 = ((_hlslcc_mtx4x4unity_MatrixVP[3] * _u_xlat1.wwww) + _u_xlat2));
    (gl_Position = _u_xlat2);
    (_u_xlat12 = ((_u_xlat2.z * __GlobalFogParam.x) + __GlobalFogParam.y));
    (_vs_TEXCOORD2.x = _u_xlat12);
    (_u_xlat2.xy = ((_in_TEXCOORD0.xy * __MainTex_ST.xy) + __MainTex_ST.zw));
    (_u_xlat2.zw = ((_in_TEXCOORD0.xy * __BumpMap_ST.xy) + __BumpMap_ST.zw));
    (_vs_TEXCOORD0 = _u_xlat2);
    (_u_xlat2.xyz = ((-_u_xlat0.xyz) + __WorldSpaceCameraPos.xyz));
    (_u_xlat12 = dot(_u_xlat2.xyz, _u_xlat2.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (_u_xlat2.xyz = (vec3_ctor(_u_xlat12) * _u_xlat2.xyz));
    (_vs_TEXCOORD1.xyz = _u_xlat2.xyz);
    (_u_xlat12 = (_u_xlat1.y + (-__GlobalFogParam.w)));
    (_u_xlat1.xyz = (_u_xlat1.xyz + (-__WorldSpaceCameraPos.xyz)));
    (_u_xlat16_3.x = ((-__GlobalFogParam.w) + __GlobalFogParam.z));
    (_u_xlatb13 = (0.001 < abs(_u_xlat16_3.x)));
    float sbf5 = {0};
    if (_u_xlatb13)
    {
        (sbf5 = _u_xlat16_3.x);
    }
    else
    {
        (sbf5 = 0.001);
    }
    (_u_xlat16_3.x = sbf5);
    (_u_xlat12 = (_u_xlat12 / _u_xlat16_3.x));
    (_u_xlat13 = dot(_u_xlat1.xyz, _u_xlat1.xyz));
    (_u_xlat2.x = sqrt(_u_xlat13));
    (_u_xlat13 = rsqrt(_u_xlat13));
    (_u_xlat1.xyz = (vec3_ctor(_u_xlat13) * _u_xlat1.xyz));
    (_u_xlat13 = (__GlobalFogHeightDis / _u_xlat2.x));
    (_u_xlat12 = (_u_xlat12 + (-_u_xlat13)));
    (_u_xlat16_3.x = (_u_xlat12 + 1.0));
    (_vs_TEXCOORD2.y = (_u_xlat16_3.x * __GlobalFogHeightDensity));
    (_vs_TEXCOORD2.y = clamp(_vs_TEXCOORD2.y, 0.0, 1.0));
    (_u_xlat12 = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (_u_xlat2.xyz = (vec3_ctor(_u_xlat12) * __WorldSpaceLightPos0.xyz));
    (_u_xlat12 = dot(_u_xlat2.xyz, _u_xlat1.xyz));
    (_u_xlat16_3.x = (_u_xlat12 + (-__FogLightRadius)));
    (_u_xlat16_7 = (_u_xlat12 + (-__HightFogLightRadius)));
    (_u_xlat16_3.y = (_u_xlat16_7 / __HightFogLightSoft));
    (_u_xlat16_3.y = clamp(_u_xlat16_3.y, 0.0, 1.0));
    (_u_xlat16_3.x = (_u_xlat16_3.x / __FogLightSoft));
    (_u_xlat16_3.x = clamp(_u_xlat16_3.x, 0.0, 1.0));
    (_u_xlat16_11.x = ((_u_xlat2.y * 2.0) + (-__FogLightHightAtten)));
    (_u_xlat16_11.x = clamp(_u_xlat16_11.x, 0.0, 1.0));
    (_u_xlat16_11.y = ((_u_xlat2.y * 2.0) + (-__HightFogLightHightAtten)));
    (_u_xlat16_11.y = clamp(_u_xlat16_11.y, 0.0, 1.0));
    (_vs_TEXCOORD2.zw = (_u_xlat16_11.xy * _u_xlat16_3.xy));
    (_vs_TEXCOORD3.xy = float2(0.0, 0.0));
    
    float4 normal;
    (normal.y = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[0].xyz));
    (normal.z = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[1].xyz));
    (normal.x = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[2].xyz));
    (_u_xlat12 = dot(normal.xyz, normal.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (normal.xyz = (vec3_ctor(_u_xlat12) * normal.xyz));

    float4 tangent;
    (tangent.xyz = (_in_TANGENT0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].yzx));
    (tangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * _in_TANGENT0.xxx) + tangent.xyz));
    (tangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * _in_TANGENT0.zzz) + tangent.xyz));
    (_u_xlat12 = dot(tangent.xyz, tangent.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (tangent.xyz = (vec3_ctor(_u_xlat12) * tangent.xyz));

    float4 bitangent;
    (bitangent.xyz = (normal.xyz * tangent.xyz));
    (bitangent.xyz = ((normal.zxy * tangent.yzx) + (-bitangent.xyz)));
    (_u_xlat12 = (_in_TANGENT0.w * _unity_WorldTransformParams.w));
    (bitangent.xyz = (vec3_ctor(_u_xlat12) * bitangent.xyz));
    (_vs_TEXCOORD4.y = bitangent.x);
    (_vs_TEXCOORD4.w = _u_xlat0.x);
    (_vs_TEXCOORD4.x = tangent.z);
    (_vs_TEXCOORD4.z = normal.y);
    (_vs_TEXCOORD5.x = tangent.x);
    (_vs_TEXCOORD6.x = tangent.y);
    (_vs_TEXCOORD5.z = normal.z);
    (_vs_TEXCOORD6.z = normal.x);
    (_vs_TEXCOORD5.y = bitangent.y);
    (_vs_TEXCOORD6.y = bitangent.z);
    (_vs_TEXCOORD5.w = _u_xlat0.y);
    (_vs_TEXCOORD6.w = _u_xlat0.z);
    (_u_xlat0.xyz = (((-_u_xlat0.xyz) * __WorldSpaceLightPos0.www) + __WorldSpaceLightPos0.xyz));
    (_vs_TEXCOORD7.xyz = _u_xlat0.xyz);
    return generateOutput(input);
}
