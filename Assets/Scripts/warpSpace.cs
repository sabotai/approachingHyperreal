using UnityEngine;
using System.Collections;

public class warpSpace : MonoBehaviour {
	
	private float playerShiftX, playerShiftY, playerShiftZ;
	private float originalX, originalY, originalZ;
	public GameObject player, targetObject;
	// Use this for initialization

	//This script compares the starting position of the player and uses their movement to close in the space,
	//forcing them to move forward.


	void Start () {
		playerShiftX = player.transform.localPosition.x;
		playerShiftY = player.transform.localPosition.y;
		playerShiftZ = player.transform.localPosition.z;
		Debug.Log ("(x,y,z original = (" + playerShiftX + "," + playerShiftY + "," + playerShiftZ + ")");
	}

	void Update() {
	}

	// FixedUpdate is called __ seconds
	void FixedUpdate () {
		
		playerShiftX = player.transform.localPosition.x - playerShiftX;
		playerShiftY = player.transform.localPosition.y - playerShiftY;
		playerShiftZ = player.transform.localPosition.z - playerShiftZ;
		
		//Debug.Log ("(x,y,z difference = (" + playerShiftX + "," + playerShiftY + "," + playerShiftZ + ")");
		Vector3 position = new Vector3 (playerShiftX, playerShiftY, playerShiftZ);
		/*
		if ((position > new Vector3(0.2,0.2,0.2)) && (position < new Vector3(0.2,0.2,0.2)){
			targetObject.transform.localPosition =  + targetObject.transform.localPosition;
		}
*/
	}
}
