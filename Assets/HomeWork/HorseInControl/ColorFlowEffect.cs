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

    public Texture flowNoise;

    private RenderTexture lastRender;

    private float speed = 1.5f;

    private Vector2 direction = new Vector2(0, 0), lastPos, currentPos;

    private void Start()
    {
        lastRender = new RenderTexture(Camera.main.pixelWidth, Camera.main.pixelHeight, 32);
        material.SetTexture("_LastRender", lastRender);
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;

        material.SetTexture("_FlowNoise", flowNoise);

        lastPos = Camera.main.WorldToScreenPoint(renderTarget.transform.position);
        currentPos = lastPos;
    }

    private void Update()
    {
        currentPos = Camera.main.WorldToScreenPoint(renderTarget.transform.position);
        Vector2 dir = (currentPos - lastPos).normalized;
        direction += dir * 0.01f;
        if (direction.magnitude > 1) direction = direction.normalized;
        lastPos = currentPos;

        if (Input.GetKey(KeyCode.W))
        {
            transform.Translate(Vector3.down * Time.deltaTime * speed);
        }

        if (Input.GetKey(KeyCode.S))
        {
            transform.Translate(Vector3.up * Time.deltaTime * speed);
        }

        if (Input.GetKey(KeyCode.A))
        {
            transform.Translate(Vector3.right * Time.deltaTime * speed);
        }

        if (Input.GetKey(KeyCode.D))
        {
            transform.Translate(Vector3.left * Time.deltaTime * speed);
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture buffer0 = RenderTexture.GetTemporary(source.width, source.height, 0);
        RenderTexture buffer1 = RenderTexture.GetTemporary(source.width, source.height, 0);

        Vector3 targetScrPos = currentPos;
        targetScrPos.x /= Screen.width;
        targetScrPos.y /= Screen.height;
        targetScrPos -= new Vector3(0.5f, 0.5f, 0);
        material.SetVector("_TargetPosition", new Vector4(targetScrPos.x, targetScrPos.y, 0, 0));

        material.SetTexture("_Buffer0", buffer0);
        material.SetTexture("_Buffer1", buffer1);

        material.SetVector("_Direction", direction);

        Graphics.Blit(source, buffer0, material, 0);
        Graphics.Blit(lastRender, buffer1, material, 1);
        Graphics.Blit(null, lastRender, material, 2);
        Graphics.Blit(source, destination, material, 3);

        RenderTexture.ReleaseTemporary(buffer0);
        RenderTexture.ReleaseTemporary(buffer1);
    }
}
