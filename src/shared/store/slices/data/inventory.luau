local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Data = require(ReplicatedStorage.Shared.Constants.Data)
local Inventory = require(ReplicatedStorage.Shared.Constants.Data.Inventory)

export type Actions = {
	loadPlayerData: (user: string, data: Data.PlayerData) -> State,
	closePlayerData: (user: string) -> State,
	incrementPlayerInventory: (user: string, key: Inventory.Item, amm: number) -> State,
}

export type State = {
	[string]: Inventory.Structure,
}

local initialState: State = {}

return Reflex.createProducer(initialState, {
	loadPlayerData = function(state: State, user: string, data: Data.PlayerData)
		local newState = {}
		for i, v in state do
			newState[i] = v
		end

		newState[user] = data.inventory

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

	incrementPlayerInventory =  function(state: State, user: string, key: Data.Currency, amm: number)
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