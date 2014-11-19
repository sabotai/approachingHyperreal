using UnityEngine;
using System.Collections;

public class CameraFly2 : MonoBehaviour {
	public float speed = 10.0F;
	public float rotationSpeed = 100.0F;
	public bool canMove = false;
	/*
	public GameObject water;
	private Material mat;
	
	float bumpiness, reflection, distortion, spd, alpha;
	Color color;
	
	void Awake() {
		mat = water.renderer.sharedMaterial;
		bumpiness = mat.GetFloat("_Bumpiness") * 10f;
		reflection = mat.GetFloat("_Amount") * 10f;
		distortion = mat.GetFloat("_Distortion") * 10f;
		spd = mat.GetFloat("_Speed") * 100;
		color = mat.GetColor("_Color");
		alpha = color.a * 10;
	}
	
	void OnGUI() {
		GUILayout.BeginArea (new Rect (0, 0, 300, 300));
		GUILayout.Label("Use WASD/Mouse to move, Q to take control");

		GUILayout.Label("Alpha Slider");
		alpha = GUILayout.HorizontalSlider(alpha, 0.0f, 10.0f);

		GUILayout.Label("Bumpiness Slider");
		bumpiness = GUILayout.HorizontalSlider(bumpiness, 0.0f, 10.0f);
		
		GUILayout.Label("Reflection/Refraction Slider");
		reflection = GUILayout.HorizontalSlider(reflection, 0.0f, 10.0f);
		
		GUILayout.Label("Refraction Slider");
		distortion = GUILayout.HorizontalSlider(distortion, 0.0f, 10.0f);
		
		GUILayout.Label("Speed Slider");
		spd = GUILayout.HorizontalSlider(spd, 0.0f, 10.0f);
		GUILayout.EndArea ();
		
		mat.SetColor("_Color", new Color(color.r, color.g, color.b, alpha/10f));
		mat.SetFloat("_Bumpiness", bumpiness/10f);
		mat.SetFloat("_Amount", reflection/10f);
		mat.SetFloat("_Distortion", distortion/10f);
		mat.SetFloat("_Speed", spd/100f);
	}
*/

	void OnGUI() {
		GUILayout.Label("Use WASD/Mouse to move, Q to take control");
	}
	void Update() {
		if (Input.GetKeyDown("q")) canMove = !canMove;
		if (canMove) {
			float z = Input.GetAxis("Vertical") * speed * Time.deltaTime;
			float x = Input.GetAxis("Horizontal") * speed * Time.deltaTime;
			float ry = Input.GetAxis("Mouse X") * rotationSpeed * Time.deltaTime;
			float rx = Input.GetAxis("Mouse Y") * rotationSpeed * Time.deltaTime;
			transform.Translate(x, 0, z);
			transform.Rotate(-rx, 0, 0);
			transform.Rotate(0, ry, 0, Space.World);
		}
	}
}