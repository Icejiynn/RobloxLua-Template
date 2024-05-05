local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Example: () -> (Instance, () -> ()) = require(StarterPlayer.StarterPlayerScripts.Client.ui.components.Example)
local Leaderboard = require(StarterPlayer.StarterPlayerScripts.Client.ui.components.Leaderboard)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local COMPONENTS = {Example, Leaderboard} :: {() -> (Instance | nil, () -> nil)}

return function(target: Instance)
	return Fusion.ForValues(COMPONENTS, function(v)
		local instance, clean = v()

		if instance then
			Fusion.Hydrate(instance) {
				Parent = instance:IsA("ScreenGui") and target or instance.Parent,
				Name = getfenv(v).script.Name
			}
		end
		
		return clean
	end, function(v)
		return v()
	end)
end