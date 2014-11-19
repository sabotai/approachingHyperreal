using UnityEngine;
using System.Collections;

public class layerShift : MonoBehaviour {


	public GameObject player;
	public GameObject portal;
	public GameObject destination;
	public float threshold;
	private int numLayers;
	private bool shiftUp;
	public GameObject layerTemplate;
	public GameObject[] layers;

	// Use this for initialization
	void Start () {
		shiftUp = false;
		numLayers = 1;
	}
	
	// Update is called once per frame
	void Update () {

		if (Vector3.Distance(player.transform.position,portal.transform.position) < threshold) {
			player.transform.position = destination.transform.position;
		}

		if (shiftUp) {
			numLayers++;
			shiftUp = false;
				}


	}
}
