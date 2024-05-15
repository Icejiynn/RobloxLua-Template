local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local DataConstants = require(ReplicatedStorage.Shared.constants.DataConstants)
local StatConstants = require(ReplicatedStorage.Shared.constants.StatConstants)

export type Actions = {
	loadPlayerData: (user: string, data: DataConstants.PlayerData) -> State,
	closePlayerData: (user: string) -> State,
	incrementPlayerStat: (user: string, key: StatConstants.Stat) -> State,
	resetPlayerStats: (user: string) -> State,
}

export type State = {
	[string]: DataConstants.PlayerStats,
}

local INITIAL_STATE: State = {}

return Reflex.createProducer(INITIAL_STATE, {
	loadPlayerData = function(state: State, user: string, data: DataConstants.PlayerData)
		local newState = {}
		for i, v in state do
			newState[i] = v
		end

		newState[user] = data.stats

		return newState
	end,
	closePlayerData = function(state: State, user: string)
		local newState = {}
		for i, v in state do
			if i == user then
				continue
			end
			newState[i] = v
		end

		return newState
	end,

	incrementPlayerStat =  function(state: State, user: string, key: StatConstants.Stat)
		local newState = {}
		for i, data in state do
			if i == user then
				data[key] = (data[key] or 0) + 1
			end
			newState[i] = data
		end

		return newState
	end,
	resetPlayerStats =  function(state: State, user: string, key: StatConstants.Stat)
		local newState = {}
		for i, data in state do
			if i == user then
				local total = 0
				for i, v in data do
					if (i == "attributePoints") then
						continue
					end
					total += v
					data[i] = 0
				end
				data.attributePoints = total
			end
			newState[i] = data
		end

		return newState
	end,
})