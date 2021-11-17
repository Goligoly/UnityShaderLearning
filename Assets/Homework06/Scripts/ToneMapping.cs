using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToneMapping : PostEffectBase
{
    public Shader tmoShader;
    public AnimationCurve curve;
    public Texture2D toneMap;
    private Material tmoMaterial = null;
    public Material material
    {
        get
        {
            tmoMaterial = CheckShaderAndCreateMaterial(tmoShader, tmoMaterial);
            return tmoMaterial;
        }
    }

    private void Start()
    {
        toneMap = new Texture2D(128, 1,TextureFormat.R8,false);
        toneMap.wrapMode = TextureWrapMode.Clamp;
        material.SetTexture("_ToneMap", toneMap);
    }

    private void Update()
    {
        genToneMap();
    }

    private void genToneMap()
    {
        float val;
        float key = 0;
        float delta = 1 / 128f;
        for (int i = 0; i < 128; i++)
        {
            val = curve.Evaluate(key);
            toneMap.SetPixel(i,0,new Color(val,0,0));
            key += delta;
        }
        toneMap.Apply();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
