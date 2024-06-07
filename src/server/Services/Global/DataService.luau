local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Promise = require(ReplicatedStorage.Packages.Promise)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)
local Data = require(ReplicatedStorage.Shared.Constants.Data)
local Store = require(ServerScriptService.Server.Store)

local PROFILE_STORE = ProfileService.GetProfileStore(
	`Data/{if RunService:IsStudio() then "Testing" else "Main"}`,
	Data.TEMPLATE
)
local KEY_TEMPLATE = `%d_Data`
local PROFILES: { [Player]: typeof(PROFILE_STORE:LoadProfileAsync("")) } = {}

if RunService:IsStudio() then
	PROFILE_STORE = PROFILE_STORE.Mock
end

local DataService = {}

function DataService:OnStart()
	for _, plr in Players:GetPlayers() do
		DataService.__createProfile(plr)
	end
	Players.PlayerAdded:Connect(DataService.__createProfile)
	Players.PlayerRemoving:Connect(DataService.removeProfile)
end

function DataService.__createProfile(plr: Player)
	if (typeof(plr) ~= "Instance") then
		return
	end

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

function DataService.removeProfile(plr: Player, teleporting: Promise.Promise?)
	Store.closePlayerData(tostring(plr.UserId))
	local profile = PROFILES[plr]

	if profile then
		profile:Release()
		PROFILES[plr] = nil

		if teleporting then
			profile:ListenToHopReady(function()
				teleporting:await()
			end)
			teleporting:catch(function()
				DataService.__createProfile(plr);
			end)
		end
	end
end

function DataService.getProfile(plr: Player)
	return PROFILES[plr]
end

return DataService
