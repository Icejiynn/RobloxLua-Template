local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Page = require(StarterPlayer.StarterPlayerScripts.Client.ui.config.Page)
local Reflex = require(ReplicatedStorage.Packages.Reflex)

export type Actions = {
	setPage: (page: Page.Pages) -> State,
}

export type State = {
	page: Page.Pages,
}

local initialState: State = {
	page = nil
}

local guiSlice = Reflex.createProducer(initialState, {
	setPage = function(state: State, page: Page.Pages)
		local newState = {}
		for i, v in state do
			newState[i] = v
		end

		newState.page = page

		return newState
	end,
})

return guiSlice
