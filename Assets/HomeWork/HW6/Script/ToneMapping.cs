using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToneMapping : PostEffectBase
{
    public Shader tmoShader;
    private Material tmoMaterial = null;
    public Material material
    {
        get
        {
            tmoMaterial = CheckShaderAndCreateMaterial(tmoShader, tmoMaterial);
            return tmoMaterial;
        }
    }

    [Range(0, 1)]
    public float xRange = 0.5f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_XRange", xRange);
        Graphics.Blit(source, destination, material);
    }
}
