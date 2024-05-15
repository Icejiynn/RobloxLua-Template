local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)
local t = require(ReplicatedStorage.Packages.t)

local isMSG = t.interface({
	msg = t.string,
	type = t.literal("error", "warn", "success")
})

return {
	create = Red.Event("CreateNotification", function(arg1)
		assert(isMSG(arg1))

		return arg1 :: {
			type: "error" | "warn" | "success",
			msg: string
		}
	end)
}