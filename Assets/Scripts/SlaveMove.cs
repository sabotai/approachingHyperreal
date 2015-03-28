using UnityEngine;
using System.Collections;

public class SlaveMove : MonoBehaviour {

	public Transform master;
	private Vector3 startLocation;
	private bool usingRigidBody = true;

	// Use this for initialization
	void Start () {
		startLocation = master.localPosition;
		Debug.Log("Master start location is : " + master.localPosition);

		if (rigidbody != null){
			usingRigidBody = true;
		} else {
			usingRigidBody = false;
		}
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		Vector3 move = master.localPosition - startLocation;
		//Debug.Log ("Move is " + move);

		if (usingRigidBody){
			rigidbody.MovePosition(transform.position + move * Time.deltaTime * 50f);
		} else {


			transform.localPosition += move;

		}

		startLocation = master.localPosition;
	}
}
