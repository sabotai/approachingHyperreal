v1.0
Initial release.
v1.1
Added new seperate shader to support 2 cubemaps.

HOW TO USE:
Just add a cube on your scene and add one of the included sample materials on it.
Please check the included textures to see how to make your own.
Also please examine the demoscene setup to see how things work.
Note:
Because of the random function to turn some lights on and off on your building.
It is impossible to fit all 4 sides of a cube to light connecting rooms correctly.
It will always fit 3 sides seamlessly but 4th side will look unaligned and static.
You may want to hide this side of the building with another.

HOW IT WORKS:
UV of the mesh is calculated in world space together with everything else.
Lighting of the interior cube map is calculated depending on its alpha value.
If your cube map doesnt include any alpha information, it will be fully lit.

KNOWN ISSUES:
1 side of a cube will always look unaligned and static. 
There is no possible cure for the above.

Support:
For any questions, you can contact me from aubergine2010@gmail.com.

Thanks for buying the package.