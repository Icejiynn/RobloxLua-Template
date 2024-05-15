local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local t = require(ReplicatedStorage.Packages.t)

return {
	redeem = Red.Event("RedeemCode", function(arg1)
		assert(t.string(arg1))
		return arg1 :: string
	end)
}