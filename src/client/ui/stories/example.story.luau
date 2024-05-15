local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Example = require(StarterPlayer.StarterPlayerScripts.Client.ui.components.Example)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

return function(target: Instance)
	local instance = Fusion.Hydrate(Example()) {
		Parent = target,
	}  

	return function()
		instance:Destroy()
	end
end
