using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class synchroCullVector : MonoBehaviour {

    public Transform directionObject = null;
    public Transform center = null;

    public float distance = 0f;
    Vector3 direction = Vector3.up;

    public GameObject cullObject;

    void Update () {
        direction = Vector3.Normalize(directionObject.position - directionObject.parent.position);
        cullObject.GetComponent<Renderer>().sharedMaterial.SetVector("_Direction", new Vector4(direction.x, direction.y, direction.z, 1));
        cullObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Distance", distance);
        cullObject.GetComponent<Renderer>().sharedMaterial.SetVector("_Center", new Vector4(center.position.x,center.position.y,center.position.z,1));
    }
}
