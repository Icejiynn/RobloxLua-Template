local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RblxUtils = require(ReplicatedStorage.Packages.RblxUtils)

export type Stat = "endurance" | "agility"
export type Structure = { [Stat]: number, attributePoints: number  }

local METADATA: {[Stat]: {
	color: Color3
}} = {
	endurance = {
		color = Color3.new(0.290196, 0.784314, 0.349020),
		text = "Endurance"
	},
	agility = {
		color = Color3.new(0.290196, 0.784314, 0.349020),
		text = "Agility"
	},
}

local TEMPLATE: Structure = {attributePoints = 0}
for _, stat in RblxUtils.Table.keys(METADATA) do
	TEMPLATE[stat] = 0
end

local Stats = {}

Stats.METADATA = METADATA
Stats.TEMPLATE = TEMPLATE

return Stats