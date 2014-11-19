using UnityEngine;
using System.Collections;

public class ForceFieldDemoScript : MonoBehaviour {

	float[] collTime = new float[4];
	Vector3 collPos;
	public float shieldPower = 1f; //This should be between 0.0 and 1.0
	int index = 0;

	// Use this for initialization
	void Start () {
		collTime[0] = 0f;
		collTime[1] = 0f;
		collTime[2] = 0f;
		collTime[3] = 0f;
		renderer.material.SetFloat("_CollisionTime0", collTime[0]);
		renderer.material.SetFloat("_CollisionTime1", collTime[1]);
		renderer.material.SetFloat("_CollisionTime2", collTime[2]);
		renderer.material.SetFloat("_CollisionTime3", collTime[3]);
		//Init with some ridiculous collision position
		renderer.material.SetVector("_CollisionPos0", transform.InverseTransformPoint(transform.forward * 10));
		renderer.material.SetVector("_CollisionPos1", transform.InverseTransformPoint(transform.forward * 10));
		renderer.material.SetVector("_CollisionPos2", transform.InverseTransformPoint(transform.forward * 10));
		renderer.material.SetVector("_CollisionPos3", transform.InverseTransformPoint(transform.forward * 10));
		
	}
	
	// Update is called once per frame
	void Update () {
		//Simple hit function using mouse clicks, you would want to change this into gun fire hit
		if (Input.GetButtonDown("Fire1")) {
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			RaycastHit hit;
			if (Physics.Raycast(ray, out hit)) {
				if (hit.transform == this.transform) {
					shieldPower -= 0.05f; //How you decrease the shields
					if (shieldPower < 0f)
						shieldPower = 0f; //Shields down
					collTime[index] = shieldPower;
					if (index == 0)
						renderer.material.SetVector("_CollisionPos0", transform.InverseTransformPoint(hit.point));
					if (index == 1)
						renderer.material.SetVector("_CollisionPos1", transform.InverseTransformPoint(hit.point));
					if (index == 2)
						renderer.material.SetVector("_CollisionPos2", transform.InverseTransformPoint(hit.point));
					if (index == 3)
						renderer.material.SetVector("_CollisionPos3", transform.InverseTransformPoint(hit.point));

					index++;
					if (index > 3)
						index = 0;
				}
			}
		}

		//The below statements are unnecessary if shieldPower is below 0
		//You can put an if check or leave it as is.
		if (collTime[0] >= 0f) {
			collTime[0] -= Time.deltaTime * shieldPower;
			renderer.material.SetFloat("_CollisionTime0", collTime[0]);
		}
		if (collTime[1] >= 0f) {
			collTime[1] -= Time.deltaTime * shieldPower;
			renderer.material.SetFloat("_CollisionTime1", collTime[1]);
		}
		if (collTime[2] >= 0f) {
			collTime[2] -= Time.deltaTime * shieldPower;
			renderer.material.SetFloat("_CollisionTime2", collTime[2]);
		}
		if (collTime[3] >= 0f) {
			collTime[3] -= Time.deltaTime * shieldPower;
			renderer.material.SetFloat("_CollisionTime3", collTime[3]);
		}
	}
}