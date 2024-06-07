local ReplicatedStorage = game:GetService("ReplicatedStorage")
local reciever = require(script.middleware.reciever)
local gui = require(script.slices.gui)
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local Store = require(ReplicatedStorage.Shared.Store)

export type State = Store.State & {
	gui: gui.State
}
export type Actions = Store.Actions & gui.Actions

local slices = table.clone(Store)
slices.gui = gui

local STORE = Reflex.combineProducers(slices) :: Reflex.Producer<State, Actions>
STORE:applyMiddleware(reciever.middleware)

return STORE
