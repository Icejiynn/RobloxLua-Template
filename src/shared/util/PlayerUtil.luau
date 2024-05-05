local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)

local module = {}

function module.promiseDisconnected(plr: Player) 
	return Promise.fromEvent(Players.PlayerRemoving, function(player): boolean  
		return player == plr
	end)
end

return module