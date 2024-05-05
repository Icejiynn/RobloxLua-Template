local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

return function<T>(initValue: T, finalValue: T, delay: number): Fusion.Value<T>
	local value = Fusion.Value(initValue)

	task.delay(delay, function()
		value:set(finalValue)
	end)

	return value
end
