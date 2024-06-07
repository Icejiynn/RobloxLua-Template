local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Network)
local Test = {}

function Test:start()
	local z, a = Network.Data.fetchLeaderboard:Call():Await()
	print(z,a)
end

return Test