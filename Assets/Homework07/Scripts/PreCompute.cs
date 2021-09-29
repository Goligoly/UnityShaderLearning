using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PreCompute : MonoBehaviour
{
    [Range(0, 1)] public float roughness;
    [Range(0, 1)] public float metallic;
    public Shader preComputeShader;
    public RenderTexture irradianceMap;
    public Texture2D preFilterEnvMap;
    public Material matDirect;
    public Material matMonte;
    public Material matPre;
    public Material matSimple;
    public Material matUnity;

    protected Material preComputeMat;
    protected int rtwidth = 1024, rtheight = 512;

    // Start is called before the first frame update
    void Start()
    {
        preComputeMat = new Material(preComputeShader);
        preComputeMat.hideFlags = HideFlags.DontSave;

        irradianceMap = new RenderTexture(rtwidth, rtheight, 0, RenderTextureFormat.Default);
        irradianceMap.wrapMode = TextureWrapMode.Repeat;

        preFilterEnvMap = new Texture2D(rtwidth, rtheight, TextureFormat.ARGB32, true);
        preFilterEnvMap.wrapMode = TextureWrapMode.Repeat;
        preFilterEnvMap.filterMode = FilterMode.Trilinear;

        GenerateMaps();
    }

    void Update()
    {
        matDirect.SetFloat("_Roughness", roughness);
        matMonte.SetFloat("_Roughness", roughness);
        matPre.SetFloat("_Roughness", roughness);
        matSimple.SetFloat("_Roughness", roughness);
        matUnity.SetFloat("_Glossiness", 1 - roughness);
        
        matDirect.SetFloat("_Metallic", metallic);
        matMonte.SetFloat("_Metallic", metallic);
        matPre.SetFloat("_Metallic", metallic);
        matSimple.SetFloat("_Metallic", metallic);
        matUnity.SetFloat("_Metallic", metallic);
    }

    Texture2D toTexture2D(RenderTexture rTex)
    {
        Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.ARGB32, false);
        RenderTexture.active = rTex;
        tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
        tex.Apply();
        return tex;
    }

    void GenerateMaps()
    {
        Graphics.Blit(null, irradianceMap, preComputeMat, 0);
        Shader.SetGlobalTexture("_IndirectIrradianceMap", irradianceMap);
        for (int i = 0; i < 6; i++)
        {
            int div = (int) Mathf.Pow(2, i);
            RenderTexture temp = RenderTexture.GetTemporary(rtwidth / div, rtheight / div);
            preComputeMat.SetFloat("_Roughness", i * 0.2f);
            Graphics.Blit(null, temp, preComputeMat, 1);
            Texture2D tex2d = toTexture2D(temp);
            preFilterEnvMap.SetPixels(tex2d.GetPixels(), i);
            RenderTexture.ReleaseTemporary(temp);
        }

        preFilterEnvMap.Apply(false);
        Shader.SetGlobalTexture("_PreFilterEnvMap", preFilterEnvMap);
    }
}