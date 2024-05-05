local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Store = require(StarterPlayer.StarterPlayerScripts.Client.Store)

return function<T>(selector: (state: Store.State) -> T)
	local value = Fusion.Value(nil) :: Fusion.Value<T>
	local disconnect = Store:subscribe(selector, function(new, old)
		value:set(new)
	end)

	return value, disconnect
end
