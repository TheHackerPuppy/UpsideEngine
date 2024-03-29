local upsideEngine = script.Parent.Parent.Parent
local contentProvider = game:GetService("ContentProvider")
local colorProperties = { "ImageColor3", "TextColor3", "TextStrokeColor3" }

local baseObject = require(upsideEngine.Classes.Internal.BaseObject)
local util = require(upsideEngine.Private.Util)
local physicalObject = {}
physicalObject.__index = physicalObject

local function tryToReplicate(self, Property)
	local value = self.ChromaticAberration.R[Property]
	self.ChromaticAberration.G[Property] = value
	self.ChromaticAberration.B[Property] = value
end

function updateChromaticAberration(self, property)
	local index = 1
	local instance = self.Instance
	local distance = util.ToVector2(instance.Position, "Scale") - self.ChromaticAberrationPoint
	distance = Vector2.new(math.abs(distance.X), math.abs(distance.Y))

	if property ~= "Position" and table.find(colorProperties, property) == nil then
		pcall(tryToReplicate, self, property)
	end

	for colorName, c in self.ChromaticAberration do
		if colorName ~= "R" then
			local localDistance = distance * index * self.ChromaticAberrationDistance
			index += 1

			c.Position = self.ChromaticAberration.R.Position
				+ UDim2.fromScale(
					instance.Position.X.Scale > self.ChromaticAberrationPoint.X and -localDistance.X or localDistance.X,
					instance.Position.Y.Scale > self.ChromaticAberrationPoint.Y and -localDistance.Y or localDistance.Y
				)
		end
	end
end

local function setAberration(data)
	local transparencyProperty = data.property:split("Color3")[1] .. "Transparency"
	if data.color[transparencyProperty] > 1 then
		return
	end

	local Color = { R = 0, G = 0, B = 0 }
	Color[data.name] = 1

	data.color[data.property] = Color3.new(Color.R, Color.G, Color.B)
	data.color[transparencyProperty] = data.intensity
end

--[[={
	@link PhysicalObject.md
}=]]

function physicalObject.new(): PhysicalObject
	local self = baseObject.new()
	self:SetClassName(script.Name)
	self.ChromaticAberrationPoint = Vector2.new(0.5, 0.5)
	self.Force = Vector2.zero
	self.Velocity = Vector2.zero
	self.ChromaticAberration = {}
	self.Collisions = {}
	self.CollisionBlacklist = {}
	self.Hitbox = {
		Vector2.zero,
		Vector2.new(1, 0),
		Vector2.new(1, 1),
		Vector2.new(0, 1),
	}

	self.Mass = 200
	self.HitboxScale = 1
	self.CollisionGroup = 0
	self.ChromaticAberrationIntensity = 0
	self.ChromaticAberrationDistance = 0.1
	self.Anchored = true
	self.CanCollide = true
	self.IsGrounded = false
	self.TrackCollisions = true
	self.ChromaticAberrationConnection = false

	local instance = self.Instance
	instance.AnchorPoint = Vector2.new(0.5, 0.5)
	instance.Position = UDim2.fromOffset(100, 100)
	instance.Size = UDim2.fromOffset(200, 200)
	instance.BackgroundTransparency = 1
	instance.ResampleMode = Enum.ResamplerMode.Pixelated

	return setmetatable(self, physicalObject)
end


--[[={
	@desc Loads an image for the current object and is set as the instance image
	@link void.link
}=]]

function physicalObject:Load(url: string)
	contentProvider:PreloadAsync({ url })
	self.Instance.Image = url
end

--[[={
	@desc Sets chromatic aberration for the image using a center as reference, by default the center is the middle of the screen, 
	to disable the chromatic aberration send 0 as first parameter
	@link void.link
}=]]

function physicalObject:SetChromaticAberration(Intensity: number, Distance: number, Point: Vector2)
	assert(typeof(Intensity) == "number", "Invalid argument #1, it must be a number")
	assert(typeof(Point) == "Vector2" or not Point, "Invalid argument #2, it must be a Vector2")

	if Intensity == 0 then
		self.ChromaticAberration.ImageColor3 = Color3.new(1, 1, 1)
		self.ChromaticAberrationConnection:Disconnect()

		self.ChromaticAberration.R = nil
		self.ChromaticAberration.G:Destroy()
		self.ChromaticAberration.B:Destroy()
		return
	end

	self.ChromaticAberrationIntensity = Intensity
	self.ChromaticAberrationDistance = Distance or 0.1
	self.ChromaticAberrationPoint = Point or self.ChromaticAberrationPoint

	updateChromaticAberration(self, "Position")

	if not self.ChromaticAberrationConnection then
		self.ChromaticAberration = {
			R = self.Instance,
			G = self.Instance:Clone(),
			B = self.Instance:Clone(),
		}

		for colorName, color in self.ChromaticAberration do
			for _, property in ipairs(colorProperties) do
				pcall(setAberration, {
					name = colorName,
					color = color,
					property = property,
					intensity = self.ChromaticAberrationIntensity,
				})
			end
		end

		local chromaticAberration = self.ChromaticAberration
		local rParent = chromaticAberration.R.Parent
		chromaticAberration.G.Parent = rParent
		chromaticAberration.B.Parent = rParent
		self.ChromaticAberrationConnection = self.Instance.Changed:Connect(util.Wrap(updateChromaticAberration, self))
	end
end

--[[={
	@desc This class is used to create objects with physics
	@about
		@ChromaticAberrationPoint This is the point which is being used as reference for the chromatic aberration
		@ChromaticAberration The instances which makes the chromatic aberration effect
		@Collisions This table stores all the active collisions
		@CollisionBlacklist This dictionary stores all the blacklisted objects, to blacklist an object do it like this:
		```lua
		CollisionBlacklist[object.Id] = true
		```
		@Mass The object mass
		@CollisionGroup A number which indicates the collision group of the object, the object only can collide with other objects with the same CollisionGroup
		@Anchored This property defines if the object should have physics or not
		@CanCollide This property defines if the object can collide with other objects
		@IsGrounded This property indicates if the object is touching the ground
		@TrackCollisions This property defines if the object is going to have physics and collisions or not
		@Force Is the force which is applied in the moment to the object
		@Velocity Is the velocity applied to the object
		@Hitbox This the CollisionMask of the object
	@events 
		@Collision Params -> [PhysicalObject](PhysicalObject.md)
		This event is fired when the object collides with other object
		@CollisionEnd Params -> [PhysicalObject](PhysicalObject.md)
		This event is fired when the object finish the collision with other object
}=]]

return setmetatable(physicalObject, baseObject)
