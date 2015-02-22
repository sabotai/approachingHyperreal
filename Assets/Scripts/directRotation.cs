using UnityEngine;
using System.Collections;

public class directRotation : MonoBehaviour {

	//rotate the model bone with rift rotation

	public Transform cameraObject;
	public bool rotateFromBehind;


	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void LateUpdate()
	{
		if (rotateFromBehind) {
			transform.rotation = cameraObject.rotation * Quaternion.Euler (0, 0, -90);
				} else {
			transform.rotation = cameraObject.rotation * Quaternion.Euler (-180, 0, 90);
				}
	}
}
