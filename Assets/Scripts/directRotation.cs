﻿using UnityEngine;
using System.Collections;

public class directRotation : MonoBehaviour {

	//rotate the model bone with rift rotation

	public Transform cameraObject;
	public bool rotateFromBehind;
	public int rotationX = -180;
	public int rotationY = 0;
	public int rotationZ = 90;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void LateUpdate()
	{
		if (rotateFromBehind) {
			//just rotate right if the transform is facing the same direction as the cameraObject
			transform.rotation = cameraObject.rotation * Quaternion.Euler (0, 0, -90);
		} else {
			//invert the cameraObject rotation so it isnt inverted and then rotate the object around
			transform.rotation = Quaternion.Inverse(cameraObject.rotation)* Quaternion.Euler (rotationX, rotationY, rotationZ);
		}
	}
}
