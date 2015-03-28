using UnityEngine;
using System.Collections;

public class InstantiateRandom : MonoBehaviour {
	
	public GameObject instantiationObj;
	public bool createNew = false;

	public float radius = 5f;
	private Transform ovrPlayer;
	private int count = 0; //which one in the current series
	public int howMany = 0; //total number of kinect skeletons
	private Transform previous;

	public float meanPoint0 = 0.1f;
	public float meanPoint1 = 1.0f;
	public float pointBalance = 0.8f;
	public float standardDeviation = 0.1f;
	
	// Use this for initialization
	void Start () {
		ovrPlayer = GameObject.Find ("OVRPlayerController").transform;
	}
	
	// Update is called once per frame
	void Update () {
		if (howMany > count){
			//create a new series if you find a new skeleton
			createNew = true;
			//count++;
		}
		
		
		if (createNew) {
			
			for(int i = 0; i < howMany; i++){
				create ();
				count++;
			}
			createNew = false;
		}
	}
	
	Vector3 findPos(float whichOne){
		Vector3 pos = Random.insideUnitSphere * radius + ovrPlayer.transform.position;
		return pos;
	}
	
	Quaternion findRot(Vector3 playerPos, Vector3 otherPos){
		Vector3 relativePos = playerPos - otherPos;
		Quaternion rotation = Quaternion.LookRotation(relativePos);
		
		return rotation;
	}
	
	void create(){
		GameObject echo;
		Vector3 Pos = findPos (count);
		Quaternion Rot = findRot (ovrPlayer.localPosition, Pos);
		echo = Instantiate (instantiationObj, Pos, Rot) as GameObject;
		
		float multi = multiNorm (meanPoint0, meanPoint1, pointBalance, standardDeviation);
		Debug.Log (multi);
		echo.transform.localScale = instantiationObj.transform.lossyScale * multi;
		echo.transform.LookAt(previous);

		previous = echo.transform;
	}

	float multiNorm(float mean0, float mean1, float balance, float stdDev){
		float which = Random.value;
		float useMean;
		if (which <= balance){
			useMean = mean0;
			Debug.Log ("use mean 0");
		} else {
			useMean = mean1;
			Debug.Log ("use mean 1");
		}
		return distNormal (useMean, stdDev);
		            
	}

	float distNormal(float mean, float stdDev){
		//Random rand = new Random(); //reuse this if you are generating many
		float u1 = Random.value; //these are uniform(0,1) random doubles
		float u2 = Random.value;
		float randStdNormal = Mathf.Sqrt(-2.0f * Mathf.Log(u1)) 	* 	Mathf.Sin(2.0f * Mathf.PI * u2); //random normal(0,1)
		//Debug.Log ("randstdnormal is " + randStdNormal);
		float randNormal = mean + stdDev * randStdNormal; //random normal(mean,stdDev^2)
		return randNormal;
	}
}
