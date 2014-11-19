using UnityEngine;
using System.Collections;

public class Holographic_v1 : MonoBehaviour {
	//Public Variables//
	public Texture holoTex;
	//Private Variables//
	private Shader shader;
	private bool button;

	//Mono Methods//
	void Awake () {
		//Set the appropriate replacement shader
		shader = Shader.Find("Aubergine/Replacement/Holographic_v1");
		//Set Holographic texture
		Shader.SetGlobalTexture("_HoloTex", holoTex);
	}
	
	void Update () {
		if (Input.GetKeyDown("space")) {
			button = !button;
			if (button) {
				transform.camera.SetReplacementShader(shader, null);
			}
			else
				transform.camera.ResetReplacementShader();
		}
	}
}