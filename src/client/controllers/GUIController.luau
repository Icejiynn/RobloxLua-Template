local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local App = require(StarterPlayer.StarterPlayerScripts.Client.App)

local GUIController = {}

function GUIController:start()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui
	GUIController.app = App(playerGui)
end

return GUIController