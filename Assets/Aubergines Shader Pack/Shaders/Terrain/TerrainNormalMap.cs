using UnityEngine;
using System.Collections;

[AddComponentMenu("Aubergine/Terrain/TerrainNormalMap")]
public class TerrainNormalMap : MonoBehaviour {
	
	public Texture2D[] bumpMaps;
	public Color specularColor = Color.grey;
	public float[] specularPowers;
	
	void Awake () {
		Terrain terrain = (Terrain)GetComponent(typeof(Terrain));
		int splatCount = terrain.terrainData.alphamapLayers;

		//Variables
		for (int i = 0; i < splatCount; i++) {
			string tileX = "_TileScaleX"+i.ToString();
			string tileZ = "_TileScaleZ"+i.ToString();
			Shader.SetGlobalFloat(tileX,  terrain.terrainData.size.x / terrain.terrainData.splatPrototypes[i].tileSize.x);
			Shader.SetGlobalFloat(tileZ,  terrain.terrainData.size.z / terrain.terrainData.splatPrototypes[i].tileSize.y);
			Debug.Log(terrain.terrainData.splatPrototypes[i].tileSize.x);
		}
		//Bumpmaps
		for (int i = 0; i < bumpMaps.Length; i++) {
			if (bumpMaps[i] != null) {
				string bump = "_Bump"+i.ToString();
				Shader.SetGlobalTexture(bump, bumpMaps[i]);
			}
		}
		//Speculars
		for (int i = 0; i < specularPowers.Length; i++) {
			string spec = "_SpecPow"+i.ToString();
			Shader.SetGlobalFloat(spec, specularPowers[i]);
		}
		//Specular Color
		Shader.SetGlobalColor("_SpecColTerrain", specularColor);

	}
}