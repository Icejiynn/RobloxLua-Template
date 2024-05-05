local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Promise = require(ReplicatedStorage.Packages.Promise)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)
local DataConstants = require(ReplicatedStorage.Shared.constants.DataConstants)
local Store = require(ServerScriptService.Server.Store)

local PROFILE_STORE = ProfileService.GetProfileStore(
	if RunService:IsStudio() then "Testing" else "Production",
	DataConstants.DataTemplate
)
local KEY_TEMPLATE = `%d_Data`
local PROFILES: { [Player]: typeof(PROFILE_STORE:LoadProfileAsync("")) } = {}

if RunService:IsStudio() then
	-- PROFILE_STORE = PROFILE_STORE.Mock
end

local DataService = {}

function DataService:start()
	for _, plr in Players:GetPlayers() do
		task.spawn(function()
			DataService.createProfile(plr)
		end)
	end
	Players.PlayerAdded:Connect(DataService.createProfile)
	Players.PlayerRemoving:Connect(DataService.removeProfile)
end

---@private
function DataService.createProfile(plr: Player)
	local user = plr.UserId

	return Promise.new(function(resolve, reject)
		local profile = PROFILE_STORE:LoadProfileAsync(string.format(KEY_TEMPLATE, user))
		if not profile then
			reject("Failed to load!")
			return
		end

		if not plr:IsDescendantOf(Players) then
			profile:Release()
			reject("Player left!")
			return
		end

		resolve(profile)
	end)
		:andThen(function(profile)
			profile:AddUserId(user)
			profile:Reconcile()
			Store.loadPlayerData(tostring(user), profile.Data)
			PROFILES[plr] = profile
		end)
		:catch(function(err)
			warn(`{err}`)
			plr:Kick(`Could not load data!\nPlease rejoin.`)
		end)
end

---@private
function DataService.removeProfile(plr: Player)
	Store.closePlayerData(tostring(plr.UserId))
	local profile = PROFILES[plr]
	if profile then
		profile:Release()
		PROFILES[plr] = nil
	end
end

function DataService.getProfile(plr: Player)
	return PROFILES[plr]
end

return DataService
