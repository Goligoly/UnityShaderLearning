using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CascadedShadowmap : BaseShadowCamera
{
    protected int level;

    protected int cascadedLevels = 3;

    protected FrustumCorners[] mainCamera_fcs, shadowCamera_fcs;

    protected RenderTexture[] shadowTexture;

    // Start is called before the first frame update
    void Start()
    {
        InitCascadedData();
        InitShadowCam();
        for (level = 0; level < cascadedLevels; level++)
        {
            InitFrustumCorners(ref mainCamera_fcs[level]);
            InitFrustumCorners(ref shadowCamera_fcs[level]);
            InitShaderTexture(ref shadowTexture[level], level);
        }
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
            ResetShadowCamera();
            ShadowTextureRender(shadowTexture[level], level);
        }
    }

    void OnDestroy()
    {
        shadowMapCam = null;

        for (level = 0; level < cascadedLevels; level++)
        {
            if (shadowTexture[level])
            {
                DestroyImmediate(shadowTexture[level]);
            }
        }
    }

    protected void OnDrawGizmos()
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
        shadowTexture = new RenderTexture[cascadedLevels];
    }

    protected void ResetShadowCamera()
    {
        Vector3 pos = shadowCamera_fcs[level].nearCorners[0] + 0.5f * (shadowCamera_fcs[level].nearCorners[2] - shadowCamera_fcs[level].nearCorners[0]);
        shadowMapCam.transform.position = pos;
        shadowMapCam.transform.rotation = directionalLight.transform.rotation;
        shadowMapCam.nearClipPlane = 0;
        shadowMapCam.farClipPlane = Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[0] - shadowCamera_fcs[level].farCorners[0]);
        shadowMapCam.aspect = Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[0]) / Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[2]);
        shadowMapCam.orthographicSize = Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[2]) * 0.5f;
    }
}
