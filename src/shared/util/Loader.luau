local RunService = game:GetService("RunService")
local IS_SERVER = RunService:IsServer()

return function(target: Script)
	local modules: { { init: () -> {} | nil, start: () -> {} | nil } } = {}
	local singletonName = if IS_SERVER then "Service" else "Controller"

	for index, value in target:GetDescendants() do
		if value.Name:match(singletonName) and value:IsA("ModuleScript") then
			local module = require(value)
	
			if module.LoadPlace and game.PlaceId ~= module.LoadPlace then
				continue
			end
	
			table.insert(modules, module)
		end
	end
	
	for _, module in modules do
		if module.init then
			module.init()
		end
	end
	print(`Initiated {#modules} {singletonName:lower()}s`)
	for _, module in modules do
		if module.start then
			task.spawn(function()
				module.start()
			end)
		end
	end
	
end
