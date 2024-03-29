local ToUDim2 = require(script.Parent.Parent.Parent.Private.Util).ToUDim2

local function isOutsideLimits(target, limits, margin)
	return target.X < limits.X - margin
		or target.X > 1 - limits.X + margin
		or target.Y < limits.Y - margin
		or target.Y > 1 - limits.Y + margin
end

return function(scene, deltaTime)
	local camera = scene.Camera
	local subject = camera.Subject

	local resolution = workspace.CurrentCamera.ViewportSize
	if not subject or not camera.FollowSubject then
		return
	elseif camera.Limits == Vector2.zero then
		return camera:LookTo(subject)
	end

	local force = subject.IsGrounded and Vector2.zero or subject.Force * deltaTime
	local velocity = subject.Velocity * deltaTime

	local limits = (camera.Limits / 2)
	local target = (subject.Instance.AbsolutePosition + force + velocity) / resolution

	if not isOutsideLimits(target, limits, 0) then
		return
	elseif isOutsideLimits(target, limits, 0.05) then
		return camera:LookTo(subject)
	end

	local position = camera.LocalPosition - force - velocity
	return camera:SetPosition(ToUDim2(position))
end
