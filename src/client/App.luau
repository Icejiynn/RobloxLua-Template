local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Example = require(StarterPlayer.StarterPlayerScripts.Client.ui.components.Example)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local displayComponents = Fusion.Value({
	Example,
} :: {() -> Instance | () -> nil})

return function(target: Instance)
	return Fusion.ForValues(displayComponents, function(v)
		local result = v()

		if typeof(result) == "Instance" then
			Fusion.Hydrate(result) {
				Parent = result:IsA("ScreenGui") and target or result.Parent,
				Name = getfenv(v).script.Name
			}
		end
		
		return result
	end, function(result)
		if typeof(result) == "Instance" then 
			result:Destroy()
		else
			result()
		end
	end)
end