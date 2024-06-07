local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local receiver

if RunService:IsRunning() then
    local Network = require(ReplicatedStorage.Shared.Network)

    receiver = Reflex.createBroadcastReceiver({
        start = function()
            Network.reflex.start:Client():Fire()
        end,
    })

    Network.reflex.dispatch:Client():On(function(actions)
        receiver:dispatch(actions)
    end)
else
    receiver = Reflex.createBroadcastReceiver({
        start = function()
            
        end,
    })
end

return receiver