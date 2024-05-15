local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

return function<T>(initValue: T, finalValue: T): Fusion.Value<T>
	local value = Fusion.Value(initValue)

	task.defer(function()
		value:set(finalValue)
	end)

	return value
end
