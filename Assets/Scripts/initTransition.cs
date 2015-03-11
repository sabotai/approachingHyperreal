using UnityEngine;
using System.Collections;

public class initTransition : MonoBehaviour {

	public bool transition = false;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if (transition) {
			
			
			AutoFade.LoadLevel("1208" ,3,1,Color.black);
			transition = false;
						//initTrans();
				}
		}


	void initTrans(){
		transition = false;
		StartCoroutine (waiting());
	}


	IEnumerator waiting(){
		Debug.Log ("waiting function");

		yield return new WaitForSeconds(3f);
		//putItHere.animation.Stop ("box");
		//Application.LoadLevel ("scene1a");
	}

}
