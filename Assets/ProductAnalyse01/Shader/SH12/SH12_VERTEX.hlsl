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
float3 vec3_ctor(float x0)
{
    return float3(x0, x0, x0);
}

// Uniforms

float3 __WorldSpaceCameraPos;
float4 __WorldSpaceLightPos0;
float4 _hlslcc_mtx4x4unity_ObjectToWorld[4];
float4 _hlslcc_mtx4x4unity_WorldToObject[4];
float4 _unity_WorldTransformParams;
float4 _hlslcc_mtx4x4unity_MatrixVP[4];
float4 _unity_LightmapST;
float4 __GlobalFogParam;
float __GlobalFogHeightDis;
float __GlobalFogHeightDensity;
float __FogLightRadius;
float __FogLightSoft;
float __FogLightHightAtten;
float __HightFogLightRadius;
float __HightFogLightSoft;
float __HightFogLightHightAtten;
float4 __MainTex_ST;
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
static float3 _u_xlat16_2 = {0, 0, 0};
static float3 _u_xlat3 = {0, 0, 0};
static float3 _u_xlat4 = {0, 0, 0};
static float3 _u_xlat5 = {0, 0, 0};
static float _u_xlat6 = {0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float _u_xlat16_12 = {0};
static float _u_xlat15 = {0};

struct VS_INPUT
{
    float4 _in_POSITION0 : POSITION;
    float3 _in_NORMAL0 : NORMAL;
    float2 _in_TEXCOORD0 : TEXCOORD0;
    float2 _in_TEXCOORD1 : TEXCOORD1;
    float4 _in_TANGENT0 : TANGENT;
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
    output.dx_Position = gl_Position;
    // output.dx_Position.x = gl_Position.x;
    // output.dx_Position.y = - gl_Position.y;
    // output.dx_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
    // output.dx_Position.w = gl_Position.w;
    output.v0 = _vs_TEXCOORD1;
    output.v1 = _vs_TEXCOORD2;
    output.v2 = _vs_TEXCOORD3;
    output.v3 = _vs_TEXCOORD4;
    output.v4 = _vs_TEXCOORD5;
    output.v5 = _vs_TEXCOORD6;
    output.v6 = _vs_TEXCOORD0;

    return output;
}

VS_OUTPUT vert(VS_INPUT input)
{
    initAttributes(input);

    (_u_xlat0 = (_in_POSITION0.yyyy * _hlslcc_mtx4x4unity_ObjectToWorld[1]));
    (_u_xlat0 = ((_hlslcc_mtx4x4unity_ObjectToWorld[0] * _in_POSITION0.xxxx) + _u_xlat0));
    (_u_xlat0 = ((_hlslcc_mtx4x4unity_ObjectToWorld[2] * _in_POSITION0.zzzz) + _u_xlat0));
    (_u_xlat0 = (_u_xlat0 + _hlslcc_mtx4x4unity_ObjectToWorld[3]));
    (_u_xlat1 = (_u_xlat0.yyyy * _hlslcc_mtx4x4unity_MatrixVP[1]));
    (_u_xlat1 = ((_hlslcc_mtx4x4unity_MatrixVP[0] * _u_xlat0.xxxx) + _u_xlat1));
    (_u_xlat1 = ((_hlslcc_mtx4x4unity_MatrixVP[2] * _u_xlat0.zzzz) + _u_xlat1));
    (_u_xlat0 = ((_hlslcc_mtx4x4unity_MatrixVP[3] * _u_xlat0.wwww) + _u_xlat1));
    (gl_Position = _u_xlat0);
    (_u_xlat0.x = ((_u_xlat0.z * __GlobalFogParam.x) + __GlobalFogParam.y));
    (_vs_TEXCOORD6.x = _u_xlat0.x);
    (_vs_TEXCOORD0.xy = ((_in_TEXCOORD0.xy * __MainTex_ST.xy) + __MainTex_ST.zw));
    (_u_xlat0.y = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[0].xyz));
    (_u_xlat0.z = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[1].xyz));
    (_u_xlat0.x = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[2].xyz));
    (_u_xlat15 = dot(_u_xlat0.xyz, _u_xlat0.xyz));
    (_u_xlat15 = rsqrt(_u_xlat15));
    (_u_xlat0.xyz = (vec3_ctor(_u_xlat15) * _u_xlat0.xyz));//normal
    (_u_xlat1.xyz = (_in_TANGENT0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].yzx));
    (_u_xlat1.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * _in_TANGENT0.xxx) + _u_xlat1.xyz));
    (_u_xlat1.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * _in_TANGENT0.zzz) + _u_xlat1.xyz));
    (_u_xlat15 = dot(_u_xlat1.xyz, _u_xlat1.xyz));
    (_u_xlat15 = rsqrt(_u_xlat15));
    (_u_xlat1.xyz = (vec3_ctor(_u_xlat15) * _u_xlat1.xyz));//tangent
    (_u_xlat16_2.xyz = (_u_xlat0.xyz * _u_xlat1.xyz));
    (_u_xlat16_2.xyz = ((_u_xlat0.zxy * _u_xlat1.yzx) + (-_u_xlat16_2.xyz)));
    (_u_xlat15 = (_in_TANGENT0.w * _unity_WorldTransformParams.w));//sign
    (_u_xlat16_2.xyz = (vec3_ctor(_u_xlat15) * _u_xlat16_2.xyz));//bitangent
    (_vs_TEXCOORD1.y = _u_xlat16_2.x);
    (_vs_TEXCOORD1.x = _u_xlat1.z);
    (_vs_TEXCOORD1.z = _u_xlat0.y);
    (_u_xlat3.xyz = (_in_POSITION0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].xyz));
    (_u_xlat3.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * _in_POSITION0.xxx) + _u_xlat3.xyz));
    (_u_xlat3.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * _in_POSITION0.zzz) + _u_xlat3.xyz));
    (_u_xlat4.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * _in_POSITION0.www) + _u_xlat3.xyz));
    (_u_xlat3.xyz = (_u_xlat3.xyz + _hlslcc_mtx4x4unity_ObjectToWorld[3].xyz));
    (_vs_TEXCOORD1.w = _u_xlat4.x);
    (_vs_TEXCOORD2.x = _u_xlat1.x);
    (_vs_TEXCOORD3.x = _u_xlat1.y);
    (_vs_TEXCOORD2.z = _u_xlat0.z);
    (_vs_TEXCOORD3.z = _u_xlat0.x);
    (_vs_TEXCOORD2.w = _u_xlat4.y);
    (_vs_TEXCOORD3.w = _u_xlat4.z);
    (_vs_TEXCOORD2.y = _u_xlat16_2.y);
    (_vs_TEXCOORD3.y = _u_xlat16_2.z);
    (_vs_TEXCOORD4.zw = float2(0.0, 0.0));
    (_u_xlat0.xy = ((_in_TEXCOORD1.xy * _unity_LightmapST.xy) + _unity_LightmapST.zw));
    (_vs_TEXCOORD4.xy = _u_xlat0.xy);
    (_vs_TEXCOORD5.xy = _u_xlat0.xy);
    (_vs_TEXCOORD5.zw = float2(0.0, 0.0));
    (_u_xlat0.x = (_u_xlat3.y + (-__GlobalFogParam.w)));
    (_u_xlat5.xyz = (_u_xlat3.xyz + (-__WorldSpaceCameraPos.xyz)));
    (_u_xlat16_2.x = ((-__GlobalFogParam.w) + __GlobalFogParam.z));
    (_u_xlatb1 = (0.001 < abs(_u_xlat16_2.x)));
    float sbf5 = {0};
    if (_u_xlatb1)
    {
        (sbf5 = _u_xlat16_2.x);
    }
    else
    {
        (sbf5 = 0.001);
    }
    (_u_xlat16_2.x = sbf5);
    (_u_xlat0.x = (_u_xlat0.x / _u_xlat16_2.x));
    (_u_xlat1.x = dot(_u_xlat5.xyz, _u_xlat5.xyz));
    (_u_xlat6 = sqrt(_u_xlat1.x));
    (_u_xlat1.x = rsqrt(_u_xlat1.x));
    (_u_xlat5.xyz = (_u_xlat5.xyz * _u_xlat1.xxx));//revert view dir
    (_u_xlat1.x = (__GlobalFogHeightDis / _u_xlat6));
    (_u_xlat0.x = (_u_xlat0.x + (-_u_xlat1.x)));
    (_u_xlat16_2.x = (_u_xlat0.x + 1.0));
    (_vs_TEXCOORD6.y = (_u_xlat16_2.x * __GlobalFogHeightDensity));
    (_vs_TEXCOORD6.y = clamp(_vs_TEXCOORD6.y, 0.0, 1.0));
    (_u_xlat16_2.x = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_2.x = rsqrt(_u_xlat16_2.x));
    (_u_xlat16_2.xyz = (_u_xlat16_2.xxx * __WorldSpaceLightPos0.xyz));
    (_u_xlat0.x = dot(_u_xlat16_2.xyz, _u_xlat5.xyz));
    (_u_xlat16_2.x = (_u_xlat0.x + (-__FogLightRadius)));
    (_u_xlat16_12 = (_u_xlat0.x + (-__HightFogLightRadius)));
    (_u_xlat16_2.z = (_u_xlat16_12 / __HightFogLightSoft));
    (_u_xlat16_2.z = clamp(_u_xlat16_2.z, 0.0, 1.0));
    (_u_xlat16_2.x = (_u_xlat16_2.x / __FogLightSoft));
    (_u_xlat16_2.x = clamp(_u_xlat16_2.x, 0.0, 1.0));
    (_u_xlat16_7.z = ((_u_xlat16_2.y * 2.0) + (-__FogLightHightAtten)));
    (_u_xlat16_7.z = clamp(_u_xlat16_7.z, 0.0, 1.0));
    (_u_xlat16_7.x = ((_u_xlat16_2.y * 2.0) + (-__HightFogLightHightAtten)));
    (_u_xlat16_7.x = clamp(_u_xlat16_7.x, 0.0, 1.0));
    (_vs_TEXCOORD6.zw = (_u_xlat16_7.zx * _u_xlat16_2.xz));
    return generateOutput(input);
}
