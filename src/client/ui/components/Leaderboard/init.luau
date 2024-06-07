local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local UIComponent = require(StarterPlayer.StarterPlayerScripts.Client.UI.components.ui.UIComponent)
local useAsync = require(StarterPlayer.StarterPlayerScripts.Client.UI.hooks.useAsync)
local List = require(script.List)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Network = require(ReplicatedStorage.Shared.Network)

return UIComponent(function(component)
	local lastFetch = Fusion.Value(0)
	local value = useAsync(function()
		return (select(2, Network.data.fetchLeaderboard:Call():Await()) :: unknown) :: {
			[string]: {{
				key: string,
				value: number
			}}
		}
	end, {lastFetch})

	component.trove:Add(task.spawn(function()
		while true do
			task.wait(60)
			lastFetch:set(tick())
		end
	end))

	local function makeList(v: Instance)
		component.trove:Add(List({
			Instance = v:FindFirstChildOfClass("SurfaceGui"),
			Data = Fusion.Computed(function()
				local data = value:get()  
				return if data then data[v.Name] else nil
			end)
		}))
	end

	for _, v in CollectionService:GetTagged("leaderboard") do
		makeList(v)
	end
end)
