struct VS_OUTPUT
{
    float4 dx_Position : SV_Position;
    float4 gl_Position : TEXCOORD7;
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float2 v6 : TEXCOORD6;
};
#pragma warning( disable: 3556 3571 )
// Uniforms

uniform float3 __WorldSpaceCameraPos : register(c1);
uniform float4 __WorldSpaceLightPos0 : register(c2);
uniform float4 _hlslcc_mtx4x4unity_ObjectToWorld[4] : register(c3);
uniform float4 _hlslcc_mtx4x4unity_WorldToObject[4] : register(c7);
uniform float4 _unity_WorldTransformParams : register(c11);
uniform float4 _hlslcc_mtx4x4unity_MatrixVP[4] : register(c12);
uniform float4 _unity_LightmapST : register(c16);
uniform float4 __GlobalFogParam : register(c17);
uniform float __GlobalFogHeightDis : register(c18);
uniform float __GlobalFogHeightDensity : register(c19);
uniform float __FogLightRadius : register(c20);
uniform float __FogLightSoft : register(c21);
uniform float __FogLightHightAtten : register(c22);
uniform float __HightFogLightRadius : register(c23);
uniform float __HightFogLightSoft : register(c24);
uniform float __HightFogLightHightAtten : register(c25);
uniform float4 __MainTex_ST : register(c26);
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
static float3 _in_NORMAL0 = {0, 0, 0};
static float2 _in_TEXCOORD0 = {0, 0};
static float2 _in_TEXCOORD1 = {0, 0};
static float4 _in_TANGENT0 = {0, 0, 0, 0};

static float4 gl_Position = float4(0, 0, 0, 0);

// Varyings
static float2 _vs_TEXCOORD0 = {0, 0};
static float4 _vs_TEXCOORD1 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD2 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD3 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD4 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD5 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD6 = {0, 0, 0, 0};

cbuffer DriverConstants : register(b1)
{
float4 dx_ViewAdjust : packoffset(c1);
float2 dx_ViewCoords : packoffset(c2);
float2 dx_ViewScale : packoffset(c3);
};

static float4 _u_xlat0 = {0, 0, 0, 0};
static float4 _u_xlat1 = {0, 0, 0, 0};
static bool _u_xlatb1 = {0};
static float4 _u_xlat2 = {0, 0, 0, 0};
static float3 _u_xlat3 = {0, 0, 0};
static float3 _u_xlat16_4 = {0, 0, 0};
static float3 _u_xlat5 = {0, 0, 0};
static float _u_xlat6 = {0};
static float3 _u_xlat16_9 = {0, 0, 0};
static float _u_xlat16_14 = {0};
static float _u_xlat15 = {0};

struct VS_INPUT
{
    float4 _in_POSITION0 : TEXCOORD0;
    float3 _in_NORMAL0 : TEXCOORD1;
    float2 _in_TEXCOORD0 : TEXCOORD2;
    float2 _in_TEXCOORD1 : TEXCOORD3;
    float4 _in_TANGENT0 : TEXCOORD4;
};

void initAttributes(VS_INPUT input)
{
    _in_POSITION0 = input._in_POSITION0;
    _in_NORMAL0 = input._in_NORMAL0;
    _in_TEXCOORD0 = input._in_TEXCOORD0;
    _in_TEXCOORD1 = input._in_TEXCOORD1;
    _in_TANGENT0 = input._in_TANGENT0;
}


VS_OUTPUT generateOutput(VS_INPUT input)
{
    VS_OUTPUT output;
    output.gl_Position = gl_Position;
    output.dx_Position.x = gl_Position.x;
    output.dx_Position.y = - gl_Position.y;
    output.dx_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
    output.dx_Position.w = gl_Position.w;
    output.v0 = _vs_TEXCOORD1;
    output.v1 = _vs_TEXCOORD2;
    output.v2 = _vs_TEXCOORD3;
    output.v3 = _vs_TEXCOORD4;
    output.v4 = _vs_TEXCOORD5;
    output.v5 = _vs_TEXCOORD6;
    output.v6 = _vs_TEXCOORD0;

    return output;
}

VS_OUTPUT main(VS_INPUT input)
{
    initAttributes(input);

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
    (_u_xlat15 = ((_u_xlat2.z * __GlobalFogParam.x) + __GlobalFogParam.y));
    (_vs_TEXCOORD6.x = _u_xlat15);
    (_vs_TEXCOORD0.xy = ((_in_TEXCOORD0.xy * __MainTex_ST.xy) + __MainTex_ST.zw));
    (_vs_TEXCOORD1.w = _u_xlat0.x);
    (_u_xlat2.y = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[0].xyz));
    (_u_xlat2.z = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[1].xyz));
    (_u_xlat2.x = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[2].xyz));
    (_u_xlat0.x = dot(_u_xlat2.xyz, _u_xlat2.xyz));
    (_u_xlat0.x = rsqrt(_u_xlat0.x));
    (_u_xlat2.xyz = (_u_xlat0.xxx * _u_xlat2.xyz));
    (_u_xlat3.xyz = (_in_TANGENT0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].yzx));
    (_u_xlat3.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * _in_TANGENT0.xxx) + _u_xlat3.xyz));
    (_u_xlat3.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * _in_TANGENT0.zzz) + _u_xlat3.xyz));
    (_u_xlat0.x = dot(_u_xlat3.xyz, _u_xlat3.xyz));
    (_u_xlat0.x = rsqrt(_u_xlat0.x));
    (_u_xlat3.xyz = (_u_xlat0.xxx * _u_xlat3.xyz));
    (_u_xlat16_4.xyz = (_u_xlat2.xyz * _u_xlat3.xyz));
    (_u_xlat16_4.xyz = ((_u_xlat2.zxy * _u_xlat3.yzx) + (-_u_xlat16_4.xyz)));
    (_u_xlat0.x = (_in_TANGENT0.w * _unity_WorldTransformParams.w));
    (_u_xlat16_4.xyz = (_u_xlat0.xxx * _u_xlat16_4.xyz));
    (_vs_TEXCOORD1.y = _u_xlat16_4.x);
    (_vs_TEXCOORD1.x = _u_xlat3.z);
    (_vs_TEXCOORD1.z = _u_xlat2.y);
    (_vs_TEXCOORD2.x = _u_xlat3.x);
    (_vs_TEXCOORD3.x = _u_xlat3.y);
    (_vs_TEXCOORD2.z = _u_xlat2.z);
    (_vs_TEXCOORD3.z = _u_xlat2.x);
    (_vs_TEXCOORD2.w = _u_xlat0.y);
    (_vs_TEXCOORD3.w = _u_xlat0.z);
    (_vs_TEXCOORD2.y = _u_xlat16_4.y);
    (_vs_TEXCOORD3.y = _u_xlat16_4.z);
    (_vs_TEXCOORD4.zw = float2(0.0, 0.0));
    (_u_xlat0.xy = ((_in_TEXCOORD1.xy * _unity_LightmapST.xy) + _unity_LightmapST.zw));
    (_vs_TEXCOORD4.xy = _u_xlat0.xy);
    (_vs_TEXCOORD5.xy = _u_xlat0.xy);
    (_vs_TEXCOORD5.zw = float2(0.0, 0.0));
    (_u_xlat0.x = (_u_xlat1.y + (-__GlobalFogParam.w)));
    (_u_xlat5.xyz = (_u_xlat1.xyz + (-__WorldSpaceCameraPos.xyz)));
    (_u_xlat16_4.x = ((-__GlobalFogParam.w) + __GlobalFogParam.z));
    (_u_xlatb1 = (0.001 < abs(_u_xlat16_4.x)));
    float sbf5 = {0};
    if (_u_xlatb1)
    {
        (sbf5 = _u_xlat16_4.x);
    }
    else
    {
        (sbf5 = 0.001);
    }
    (_u_xlat16_4.x = sbf5);
    (_u_xlat0.x = (_u_xlat0.x / _u_xlat16_4.x));
    (_u_xlat1.x = dot(_u_xlat5.xyz, _u_xlat5.xyz));
    (_u_xlat6 = sqrt(_u_xlat1.x));
    (_u_xlat1.x = rsqrt(_u_xlat1.x));
    (_u_xlat5.xyz = (_u_xlat5.xyz * _u_xlat1.xxx));
    (_u_xlat1.x = (__GlobalFogHeightDis / _u_xlat6));
    (_u_xlat0.x = (_u_xlat0.x + (-_u_xlat1.x)));
    (_u_xlat16_4.x = (_u_xlat0.x + 1.0));
    (_vs_TEXCOORD6.y = (_u_xlat16_4.x * __GlobalFogHeightDensity));
    (_vs_TEXCOORD6.y = clamp(_vs_TEXCOORD6.y, 0.0, 1.0));
    (_u_xlat16_4.x = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_4.x = rsqrt(_u_xlat16_4.x));
    (_u_xlat16_4.xyz = (_u_xlat16_4.xxx * __WorldSpaceLightPos0.xyz));
    (_u_xlat0.x = dot(_u_xlat16_4.xyz, _u_xlat5.xyz));
    (_u_xlat16_4.x = (_u_xlat0.x + (-__FogLightRadius)));
    (_u_xlat16_14 = (_u_xlat0.x + (-__HightFogLightRadius)));
    (_u_xlat16_4.z = (_u_xlat16_14 / __HightFogLightSoft));
    (_u_xlat16_4.z = clamp(_u_xlat16_4.z, 0.0, 1.0));
    (_u_xlat16_4.x = (_u_xlat16_4.x / __FogLightSoft));
    (_u_xlat16_4.x = clamp(_u_xlat16_4.x, 0.0, 1.0));
    (_u_xlat16_9.z = ((_u_xlat16_4.y * 2.0) + (-__FogLightHightAtten)));
    (_u_xlat16_9.z = clamp(_u_xlat16_9.z, 0.0, 1.0));
    (_u_xlat16_9.x = ((_u_xlat16_4.y * 2.0) + (-__HightFogLightHightAtten)));
    (_u_xlat16_9.x = clamp(_u_xlat16_9.x, 0.0, 1.0));
    (_vs_TEXCOORD6.zw = (_u_xlat16_9.zx * _u_xlat16_4.xz));
    return generateOutput(input);
}
