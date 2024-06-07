local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Network = require(ReplicatedStorage.Shared.Network)
local Store = require(ReplicatedStorage.Shared.Store)

local BROADCASTER = Reflex.createBroadcaster({
    producers = Store,
    dispatch = function(player, actions)
        Network.reflex.dispatch:Server():Fire(player, actions)
    end,
})

Network.reflex.start:Server():On(function(player)
    BROADCASTER:start(player)
end)

return BROADCASTER