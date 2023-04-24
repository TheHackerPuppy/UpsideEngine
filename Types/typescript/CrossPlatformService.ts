export type CrossPlatformService = {
DefaultControllersEnabled: boolean
SideView: boolean
Character: Character
StickSensibility: number
Configs: 	{
 Keyboard: 	{
 W: string,
A: string,
S: string,
D: string,
Up: string,
Left: string,
Down: string,
Right: string,
Space: string,
	},
Gamepad: 	{
 ButtonA: string,
Thumbstick1: 	{
 Up: string,
Left: string,
Down: string,
Right: string,
	},
	},
Mobile: 	{
 JumpButton: string,
Thumbstick1: 	{
 Up: string,
Left: string,
Down: string,
Right: string,
	},
	},
	},
SetDeviceKey(self: CrossPlatformService, device: string, key: string, action: string): null
SetDeviceConfig(self: CrossPlatformService, device: string, controls: Dictionary<string, string?>): null
SetPlayerCharacter(self: CrossPlatformService, character: Character): null
}


module.exports = {}