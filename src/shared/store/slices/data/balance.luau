local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local DataConstants = require(ReplicatedStorage.Shared.constants.DataConstants)

export type Actions = {
	loadPlayerData: (user: string, data: DataConstants.PlayerData) -> State,
	closePlayerData: (user: string) -> State,
	incrementPlayerBalance: (user: string, key: DataConstants.Currency, amm: number) -> State,
}

export type State = {
	[string]: DataConstants.PlayerBalance,
}

local initialState: State = {}

return Reflex.createProducer(initialState, {
	loadPlayerData = function(state: State, user: string, data: DataConstants.PlayerData)
		local newState = {}
		for i, v in state do
			newState[i] = v
		end

		newState[user] = data.balance

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

	incrementPlayerBalance =  function(state: State, user: string, key: DataConstants.Currency, amm: number)
		local newState = {}
		for i, data in state do
			if i == user then
				data[key] = (data[key] or 0) + amm
			end
			newState[i] = data
		end

		return newState
	end
})