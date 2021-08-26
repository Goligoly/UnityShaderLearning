using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CascadedShadowmap : BaseShadowCamera
{
    protected int level;

    protected int cascadedLevels = 3;//不要超过3

    protected FrustumCorners[] mainCamera_fcs, shadowCamera_fcs;

    protected RenderTexture[] depthTexture;

    // Start is called before the first frame update
    void Start()
    {
        InitCascadedData();
        InitShadowCam();
        for (level = 0; level < cascadedLevels; level++)
        {
            InitFrustumCorners(ref mainCamera_fcs[level]);
            InitFrustumCorners(ref shadowCamera_fcs[level]);
            InitDepthTexture(ref depthTexture[level], level);
        }
        Shader.SetGlobalFloat("_CascadedLevels", cascadedLevels);
    }

    // Update is called once per frame
    void Update()
    {
        if (mainCamera_fcs == null || shadowCamera_fcs == null) return;
        for (level = 0; level < cascadedLevels; level++)
        {
            float near = Camera.main.nearClipPlane;
            float far = Camera.main.farClipPlane;
            float delta = (far - near) / cascadedLevels;
            CalcMainCameraFrustumCorners(near + level * delta, near + (level + 1) * delta, ref mainCamera_fcs[level]);
            CalcShadowCameraFrustum(ref shadowCamera_fcs[level], ref mainCamera_fcs[level]);
            ResetShadowCamera(ref shadowCamera_fcs[level]);
            ShadowTextureRender(depthTexture[level], level);
        }
    }

    void OnDestroy()
    {
        shadowMapCam = null;

        for (level = 0; level < cascadedLevels; level++)
        {
            if (depthTexture[level])
            {
                DestroyImmediate(depthTexture[level]);
            }
        }
    }

    void OnDrawGizmos()
    {
        if (mainCamera_fcs == null || shadowCamera_fcs == null) return;
        for (level = 0; level < cascadedLevels; level++)
        {
            Gizmos.color = Color.magenta;
            DrawFrustum(mainCamera_fcs[level].nearCorners, mainCamera_fcs[level].farCorners);

            Gizmos.color = Color.cyan;
            DrawFrustum(shadowCamera_fcs[level].nearCorners, shadowCamera_fcs[level].farCorners);
        }
    }

    protected void InitCascadedData()
    {
        mainCamera_fcs = new FrustumCorners[cascadedLevels];
        shadowCamera_fcs = new FrustumCorners[cascadedLevels];
        depthTexture = new RenderTexture[cascadedLevels];
    }
}
