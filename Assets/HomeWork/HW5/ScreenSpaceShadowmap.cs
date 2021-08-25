using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenSpaceShadowmap : BaseShadowCamera
{
    protected FrustumCorners mainCamera_fcs, shadowCamera_fcs;

    protected RenderTexture shadowTexture;

    // Start is called before the first frame update
    void Start()
    {
        InitShadowCam();
        InitFrustumCorners(ref mainCamera_fcs);
        InitFrustumCorners(ref shadowCamera_fcs);
        InitShaderTexture(ref shadowTexture, 0);
    }

    // Update is called once per frame
    void Update()
    {
        CalcMainCameraFrustumCorners(Camera.main.nearClipPlane, Camera.main.farClipPlane, ref mainCamera_fcs);
        CalcShadowCameraFrustum(ref shadowCamera_fcs, ref mainCamera_fcs);
        ResetShadowCamera(ref shadowCamera_fcs);
        ShadowTextureRender(shadowTexture, 0);
    }

    void OnDestroy()
    {
        shadowMapCam = null;
        DestroyImmediate(shadowTexture);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        DrawFrustum(mainCamera_fcs.nearCorners, mainCamera_fcs.farCorners);

        Gizmos.color = Color.cyan;
        DrawFrustum(shadowCamera_fcs.nearCorners, shadowCamera_fcs.farCorners);
    }
}
