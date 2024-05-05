--!strict
export type Stat = "endurance" | "agility"

local metadata: {[Stat]: {
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

local Stats = {}

Stats.metadata = metadata

return Stats