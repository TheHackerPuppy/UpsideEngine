local upsideEngine = script.Parent.Parent.Parent
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local getNormalAccess = require(upsideEngine.Private.Util).GetNormalAccess

local methods = {}
local constructor = {}

local function setProperty(obj, p, v)
	obj[p] = v
end

function constructor:Environment()
	self:On("Changed", function(property)
		if property ~= "Content" or self.Count ~= 0 then
			return
		end

		local count = 0
		for _ in self.Content do
			count += 1
		end

		self.Count = count
	end)
end

--[[={
	@desc Gets the object with the specified index
	@link any.link
}=]]

function methods:Get(index: string): any
	return self.Content[index]
end

--[[={
	@desc Adds an object with the specified index, if no parameter is specified it will use the next number of the count property as index
	@link any.link
}=]]

function methods:AddOne(value: any, index: string)
	assert(self.Content[index] == nil, "This value already exist!")
	if typeof(value) == "table" then
		value = getNormalAccess(value)
	end

	self.Count += 1
	self.Content[index or self.Count] = value
end

--[[={
	@desc Removes the object with the specified index
	@link void.link
}=]]

function methods:RemoveOne(index: string)
	assert(self.Content[index], "This value does not exist!")
	self.Content[index or self.Count] = nil
	self.Count -= 1
end

--[[={
	@desc Checks if the environment has a value with the specified index
	@link boolean.link
}=]]

function methods:HasOne(index: string): boolean
	return self.Content[index] ~= nil
end

--[[={
	@desc Checks if the environment contains every specified index and returns a boolean and a dictionary with boolean values, example:
	@tsreturns LuaTuple<[boolean, Dictionary<any, boolean>]>
	@link boolean.link
	```lua
	local hasAll, dictionary = treeEnv:Has({
		"Tree1",
		"Tree2",
		"Tree4"
	})

	print(hasAll, dictionary) -- output: false, { Tree1 = true, Tree2 = true, Tree4 = false }
	```
}=]]

function methods:Has(objects: Array<string>): (boolean, Dictionary<string, boolean>)
	local hasAll = true
	local result = {}

	for _, index in ipairs(objects) do
		local has = self:HasOne(index)
		result[index] = has

		if has == false then
			hasAll = false
		end
	end

	return hasAll, result
end

--[[={
	@desc Adds objects with the specified index
	```lua
	treeEnv:Add({
		"Tree1" = tree:new(),
		"Tree2" = tree:new(),
		"Tree3" = tree:new()
	})

	print(treeEnv:Get("Tree2")) -- output: Tree2
	```
	@link void.link
}=]]

function methods:Add(objects: Dictionary<string, any>)
	for index, object in objects do
		self:AddOne(object, index)
	end
end

--[[={
	@desc Removes the objects with the specified index, example:
	```lua
	treeEnv:Remove({ "Tree1", "Tree2", "Tree3" })
	print(treeEnv:Get("Tree2")) -- output: nil
	```
	@link void.link
}=]]

function methods:Remove(objects: Array<string>)
	for _, index in ipairs(objects) do
		self:RemoveOne(index)
	end
end

--[[={
	@desc Updates the objects with the specified index, example:
	```lua
	treeEnv:Update({
		Tree1 = treeEnv:Get("Tree2"),
		Tree2 = treeEnv:Get("Tree1"),
	})
	```
	@link void.link
}=]]

function methods:Update(objects: Dictionary<string, any>)
	for index, object in objects do
		if typeof(object) == "table" then
			object = getNormalAccess(object)
		end

		self.Content[index] = object
	end
end

--[[={
	@desc Finds an object by his name
	@link any.link
}=]]

function methods:FindByName(name: string): any
	for _, object in self.Content do
		if object.Name ~= name then
			continue
		end

		return object
	end

	return
end

--[[={
	@desc Sets the specified property in every object in the environment
	@link void.link
}=]]

function methods:SetProperty(property: string, value: any)
	for _, object in self.Content do
		pcall(setProperty, object, property, value)
	end
end

--[[={
	@desc Executes the specified methods in every object in the environment with the specified parameters
	@link void.link
}=]]

function methods:Run(method: string, ...)
	for _, object in self.Content do
		if typeof(object) == "table" then
			coroutine.wrap(pcall)(object[method] or warn, object, ...)
		end
	end
end

--[[={
	@desc This class is used to storage objects and interact with them in an easier way
	@about
		@Count The amount of objects in this environment
}=]]

return baseObject:Extend(script.Name, {
	methods = methods,
	constructor = constructor,
	rules = { Content = {} },
	readonly = {
		Count = 0,
		InstanceType = "Folder",
	},
})