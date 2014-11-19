using UnityEngine;
using System.Collections;

public class Flow : MonoBehaviour {

	public float FlowSpeed = .05f;
	public float Cycle = .5f;
	private float HalfCycle = .25f;
	private float FlowMapOffset0, FlowMapOffset1;

	// Use this for initialization
	void Awake () {
		HalfCycle = Cycle * 0.5f;
		FlowMapOffset0 = 0.0f;
		FlowMapOffset1 = HalfCycle;
		renderer.sharedMaterial.SetFloat("_HalfCycle", HalfCycle);
		renderer.sharedMaterial.SetFloat("_FlowOffset0", FlowMapOffset0);
		renderer.sharedMaterial.SetFloat("_FlowOffset1", FlowMapOffset1);
	}
	
	// Update is called once per frame
	void Update () {
		FlowMapOffset0 += FlowSpeed * Time.deltaTime;
		FlowMapOffset1 += FlowSpeed * Time.deltaTime;
		if (FlowMapOffset0 >= Cycle)
			FlowMapOffset0 = 0.0f;

		if (FlowMapOffset1 >= Cycle)
			FlowMapOffset1 = 0.0f;
		
		renderer.sharedMaterial.SetFloat("_FlowOffset0", FlowMapOffset0);
		renderer.sharedMaterial.SetFloat("_FlowOffset1", FlowMapOffset1);
	}
}