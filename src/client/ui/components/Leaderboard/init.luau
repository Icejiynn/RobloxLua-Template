local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local List = require(script.List)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Network = require(ReplicatedStorage.Shared.Network)
local useAsync = require(StarterPlayer.StarterPlayerScripts.Client.ui.hooks.useAsync)

type SurfaceGui = typeof(workspace.Leaderboards.leaderboard.SurfaceGui)

local LEADERBOARD_FOLDER = workspace:WaitForChild("Leaderboards")

return function()
	local fetch = Fusion.Value(false)
	local value = useAsync(function()
		return (select(2, Network.Data.FetchLeaderboard:Call():Await()) :: unknown) :: {
			[string]: {{
				key: string,
				value: number
			}}
		}
	end, {fetch})

	local thread = task.spawn(function()
		while true do
			task.wait(60)
			fetch:set(not fetch:get())
		end
	end)

	local function makeList(v: Instance)
		List({
			Instance = v:FindFirstChildOfClass("SurfaceGui"),
			Data = Fusion.Computed(function()
				local data = value:get()  
				return if data then data[v.Name] else nil
			end)
		})
	end

	for _, v in LEADERBOARD_FOLDER:GetChildren() do
		makeList(v)
	end
	LEADERBOARD_FOLDER.ChildAdded:Connect(makeList)

	return nil, function()
		task.cancel(thread)
	end
end
