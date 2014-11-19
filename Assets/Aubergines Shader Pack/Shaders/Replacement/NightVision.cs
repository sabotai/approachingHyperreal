using UnityEngine;
using System.Collections;

public class NightVision : MonoBehaviour {
	//Public Variables//
	public Color visionColor = Color.green;
	//Private Variables//
	private Shader shader;
	private bool button;

	//Mono Methods//
	void Awake () {
		//Set the appropriate replacement shader
		shader = Shader.Find("Aubergine/Replacement/NightVision");
		//Set vision color
		Shader.SetGlobalColor("_VisionColor", visionColor);
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