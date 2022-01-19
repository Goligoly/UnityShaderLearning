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

uniform float3 __WorldSpaceCameraPos : register(c0);
uniform float4 __WorldSpaceLightPos0 : register(c1);
uniform float4 _unity_OcclusionMaskSelector : register(c2);
uniform float4 _unity_SpecCube0_BoxMax : register(c3);
uniform float4 _unity_SpecCube0_BoxMin : register(c4);
uniform float4 _unity_SpecCube0_ProbePosition : register(c5);
uniform float4 _unity_SpecCube0_HDR : register(c6);
uniform float4 _unity_Lightmap_HDR : register(c7);
uniform float4 __LightColor0 : register(c8);
uniform float4 __GlobalFogDistColor : register(c9);
uniform float4 __GlobalFogHeightColor : register(c10);
uniform float __FogLightPow : register(c11);
uniform float4 __Color : register(c12);
uniform float __BumpScale : register(c13);
uniform float __Metallic : register(c14);
uniform float __Glossiness : register(c15);
uniform float __OcclusionStrength : register(c16);
uniform float __LightPower : register(c17);
uniform float3 __AmbientSpCol : register(c18);
uniform float __AmbientHighPos : register(c19);
uniform float __ReflectionPower : register(c20);
uniform float4 __GIPower : register(c21);
uniform float __AlbedoMapScale : register(c22);
static const uint __MainTex = 0;
static const uint __MetallicGlossMap = 1;
static const uint _unity_Lightmap = 2;
static const uint _unity_ShadowMask = 3;
uniform Texture2D<float4> textures2D[4] : register(t0);
uniform SamplerState samplers2D[4] : register(s0);
static const uint _unity_SpecCube0 = 4;
static const uint textureIndexOffsetCube = 4;
static const uint samplerIndexOffsetCube = 4;
uniform TextureCube<float4> texturesCube[1] : register(t4);
uniform SamplerState samplersCube[1] : register(s4);
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
SamplerMetadata samplerMetadata[5] : packoffset(c4);
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

static float3 _u_xlat0 = {0, 0, 0};
static float3 _u_xlat1 = {0, 0, 0};
static float4 _u_xlat2 = {0, 0, 0, 0};
static float4 _u_xlat16_2 = {0, 0, 0, 0};
static float3 _u_xlat16_3 = {0, 0, 0};
static float3 _u_xlat4 = {0, 0, 0};
static float4 _u_xlat16_4 = {0, 0, 0, 0};
static float4 _u_xlat16_5 = {0, 0, 0, 0};
static float4 _u_xlat16_6 = {0, 0, 0, 0};
static bool3 _u_xlatb6 = {0, 0, 0};
static float3 _u_xlat16_7 = {0, 0, 0};
static float3 _u_xlat8 = {0, 0, 0};
static float4 _u_xlat16_8 = {0, 0, 0, 0};
static float3 _u_xlat16_9 = {0, 0, 0};
static float3 _u_xlat16_10 = {0, 0, 0};
static float3 _u_xlat16_11 = {0, 0, 0};
static float3 _u_xlat16_12 = {0, 0, 0};
static float3 _u_xlat16_13 = {0, 0, 0};
static float3 _u_xlat14 = {0, 0, 0};
static float3 _u_xlat16_17 = {0, 0, 0};
static float3 _u_xlat16_21 = {0, 0, 0};
static float _u_xlat16_25 = {0};
static float _u_xlat28 = {0};
static float2 _u_xlat16_33 = {0, 0};
static float _u_xlat42 = {0};
static float _u_xlat43 = {0};
static bool _u_xlatb43 = {0};
static float _u_xlat16_45 = {0};
static float _u_xlat16_47 = {0};
static float _u_xlat16_49 = {0};
static float _u_xlat16_51 = {0};
static float _u_xlat16_52 = {0};
static float _u_xlat16_53 = {0};
static float _u_xlat16_54 = {0};

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
    _vs_TEXCOORD1 = input.v0;
    _vs_TEXCOORD2 = input.v1;
    _vs_TEXCOORD3 = input.v2;
    _vs_TEXCOORD4 = input.v3;
    _vs_TEXCOORD5 = input.v4;
    _vs_TEXCOORD6 = input.v5;
    _vs_TEXCOORD0 = input.v6.xy;

    (_u_xlat0.x = _vs_TEXCOORD1.w);
    (_u_xlat0.y = _vs_TEXCOORD2.w);
    (_u_xlat0.z = _vs_TEXCOORD3.w);//positionWS
    (_u_xlat1.xyz = ((-_u_xlat0.xyz) + __WorldSpaceCameraPos.xyz));
    (_u_xlat42 = dot(_u_xlat1.xyz, _u_xlat1.xyz));
    (_u_xlat42 = rsqrt(_u_xlat42));
    (_u_xlat1.xyz = (vec3_ctor(_u_xlat42) * _u_xlat1.xyz));//viewDir
    (_u_xlat2.x = _vs_TEXCOORD1.z);
    (_u_xlat2.y = _vs_TEXCOORD2.z);
    (_u_xlat2.z = _vs_TEXCOORD3.z);
    (_u_xlat16_3.x = dot(_u_xlat2.xyz, _u_xlat2.xyz));
    (_u_xlat16_3.x = rsqrt(_u_xlat16_3.x));
    (_u_xlat16_17.xyz = (_u_xlat2.xyz * _u_xlat16_3.xxx));//normalWS
    (_u_xlat2.xz = (_vs_TEXCOORD0.xy * vec2_ctor(__AlbedoMapScale)));
    (_u_xlat16_4 = gl_texture2D(__MainTex, _u_xlat2.xz));//mainTexCol
    (_u_xlat16_5.xyz = (_u_xlat16_4.xyz * __Color.xyz));//albedo
    (_u_xlat16_6 = gl_texture2D(__MetallicGlossMap, _vs_TEXCOORD0.xy));//metallicGloss
    (_u_xlat16_7.xy = ((_u_xlat16_6.yz * float2(2.0, 2.0)) + float2(-1.0, -1.0)));
    (_u_xlat16_7.xy = (_u_xlat16_7.xy * vec2_ctor(__BumpScale)));
    (_u_xlat16_47 = dot(_u_xlat16_7.xy, _u_xlat16_7.xy));
    (_u_xlat16_47 = min(_u_xlat16_47, 1.0));
    (_u_xlat16_47 = ((-_u_xlat16_47) + 1.0));
    (_u_xlat16_7.z = sqrt(_u_xlat16_47));//bumpTS
    (_u_xlat8.x = dot(_vs_TEXCOORD1.xyz, _u_xlat16_7.xyz));
    (_u_xlat8.y = dot(_vs_TEXCOORD2.xyz, _u_xlat16_7.xyz));
    (_u_xlat8.z = dot(_vs_TEXCOORD3.xyz, _u_xlat16_7.xyz));
    (_u_xlat16_47 = dot(_u_xlat8.xyz, _u_xlat8.xyz));
    (_u_xlat16_47 = rsqrt(_u_xlat16_47));
    (_u_xlat16_7.xyz = (vec3_ctor(_u_xlat16_47) * _u_xlat8.xyz));//bumpWS
    (_u_xlat16_47 = (_u_xlat16_6.x * __Metallic));//metallic
    (_u_xlat16_49 = ((-__OcclusionStrength) + 1.0));
    (_u_xlat16_49 = ((_u_xlat16_4.w * __OcclusionStrength) + _u_xlat16_49));//occlusion
    (_u_xlat16_9.xyz = (__LightColor0.xyz * vec3_ctor(vec3_ctor(__LightPower, __LightPower, __LightPower))));//light
    (_u_xlat16_8 = gl_texture2D(_unity_ShadowMask, _vs_TEXCOORD5.xy));//rawOcclusionMask
    (_u_xlat16_51 = dot(_u_xlat16_8, _unity_OcclusionMaskSelector));
    (_u_xlat16_51 = clamp(_u_xlat16_51, 0.0, 1.0));//bakedAtten
    (_u_xlat16_10.xyz = ((_u_xlat16_4.xyz * __Color.xyz) + float3(-0.039999999, -0.039999999, -0.039999999)));
    (_u_xlat16_10.xyz = ((vec3_ctor(_u_xlat16_47) * _u_xlat16_10.xyz) + float3(0.039999999, 0.039999999, 0.039999999)));//metallCol
    (_u_xlat16_47 = (((-_u_xlat16_47) * 0.95999998) + 0.95999998));//metallic
    (_u_xlat16_5.xyz = (vec3_ctor(_u_xlat16_47) * _u_xlat16_5.xyz));//albedo
    (_u_xlat16_9.xyz = (vec3_ctor(_u_xlat16_51) * _u_xlat16_9.xyz));//lightColor
    (_u_xlat16_2.xzw = gl_texture2D(_unity_Lightmap, _vs_TEXCOORD4.xy).xyz);
    (_u_xlat16_11.xyz = (_u_xlat16_2.xzw * _unity_Lightmap_HDR.xxx));
    (_u_xlat16_11.xyz = (vec3_ctor(_u_xlat16_49) * _u_xlat16_11.xyz));//lightBaked
    (_u_xlat42 = (((-_u_xlat16_6.w) * __Glossiness) + 1.0));//glossiness
    (_u_xlat16_49 = dot((-_u_xlat1.xyz), _u_xlat16_7.xyz));
    (_u_xlat16_49 = (_u_xlat16_49 + _u_xlat16_49));
    (_u_xlat16_12.xyz = ((_u_xlat16_7.xyz * (-vec3_ctor(_u_xlat16_49))) + (-_u_xlat1.xyz)));
    (_u_xlat16_49 = dot(_u_xlat16_12.xyz, _u_xlat16_12.xyz));
    (_u_xlat16_49 = rsqrt(_u_xlat16_49));
    (_u_xlat16_12.xyz = (vec3_ctor(_u_xlat16_49) * _u_xlat16_12.xyz));//reflectDir
    (_u_xlatb43 = (0.0 < _unity_SpecCube0_ProbePosition.w));
    if (_u_xlatb43)
    {
        (_u_xlat2.xzw = ((-_u_xlat0.xyz) + _unity_SpecCube0_BoxMax.xyz));
        (_u_xlat2.xzw = (_u_xlat2.xzw / _u_xlat16_12.xyz));
        (_u_xlat4.xyz = ((-_u_xlat0.xyz) + _unity_SpecCube0_BoxMin.xyz));
        (_u_xlat4.xyz = (_u_xlat4.xyz / _u_xlat16_12.xyz));
        (_u_xlatb6.xyz = (float4(0.0, 0.0, 0.0, 0.0) < _u_xlat16_12.xyzx).xyz);
        {
            float4 _hlslcc_movcTemp3091 = _u_xlat2;
            float sc14 = {0};
            if (_u_xlatb6.x)
            {
                (sc14 = _u_xlat2.x);
            }
            else
            {
                (sc14 = _u_xlat4.x);
            }
            (_hlslcc_movcTemp3091.x = sc14);
            float sc15 = {0};
            if (_u_xlatb6.y)
            {
                (sc15 = _u_xlat2.z);
            }
            else
            {
                (sc15 = _u_xlat4.y);
            }
            (_hlslcc_movcTemp3091.z = sc15);
            float sc16 = {0};
            if (_u_xlatb6.z)
            {
                (sc16 = _u_xlat2.w);
            }
            else
            {
                (sc16 = _u_xlat4.z);
            }
            (_hlslcc_movcTemp3091.w = sc16);
            (_u_xlat2 = _hlslcc_movcTemp3091);
        }
        (_u_xlat43 = min(_u_xlat2.z, _u_xlat2.x));
        (_u_xlat43 = min(_u_xlat2.w, _u_xlat43));
        (_u_xlat0.xyz = (_u_xlat0.xyz + (-_unity_SpecCube0_ProbePosition.xyz)));
        (_u_xlat0.xyz = ((_u_xlat16_12.xyz * vec3_ctor(_u_xlat43)) + _u_xlat0.xyz));
    }
    else
    {
        (_u_xlat0.xyz = _u_xlat16_12.xyz);
    }
    (_u_xlat16_49 = (((-_u_xlat42) * 0.69999999) + 1.7));
    (_u_xlat16_49 = (_u_xlat42 * _u_xlat16_49));
    (_u_xlat16_49 = (_u_xlat16_49 * 6.0));//roughness
    (_u_xlat16_4 = gl_textureCubeLod(_unity_SpecCube0, _u_xlat0.xyz, _u_xlat16_49));//reflectColor
    (_u_xlat16_49 = (_u_xlat16_4.w + -1.0));
    (_u_xlat16_49 = ((_unity_SpecCube0_HDR.w * _u_xlat16_49) + 1.0));
    (_u_xlat16_49 = log2(_u_xlat16_49));
    (_u_xlat16_49 = (_u_xlat16_49 * _unity_SpecCube0_HDR.y));
    (_u_xlat16_49 = exp2(_u_xlat16_49));
    (_u_xlat16_49 = (_u_xlat16_49 * _unity_SpecCube0_HDR.x));
    (_u_xlat16_12.xyz = (_u_xlat16_4.xyz * vec3_ctor(_u_xlat16_49)));//iblSpecular
    (_u_xlat16_11.xyz = (_u_xlat16_11.xyz * __GIPower.xyz));//lightBaked
    (_u_xlat0.x = (_u_xlat42 * _u_xlat42));
    (_u_xlat14.xyz = ((_u_xlat1.xyz * float3(0.99900001, 0.99900001, 0.99900001)) + __WorldSpaceLightPos0.xyz));
    (_u_xlat43 = dot(_u_xlat14.xyz, _u_xlat14.xyz));
    (_u_xlat43 = rsqrt(_u_xlat43));
    (_u_xlat14.xyz = (_u_xlat14.xyz * vec3_ctor(_u_xlat43)));//viewAddLight
    (_u_xlat16_49 = dot(_u_xlat16_7.xyz, _u_xlat1.xyz));//ndotv
    (_u_xlat16_52 = dot(_u_xlat16_7.xyz, __WorldSpaceLightPos0.xyz));
    (_u_xlat16_52 = clamp(_u_xlat16_52, 0.0, 1.0));//ndotl
    (_u_xlat16_53 = dot(_u_xlat16_7.xyz, _u_xlat14.xyz));
    (_u_xlat16_53 = clamp(_u_xlat16_53, 0.0, 1.0));//ndotv
    (_u_xlat16_54 = dot(__WorldSpaceLightPos0.xyz, _u_xlat14.xyz));
    (_u_xlat16_54 = clamp(_u_xlat16_54, 0.0, 1.0));//vdotl
    (_u_xlat16_13.xz = _u_xlat16_17.xz);
    (_u_xlat16_13.y = ((_u_xlat2.y * _u_xlat16_3.x) + __AmbientHighPos));
    (_u_xlat16_3.x = dot(_u_xlat16_13.xyz, _u_xlat16_13.xyz));
    (_u_xlat16_3.x = rsqrt(_u_xlat16_3.x));
    (_u_xlat16_13.xyz = (_u_xlat16_3.xxx * _u_xlat16_13.xyz));//normal
    (_u_xlat16_3.x = dot(_u_xlat16_13.xyz, _u_xlat16_7.xyz));
    (_u_xlat16_7.x = ((-_u_xlat16_3.x) + 1.0));
    (_u_xlat16_3.x = ((_u_xlat16_51 * _u_xlat16_7.x) + _u_xlat16_3.x));//aoFactor
    (_u_xlat16_7.xyz = (_u_xlat16_9.xyz * vec3_ctor(_u_xlat16_52)));
    (_u_xlat16_7.xyz = ((_u_xlat16_11.xyz * _u_xlat16_3.xxx) + _u_xlat16_7.xyz));//light
    (_u_xlat16_3.x = (abs(_u_xlat16_49) * 4.0));
    (_u_xlat16_3.x = min(_u_xlat16_3.x, 1.0));//absndotv4
    (_u_xlat16_51 = max(_u_xlat0.x, 0.0080000004));//gloss
    (_u_xlat16_11.x = ((-_u_xlat16_51) + 1.0));
    (_u_xlat16_25 = ((abs(_u_xlat16_49) * _u_xlat16_11.x) + _u_xlat16_51));//spec0
    (_u_xlat16_11.x = ((_u_xlat16_52 * _u_xlat16_11.x) + _u_xlat16_51));
    (_u_xlat16_11.x = (abs(_u_xlat16_49) * _u_xlat16_11.x));//spec1
    (_u_xlat16_11.x = ((_u_xlat16_52 * _u_xlat16_25) + _u_xlat16_11.x));
    (_u_xlat0.x = (_u_xlat16_11.x + 0.001));
    (_u_xlat0.x = (0.5 / _u_xlat0.x));
    (_u_xlat0.x = min(_u_xlat0.x, 8.0));//specular
    (_u_xlat14.x = (((-_u_xlat16_53) * _u_xlat16_53) + 1.0));
    (_u_xlat28 = (_u_xlat16_51 * _u_xlat16_53));
    (_u_xlat14.x = ((_u_xlat28 * _u_xlat28) + _u_xlat14.x));
    (_u_xlat14.x = (_u_xlat16_51 / _u_xlat14.x));
    (_u_xlat16_11.x = (_u_xlat14.x * _u_xlat14.x));
    (_u_xlat14.x = min(_u_xlat16_11.x, 8.0));
    (_u_xlat16_11.x = (_u_xlat14.x * _u_xlat0.x));//specular
    (_u_xlat16_52 = (_u_xlat16_52 * _u_xlat16_11.x));
    (_u_xlat16_9.xyz = (_u_xlat16_9.xyz * vec3_ctor(_u_xlat16_52)));//lightColor
    (_u_xlat16_52 = ((-_u_xlat16_54) + 1.0));
    (_u_xlat16_11.x = (_u_xlat16_52 * _u_xlat16_52));
    (_u_xlat16_11.x = (_u_xlat16_11.x * _u_xlat16_11.x));
    (_u_xlat16_52 = (_u_xlat16_52 * _u_xlat16_11.x));//1-vdotl 5 times
    (_u_xlat16_11.xyz = ((-_u_xlat16_10.xyz) + float3(1.0, 1.0, 1.0)));
    (_u_xlat16_11.xyz = ((_u_xlat16_11.xyz * vec3_ctor(_u_xlat16_52)) + _u_xlat16_10.xyz));
    (_u_xlat16_9.xyz = (_u_xlat16_9.xyz * _u_xlat16_11.xyz));
    (_u_xlat16_9.xyz = (_u_xlat16_3.xxx * _u_xlat16_9.xyz));//specColor
    (_u_xlat16_5.xyz = ((_u_xlat16_5.xyz * _u_xlat16_7.xyz) + _u_xlat16_9.xyz));//directCol
    (_u_xlat16_47 = ((_u_xlat16_6.w * __Glossiness) + (-_u_xlat16_47)));
    (_u_xlat16_47 = (_u_xlat16_47 + 1.0));
    (_u_xlat16_47 = clamp(_u_xlat16_47, 0.0, 1.0));//metallic
    (_u_xlat16_7.x = ((-abs(_u_xlat16_49)) + 1.0));
    (_u_xlat16_21.x = (_u_xlat16_7.x * _u_xlat16_7.x));
    (_u_xlat16_21.x = (_u_xlat16_21.x * _u_xlat16_21.x));
    (_u_xlat16_7.x = (_u_xlat16_7.x * _u_xlat16_21.x));//1-absndotv 5 times
    (_u_xlat16_21.xyz = ((-_u_xlat16_10.xyz) + vec3_ctor(_u_xlat16_47)));
    (_u_xlat16_21.xyz = ((_u_xlat16_7.xxx * _u_xlat16_21.xyz) + _u_xlat16_10.xyz));//metallcolor
    (_u_xlat16_17.x = dot(_u_xlat16_17.xyz, _u_xlat1.xyz));
    (_u_xlat16_17.x = clamp(_u_xlat16_17.x, 0.0, 1.0));//normaldotv
    (_u_xlat16_9.xyz = ((_u_xlat16_12.xyz * __AmbientSpCol.xyz) + __AmbientSpCol.xyz));
    (_u_xlat16_9.xyz = (_u_xlat16_7.xxx * _u_xlat16_9.xyz));
    (_u_xlat16_9.xyz = (vec3_ctor(_u_xlat16_47) * _u_xlat16_9.xyz));//ambientSpec
    (_u_xlat16_17.xyz = ((_u_xlat16_9.xyz * _u_xlat16_17.xxx) + _u_xlat16_5.xyz));//ambientColor
    (_u_xlat16_5.x = ((_u_xlat16_51 * _u_xlat16_51) + 1.0));
    (_u_xlat16_5.x = (1.0 / _u_xlat16_5.x));
    (_u_xlat16_5.xyz = (_u_xlat16_12.xyz * _u_xlat16_5.xxx));
    (_u_xlat16_5.xyz = (_u_xlat16_21.xyz * _u_xlat16_5.xyz));
    (_u_xlat16_5.xyz = (_u_xlat16_5.xyz * vec3_ctor(__ReflectionPower)));
    (_u_xlat16_3.xyz = ((_u_xlat16_5.xyz * _u_xlat16_3.xxx) + _u_xlat16_17.xyz));
    (_u_xlat16_3.xyz = min(_u_xlat16_3.xyz, float3(5.0, 5.0, 5.0)));//finalColor
    (_u_xlat16_5.xy = _vs_TEXCOORD6.xy);
    (_u_xlat16_5.xy = clamp(_u_xlat16_5.xy, 0.0, 1.0));
    (_u_xlat16_45 = ((-_u_xlat16_5.x) + 1.0));
    (_u_xlat16_33.xy = (vec2_ctor(_u_xlat16_45) * _vs_TEXCOORD6.zw));
    (_u_xlat16_33.xy = (_u_xlat16_33.xy * vec2_ctor(__FogLightPow)));
    (_u_xlat16_33.xy = clamp(_u_xlat16_33.xy, 0.0, 1.0));
    (_u_xlat16_7.xyz = (__LightColor0.xyz + (-__GlobalFogDistColor.xyz)));
    (_u_xlat16_7.xyz = ((_u_xlat16_33.xxx * _u_xlat16_7.xyz) + __GlobalFogDistColor.xyz));
    (_u_xlat16_3.xyz = (_u_xlat16_3.xyz + (-_u_xlat16_7.xyz)));
    (_u_xlat16_3.xyz = ((_u_xlat16_5.xxx * _u_xlat16_3.xyz) + _u_xlat16_7.xyz));
    (_u_xlat16_7.xyz = (__LightColor0.xyz + (-__GlobalFogHeightColor.xyz)));
    (_u_xlat16_5.xzw = ((_u_xlat16_33.yyy * _u_xlat16_7.xyz) + __GlobalFogHeightColor.xyz));
    (_u_xlat16_5.xzw = ((-_u_xlat16_3.xyz) + _u_xlat16_5.xzw));
    (out_SV_Target0.xyz = ((_u_xlat16_5.yyy * _u_xlat16_5.xzw) + _u_xlat16_3.xyz));
    (out_SV_Target0.w = 1.0);
    return generateOutput();
}
