local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Network = require(ReplicatedStorage.Shared.Network)
local sharedStore = require(ReplicatedStorage.Shared.store)

local broadcaster = Reflex.createBroadcaster({
    producers = sharedStore.slices,
    dispatch = function(player, actions)
        Network.reflex.dispatch:Server():Fire(player, actions)
    end,
})

Network.reflex.start:Server():On(function(player)
    broadcaster:start(player)
end)

return broadcaster