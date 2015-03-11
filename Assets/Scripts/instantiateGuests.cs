using UnityEngine;
using System.Collections;

public class instantiateGuests : MonoBehaviour {

	public GameObject instantiationObj;
	public bool createNew = false;

	public float radius = 1f;
	public float circumDensity = 5f;
	public float radianSpreadMultiplier = 0.1f;
	private Transform ovrPlayer;
	private int count = 0; //which one in the current series
	private int kCount = 0; //total number of kinect skeletons
	private GameObject kinectObj;

	// Use this for initialization
	void Start () {
		ovrPlayer = GameObject.Find ("OVRPlayerController").transform;
		kinectObj = GameObject.Find ("KinectPrefab");
	}
	
	// Update is called once per frame
	void Update () {
		if (kinectObj.GetComponent<SkeletonWrapper>().trackedCount > kCount){
			//create a new series if you find a new skeleton
			createNew = true;
			kCount++;
		}


		if (createNew) {

			for(int i = 0; i < circumDensity; i++){
				create ();
				count++;
			}
			createNew = false;
		}
	}

	Vector3 findPos(float whichOne){
		//angle rad in radians and a circle's center (h,k), you can calculate the coordinates of a point on the circumference as follows 

		float rad = ((whichOne/circumDensity) * (4* Mathf.PI)) - 2 * Mathf.PI;
		rad = rad + (rad * radianSpreadMultiplier);

		float h = ovrPlayer.localPosition.x;
		float k = ovrPlayer.localPosition.z;

		float newRadius = radius + ((count / circumDensity) * radius);
		float x = newRadius*Mathf.Cos(rad) + h;
		float z = newRadius*Mathf.Sin(rad) + k;

		Vector3 pos = new Vector3 (x, ovrPlayer.localPosition.y, z);
		return pos;
	}

	Quaternion findRot(Vector3 playerPos, Vector3 otherPos){
		Vector3 relativePos = playerPos - otherPos;
		Quaternion rotation = Quaternion.LookRotation(relativePos);

		return rotation;
	}

	void create(){
		GameObject kinectParticipant;
		Vector3 Pos = findPos (count);
		Quaternion Rot = findRot (ovrPlayer.localPosition, Pos);
		kinectParticipant = Instantiate (instantiationObj, Pos, Rot) as GameObject;
		kinectParticipant.transform.localScale = instantiationObj.transform.lossyScale;
	}
}
