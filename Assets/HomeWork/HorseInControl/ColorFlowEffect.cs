using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorFlowEffect : PostEffectBase
{
    public Shader colorFlowShader;
    private Material colorFlowMaterial = null;
    public Material material
    {
        get
        {
            colorFlowMaterial = CheckShaderAndCreateMaterial(colorFlowShader, colorFlowMaterial);
            return colorFlowMaterial;
        }
    }

    public GameObject renderTarget;

    private RenderTexture lastRender;

    private void Start()
    {
        lastRender = new RenderTexture(Camera.main.pixelWidth, Camera.main.pixelHeight, 32);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture buffer0 = RenderTexture.GetTemporary(source.width, source.height, 0);
        RenderTexture buffer1 = RenderTexture.GetTemporary(source.width, source.height, 0);

        Vector3 targetScrPos = Camera.main.WorldToScreenPoint(renderTarget.transform.position);
        targetScrPos.x /= Screen.width;
        targetScrPos.y /= Screen.height;
        targetScrPos -= new Vector3(0.5f, 0.5f, 0);
        Debug.Log(targetScrPos);
        material.SetVector("_TargetPosition", new Vector4(targetScrPos.x, targetScrPos.y, 0, 0));

        material.SetTexture("_Buffer0", buffer0);
        material.SetTexture("_Buffer1", buffer1);

        material.SetVector("_Direction", new Vector4(0, 0, 0, 0));

        Graphics.Blit(source, buffer0, material, 0);
        Graphics.Blit(lastRender, buffer1, material, 1);
        Graphics.Blit(null, lastRender, material, 2);
        Graphics.Blit(lastRender, destination);

        RenderTexture.ReleaseTemporary(buffer0);
        RenderTexture.ReleaseTemporary(buffer1);
    }
}
