struct PS_INPUT
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
float2 vec2_ctor(float x0)
{
    return float2(x0, x0);
}

float2 vec2_ctor(float x0, float x1)
{
    return float2(x0, x1);
}

float2 vec2_ctor(float2 x0)
{
    return float2(x0);
}

float3 vec3_ctor(float x0)
{
    return float3(x0, x0, x0);
}

// Uniforms

uniform float3 __WorldSpaceCameraPos : register(c0);
uniform float4 __WorldSpaceLightPos0 : register(c1);
uniform float4 _unity_OcclusionMaskSelector : register(c2);
uniform float4 _unity_Lightmap_HDR : register(c3);
uniform float4 __LightColor0 : register(c4);
uniform float4 __GlobalFogDistColor : register(c5);
uniform float4 __GlobalFogHeightColor : register(c6);
uniform float __FogLightPow : register(c7);
uniform float4 __Color : register(c8);
uniform float __LightPower : register(c9);
uniform float __OcclusionStrength : register(c10);
uniform float4 __GIPower : register(c11);
uniform float4 __SpecularColor : register(c12);
uniform float __SpecStrength : register(c13);
uniform float __SpecShininess : register(c14);
uniform float __BumpScale : register(c15);
uniform float __AmbientHighPos : register(c16);
uniform float __AlbedoMapScale : register(c17);
static const uint __MainTex = 0;
static const uint __MetallicGlossMap = 1;
static const uint _unity_Lightmap = 2;
static const uint _unity_ShadowMask = 3;
uniform Texture2D<float4> textures2D[4] : register(t0);
uniform SamplerState samplers2D[4] : register(s0);
#ifdef ANGLE_ENABLE_LOOP_FLATTEN
#define LOOP [loop]
#define FLATTEN [flatten]
#else
#define LOOP
#define FLATTEN
#endif

#define ATOMIC_COUNTER_ARRAY_STRIDE 4

// Varyings
static float2 _vs_TEXCOORD0 = {0, 0};
static float4 _vs_TEXCOORD1 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD2 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD3 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD4 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD5 = {0, 0, 0, 0};
static float4 _vs_TEXCOORD6 = {0, 0, 0, 0};

static float4 out_SV_Target0 = {0, 0, 0, 0};
static bool gl_FrontFacing = false;

cbuffer DriverConstants : register(b1)
{
float3 dx_DepthFront : packoffset(c2);
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

#define GL_USES_FRONT_FACING
static float3 _u_xlat0 = {0, 0, 0};
static float4 _u_xlat16_0 = {0, 0, 0, 0};
static float4 _u_xlat16_1 = {0, 0, 0, 0};
static float4 _u_xlat16_2 = {0, 0, 0, 0};
static float3 _u_xlat16_3 = {0, 0, 0};
static float3 _u_xlat16_4 = {0, 0, 0};
static float _u_xlat16_6 = {0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float _u_xlat16_11 = {0};
static float2 _u_xlat16_13 = {0, 0};
static float _u_xlat15 = {0};
static float _u_xlat16_16 = {0};
static float _u_xlat16_18 = {0};

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


PS_OUTPUT main(PS_INPUT input, bool isFrontFace : SV_IsFrontFace)
{
    gl_FrontFacing = isFrontFace;
    _vs_TEXCOORD1 = input.v0;
    _vs_TEXCOORD2 = input.v1;
    _vs_TEXCOORD3 = input.v2;
    _vs_TEXCOORD4 = input.v3;
    _vs_TEXCOORD5 = input.v4;
    _vs_TEXCOORD6 = input.v5;
    _vs_TEXCOORD0 = input.v6.xy;

    (_u_xlat0.x = _vs_TEXCOORD1.z);
    (_u_xlat0.y = _vs_TEXCOORD2.z);
    (_u_xlat0.z = _vs_TEXCOORD3.z);
    (_u_xlat16_1.x = dot(_u_xlat0.xyz, _u_xlat0.xyz));
    (_u_xlat16_1.x = rsqrt(_u_xlat16_1.x));
    (_u_xlat16_1.xyz = (_u_xlat0.xyz * _u_xlat16_1.xxx));//normal
    float sbf8 = {0};
    uint sbf9 = {0};
    if (gl_FrontFacing)
    {
        (sbf9 = 4294967295);
    }
    else
    {
        (sbf9 = 0);
    }
    if ((sbf9 != 0))
    {
        (sbf8 = 1.0);
    }
    else
    {
        (sbf8 = -1.0);
    }
    (_u_xlat16_16 = sbf8);
    (_u_xlat16_2.xz = (vec2_ctor(_u_xlat16_16) * _u_xlat16_1.xz));
    (_u_xlat16_2.y = ((_u_xlat16_1.y * _u_xlat16_16) + __AmbientHighPos));
    (_u_xlat16_1.x = dot(_u_xlat16_2.xyz, _u_xlat16_2.xyz));
    (_u_xlat16_1.x = rsqrt(_u_xlat16_1.x));
    (_u_xlat16_1.xyz = (_u_xlat16_1.xxx * _u_xlat16_2.xyz));//normal calculated
    (_u_xlat16_0.xyz = gl_texture2D(__MetallicGlossMap, _vs_TEXCOORD0.xy).yzw);
    (_u_xlat16_2.xy = ((_u_xlat16_0.xy * float2(2.0, 2.0)) + float2(-1.0, -1.0)));//bump
    (_u_xlat16_7.y = (_u_xlat16_0.z * __SpecStrength));//spec
    (_u_xlat16_3.xy = (_u_xlat16_2.xy * vec2_ctor(vec2_ctor(__BumpScale, __BumpScale))));
    (_u_xlat16_2.x = dot(_u_xlat16_3.xy, _u_xlat16_3.xy));
    (_u_xlat16_2.x = min(_u_xlat16_2.x, 1.0));
    (_u_xlat16_2.x = ((-_u_xlat16_2.x) + 1.0));
    (_u_xlat16_3.z = sqrt(_u_xlat16_2.x));
    (_u_xlat16_2.x = dot(_u_xlat16_3.xyz, _u_xlat16_3.xyz));
    (_u_xlat16_2.x = rsqrt(_u_xlat16_2.x));
    (_u_xlat16_2.xyw = (_u_xlat16_2.xxx * _u_xlat16_3.xyz));//bump
    (_u_xlat0.x = dot(_vs_TEXCOORD1.xyz, _u_xlat16_2.xyw));
    (_u_xlat0.y = dot(_vs_TEXCOORD2.xyz, _u_xlat16_2.xyw));
    (_u_xlat0.z = dot(_vs_TEXCOORD3.xyz, _u_xlat16_2.xyw));
    (_u_xlat16_2.x = dot(_u_xlat0.xyz, _u_xlat0.xyz));
    (_u_xlat16_2.x = rsqrt(_u_xlat16_2.x));
    (_u_xlat16_2.xyw = (_u_xlat0.xyz * _u_xlat16_2.xxx));
    (_u_xlat16_2.xyw = (vec3_ctor(_u_xlat16_16) * _u_xlat16_2.xyw));//bumpWS
    (_u_xlat16_1.x = dot(_u_xlat16_1.xyz, _u_xlat16_2.xyw));//ndotb
    (_u_xlat16_6 = ((-_u_xlat16_1.x) + 1.0));//ao
    (_u_xlat16_0 = gl_texture2D(_unity_ShadowMask, _vs_TEXCOORD5.xy));
    (_u_xlat16_11 = dot(_u_xlat16_0, _unity_OcclusionMaskSelector));
    (_u_xlat16_11 = clamp(_u_xlat16_11, 0.0, 1.0));//bakedAtten
    (_u_xlat16_1.x = ((_u_xlat16_11 * _u_xlat16_6) + _u_xlat16_1.x));
    (_u_xlat16_0.xyz = gl_texture2D(_unity_Lightmap, _vs_TEXCOORD4.xy).xyz);
    (_u_xlat16_3.xyz = (_u_xlat16_0.xyz * _unity_Lightmap_HDR.xxx));//bakedlight
    (_u_xlat16_6 = ((-__OcclusionStrength) + 1.0));
    (_u_xlat0.xy = (_vs_TEXCOORD0.xy * vec2_ctor(__AlbedoMapScale)));
    (_u_xlat16_0 = gl_texture2D(__MainTex, _u_xlat0.xy));
    (_u_xlat16_6 = ((_u_xlat16_0.w * __OcclusionStrength) + _u_xlat16_6));
    (_u_xlat16_4.xyz = (_u_xlat16_0.xyz * __Color.xyz));//albedo
    (_u_xlat16_3.xyz = (vec3_ctor(_u_xlat16_6) * _u_xlat16_3.xyz));
    (_u_xlat16_3.xyz = (_u_xlat16_3.xyz * __GIPower.xyz));
    (_u_xlat16_3.xyz = (_u_xlat16_3.xyz * _u_xlat16_4.xyz));
    (_u_xlat16_1.xyw = (_u_xlat16_1.xxx * _u_xlat16_3.xyz));//diffuse
    (_u_xlat0.x = _vs_TEXCOORD1.w);
    (_u_xlat0.y = _vs_TEXCOORD2.w);
    (_u_xlat0.z = _vs_TEXCOORD3.w);
    (_u_xlat0.xyz = ((-_u_xlat0.xyz) + __WorldSpaceCameraPos.xyz));
    (_u_xlat15 = dot(_u_xlat0.xyz, _u_xlat0.xyz));
    (_u_xlat15 = rsqrt(_u_xlat15));
    (_u_xlat16_3.xyz = ((_u_xlat0.xyz * vec3_ctor(_u_xlat15)) + __WorldSpaceLightPos0.xyz));
    (_u_xlat16_18 = dot(_u_xlat16_3.xyz, _u_xlat16_3.xyz));
    (_u_xlat16_18 = rsqrt(_u_xlat16_18));
    (_u_xlat16_3.xyz = (vec3_ctor(_u_xlat16_18) * _u_xlat16_3.xyz));//viewDir
    (_u_xlat16_3.x = dot(_u_xlat16_2.xyw, _u_xlat16_3.xyz));
    (_u_xlat16_3.x = clamp(_u_xlat16_3.x, 0.0, 1.0));//ndotv
    (_u_xlat16_2.x = dot(_u_xlat16_2.xyw, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_2.x = clamp(_u_xlat16_2.x, 0.0, 1.0));//ndotl
    (_u_xlat16_7.x = log2(_u_xlat16_3.x));
    (_u_xlat16_7.z = (__SpecShininess * 128.0));
    (_u_xlat16_7.xy = (_u_xlat16_7.xy * _u_xlat16_7.zy));
    (_u_xlat16_7.x = exp2(_u_xlat16_7.x));
    (_u_xlat16_7.x = (_u_xlat16_7.x * _u_xlat16_7.y));//specFactor
    (_u_xlat0.x = min(_u_xlat16_7.x, 8.0));
    (_u_xlat16_7.xyz = (_u_xlat0.xxx * __SpecularColor.xyz));//specular
    (_u_xlat16_2.xyz = ((_u_xlat16_4.xyz * _u_xlat16_2.xxx) + _u_xlat16_7.xyz));//color
    (_u_xlat16_3.xyz = (__LightColor0.xyz * vec3_ctor(__LightPower)));
    (_u_xlat16_3.xyz = (vec3_ctor(_u_xlat16_11) * _u_xlat16_3.xyz));//lightcolor
    (_u_xlat16_1.xyz = ((_u_xlat16_2.xyz * _u_xlat16_3.xyz) + _u_xlat16_1.xyw));//finalColor
    (_u_xlat16_2.xyz = (__LightColor0.xyz + (-__GlobalFogDistColor.xyz)));
    (_u_xlat16_3.xy = _vs_TEXCOORD6.xy);
    (_u_xlat16_3.xy = clamp(_u_xlat16_3.xy, 0.0, 1.0));
    (_u_xlat16_16 = ((-_u_xlat16_3.x) + 1.0));
    (_u_xlat16_13.xy = (vec2_ctor(_u_xlat16_16) * _vs_TEXCOORD6.zw));
    (_u_xlat16_13.xy = (_u_xlat16_13.xy * vec2_ctor(__FogLightPow)));
    (_u_xlat16_13.xy = clamp(_u_xlat16_13.xy, 0.0, 1.0));
    (_u_xlat16_2.xyz = ((_u_xlat16_13.xxx * _u_xlat16_2.xyz) + __GlobalFogDistColor.xyz));
    (_u_xlat16_1.xyz = (_u_xlat16_1.xyz + (-_u_xlat16_2.xyz)));
    (_u_xlat16_1.xyz = ((_u_xlat16_3.xxx * _u_xlat16_1.xyz) + _u_xlat16_2.xyz));
    (_u_xlat16_2.xyz = (__LightColor0.xyz + (-__GlobalFogHeightColor.xyz)));
    (_u_xlat16_2.xyz = ((_u_xlat16_13.yyy * _u_xlat16_2.xyz) + __GlobalFogHeightColor.xyz));
    (_u_xlat16_2.xyz = ((-_u_xlat16_1.xyz) + _u_xlat16_2.xyz));
    (out_SV_Target0.xyz = ((_u_xlat16_3.yyy * _u_xlat16_2.xyz) + _u_xlat16_1.xyz));
    (out_SV_Target0.w = 1.0);
    return generateOutput();
}
