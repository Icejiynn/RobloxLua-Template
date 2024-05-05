local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
return function()
	local hovering = Fusion.Value(false)
	local click = Fusion.Value(false)
	local events = {
		MouseEnter = function()
			hovering:set(true)
		end,
		MouseLeave = function()
			hovering:set(false)
			click:set(false)
		end,
		MouseButton1Down = function()
			click:set(true)
		end,
		MouseButton1Up = function()
			click:set(false)
		end,
	}

	return hovering, click, events
end
