using UnityEngine;
using System.Collections;

public class Emboss : MonoBehaviour {
	//Private Variables//
	private Shader shader;
	private bool button;

	//Mono Methods//
	void Awake () {
		//Set the appropriate replacement shader
		shader = Shader.Find("Aubergine/Replacement/Emboss");
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