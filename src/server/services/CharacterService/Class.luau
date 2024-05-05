local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)

type Properties = {
	model: Model
}

type CharacterModel = Model & {
	Humanoid: Humanoid & {
		Animator: Animator
	},
	HumanoidRootPart: BasePart
}

local Character = {}
Character.__index = Character

function Character.new(props: Properties)
	local self = {
		model = props.model :: CharacterModel,
	}
	self.trove = Trove.new()
	
	return setmetatable(self, Character)
end

type ClassType = typeof(Character.new(...))

function Character.damage(self: ClassType, amm: number)
	self.model.Humanoid:TakeDamage(amm)
end

function Character.destroy(self: ClassType)
	self.trove:Destroy()
end

return Character