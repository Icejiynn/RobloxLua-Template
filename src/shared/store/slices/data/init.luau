local ReplicatedStorage = game:GetService("ReplicatedStorage")
local balance = require(script.balance)
local stats = require(script.stats)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

export type State = {
	balance: balance.State,
	stats: stats.State
}
export type Actions = balance.Actions & stats.Actions

local dataSlice = Reflex.combineProducers({
	balance = balance,
	stats = stats,
})

return dataSlice
