local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Source = require(ReplicatedStorage.Shared.Constants.Model.Character)

local Character = {}
Character.__index = Character

function Character.new(props: {
	model: Model
})
	local self = {
		model = props.model :: Source.Structure,
	}
	self.trove = Trove.new()

	self.trove:Add(self.model.Humanoid.Died:Connect(function()
		self:destroy()
	end))

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