#ifndef PBRBASE
    #define PBRBASE
    struct dotData
    {
        float ndoth;
        float ndotv;
        float ndotl;
        float hdotl;
    };

    dotData calDots(float3 lightDir, float3 viewDIr, float3 normDir)
    {
        dotData o;
    
        float3 halfVec = normalize(lightDir + viewDIr);

        o.ndoth = max(dot(normDir, halfVec), 0);
        o.ndotv = max(dot(normDir, viewDIr), 0);
        o.ndotl = max(dot(normDir, lightDir), 0);
        o.hdotl = max(dot(halfVec, lightDir), 0);

        return o;
    }

    float distributionFunc(float ndoth, float rough)
    {
        float alpha2 = rough * rough;
        float ndoth2 = ndoth * ndoth;
        float den = ndoth2 * alpha2 + 1 - ndoth2;
        return alpha2 / (UNITY_PI * den * den);
    }

    float geometrySchlickGGX(float ndot, float k)
    {
        return ndot / (ndot * (1 - k) + k);
    }

    float geometryFunc(float ndotv, float ndotl, float k)
    {
        return geometrySchlickGGX(ndotv, k) * geometrySchlickGGX(ndotl, k);
    }

    float3 fresnelFunc(float cosTheta, float3 F0)
    {
        return F0 + (1 - F0) * pow((1 - cosTheta), 5);
    }

    float3x3 genTrans(float3 zDir)
    {
        float3 zz = zDir;
        float3 yy = normalize(cross(float3(0, 1, 0), zz));
        float3 xx = normalize(cross(zz, yy));
        return float3x3(xx.x, yy.x, zz.x, xx.y, yy.y, zz.y, xx.z, yy.z, zz.z);
    }

    float radicalInverse(int bits)
    {
        bits = (bits << 16) | (bits >> 16);
        bits = ((bits & 0x55555555) << 1) | ((bits & 0xAAAAAAAA) >> 1);
        bits = ((bits & 0x33333333) << 2) | ((bits & 0xCCCCCCCC) >> 2);
        bits = ((bits & 0x0F0F0F0F) << 4) | ((bits & 0xF0F0F0F0) >> 4);
        bits = ((bits & 0x00FF00FF) << 8) | ((bits & 0xFF00FF00) >> 8);
        return float(bits) * 2.3283064365386963e-10;;
    }

    float2 hammersleySample(int i, int n)
    {
        return float2(float(i) / float(n), radicalInverse(i));
    }

    //hemisphereCos的pdf为 1 / (2 * pi)
    float3 hemisphereUniform(float2 uv)
    {
        float phi = uv.y * UNITY_TWO_PI;
        float cosTheta = 1.0 - uv.x;
        float sinTheta = sqrt(1 - cosTheta * cosTheta);
        return float3(cos(phi) * sinTheta, sin(phi) * sinTheta, cosTheta);
    }

    //hemisphereCos的pdf为 costheta / pi
    float3 hemisphereCos(float2 uv)
    {
        float phi = uv.y * UNITY_TWO_PI;
        float cosTheta = sqrt(1.0 - uv.x);
        float sinTheta = sqrt(1 - cosTheta * cosTheta);
        return float3(cos(phi) * sinTheta, sin(phi) * sinTheta, cosTheta);
    }

    float4 importanceSampleGGX(float2 uv, float roughness)
    {
        float a2 = roughness * roughness;
        float phi = uv.y * UNITY_TWO_PI;
        float cosTheta = sqrt((1 - uv.x) / (1 + (a2 - 1) * uv.x));
        float sinTheta = sqrt(1 - cosTheta * cosTheta);

        float3 H;
        H.x = sinTheta * cos(phi);
        H.y = sinTheta * sin(phi);
        H.z = cosTheta;

        float d = a2 * cosTheta * cosTheta + sinTheta * sinTheta;
        float D = a2 / (UNITY_PI * d * d);
        float PDF = D * cosTheta;

        return float4(H, PDF);
    }

    float3 uniformSampler(float3 zDir)
    {
        float3 color = 0;
        int num = 1024;
        float3x3 localCord = genTrans(zDir);
        for (int i = 0; i < num; i++)
        {
            float2 hammersley = hammersleySample(i, num);
            float3 sample = hemisphereCos(hammersley);
            sample = mul(localCord, sample);
            color += UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, sample) * dot(sample, zDir);
        }
        color = 2 * color / num;
        return color;
    }

    float3 diffuseHemisphereSampler(float3 zDir)
    {
        float3 color = 0;
        float num = 0;
        float deltaAngle = 0.01 * UNITY_PI;
        float3x3 localCord = genTrans(zDir);
        for (float dphi = 0; dphi < UNITY_TWO_PI; dphi += deltaAngle)
        {
            for (float dtheta = 0; dtheta < UNITY_HALF_PI; dtheta += deltaAngle)
            {
                float3 sample = float3(sin(dphi) * sin(dtheta), cos(dphi) * sin(dtheta), cos(dtheta));
                sample = mul(localCord, sample);
                color += UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, sample) * cos(dtheta) * sin(dtheta);
                num++;
            }
        }
        color = UNITY_PI * color / num;
        return color;
    }

    float3 approxiIndSpec(float3 specularResult, float roughness, float3 reflectDir, float3 F0, float3 ndotv)
    {
        float mipRoughness = roughness * (1.7 - 0.7 * roughness);
        float mip = mipRoughness * UNITY_SPECCUBE_LOD_STEPS;
        float3 indirectSpecular = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectDir, mip);

        float surfaceReduction = 1.0 / (roughness * roughness + 1.0);
        float oneMinusReflectivity = 1 - max(max(specularResult.r, specularResult.g), specularResult.b);
        float grazingTerm = saturate((1 - roughness) + (1 - oneMinusReflectivity));
        indirectSpecular = indirectSpecular * surfaceReduction * FresnelLerp(F0, grazingTerm, ndotv);
        return indirectSpecular;
    }

    float2 vec2uv(float3 vec)
    {
        float2 uv;
        float signal = sign(vec.z);
        uv.x = (signal * acos(dot(normalize(vec.xz), float2(1, 0))) / UNITY_PI) * 0.5;
        uv.y = 1 - acos(dot(vec, float3(0, 1, 0))) / UNITY_PI;
        return uv;
    }
#endif