local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)

local module = {}

function module.promiseLoaded(char: Model) 
	return Promise.all({}):timeout(10)
end

function module.promiseDestroyed(char: Model) 
	return Promise.fromEvent(char.AncestryChanged, function(...): boolean  
		return not char:IsDescendantOf(workspace)
	end)
end

return module