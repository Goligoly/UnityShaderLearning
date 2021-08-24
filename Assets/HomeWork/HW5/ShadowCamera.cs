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

    private int level;

    private int cascadedLevels = 3;

    private Camera shadowMapCam;

    private struct FrustumCorners
    {
        public Vector3[] nearCorners;
        public Vector3[] farCorners;
    }

    private FrustumCorners[] mainCamera_fcs, shadowCamera_fcs;

    private RenderTexture[] shadowTexture;

    // Start is called before the first frame update
    void Start()
    {
        InitCascadedData();
        InitShadowCam();
        for (level = 0; level < cascadedLevels; level++)
        { 
            InitFrustumCorners();
            InitShaderTexture();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (mainCamera_fcs == null || shadowCamera_fcs == null) return;
        for (level = 0; level < cascadedLevels; level++)
        {
            CalcMainCameraFrustumCorners();
            CalcShadowCameraFrustum();
            ShadowTextureRender();
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

    private void OnDrawGizmos()
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

    private void InitCascadedData()
    {
        mainCamera_fcs = new FrustumCorners[cascadedLevels];
        shadowCamera_fcs = new FrustumCorners[cascadedLevels];
        shadowTexture = new RenderTexture[cascadedLevels];
    }

    private void InitShadowCam()
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
    }

    void InitFrustumCorners()
    {
        mainCamera_fcs[level] = new FrustumCorners();
        mainCamera_fcs[level].nearCorners = new Vector3[4];
        mainCamera_fcs[level].farCorners = new Vector3[4];
        shadowCamera_fcs[level] = new FrustumCorners();
        shadowCamera_fcs[level].nearCorners = new Vector3[4];
        shadowCamera_fcs[level].farCorners = new Vector3[4];
    }

    private void InitShaderTexture()
    {
        shadowTexture[level] = new RenderTexture((int)shadowResolution, (int)shadowResolution, 32);
        Shader.SetGlobalTexture("_CustomShadowMap" + level, shadowTexture[level]);
    }

    private void DrawFrustum(Vector3[] nearCorners, Vector3[] farCorners)
    {
        //nearClipPlane
        Gizmos.DrawLine(nearCorners[0], nearCorners[1]);
        Gizmos.DrawLine(nearCorners[1], nearCorners[2]);
        Gizmos.DrawLine(nearCorners[2], nearCorners[3]);
        Gizmos.DrawLine(nearCorners[3], nearCorners[0]);

        //farClipPlane
        Gizmos.DrawLine(farCorners[0], farCorners[1]);
        Gizmos.DrawLine(farCorners[1], farCorners[2]);
        Gizmos.DrawLine(farCorners[2], farCorners[3]);
        Gizmos.DrawLine(farCorners[3], farCorners[0]);

        Gizmos.DrawLine(nearCorners[0], farCorners[0]);
        Gizmos.DrawLine(nearCorners[1], farCorners[1]);
        Gizmos.DrawLine(nearCorners[2], farCorners[2]);
        Gizmos.DrawLine(nearCorners[3], farCorners[3]);
    }

    private void CalcMainCameraFrustumCorners()
    {
        float near = Camera.main.nearClipPlane;
        float far = Camera.main.farClipPlane;
        float delta = (far - near) / cascadedLevels;
        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), near + level * delta, Camera.MonoOrStereoscopicEye.Mono, mainCamera_fcs[level].nearCorners);

        for (int i = 0; i < 4; i++)
        {
            mainCamera_fcs[level].nearCorners[i] = Camera.main.transform.TransformPoint(mainCamera_fcs[level].nearCorners[i]);
        }

        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), near + (level + 1) * delta, Camera.MonoOrStereoscopicEye.Mono, mainCamera_fcs[level].farCorners);

        for (int i = 0; i < 4; i++)
        {
            mainCamera_fcs[level].farCorners[i] = Camera.main.transform.TransformPoint(mainCamera_fcs[level].farCorners[i]);
        }
    }

    private void CalcShadowCameraFrustum()
    {
        if (shadowMapCam == null) return;

        for (int i = 0; i < 4; i++)
        {
            shadowCamera_fcs[level].nearCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCamera_fcs[level].nearCorners[i]);
            shadowCamera_fcs[level].farCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCamera_fcs[level].farCorners[i]);
        }

        float[] xs = { shadowCamera_fcs[level].nearCorners[0].x, shadowCamera_fcs[level].nearCorners[1].x, shadowCamera_fcs[level].nearCorners[2].x, shadowCamera_fcs[level].nearCorners[3].x,
                    shadowCamera_fcs[level].farCorners[0].x, shadowCamera_fcs[level].farCorners[1].x, shadowCamera_fcs[level].farCorners[2].x, shadowCamera_fcs[level].farCorners[3].x };

        float[] ys = { shadowCamera_fcs[level].nearCorners[0].y, shadowCamera_fcs[level].nearCorners[1].y, shadowCamera_fcs[level].nearCorners[2].y, shadowCamera_fcs[level].nearCorners[3].y,
                    shadowCamera_fcs[level].farCorners[0].y, shadowCamera_fcs[level].farCorners[1].y, shadowCamera_fcs[level].farCorners[2].y, shadowCamera_fcs[level].farCorners[3].y };

        float[] zs = { shadowCamera_fcs[level].nearCorners[0].z, shadowCamera_fcs[level].nearCorners[1].z, shadowCamera_fcs[level].nearCorners[2].z, shadowCamera_fcs[level].nearCorners[3].z,
                    shadowCamera_fcs[level].farCorners[0].z, shadowCamera_fcs[level].farCorners[1].z, shadowCamera_fcs[level].farCorners[2].z, shadowCamera_fcs[level].farCorners[3].z };

        float minX = Mathf.Min(xs);
        float maxX = Mathf.Max(xs);
        float minY = Mathf.Min(ys);
        float maxY = Mathf.Max(ys);
        float minZ = Mathf.Min(zs);
        float maxZ = Mathf.Max(zs);

        shadowCamera_fcs[level].nearCorners[0] = new Vector3(minX, minY, minZ);
        shadowCamera_fcs[level].nearCorners[1] = new Vector3(maxX, minY, minZ);
        shadowCamera_fcs[level].nearCorners[2] = new Vector3(maxX, maxY, minZ);
        shadowCamera_fcs[level].nearCorners[3] = new Vector3(minX, maxY, minZ);

        shadowCamera_fcs[level].farCorners[0] = new Vector3(minX, minY, maxZ);
        shadowCamera_fcs[level].farCorners[1] = new Vector3(maxX, minY, maxZ);
        shadowCamera_fcs[level].farCorners[2] = new Vector3(maxX, maxY, maxZ);
        shadowCamera_fcs[level].farCorners[3] = new Vector3(minX, maxY, maxZ);

        Vector3 pos = shadowCamera_fcs[level].nearCorners[0] + 0.5f * (shadowCamera_fcs[level].nearCorners[2] - shadowCamera_fcs[level].nearCorners[0]);
        shadowMapCam.transform.rotation = directionalLight.transform.rotation;
        shadowMapCam.nearClipPlane = minZ;
        shadowMapCam.farClipPlane = maxZ;
        shadowMapCam.aspect = Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[0]) / Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[2]);
        shadowMapCam.orthographicSize = Vector3.Magnitude(shadowCamera_fcs[level].nearCorners[1] - shadowCamera_fcs[level].nearCorners[2]) * 0.5f;

        for (int i = 0; i < 4; i++)
        {
            shadowCamera_fcs[level].nearCorners[i] = shadowMapCam.transform.TransformPoint(shadowCamera_fcs[level].nearCorners[i]);
            shadowCamera_fcs[level].farCorners[i] = shadowMapCam.transform.TransformPoint(shadowCamera_fcs[level].farCorners[i]);
        }

        shadowMapCam.transform.position = shadowMapCam.transform.TransformPoint(pos);
    }

    private void ShadowTextureRender()
    {
        shadowMapCam.targetTexture = shadowTexture[level];
        shadowMapCam.Render();

        var lightSpaceMatrix = GL.GetGPUProjectionMatrix(shadowMapCam.projectionMatrix, false);
        lightSpaceMatrix = lightSpaceMatrix * shadowMapCam.worldToCameraMatrix;

        Shader.SetGlobalMatrix("_CustomLightSpaceMatrix" + level, lightSpaceMatrix);
    }
}
