local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)

export type Properties = {
	name: string,
	trackingAmount: number
}

local Leaderboard = {}
Leaderboard.__index = Leaderboard

function Leaderboard.new(props: Properties)
	local self = {
		_dataStore = DataStoreService:GetOrderedDataStore(props.name),
		_trackingAmount = props.trackingAmount,
		_posted = {} :: {[string]: number},
		cache = {} :: {{
			key: string,
			value: number
		}},
	}

	task.defer(function()
		local function fetch() 
			return Promise.try(function()
				return self._dataStore:GetSortedAsync(true, props.trackingAmount)
			end):andThen(function(a0: DataStorePages): ...any  
				self.cache = a0:GetCurrentPage()
				print(self.cache)
			end)
		end

		Promise.retry(function(...)  
			return fetch()
		end, 5, 10):finally(function()
			while true do
				task.wait(60)
				fetch()
			end
		end)
	end)

	return setmetatable(self, Leaderboard)
end

type ClassType = typeof(Leaderboard.new(...))

function Leaderboard.post(self: ClassType, key: string, value: number)
	local cacheSize = #self.cache
	-- Deny if not in the top Nth of sorted cache
	if cacheSize > 0 then
		if value < self.cache[cacheSize]["value"] then
			return
		end

		-- Return if user has a smaller value in the cache than the requested
		if cacheSize ~= self._trackingAmount then
			for i,v in self.cache do
				if v.key == key and value < v.value then
					return 
				end
			end
		end
	end

	self._posted[key] = value
end

function Leaderboard.update(self: ClassType, key: string, value: number)
	self._dataStore:UpdateAsync(key, function(a0: number?, a1: DataStoreKeyInfo): (number, {number}?, {  }?)  
		return value
	end)
	self._posted[key] = nil
end

return Leaderboard