# [Extended from BaseObject](BaseObject.md) Scene 
This class is useful to have a workspace and manage your project more easily
	 
# Properties

## [Camera](Camera.md) Camera
The scene camera
		
## [LightingEnvironment](LightingEnvironment.md) LightingEnvironment
This is the LightingEnvironment of the scene

## [ParticleEnvironment](ParticleEnvironment.md) ParticleEnvironment
This is the ParticleEnvironment of the scene
		
## [SoundEnvironment](SoundEnvironment.md) SoundEnvironment
This is the SoundEnvironment of the scene
		
## [ObjectEnvironment](ObjectEnvironment.md) Objects
This environment stores all the objects in the scene
		


# Methods

## [Scene](Scene.md) Constructor() 
 
## [void](https://create.roblox.com/docs/scripting/luau/tables#arrays) Enable() 
 Enables the scene, which will make it process physics, lights, sounds and sprites
	
## [void](https://create.roblox.com/docs/scripting/luau/tables#arrays) Disable() 
 Disables the scene
	
## [Array<string>](https://create.roblox.com/docs/scripting/luau/tables#arrays) GetTaggedObjects(`tag: string`) 
 Gets all the objects with the provided tags in the scene
	
## [Raycast2dResult](/documentation/datatypes/Raycast2DResult.html) Raycast(`info: Raycast2dParams`) 
 Casts a ray using the Raycast2dParams. If it finds an elegible object a Raycast2dResult is returned containing the results of the operations
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|


