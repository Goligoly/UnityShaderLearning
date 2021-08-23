using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShadowCamera : MonoBehaviour
{
    public enum ShadowMapResolution
    {
        VeryLow = 128,
        Low = 256,
        Medium = 512,
        High = 1024,
        VertHigh = 2048
    }

    public Light directionalLight;

    public Shader shadowMapCasterShader;

    public ShadowMapResolution shadowResolution = ShadowMapResolution.Medium;

    private Camera shadowMapCam;

    private static readonly int _CustomShadowMap = Shader.PropertyToID("_CustomShadowMap");

    private static readonly int _CustomLightSpaceMatrix = Shader.PropertyToID("_CustomLightSpaceMatrix");

    // Start is called before the first frame update
    void Start()
    {
        shadowMapCam = directionalLight.gameObject.AddComponent<Camera>() ?? directionalLight.gameObject.GetComponent<Camera>();
        shadowMapCam.backgroundColor = Color.white;
        shadowMapCam.clearFlags = CameraClearFlags.SolidColor;
        shadowMapCam.orthographic = true;
        shadowMapCam.orthographicSize = 10;
        shadowMapCam.nearClipPlane = 0.3f;
        shadowMapCam.farClipPlane = 20;
        shadowMapCam.enabled = false;

        shadowMapCam.SetReplacementShader(shadowMapCasterShader, null);

        var shadowMapTexture = shadowMapCam.targetTexture;
        var textureSize = (int)shadowResolution;
        if (shadowMapTexture == null || shadowMapTexture.width != textureSize)
        {
            if (shadowMapTexture != null) RenderTexture.ReleaseTemporary(shadowMapTexture);
            shadowMapTexture = RenderTexture.GetTemporary(textureSize, textureSize, 0, RenderTextureFormat.ARGB32);
            shadowMapTexture.name = "_CustomShadowMap";
            shadowMapCam.targetTexture = shadowMapTexture;
            Shader.SetGlobalTexture(_CustomShadowMap, shadowMapTexture);
        }
    }

    private void OnDrawGizmos()
    {
        if (directionalLight == null || shadowMapCam == null) return;
        Gizmos.color = Color.cyan;
        float size = shadowMapCam.orthographicSize;

        var l_near = shadowMapCam.nearClipPlane;
        var l_far = shadowMapCam.farClipPlane;
        var l_pos = directionalLight.transform.position;
        var l_up = directionalLight.transform.up;
        var l_forward = directionalLight.transform.forward;
        var l_right = directionalLight.transform.right;

        Vector3 tl_n = l_pos + l_forward * l_near - l_right * size + l_up * size;
        Vector3 bl_n = l_pos + l_forward * l_near - l_right * size - l_up * size;

        Vector3 tr_n = l_pos + l_forward * l_near + l_right * size + l_up * size;
        Vector3 br_n = l_pos + l_forward * l_near + l_right * size - l_up * size;

        Vector3 tl_f = l_pos + l_forward * l_far - l_right * size + l_up * size;
        Vector3 bl_f = l_pos + l_forward * l_far - l_right * size - l_up * size;

        Vector3 tr_f = l_pos + l_forward * l_far + l_right * size + l_up * size;
        Vector3 br_f = l_pos + l_forward * l_far + l_right * size - l_up * size;

        //nearClipPlane
        Gizmos.DrawLine(bl_n, tl_n);
        Gizmos.DrawLine(br_n, tr_n);
        Gizmos.DrawLine(tl_n, tr_n);
        Gizmos.DrawLine(bl_n, br_n);

        //farClipPlane
        Gizmos.DrawLine(bl_f, tl_f);
        Gizmos.DrawLine(br_f, tr_f);
        Gizmos.DrawLine(tl_f, tr_f);
        Gizmos.DrawLine(bl_f, br_f);

        Gizmos.DrawLine(tl_n, tl_f);
        Gizmos.DrawLine(bl_n, bl_f);
        Gizmos.DrawLine(tr_n, tr_f);
        Gizmos.DrawLine(br_n, br_f);
    }

    // Update is called once per frame
    void Update()
    {
        shadowMapCam.Render();

        var lightSpaceMatrix = GL.GetGPUProjectionMatrix(shadowMapCam.projectionMatrix, false);
        lightSpaceMatrix = lightSpaceMatrix * shadowMapCam.worldToCameraMatrix;

        Shader.SetGlobalMatrix(_CustomLightSpaceMatrix, lightSpaceMatrix);
    }
}
