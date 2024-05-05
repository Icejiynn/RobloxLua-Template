local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterUtil = require(ReplicatedStorage.Shared.util.CharacterUtil)
local Class = require(script.Class)

local REGEN_HEALTH = 1

local CharacterService = {}

CharacterService.__list = {}

function CharacterService:start()
	local function playerAdded(plr: Player)
		plr.CharacterAdded:Connect(CharacterService._addCharacter)
	end

	Players.PlayerAdded:Connect(playerAdded)
	for _, v in Players:GetPlayers() do
		playerAdded(v)
		if (v.Character) then
			CharacterService._addCharacter(v.Character)
		end
	end

	-- Regen
	task.spawn(function()
		while true do
			for _, v in CharacterService.__list do
				local hum = v.model.Humanoid
				hum.Health = math.min(hum.Health + REGEN_HEALTH, hum.MaxHealth) 
			end
			task.wait(2)
		end
	end)
end

function CharacterService._addCharacter(model: Model)
	local newInstance = Class.new({
		model = model,
	})

	CharacterService.__list[model] = newInstance
	newInstance.trove:AddPromise(CharacterUtil.promiseDestroyed(model):andThen(function()
		CharacterService._removeCharacter(model)
	end))

	newInstance:damage(50)
end

function CharacterService._removeCharacter(model: Model)
	local instance = CharacterService.__list[model]
	if not instance then 
		return
	end

	CharacterService.__list[model] = nil
	instance:destroy()
end

function CharacterService.getCharacter(model: Model)
	return CharacterService.__list[model]
end


return CharacterService