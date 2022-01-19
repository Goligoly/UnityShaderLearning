using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderParamterSeter : MonoBehaviour
{
    public bool FogOn = true;
    public Vector4 _GlobalFogParam = new Vector4(-0.0020f, 1.0298f, 0.0f, 119.4000f);
    public Color _GlobalFogDistColor = new Vector4(0.2551f, 0.3515f, 0.4623f, 1.0f);
    public Color _GlobalFogHeightColor = new Vector4(0.2296f, 0.2769f, 0.3774f, 1.0f);
    public float _GlobalFogHeightDis = 252.5f;
    public float _GlobalFogHeightDensity = 0.37f;
    public float _FogLightRadius = 0.14f;
    public float _FogLightSoft = 0.548f;
    public float _FogLightHightAtten = 0.18f;
    public float _HightFogLightRadius = -0.06f;
    public float _HightFogLightSoft = 1.0f;
    public float _HightFogLightHightAtten = 0.1f;
    public float _FogLightPow = 1.0f;

    void SetShaderParamter(string filename)
    {
        TextAsset binAsset = Resources.Load(filename, typeof(TextAsset)) as TextAsset;
        string[] lineArray = binAsset.text.Split("\r"[0]);

        String[] title = lineArray[0].Split(',');
        String[] row0 = lineArray[1].Split(',');
        String[] row1 = lineArray[2].Split(',');
        String[] row2 = lineArray[3].Split(',');
        String[] row3 = lineArray[4].Split(',');

        Dictionary<string, Vector4[]> matrixDic = new Dictionary<string, Vector4[]>();
        matrixDic["_hlslcc_mtx4x4unity_ObjectToWorld"] = new Vector4[4];
        matrixDic["_hlslcc_mtx4x4unity_WorldToObject"] = new Vector4[4];
        matrixDic["_hlslcc_mtx4x4unity_MatrixVP"] = new Vector4[4];

        for (int i = 0; i < title.Length; i++)
        {
            if (title[i] == "" || title[i] == "Index" || title[i].Contains("byte")) continue;
            if (title[i].Contains("_hlslcc_mtx4x4unity"))
            {
                string name = title[i].Substring(0, title[i].Length - 2);
                int index = int.Parse(title[i].Substring(title[i].Length - 1, 1));
                matrixDic[name][index] = new Vector4(float.Parse(row0[i]), float.Parse(row1[i]), float.Parse(row2[i]),
                    float.Parse(row3[i]));
                if (index == 3)
                {
                    Shader.SetGlobalVectorArray(name, matrixDic[name]);
                }
                // Debug.Log($"{name} {index}");
            }
            else
            {
                if (title[i] == "__WorldSpaceCameraPos")
                {
                    Shader.SetGlobalVector(title[i],
                        new Vector3(float.Parse(row0[i]), float.Parse(row1[i]), float.Parse(row2[i])));
                }
                else if (row3[i] != "")
                {
                    Shader.SetGlobalVector(title[i],
                        new Vector4(float.Parse(row0[i]), float.Parse(row1[i]), float.Parse(row2[i]),
                            float.Parse(row3[i])));
                }
                else
                {
                    Shader.SetGlobalFloat(title[i], float.Parse(row0[i]));
                }
                // Debug.Log($"{title[i]}, {row0[i]}, {row1[i]}, {row2[i]}, {row3[i]}");
            }
            // Debug.Log($"{title[i]} set successful!");
        }
    }

    void SetFogParamter()
    {
        if (FogOn)
        {
            Shader.SetGlobalVector("_GlobalFogParam", _GlobalFogParam);
            Shader.SetGlobalVector("_GlobalFogDistColor", _GlobalFogDistColor);
            Shader.SetGlobalVector("_GlobalFogHeightColor", _GlobalFogHeightColor);
            Shader.SetGlobalFloat("_GlobalFogHeightDis", _GlobalFogHeightDis);
            Shader.SetGlobalFloat("_GlobalFogHeightDensity", _GlobalFogHeightDensity);
            Shader.SetGlobalFloat("_FogLightRadius", _FogLightRadius);
            Shader.SetGlobalFloat("_FogLightSoft", _FogLightSoft);
            Shader.SetGlobalFloat("_FogLightHightAtten", _FogLightHightAtten);
            Shader.SetGlobalFloat("_HightFogLightRadius", _HightFogLightRadius);
            Shader.SetGlobalFloat("_HightFogLightSoft", _HightFogLightSoft);
            Shader.SetGlobalFloat("_HightFogLightHightAtten", _HightFogLightHightAtten);
            Shader.SetGlobalFloat("_FogLightPow", _FogLightPow);
        }
        else
        {
            Shader.SetGlobalVector("_GlobalFogParam", new Vector4(0, 1, 100, 0));
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        // SetShaderParamter("ShaderParamter0");
        // SetShaderParamter("ShaderParamter1");
    }

    private void Update()
    {
        SetFogParamter();
    }
}