local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Store = require(ReplicatedStorage.Shared.Store)
local broadcaster = require(script.middleware.broadcaster)

export type State = Store.State
export type Actions = Store.Actions

local slices = table.clone(Store)

local STORE = Reflex.combineProducers(slices) :: Reflex.Producer<State, Actions>
STORE:applyMiddleware(broadcaster.middleware)

return STORE
