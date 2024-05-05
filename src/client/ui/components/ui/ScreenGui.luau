local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

return function (props: {[{} | unknown]: unknown})
	local properties = {
		IgnoreGuiInset = true,
	}
	for i,v in props do
		properties[i] = v
	end

	return Fusion.New("ScreenGui")((properties :: unknown) :: {[string]: unknown})
end