using UnityEngine;
using System.Collections;

public class headRotate : MonoBehaviour {

	//rotate the model bone with rift rotation

	public Transform cameraObject;
	public bool rotateFromBehind;
	
	public Transform headBone;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void LateUpdate()
	{
		if (rotateFromBehind) {
			headBone.rotation = cameraObject.rotation * Quaternion.Euler (0, 0, -90);
				} else {
			headBone.rotation = cameraObject.rotation * Quaternion.Euler (-180, 0, 90);
				}
	}
}
