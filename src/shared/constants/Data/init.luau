local Inventory = require(script.Inventory)
local Stats = require(script.Stats)

export type PlayerData = {
	inventory: Inventory.Structure,
	stats: Stats.Structure
}

local TEMPLATE: PlayerData = {
	inventory = Inventory.TEMPLATE,
	stats = Stats.TEMPLATE,
}

return {
	Inventory = Inventory,
	Stats = Stats,
	TEMPLATE = TEMPLATE
}