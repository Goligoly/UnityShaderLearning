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

    private struct FrustumCorners
    {
        public Vector3[] nearCorners;
        public Vector3[] farCorners;
    }

    private FrustumCorners mainCamera_fcs, shadowCamera_fcs;

    private static readonly int _CustomShadowMap = Shader.PropertyToID("_CustomShadowMap");

    private static readonly int _CustomLightSpaceMatrix = Shader.PropertyToID("_CustomLightSpaceMatrix");

    // Start is called before the first frame update
    void Start()
    {
        InitFrustumCorners();
        InitShadowCam();
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

    void InitFrustumCorners()
    {
        mainCamera_fcs = new FrustumCorners();
        mainCamera_fcs.nearCorners = new Vector3[4];
        mainCamera_fcs.farCorners = new Vector3[4];
        shadowCamera_fcs = new FrustumCorners();
        shadowCamera_fcs.nearCorners = new Vector3[4];
        shadowCamera_fcs.farCorners = new Vector3[4];
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        DrawFrustum(mainCamera_fcs.nearCorners, mainCamera_fcs.farCorners);
        Gizmos.color = Color.cyan;
        DrawFrustum(shadowCamera_fcs.nearCorners, shadowCamera_fcs.farCorners);
    }

    private void DrawFrustum(Vector3[] nearCorners, Vector3[] farCorners)
    {
        if (nearCorners == null || farCorners == null) return;

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

    // Update is called once per frame
    void Update()
    {
        CalcMainCameraFrustumCorners();
        CalcShadowCameraFrustum();

        shadowMapCam.Render();

        var lightSpaceMatrix = GL.GetGPUProjectionMatrix(shadowMapCam.projectionMatrix, false);
        lightSpaceMatrix = lightSpaceMatrix * shadowMapCam.worldToCameraMatrix;

        Shader.SetGlobalMatrix(_CustomLightSpaceMatrix, lightSpaceMatrix);
    }

    private void CalcMainCameraFrustumCorners()
    {
        if (mainCamera_fcs.nearCorners == null) return;

        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), Camera.main.nearClipPlane, Camera.MonoOrStereoscopicEye.Mono, mainCamera_fcs.nearCorners);

        for (int i = 0; i < 4; i++)
        {
            mainCamera_fcs.nearCorners[i] = Camera.main.transform.TransformPoint(mainCamera_fcs.nearCorners[i]);
        }

        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), Camera.main.farClipPlane, Camera.MonoOrStereoscopicEye.Mono, mainCamera_fcs.farCorners);

        for (int i = 0; i < 4; i++)
        {
            mainCamera_fcs.farCorners[i] = Camera.main.transform.TransformPoint(mainCamera_fcs.farCorners[i]);
        }
    }

    private void CalcShadowCameraFrustum()
    {
        if (shadowMapCam == null || mainCamera_fcs.nearCorners == null) return;

        for (int i = 0; i < 4; i++)
        {
            shadowCamera_fcs.nearCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCamera_fcs.nearCorners[i]);
            shadowCamera_fcs.farCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCamera_fcs.farCorners[i]);
        }

        float[] xs = { shadowCamera_fcs.nearCorners[0].x, shadowCamera_fcs.nearCorners[1].x, shadowCamera_fcs.nearCorners[2].x, shadowCamera_fcs.nearCorners[3].x,
                    shadowCamera_fcs.farCorners[0].x, shadowCamera_fcs.farCorners[1].x, shadowCamera_fcs.farCorners[2].x, shadowCamera_fcs.farCorners[3].x };

        float[] ys = { shadowCamera_fcs.nearCorners[0].y, shadowCamera_fcs.nearCorners[1].y, shadowCamera_fcs.nearCorners[2].y, shadowCamera_fcs.nearCorners[3].y,
                    shadowCamera_fcs.farCorners[0].y, shadowCamera_fcs.farCorners[1].y, shadowCamera_fcs.farCorners[2].y, shadowCamera_fcs.farCorners[3].y };

        float[] zs = { shadowCamera_fcs.nearCorners[0].z, shadowCamera_fcs.nearCorners[1].z, shadowCamera_fcs.nearCorners[2].z, shadowCamera_fcs.nearCorners[3].z,
                    shadowCamera_fcs.farCorners[0].z, shadowCamera_fcs.farCorners[1].z, shadowCamera_fcs.farCorners[2].z, shadowCamera_fcs.farCorners[3].z };

        float minX = Mathf.Min(xs);
        float maxX = Mathf.Max(xs);
        float minY = Mathf.Min(ys);
        float maxY = Mathf.Max(ys);
        float minZ = Mathf.Min(zs);
        float maxZ = Mathf.Max(zs);

        shadowCamera_fcs.nearCorners[0] = new Vector3(minX, minY, minZ);
        shadowCamera_fcs.nearCorners[1] = new Vector3(maxX, minY, minZ);
        shadowCamera_fcs.nearCorners[2] = new Vector3(maxX, maxY, minZ);
        shadowCamera_fcs.nearCorners[3] = new Vector3(minX, maxY, minZ);

        shadowCamera_fcs.farCorners[0] = new Vector3(minX, minY, maxZ);
        shadowCamera_fcs.farCorners[1] = new Vector3(maxX, minY, maxZ);
        shadowCamera_fcs.farCorners[2] = new Vector3(maxX, maxY, maxZ);
        shadowCamera_fcs.farCorners[3] = new Vector3(minX, maxY, maxZ);

        Vector3 pos = shadowCamera_fcs.nearCorners[0] + 0.5f * (shadowCamera_fcs.nearCorners[2] - shadowCamera_fcs.nearCorners[0]);
        shadowMapCam.transform.position = shadowMapCam.transform.TransformPoint(pos);
        shadowMapCam.transform.rotation = directionalLight.transform.rotation;
        shadowMapCam.nearClipPlane = minZ;
        shadowMapCam.farClipPlane = maxZ;
        shadowMapCam.aspect = Vector3.Magnitude(shadowCamera_fcs.nearCorners[1] - shadowCamera_fcs.nearCorners[0]) / Vector3.Magnitude(shadowCamera_fcs.nearCorners[1] - shadowCamera_fcs.nearCorners[2]);
        shadowMapCam.orthographicSize = Vector3.Magnitude(shadowCamera_fcs.nearCorners[1] - shadowCamera_fcs.nearCorners[2]) * 0.5f;

        for (int i = 0; i < 4; i++)
        {
            shadowCamera_fcs.nearCorners[i] = shadowMapCam.transform.TransformPoint(shadowCamera_fcs.nearCorners[i]);
            shadowCamera_fcs.farCorners[i] = shadowMapCam.transform.TransformPoint(shadowCamera_fcs.farCorners[i]);
        }
    }
}
