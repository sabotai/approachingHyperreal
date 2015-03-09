using UnityEngine;
using System.Collections;

public class scaleMaterialTiling : MonoBehaviour {

	public Renderer rend;

	// Use this for initialization
	void Start () {
		rend = GetComponent<Renderer> ();
	}
	
	// Update is called once per frame
	void Update () {
		float scaleY = Mathf.Cos (Time.time/50f) * 200f + 200f;
		rend.material.mainTextureScale = new Vector2 (1f, scaleY);
	
	}
}


