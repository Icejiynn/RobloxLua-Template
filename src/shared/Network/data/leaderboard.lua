local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Guard = require(ReplicatedStorage.Packages.Guard)
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Function("FetchLeaderboard", function(...: unknown)
	return 
end, function(...: unknown)  
	return Guard.Map(Guard.String, Guard.Any)
end)