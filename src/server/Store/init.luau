local ReplicatedStorage = game:GetService("ReplicatedStorage")
local broadcaster = require(script.broadcaster)
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local sharedStore = require(ReplicatedStorage.Shared.store)

export type State = sharedStore.State
export type Actions = sharedStore.Actions

local slices = {} :: typeof(sharedStore.slices)
for i, v in sharedStore.slices do
	slices[i] = v
end

local store = Reflex.combineProducers(slices) :: Reflex.Producer<State, Actions>

store:applyMiddleware(broadcaster.middleware)

return store
