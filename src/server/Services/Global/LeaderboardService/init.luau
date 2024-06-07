local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Leaderboard = require(script.Leaderboard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Store = require(ServerScriptService.Server.Store)
local Network = require(ReplicatedStorage.Shared.Network)
local PlayerUtil = require(ReplicatedStorage.Shared.Util.PlayerUtil)

local LeaderboardService = {}

LeaderboardService.__list = {} :: {[string]: typeof(Leaderboard.new({
	name = "",
	trackingAmount = 0,
}))}

function LeaderboardService:start()
	Network.data.fetchLeaderboard:SetCallback(function(Player: Player)
		local data = {}
		for i,v in LeaderboardService.__list do
			data[i] = v.cache 
		end
		return data
	end)

	LeaderboardService.createLeaderboard({
		name = "Coins",
		trackingAmount = 100,
	})

	for _, v in Players:GetPlayers() do
		LeaderboardService.createTracker(v)
	end
	Players.PlayerAdded:Connect(LeaderboardService.createTracker)

	game:BindToClose(function()
		for _, lb in LeaderboardService.__list do
			for k, v in lb._posted do
				lb:update(k, v)
			end
		end
	end)
end

function LeaderboardService.createTracker(plr: Player)
	local trove = Trove.new()
	local user = tostring(plr.UserId)

	trove:Add(function()
		for _,v in LeaderboardService.__list do
			if v._posted[user] then
				v:update(user, v._posted[user])
			end
		end
	end)

	trove:Add(Store:subscribe(function(state: Store.State)
		local inventorys = state.data.inventory[user]
		return inventorys and inventorys["coins"] :: number
	end, function(new: number, old: number)
		if (new and (if old then new > old else true)) then
			LeaderboardService.__list.Coins:post(user, new)
		end
	end))

	PlayerUtil.promiseDisconnected(plr):andThen(function()
		trove:Clean()
	end)
end

function LeaderboardService.createLeaderboard(props: Leaderboard.Properties)
	local Leaderboard = Leaderboard.new(props)
	LeaderboardService.__list[props.name] = Leaderboard
end

return LeaderboardService