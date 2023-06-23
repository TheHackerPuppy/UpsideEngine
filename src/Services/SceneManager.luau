local upsideEngine = script.Parent.Parent
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)

local methods = {}

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function methods:Load(scene: Scene)
	local instance = scene.Instance :: Frame
	instance.Visible = true

	self.ActiveScenes[scene.Id] = scene
	self:Fire("SceneLoaded", scene)
end

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function methods:Unload(scene: Scene)
	local instance = scene.Instance :: Frame
	instance.Visible = false

	self.ActiveScenes[scene.Id] = nil
	self:Fire("SceneUnloaded", scene)
end

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function methods:FindByName(name: string): Scene?
	for _, scene in self.Scenes do
		if scene.Name == name then
			return scene
		end
	end

	return
end

--[[={
	@desc Loads the engine data stored in the "UpsideEngineDB" attribute of replicated storage, when it ends sets the attribute as an empty table
	@link void.link
}=]]

function methods:Get(Id: string): Scene
	return self.Scenes[Id]
end

--[[={
	@desc This class save and build the engine data
	@about
		@Scenes	This dictionary stores all the scenes
		@ActiveScenes This dictionary stores all the active scenes
	@events
		@SceneLoaded Params -> [Scene](Scene.md) 
		Fired when a scene is loaded
		@SceneUnloaded Params -> [Scene](Scene.md) 
		Fired when a scene is unloaded
}=]]

return eventEmitter:Extend(script.Name, {
	methods = methods,
	readonly = {
		Scenes = {},
		ActiveScenes = {},
	},
})