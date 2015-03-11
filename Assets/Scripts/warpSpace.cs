using UnityEngine;
using System.Collections;

public class warpSpace : MonoBehaviour {
	
	private float playerShiftX, playerShiftY, playerShiftZ;
	private float originalX, originalY, originalZ;
	public GameObject player, targetObject;
	public bool changeScale = false;
	public bool changePosition = false;
	public bool changeRotation = false;
	private Vector3 targetOriginalScale; 
	public float positionMultiplier = 2000f;
	public float scaleMultiplier = 0.05f;
	public float rotationMultiplier = .025f;
	public float clampAmount = 350f;
	// Use this for initialization

	//This script compares the starting position of the player and uses their movement to close in the space,
	//forcing them to move forward.


	void Start () {
		playerShiftX = player.transform.localPosition.x;
		playerShiftY = player.transform.localPosition.y;
		playerShiftZ = player.transform.localPosition.z;
		originalX = playerShiftX;
		originalY = playerShiftY;
		originalZ = playerShiftZ;
		Debug.Log ("(x,y,z original = (" + playerShiftX + "," + playerShiftY + "," + playerShiftZ + ")");

		targetOriginalScale = targetObject.transform.localScale;
	}

	// FixedUpdate is called __ seconds
	void Update () {
		
		playerShiftX = player.transform.localPosition.x - originalX;
		playerShiftY = player.transform.localPosition.y - originalY;
		playerShiftZ = player.transform.localPosition.z - originalZ;
		
		//Debug.Log ("(x,y,z difference = (" + playerShiftX + "," + playerShiftY + "," + playerShiftZ + ")");
		Vector3 position = new Vector3 (playerShiftX, playerShiftY, playerShiftZ);
		//position *= 50f;

		if (changePosition) {
						targetObject.transform.localPosition = (Vector3.ClampMagnitude (targetObject.transform.localPosition - (position * positionMultiplier), clampAmount*100f)); 
						//Debug.Log (targetObject.transform.localPosition);
				}//targetObject.transform.localScale = targetOriginalScale - position;

		//Vector3 newScale = new Vector3 (position.
		if (changeScale) {
			Vector3 shrinkScale = new Vector3 (Mathf.Abs (position.x), position.y, position.z); //left or right = always shrink
			targetObject.transform.localScale -= Vector3.ClampMagnitude (shrinkScale * scaleMultiplier, clampAmount); 
				}


		//targetObject.transform.localScale -= position * effectMultiplier; //this is crazy effect that is over too quickly

		//targetObject.transform.localScale = Vector3.ClampMagnitude(targetObject.transform.localScale - (position * effectMultiplier), 11f); //this is crazy effect that is over too quickly

		if (changeRotation){
			targetObject.transform.eulerAngles -= position * rotationMultiplier; //rotate a bit 
		}


	}
}
