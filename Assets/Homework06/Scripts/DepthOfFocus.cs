using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthOfFocus : PostEffectBase
{
    public Shader dofShader;
    private Material dofMaterial = null;
    public Material material
    {
        get
        {
            dofMaterial = CheckShaderAndCreateMaterial(dofShader, dofMaterial);
            return dofMaterial;
        }
    }

    public GameObject renderTarget;

    [Range(0, 1.0f)]
    public float focusDistance = 0.5f;

    [Range(0, 0.5f)]
    public float focusRange = 0.1f;

    [Range(1, 10.0f)]
    public float bokehRadius = 4.0f;

    protected int rowGO = 20, columnGO = 8;
    protected float distance = 1.5f;
    protected GameObject root;

    // Start is called before the first frame update
    void Start()
    {
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;
        InitScene();
    }

    // Update is called once per frame
    void Update()
    {
        material.SetFloat("_BokehRadius", bokehRadius);
        material.SetFloat("_FocusDistance", focusDistance);
        material.SetFloat("_FocusRange", focusRange);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int halfW = source.width / 2;
        int halfH = source.height / 2;
        RenderTextureFormat format = source.format;
        RenderTexture coc = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.RHalf, RenderTextureReadWrite.Linear);
        RenderTexture bokeh1 = RenderTexture.GetTemporary(halfW, halfH, 0, format);
        RenderTexture bokeh2 = RenderTexture.GetTemporary(halfW, halfH, 0, format);

        material.SetTexture("_CocTex", coc);
        material.SetTexture("_DofTex", bokeh1);

        Graphics.Blit(source, coc, material, 0);
        Graphics.Blit(source, bokeh1, material, 1);
        Graphics.Blit(bokeh1, bokeh2, material, 2);
        Graphics.Blit(bokeh2, bokeh1, material, 3);
        Graphics.Blit(source, destination, material, 4);

        RenderTexture.ReleaseTemporary(coc);
        RenderTexture.ReleaseTemporary(bokeh1);
        RenderTexture.ReleaseTemporary(bokeh2);
    }

    protected void InitScene()
    {
        root = new GameObject("Root");
        for(int i = 0; i< rowGO; i++)
        {
            for(int j =0; j<columnGO; j++)
            {
                GameObject instance = Instantiate(renderTarget, root.transform);
                instance.transform.position = new Vector3(i * distance, 0.5f, j * distance);
            }
        }
    }
}
