using UnityEngine;
using System.Collections;


[AddComponentMenu("Rendering/SetRenderQueueWithChildren")]

public class SetRenderQueueWithChildren : MonoBehaviour {

	 
	public int queuePosition = 3000;
		[SerializeField]
		protected int[] m_queues = new int[]{3000};
		
		protected void Awake() {

		/*
			Material[] materials = renderer.materials;
			for (int i = 0; i < materials.Length && i < m_queues.Length; ++i) {
				materials[i].renderQueue = m_queues[i];
			}
		*/
		
		Renderer[] rendererz = gameObject.GetComponentsInChildren<Renderer>();
		foreach (Renderer rend in rendererz) {
			for (int i = 0; i < rend.materials.Length && i < m_queues.Length; ++i) {
				rend.materials[i].renderQueue = m_queues[i];
			}
			}
		}
}