using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenSpaceShadowmap : BaseShadowCamera
{
    public RenderTexture mainCameraDepthTexture;

    public Material SSSMGenerator;

    protected FrustumCorners mainCamera_fcs, shadowCamera_fcs;

    protected RenderTexture lightSpaceDepthTexture;

    // Start is called before the first frame update
    void Start()
    {
        InitShadowCam();
        InitFrustumCorners(ref mainCamera_fcs);
        InitFrustumCorners(ref shadowCamera_fcs);
        InitDepthTexture(ref lightSpaceDepthTexture, 0);
        InitMainCamera();
    }

    // Update is called once per frame
    void Update()
    {
        CalcMainCameraFrustumCorners(Camera.main.nearClipPlane, Camera.main.farClipPlane, ref mainCamera_fcs);
        CalcShadowCameraFrustum(ref shadowCamera_fcs, ref mainCamera_fcs);
        ResetShadowCamera(ref shadowCamera_fcs);
        ShadowTextureRender(lightSpaceDepthTexture, 0);
        GenerateSSSM();
    }

    void OnDisable()
    {
        shadowMapCam = null;
        DestroyImmediate(lightSpaceDepthTexture);
        DestroyImmediate(mainCameraDepthTexture);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        DrawFrustum(mainCamera_fcs.nearCorners, mainCamera_fcs.farCorners);

        Gizmos.color = Color.cyan;
        DrawFrustum(shadowCamera_fcs.nearCorners, shadowCamera_fcs.farCorners);
    }

    protected void InitMainCamera()
    {
        mainCameraDepthTexture = new RenderTexture(Screen.width, Screen.height, 32);
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;
        Shader.SetGlobalFloat("_CascadedLevels", 1);
        Shader.SetGlobalTexture("_ScreenSpaceShadowMap", mainCameraDepthTexture);
    }

    protected void GenerateSSSM()
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;

        float fov = Camera.main.fieldOfView;
        float near = Camera.main.nearClipPlane;
        float aspect = Camera.main.aspect;

        float halfHeight = near * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
        Vector3 toRight = Camera.main.transform.right * halfHeight * aspect;
        Vector3 toTop = Camera.main.transform.up * halfHeight;

        Vector3 topLeft = Camera.main.transform.forward * near + toTop - toRight;
        float scale = topLeft.magnitude / near;

        topLeft.Normalize();
        topLeft *= scale;

        Vector3 topRight = Camera.main.transform.forward * near + toRight + toTop;
        topRight.Normalize();
        topRight *= scale;

        Vector3 bottomLeft = Camera.main.transform.forward * near - toTop - toRight;
        bottomLeft.Normalize();
        bottomLeft *= scale;

        Vector3 bottomRight = Camera.main.transform.forward * near + toRight - toTop;
        bottomRight.Normalize();
        bottomRight *= scale;

        frustumCorners.SetRow(0, bottomLeft);
        frustumCorners.SetRow(1, bottomRight);
        frustumCorners.SetRow(2, topRight);
        frustumCorners.SetRow(3, topLeft);

        SSSMGenerator.SetMatrix("_FrustumCornersRay", frustumCorners);

        Graphics.Blit(mainCameraDepthTexture, mainCameraDepthTexture, SSSMGenerator);
    }
}
