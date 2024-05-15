local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
return function ()
	return if not RunService:IsRunning() then "0" else tostring(Players.LocalPlayer.UserId)
end
