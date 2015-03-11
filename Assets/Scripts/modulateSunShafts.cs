using UnityEngine;
using System.Collections;

public class modulateSunShafts : MonoBehaviour {


	public GameObject[] cameraObject;// = new GameObject[howManyCameras];
	private float[] originalValue;// = new float[howManyCameras];
	public float[] speed;// = new GameObject[howManyCameras];

	// Use this for initialization
	void Start () {
		originalValue = new float[cameraObject.Length];
				for (int i = 0; i < cameraObject.Length; i++) {
						originalValue [i] = cameraObject [i].GetComponent<SunShafts> ().sunShaftIntensity;
				}
		}
	
	// Update is called once per frame
	void Update () {
		float localSpeed;

		for (int i = 0; i < cameraObject.Length; i++) {
			if (i > speed.Length){
				localSpeed = Mathf.PingPong (Time.time * speed[speed.Length-1], originalValue[i]);
			} else {
				localSpeed = Mathf.PingPong (Time.time * speed[i], originalValue[i]);
			}
					cameraObject[i].GetComponent<SunShafts> ().sunShaftIntensity = localSpeed;
				}
	}
}
