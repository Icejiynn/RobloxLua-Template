local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)
local WaitFor = require(ReplicatedStorage.Packages.WaitFor)

local CharacterUtil = {}

function CharacterUtil.promiseLoaded(char: Model) 
	return Promise.all({
		WaitFor.Child(char, "Humanoid", 10):andThen(function(humanoid)
			return WaitFor.Child(humanoid, "Animator")
		end),
		WaitFor.Child(char, "HumanoidRootPart", 10),
	})
end

function CharacterUtil.promiseDestroyed(char: Model) 
	return Promise.fromEvent(char.AncestryChanged, function(...): boolean  
		return not char:IsDescendantOf(workspace)
	end)
end

return CharacterUtil