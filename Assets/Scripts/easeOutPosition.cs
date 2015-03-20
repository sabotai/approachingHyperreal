using UnityEngine;
using System.Collections;

public class easeOutPosition : MonoBehaviour {

	public Transform target;
	public float tripTime = 5f;
	public float easeAmt = 0.5f; //going over 1f will make it go back to where it began
	private float currentLerpTime;
	private Vector3 startPos;
	private bool done = false;

	// Use this for initialization
	void Start () {
		startPos = transform.position;
		currentLerpTime = Time.time;
		
	}
	
	// Update is called once per frame
	void Update () {
		if (!done){
			currentLerpTime += Time.deltaTime;
			if (currentLerpTime > tripTime) {
				currentLerpTime = tripTime;
			}

			float t = currentLerpTime / tripTime;
			t = Mathf.Sin(t * Mathf.PI * easeAmt);

			
			//float perc = currentLerpTime / tripTime;
			transform.position = Vector3.Lerp(startPos, target.position, t);
			if (t == 1f){
				done = true;
			}
		}
	}
}
