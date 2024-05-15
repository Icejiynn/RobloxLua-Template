local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

return Red.Event("ReflexDispatch", function(arg1)
	return arg1 :: {Reflex.BroadcastAction}
end)