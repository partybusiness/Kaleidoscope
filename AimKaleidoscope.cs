using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AimKaleidoscope : MonoBehaviour {

    [SerializeField]
    Material targetMaterial;

    
    void Update () {
        if (targetMaterial == null)
            return;
        Quaternion rotation = transform.rotation;
        targetMaterial.SetVector("_Rotation", new Vector4(rotation.x,rotation.y,rotation.z,rotation.w));
        Quaternion inverse = Quaternion.Inverse(rotation);
        targetMaterial.SetVector("_InverseRotation", new Vector4(inverse.x, inverse.y, inverse.z, inverse.w));
        targetMaterial.SetVector("_Centre", transform.position);
    }
}
