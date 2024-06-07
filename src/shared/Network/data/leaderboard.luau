local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local t = require(ReplicatedStorage.Packages.t)

return Red.Function("fetchLeaderboard", function()
	return
end, function(arg1)
	assert(
		t.array(
			t.interface({
				key = t.string,
				value = t.number
			})
		)(arg1)
	)
	
	return arg1 :: {{
		key: string,
		value: number,
	}}
end)