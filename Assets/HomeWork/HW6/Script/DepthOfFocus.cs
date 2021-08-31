using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthOfFocus : PostEffectBase
{
    public Shader dofShader;
    private Material dofMaterial = null;
    public Material material
    {
        get
        {
            dofMaterial = CheckShaderAndCreateMaterial(dofShader, dofMaterial);
            return dofMaterial;
        }
    }

    public GameObject renderTarget;
    protected int rowGO = 10, columnGO = 6;
    protected float distance = 1.5f;
    protected GameObject root;

    // Start is called before the first frame update
    void Start()
    {
        InitScene();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    protected void InitScene()
    {
        root = new GameObject("Root");
        for(int i = 0; i< rowGO; i++)
        {
            for(int j =0; j<columnGO; j++)
            {
                GameObject instance = Instantiate(renderTarget, root.transform);
                instance.transform.position = new Vector3(i * distance, 0.5f, j * distance);
            }
        }
    }
}
