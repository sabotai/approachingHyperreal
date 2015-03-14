using UnityEngine;
using System.Collections;

public class hideOVRWarning : MonoBehaviour {

	//this script will change the scale of the OVR warning to 0, so it is no longer seen
	//the script execution order should be last, to give time for instantiation of the OVRGuiObjectMain
	private bool search = true;

	// Use this for initialization
	void Awake () {
	}
	
	// Update is called once per frame
	void Update () {
		if (search){
			GameObject GuiInstance = GameObject.Find ("OVRGuiObjectMain(Clone)");
			if (GuiInstance != null){
				GuiInstance.transform.localScale = new Vector3(0f,0f,0f);
				Debug.Log ("gui found");
				search = false;
			}
		}
	}
}
