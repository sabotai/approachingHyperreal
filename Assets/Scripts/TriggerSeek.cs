using UnityEngine;
using System.Collections;

public class TriggerSeek : MonoBehaviour {

	public Transform comeToMe;
	public Transform lookAtMe;
	public bool activateSeek;
	public float transitionThreshold = 0.9999f;

	private Vector3 totalDistance;
	private GameObject faderObj;

	// Use this for initialization
	void Start () {
		totalDistance = comeToMe.position - transform.position;
		faderObj = GameObject.Find ("guiFader");
	}
	
	// Update is called once per frame
	void FixedUpdate () {

		
		if (Input.GetKey(KeyCode.Space) || activateSeek){
			//find the percentage to destination
			Vector3 temp = comeToMe.position - transform.position;
			float tempMag =  1f - temp.sqrMagnitude / totalDistance.sqrMagnitude;
			//Debug.Log ("difference is " + tempMag);

			transform.LookAt (lookAtMe);

			if (tempMag < transitionThreshold){
				transform.position = Vector3.Lerp (transform.position, comeToMe.position, Time.deltaTime);
			} else {
				//find the fadeout bool in the screenfadeinout script
				faderObj.GetComponent <ScreenFadeInOut>().fadeOut = true;

			}

		}
	}


}
