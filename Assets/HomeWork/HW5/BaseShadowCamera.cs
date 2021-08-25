using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BaseShadowCamera : MonoBehaviour
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

    protected Camera shadowMapCam;

    protected struct FrustumCorners
    {
        public Vector3[] nearCorners;
        public Vector3[] farCorners;
    }

    protected void InitShadowCam()
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

    protected void InitFrustumCorners(ref FrustumCorners frustumCorners)
    {
        frustumCorners = new FrustumCorners();
        frustumCorners.nearCorners = new Vector3[4];
        frustumCorners.farCorners = new Vector3[4];
    }

    protected void InitShaderTexture(ref RenderTexture renderTexture, int level)
    {
        renderTexture = new RenderTexture((int)shadowResolution, (int)shadowResolution, 32);
        Shader.SetGlobalTexture("_CustomShadowMap" + level, renderTexture);
    }

    protected void DrawFrustum(Vector3[] nearCorners, Vector3[] farCorners)
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

    protected void CalcMainCameraFrustumCorners(float near, float far, ref FrustumCorners frustumCorners)
    {
        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), near, Camera.MonoOrStereoscopicEye.Mono, frustumCorners.nearCorners);

        for (int i = 0; i < 4; i++)
        {
            frustumCorners.nearCorners[i] = Camera.main.transform.TransformPoint(frustumCorners.nearCorners[i]);
        }

        Camera.main.CalculateFrustumCorners(new Rect(0, 0, 1, 1), far, Camera.MonoOrStereoscopicEye.Mono, frustumCorners.farCorners);

        for (int i = 0; i < 4; i++)
        {
            frustumCorners.farCorners[i] = Camera.main.transform.TransformPoint(frustumCorners.farCorners[i]);
        }
    }

    protected void CalcShadowCameraFrustum(ref FrustumCorners shadowCam, ref FrustumCorners mainCam)
    {
        if (shadowMapCam == null) return;

        for (int i = 0; i < 4; i++)
        {
            shadowCam.nearCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCam.nearCorners[i]);
            shadowCam.farCorners[i] = shadowMapCam.transform.InverseTransformPoint(mainCam.farCorners[i]);
        }

        float[] xs = { shadowCam.nearCorners[0].x, shadowCam.nearCorners[1].x, shadowCam.nearCorners[2].x, shadowCam.nearCorners[3].x,
                    shadowCam.farCorners[0].x, shadowCam.farCorners[1].x, shadowCam.farCorners[2].x, shadowCam.farCorners[3].x };

        float[] ys = { shadowCam.nearCorners[0].y, shadowCam.nearCorners[1].y, shadowCam.nearCorners[2].y, shadowCam.nearCorners[3].y,
                    shadowCam.farCorners[0].y, shadowCam.farCorners[1].y, shadowCam.farCorners[2].y, shadowCam.farCorners[3].y };

        float[] zs = { shadowCam.nearCorners[0].z, shadowCam.nearCorners[1].z, shadowCam.nearCorners[2].z, shadowCam.nearCorners[3].z,
                    shadowCam.farCorners[0].z, shadowCam.farCorners[1].z, shadowCam.farCorners[2].z, shadowCam.farCorners[3].z };

        float minX = Mathf.Min(xs);
        float maxX = Mathf.Max(xs);
        float minY = Mathf.Min(ys);
        float maxY = Mathf.Max(ys);
        float minZ = Mathf.Min(zs);
        float maxZ = Mathf.Max(zs);

        shadowCam.nearCorners[0] = new Vector3(minX, minY, minZ);
        shadowCam.nearCorners[1] = new Vector3(maxX, minY, minZ);
        shadowCam.nearCorners[2] = new Vector3(maxX, maxY, minZ);
        shadowCam.nearCorners[3] = new Vector3(minX, maxY, minZ);

        shadowCam.farCorners[0] = new Vector3(minX, minY, maxZ);
        shadowCam.farCorners[1] = new Vector3(maxX, minY, maxZ);
        shadowCam.farCorners[2] = new Vector3(maxX, maxY, maxZ);
        shadowCam.farCorners[3] = new Vector3(minX, maxY, maxZ);

        for (int i = 0; i < 4; i++)
        {
            shadowCam.nearCorners[i] = shadowMapCam.transform.TransformPoint(shadowCam.nearCorners[i]);
            shadowCam.farCorners[i] = shadowMapCam.transform.TransformPoint(shadowCam.farCorners[i]);
        }
    }

    protected void ResetShadowCamera(ref FrustumCorners shadowCam)
    {
        Vector3 pos = shadowCam.nearCorners[0] + 0.5f * (shadowCam.nearCorners[2] - shadowCam.nearCorners[0]);
        shadowMapCam.transform.position = pos;
        shadowMapCam.transform.rotation = directionalLight.transform.rotation;
        shadowMapCam.nearClipPlane = 0;
        shadowMapCam.farClipPlane = Vector3.Magnitude(shadowCam.nearCorners[0] - shadowCam.farCorners[0]);
        shadowMapCam.aspect = Vector3.Magnitude(shadowCam.nearCorners[1] - shadowCam.nearCorners[0]) / Vector3.Magnitude(shadowCam.nearCorners[1] - shadowCam.nearCorners[2]);
        shadowMapCam.orthographicSize = Vector3.Magnitude(shadowCam.nearCorners[1] - shadowCam.nearCorners[2]) * 0.5f;
    }

    protected void ShadowTextureRender(RenderTexture renderTexture, int level)
    {
        shadowMapCam.targetTexture = renderTexture;
        shadowMapCam.Render();

        var lightSpaceMatrix = GL.GetGPUProjectionMatrix(shadowMapCam.projectionMatrix, false);
        lightSpaceMatrix = lightSpaceMatrix * shadowMapCam.worldToCameraMatrix;

        Shader.SetGlobalMatrix("_CustomLightSpaceMatrix" + level, lightSpaceMatrix);
    }
}
