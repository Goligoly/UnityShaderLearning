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
    float3 v6 : TEXCOORD6;
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
    output.v1 = _vs_TEXCOORD0;
    output.v2 = _vs_TEXCOORD2;
    output.v3 = _vs_TEXCOORD4;
    output.v4 = _vs_TEXCOORD5;
    output.v5 = _vs_TEXCOORD6;
    output.v6 = _vs_TEXCOORD1;

    return output;
}

VS_OUTPUT main(VS_INPUT input)
{
    initAttributes(input);

    (_vs_COlOR0 = _in_COLOR0);
    float4 worldPos;
    (worldPos = (_in_POSITION0.yyyy * _hlslcc_mtx4x4unity_ObjectToWorld[1]));
    (worldPos = ((_hlslcc_mtx4x4unity_ObjectToWorld[0] * _in_POSITION0.xxxx) + worldPos));
    (worldPos = ((_hlslcc_mtx4x4unity_ObjectToWorld[2] * _in_POSITION0.zzzz) + worldPos));
    (_u_xlat1 = (worldPos + _hlslcc_mtx4x4unity_ObjectToWorld[3]));
    (worldPos.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * _in_POSITION0.www) + worldPos.xyz));
    float4 projectPos;
    (projectPos = (_u_xlat1.yyyy * _hlslcc_mtx4x4unity_MatrixVP[1]));
    (projectPos = ((_hlslcc_mtx4x4unity_MatrixVP[0] * _u_xlat1.xxxx) + projectPos));
    (projectPos = ((_hlslcc_mtx4x4unity_MatrixVP[2] * _u_xlat1.zzzz) + projectPos));
    (projectPos = ((_hlslcc_mtx4x4unity_MatrixVP[3] * _u_xlat1.wwww) + projectPos));
    (gl_Position = projectPos);
    (_u_xlat12 = ((projectPos.z * __GlobalFogParam.x) + __GlobalFogParam.y));
    (_vs_TEXCOORD2.x = _u_xlat12);
    float4 UVs;
    (UVs.xy = ((_in_TEXCOORD0.xy * __MainTex_ST.xy) + __MainTex_ST.zw));
    (UVs.zw = ((_in_TEXCOORD0.xy * __BumpMap_ST.xy) + __BumpMap_ST.zw));
    (_vs_TEXCOORD0 = UVs);
    float4 cameraDirCustom;
    float4 cameraDirCustomNormlized;
    (cameraDirCustom.xyz = ((-worldPos.xyz) + __WorldSpaceCameraPos.xyz));
    (_u_xlat12 = dot(cameraDirCustom.xyz, cameraDirCustom.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (cameraDirCustomNormlized.xyz = (vec3_ctor(_u_xlat12) * cameraDirCustom.xyz));
    (_vs_TEXCOORD1.xyz = cameraDirCustomNormlized.xyz);
    (_u_xlat12 = (_u_xlat1.y + (-__GlobalFogParam.w)));
    float4 cameraDir;
    (cameraDir.xyz = (_u_xlat1.xyz + (-__WorldSpaceCameraPos.xyz)));
    (_u_xlat16_3.x = ((-__GlobalFogParam.w) + __GlobalFogParam.z));
    (_u_xlatb13 = (0.001 < abs(_u_xlat16_3.x)));
    float sbf4 = {0};
    if (_u_xlatb13)
    {
        (sbf4 = _u_xlat16_3.x);
    }
    else
    {
        (sbf4 = 0.001);
    }
    (_u_xlat16_3.x = sbf4);
    (_u_xlat12 = (_u_xlat12 / _u_xlat16_3.x));
    (_u_xlat13 = dot(cameraDir.xyz, cameraDir.xyz));
    (_u_xlat2.x = sqrt(_u_xlat13));
    (_u_xlat13 = rsqrt(_u_xlat13));
    float4 cameraDirNormlized;
    (cameraDirNormlized.xyz = (vec3_ctor(_u_xlat13) * cameraDir.xyz));
    (_u_xlat13 = (__GlobalFogHeightDis / _u_xlat2.x));
    (_u_xlat12 = (_u_xlat12 + (-_u_xlat13)));
    (_u_xlat16_3.x = (_u_xlat12 + 1.0));
    (_vs_TEXCOORD2.y = (_u_xlat16_3.x * __GlobalFogHeightDensity));
    (_vs_TEXCOORD2.y = clamp(_vs_TEXCOORD2.y, 0.0, 1.0));
    (_u_xlat12 = dot(__WorldSpaceLightPos0.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat12 = rsqrt(_u_xlat12));
    (_u_xlat2.xyz = (vec3_ctor(_u_xlat12) * __WorldSpaceLightPos0.xyz));
    (_u_xlat12 = dot(_u_xlat2.xyz, cameraDirNormlized.xyz));
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
    (_vs_TEXCOORD4.w = worldPos.x);
    
    float4 worldNormal;
    float4 worldNormalNormlized;
    (worldNormal.y = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[0].xyz));
    (worldNormal.z = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[1].xyz));
    (worldNormal.x = dot(_in_NORMAL0.xyz, _hlslcc_mtx4x4unity_WorldToObject[2].xyz));
    (_u_xlat0.x = dot(worldNormal.xyz, worldNormal.xyz));
    (_u_xlat0.x = rsqrt(_u_xlat0.x));
    (worldNormalNormlized.xyz = (_u_xlat0.xxx * worldNormal.xyz));
    
    float4 worldTangent;
    float4 worldTangentNormlized;
    (worldTangent.xyz = (_in_TANGENT0.yyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].yzx));
    (worldTangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[0].yzx * _in_TANGENT0.xxx) + worldTangent.xyz));
    (worldTangent.xyz = ((_hlslcc_mtx4x4unity_ObjectToWorld[2].yzx * _in_TANGENT0.zzz) + worldTangent.xyz));
    (_u_xlat0.x = dot(worldTangent.xyz, worldTangent.xyz));
    (_u_xlat0.x = rsqrt(_u_xlat0.x));
    (worldTangentNormlized.xyz = (_u_xlat0.xxx * worldTangent.xyz));

    float4 worldBitangent;
    (worldBitangent.xyz = (worldNormalNormlized.xyz * worldTangentNormlized.xyz));
    (worldBitangent.xyz = ((worldNormalNormlized.zxy * worldTangentNormlized.yzx) + (-worldBitangent.xyz)));
    (_u_xlat0.x = (_in_TANGENT0.w * _unity_WorldTransformParams.w));
    (worldBitangent.xyz = (_u_xlat0.xxx * worldBitangent.xyz));
    (_vs_TEXCOORD4.y = worldBitangent.x);
    (_vs_TEXCOORD4.x = worldTangentNormlized.z);
    (_vs_TEXCOORD4.z = worldNormalNormlized.y);
    (_vs_TEXCOORD5.x = worldTangentNormlized.x);
    (_vs_TEXCOORD6.x = worldTangentNormlized.y);
    (_vs_TEXCOORD5.z = worldNormalNormlized.z);
    (_vs_TEXCOORD6.z = worldNormalNormlized.x);
    (_vs_TEXCOORD5.w = _u_xlat0.y);
    (_vs_TEXCOORD6.w = _u_xlat0.z);
    (_vs_TEXCOORD5.y = worldBitangent.y);
    (_vs_TEXCOORD6.y = worldBitangent.z);
    return generateOutput(input);
}
