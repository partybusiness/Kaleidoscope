# Kaleidoscope
Kaleidoscope shaders and scripts for use in Unity

KaleidoscopeInstanced.shader works with the KaleidoscopeRenderer.cs script. The script will call DrawMeshInstanced and pass an array of 8 values to make it render each reflection. Maybe if you want to have them appear one by one, you would make a variant on this script that changes the number of meshes while making the group appear and disappear.

Kaleidoscop.shader skips the trouble of being called eight times and instead contains eight passes that. This means you don't need any script and can attach it directly as a mesh renderer.

Both of these two assume you're reflecting around the same axis.

So the AimableKaleidoscope.shader allows you to change the position and orientation of the axis around which the kaleidoscope is reflected.

AimKaleidoscope.cs will automatically change the position and orientation of an AimableKaleidoscope material based on whatever transform it is attached to.
