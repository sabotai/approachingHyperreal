using UnityEngine;
using System.Collections;

public class moveObject : MonoBehaviour {

	public bool activate = false;
	public GameObject destinationObject;
	
	private Vector3 velo;
	public float speed;
	public float arrivalThreshold = 1.25f;
	public bool arrivalCheck = false;
	public bool rotate = false;

	// Use this for initialization
	void Start () {
		//place this script on the object that should move
		
	}
	
	// Update is called once per frame
	void Update () {

				if (activate) {
						Vector3 target = destinationObject.transform.position;
		
						Vector3 moveDirection = target - transform.position;


						////////
						if (moveDirection.magnitude > arrivalThreshold) {

								velo = moveDirection.normalized * (speed * -1);

						} else {
								velo = rigidbody.velocity;
								arrivalCheck = true; //let other scripts know that the object has arrived

						}

						rigidbody.velocity = velo;
				} else {
					arrivalCheck = false; //reset arrival check
					rigidbody.velocity = new Vector3(0,0,0); //zero out the objects velocity when not on
				}
				
				if (rotate) {


				}

		}
	
}