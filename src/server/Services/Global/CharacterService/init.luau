local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Character = require(script.Character)
local CharacterUtil = require(ReplicatedStorage.Shared.Util.Model.CharacterUtil)
local PlayerUtil = require(ReplicatedStorage.Shared.Util.PlayerUtil)

local REGEN_HEALTH = 1

local CharacterService = {}

CharacterService.__list = {}

function CharacterService:start()
	local function playerAdded(plr: Player)
		local trove = Trove.new()

		trove:Add(plr.CharacterAdded:Connect(CharacterService.__addCharacter))
		if (plr.Character) then
			CharacterService.__addCharacter(plr.Character)
		end

		PlayerUtil.promiseDisconnected(plr):andThen(function()
			trove:Clean()
			if plr.Character then
				CharacterService.removeCharacter(plr.Character)
			end
		end)
	end

	Players.PlayerAdded:Connect(playerAdded)
	for _, v in Players:GetPlayers() do
		playerAdded(v)
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

function CharacterService.__addCharacter(model: Model)
	return CharacterUtil.promiseLoaded(model):andThen(function()
		local character = Character.new({
			model = model,
		})
	
		CharacterService.__list[model] = character
		character.trove:AddPromise(CharacterUtil.promiseDestroyed(model):finally(function()
			CharacterService.removeCharacter(model)
		end))
	end):catch(function()
		if model then
			model:Destroy()
		end
		warn("Character did not load!")
	end)
end

function CharacterService.removeCharacter(model: Model)
	local character = CharacterService.__list[model]
	if character then 
		CharacterService.__list[model] = nil
		character:destroy()
	end
end

function CharacterService.getCharacter(model: Model)
	return CharacterService.__list[model]
end


return CharacterService