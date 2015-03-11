using UnityEngine;
using System.Collections;

public class scaleMaterialTiling : MonoBehaviour {

	public Renderer rend;
	public int tilingMax;
	public int tilingMin;
	public bool tileX, tileY;
	private float myTime;
	public float timeModulator = 1f;

	// Use this for initialization
	void Start () {
		rend = GetComponent<Renderer> ();
	}
	
	// Update is called once per frame
	void Update () {
		float scaleY = Mathf.Cos (Time.time/50f) * 200f + 200f;

		float modTime = Time.time;// % timeModulator;//Mathf.Sin (Time.time/20f);
		myTime = Time.time * Time.time * (3f - 2f * Time.time);
		myTime = modTime * modTime * modTime * (modTime * (6f*modTime - 15f)+10f);
		//if (tileX && !tileY){
		//rend.material.mainTextureScale = new Vector2 (1f, Mathf.Lerp (tilingMin, tilingMax, Time.time * timeModulator));

		rend.material.mainTextureScale = new Vector2 (1f, Mathf.PingPong (myTime * timeModulator, tilingMax));
		//}
		if (tileY && !tileX){

			}
			                                            
	}
}


