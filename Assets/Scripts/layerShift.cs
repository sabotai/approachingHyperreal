using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class layerShift : MonoBehaviour {


	public GameObject player;
	public GameObject portal;
	public GameObject destination;
	public float threshold;
	private int numLayers;
	private bool shiftUp;
	public bool latShift;

	public GameObject layerTemplate;
	public GameObject originalRoom;
	public GameObject[] layers;
	List<GameObject> layerList;
	public bool initialJump;


	// Use this for initialization
	void Start () {
		layerList =  new List<GameObject>();
		shiftUp = false;
		numLayers = 1;



		
		/*
		for (int i = 0; i < numLayers; i ++) {
			GameObject newLayer = Instantiate (layerTemplate, new Vector3(layerTemplate.transform.position.x, yPos, layerTemplate.transform.position.z), layerTemplate.transform.rotation) as GameObject;
			layerList.Add (newLayer);
			Instantiate (fishBlueprint, Random.insideUnitSphere * 10f, Random.rotation); //
		}
		*/
	}
	
	// Update is called once per frame
	void Update () {

		if (shiftUp) {
			if (!initialJump){
				numLayers++;
				GameObject newLayer;
				float yPos = 2 * layerTemplate.transform.localPosition.y - originalRoom.transform.position.y;

				newLayer = Instantiate (layerTemplate, new Vector3(layerTemplate.transform.position.x, yPos, layerTemplate.transform.position.z), layerTemplate.transform.rotation) as GameObject;
				
				newLayer.name = "layer" + numLayers;
				GameObject tempGO = GameObject.Find ("layer"+numLayers);
				string tempString = "layer" + numLayers;
				tempString += "/physical spawn 0";
				destination = GameObject.Find (tempString);//layerList[layerList.Count-1];//GameObject.Find(layerList.length());
				//numLayers++;
				layerList.Add (newLayer);
				//layerList.length()
			}
			
			player.transform.position = destination.transform.position;

			shiftUp = false;		
		}

		
		if (Vector3.Distance(player.transform.position,portal.transform.position) < threshold) {
			if (latShift){
				player.transform.position = destination.transform.position;
			} else {

			shiftUp = true;
			}
		}


	}
}
