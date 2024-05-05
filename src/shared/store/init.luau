local ReplicatedStorage = game:GetService("ReplicatedStorage")
local data = require(ReplicatedStorage.Shared.store.slices.data)

export type State = {
	data: data.State
}
export type Actions = data.Actions

local slices = {
	data = data,
}

return { slices = slices }
