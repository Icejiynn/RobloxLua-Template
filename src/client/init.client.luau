local modules: { { init: (self: {}) -> {} | nil, start: (self: {}) -> {} | nil } } = {}

for index, value in script.controllers:GetDescendants() do
	if value.Name:match("Controller") and value:IsA("ModuleScript") then
		table.insert(modules, require(value))
	end
end

for _, module in modules do
	if module.init then
		module:init()
	end
end
for _, module in modules do
	if module.start then
		task.spawn(function()
			module:start()
		end)
	end
end
