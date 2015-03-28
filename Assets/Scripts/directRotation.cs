using UnityEngine;
using System.Collections;

public class directRotation : MonoBehaviour {

	//rotate the model bone with rift rotation

	public Transform cameraObject;
	public bool rotateFromBehind, lockXZ;
	public int rotationX = -180;
	public int rotationY = 0;
	public int rotationZ = 90;

	public Animator animController;
	private bool go;

	// Use this for initialization
	void Start () {
		if (animController != null){
			go = false;
		} else {
			go = true;
		}
	}

	void LateUpdate()
	{
		if (animController != null){
			if (animController.GetInteger("MovementState") != 0){
				go = false;
			} else {
				go = true;
			}

		}


		if (go){
			if (lockXZ){
				Quaternion temp;
				if (rotateFromBehind){
					temp = cameraObject.rotation * Quaternion.Euler (0, 0, -90);
				}	else {
					temp = cameraObject.rotation * Quaternion.Euler (rotationX , rotationY, rotationZ );
			}

				transform.localRotation = Quaternion.Euler (transform.eulerAngles.x, temp.eulerAngles.y, transform.eulerAngles.z);
			} else {

				if (rotateFromBehind) {
					//just rotate right if the transform is facing the same direction as the cameraObject
					transform.rotation = cameraObject.rotation * Quaternion.Euler (0, 0, -90);
				} else {
					//invert the cameraObject rotation so it isnt inverted and then rotate the object around
					transform.rotation = Quaternion.Inverse(cameraObject.rotation)* Quaternion.Euler (rotationX, rotationY, rotationZ);
				}
			}
		}
	}
		

	float ClampAngle(float angle,float min, float max){
		
		if (angle<90 || angle>270){       // if angle in the critic region...
			if (angle>180){ angle -= 360;}  // convert all angles to -180..+180
			if (max>180){ max -= 360;}
			if (min>180){ min -= 360;}
		}    
		angle = Mathf.Clamp(angle, min, max);
		if (angle<0) {
			angle += 360;  // if angle negative, convert to 0..360
		}
		return angle;
	}
}
