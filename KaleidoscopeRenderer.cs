using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class KaleidoscopeRenderer : MonoBehaviour {

    public Mesh sourceMesh;

    public Material sourceMaterial;

    public List<Matrix4x4> matrices;

    private MaterialPropertyBlock properties;

	void Start () {
        properties = new MaterialPropertyBlock();
        properties.SetFloatArray("_reflectX", new float[] { 1, -1, 1, -1, 1, -1, 1, -1 });
        properties.SetFloatArray("_reflectY", new float[] { 1, 1, -1, -1, 1, 1, -1, -1 });
        properties.SetFloatArray("_swapXY", new float[] { 0, 0, 0, 0, 1, 1, 1, 1  });
    }
	
	void Update () {
        var newMatrix = new Matrix4x4();
        newMatrix.SetTRS(transform.position, transform.rotation, transform.localScale);
        for (int i=0;i<matrices.Count;i++)
        {
            matrices[i] = newMatrix;
        }
        Graphics.DrawMeshInstanced(sourceMesh, 0, sourceMaterial, matrices, properties);
	}
}
