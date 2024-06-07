local ReplicatedStorage = game:GetService("ReplicatedStorage")
local inventory = require(script.inventory)
local stats = require(script.stats)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

export type State = {
	inventory: inventory.State,
	stats: stats.State
}
export type Actions = inventory.Actions & stats.Actions

local dataSlice = Reflex.combineProducers({
	inventory = inventory,
	stats = stats,
})

return dataSlice
