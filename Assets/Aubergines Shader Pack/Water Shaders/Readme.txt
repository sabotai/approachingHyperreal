v1.0
Initial release.

HOW TO USE:
Just check the example scenes on how to use individual shaders.

A few notes;
*Cube reflection shaders do as the name implies, reflects and refracts a cubemap.
Which can be a skybox or a custom cube map of an individual part of your scene.
(Unity pro provides ways to create cubemaps, but Unity free also can create them,
with some coding skills. There are scripts that do this on the forums, so i wont provide it.)
NOTE: A good usage of cubemaps is rendering several of them scattered on your scene,
and blending between cubemaps according to players position.

*Realtime reflection shaders require Unity PRO licence, and these shaders are meant
for fast hardware, like new smart phones with fast cores and graphics, tablets and 
desktops with fast graphics cards.

*Refraction property is the most important variable, it does calculate;
the waters color, deep color, reflection and refraction amount.
(Refraction is basically how clear the water is.

*Color variable is best used with darker values.

*Mask;
-with refraction value it only defines the transparency of the shores.
-without refraction, mask is the refraction value itself, it defines the deep water
and shallow water colors.
(in a future update, if there will be a demand i can put combination of the above two)

*Flow maps are special maps that each pixel shows a direction vector rather than a color.
(There are resources on the internet on how to create these kind of maps,
also in a future update i may or (may not) provide a custom flow map creator.)
One good flow map generator (which i also use) can be found here:
http://teckartist.com/?page_id=107

*If you want to write your own flow map creator for your specific needs,
the basic idea is:
1-Create a texture
2-Save initial mouse click position on the texture
3-Save the mouse movement direction as a vector (unity also provides code for this in Editor class)
4-Set those pixels with this vectors normalized value.(Flow map only cares about x,y directions)
thats it.


KNOWN ISSUES:
*The shaders with the "Fast" tag, are heavier in aritmethic instructions for Unity
Shaderlab, but indeed after compilation, they have less instructions and are faster.
Unfortunately, I cant do anything about it.
*Cubemap reflections must have a flat water plane. That means you cant do Vertical
water with them.
*Flow shaders will only be visible after you play the scene once in editor.

Support:
For any questions, you can contact me from aubergine2010@gmail.com.
Web: http://www.tamer.co

Thanks for buying the package.