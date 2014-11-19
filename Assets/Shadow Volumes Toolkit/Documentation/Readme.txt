# Shadow Volumes Toolkit
# Copyright 2012 Gustav Olsson

# Good to know

- All the script properties have inspector tooltips

- To perfectly align a shadow game object to it's parent, click the little cog of the Transform component and select Reset

- For better performance, set your ShadowVolumes to be simple if you know that the camera will never be inside a volume (For example in games with a top-down/side view or a constrained camera)

- For better performance, use the Standard compatibility mode

- If you're targeting platforms that don't reliably support the BlendOp shader function (such as the Android platform), use the NoBlendOp compatibility mode

- If you're targeting mobile platforms, make sure to enable a 32bit display buffer in the build settings

# Scene setup

1. Click on the menu item Window > Shadow Mesh Creator to open up the mesh creator dialog. Select a reference mesh and click on the "Create Shadow Mesh" button to create a shadow mesh asset.

2. Drag & drop the ShadowVolumeRenderer script onto an empty game object (preferably called "Shadow Renderer")

3. Drag & drop the ShadowVolumeSource script onto a light game object

4. For each shadow caster - create an empty game object (preferably called "Shadow") and put it as a child to the shadow caster. Drag & drop the ShadowVolume script onto the child object. Choose which shadow mesh the child object's MeshFilter should use.

See the Basic example scene

5. For each skinned shadow caster - create an empty game object and put the shadow caster object as a child to it. Duplicate the shadow caster (so that it's also a child of the empty game object) and rename it to something useful (preferably "Shadow"). Go through the object tree of the duplicate and do the following:

a) Remove the Animation component
b) Drag & drop the SkinnedShadowVolume script onto the game object with the SkinnedMeshRenderer component
c) Choose which shadow mesh the SkinnedMeshRenderer should use
d) Drag & drop the MimicSkinnedMeshRenderer script onto the game object with the SkinnedMeshRenderer and select the shadow caster's SkinnedMeshRenderer as Reference

See the Animation example scene