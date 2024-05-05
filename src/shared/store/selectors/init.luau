local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataConstants = require(ReplicatedStorage.Shared.constants.DataConstants)
local store = require(script.Parent)
local module = {}

function module.selectPlayerBalanceValue(user: string, key: string)
	return function(state: store.State) 
		local data=  state.data.balance[user]
		return if data then data[key] else (DataConstants.DataTemplate.balance[key] or 0) 
	end
end

return module