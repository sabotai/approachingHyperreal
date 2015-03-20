using UnityEngine;
using System.Collections;

public class TriggerSeek : MonoBehaviour {

	public Transform comeToMe;
	public Transform lookAtMe;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void FixedUpdate () {

		
		if (Input.GetKey(KeyCode.Space)){
			transform.position = Vector3.Lerp (transform.position, comeToMe.position, Time.deltaTime);
			transform.LookAt (lookAtMe);

			//make it face the other way
			transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x - 65f, transform.rotation.eulerAngles.y * -1f + 45f, transform.rotation.eulerAngles.z * -1f);
		}
	}


	void OnTriggerEnter(){

	}
}
