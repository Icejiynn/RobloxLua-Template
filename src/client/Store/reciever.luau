local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Network = require(ReplicatedStorage.Shared.Network)

local receiver = Reflex.createBroadcastReceiver({
    start = function()
        Network.reflex.start:Client():Fire()
    end,
})

Network.reflex.dispatch:Client():On(function(actions)
    receiver:dispatch(actions)
end)

return receiver