local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Promise = require(ReplicatedStorage.Packages.Promise)

return function<T>(callback: () -> T, deps: {Fusion.StateObject<any>})
	deps = deps or {}

	local value = Fusion.Value(nil) :: Fusion.Value<T | nil>
	local currentPromise = nil :: nil | Promise.TypedPromise<>
	local connections = {}
    
    local function execute(...)
        if currentPromise ~= nil then
            currentPromise:cancel()
        end
        
		local args = {...}
        local promise = Promise.try(function()  
			return callback(table.unpack(args))
		end):andThen(function(val)
			value:set(val)
		end)
        
        currentPromise = promise
    end

	for _,v in deps do
		table.insert(connections, Fusion.Observer(v):onChange(execute))
	end
	execute()

    return value, function()
		if currentPromise then
			currentPromise:cancel()
		end

		for _, v in connections do
			v()
		end
	end
end