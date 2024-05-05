local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatConstants = require(script.Parent.StatConstants)
local RblxUtils = require(ReplicatedStorage.Packages.RblxUtils)

export type Currency = "coins" | "gems"
export type PlayerBalance = { [string]: number | nil }
export type PlayerStats = { [StatConstants.Stat]: number, attributePoints: number  }
export type PlayerData = {
	balance: PlayerBalance,
	stats: PlayerStats
}

local statKeys = RblxUtils.Table.keys(StatConstants.metadata)
local stats: PlayerStats = {
	attributePoints = 0,
}
for _, stat in statKeys do
	stats[stat] = 0
end

local DATA_TEMPLATE: PlayerData = {
	balance = {
		coins = 5,
	},
	stats = stats,
}

local module = {}

module.DataTemplate = DATA_TEMPLATE

return module