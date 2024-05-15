local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Store = (if RunService:IsServer() then 
	require(ServerScriptService.Server.Store)
	else require(StarterPlayer.StarterPlayerScripts.Client.Store)
) :: typeof(require(ServerScriptService.Server.Store))

local TimeUtil = {}

function TimeUtil.wait(waitFor: number)
	local thread = coroutine.running()

	local elapsed = 0
	local connection = RunService.PostSimulation:Connect(function(a0: number)
		elapsed += a0 * Store:getState().match.clock.speed
		if elapsed >= waitFor then
			coroutine.resume(thread)
		end
	end)

	coroutine.yield()
	connection:Disconnect()
end

return TimeUtil