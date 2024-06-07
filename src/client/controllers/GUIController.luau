local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Network = require(ReplicatedStorage.Shared.Network)
local App = require(StarterPlayer.StarterPlayerScripts.Client.UI.App)
local Store = require(StarterPlayer.StarterPlayerScripts.Client.Store)

local GUIController = {}

GUIController.__app = nil :: typeof(App(...))?

function GUIController:OnInit()
	Network.notification.create:Client():On(function(notification)
		Store.createNotification(notification)
	end)
end

function GUIController:OnStart()
	GUIController.app = App(Players.LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui)
end

return GUIController