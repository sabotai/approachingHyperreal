using UnityEngine;
using System.Collections;

public class SobelEdge03 : MonoBehaviour {
	//Private Variables//
	private Shader shader;
	private bool button;

	//Mono Methods//
	void Awake () {
		//Set the appropriate replacement shader
		shader = Shader.Find("Aubergine/Replacement/SobelEdge03");
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