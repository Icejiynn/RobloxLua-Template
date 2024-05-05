local modules: { { init: () -> {} | nil, start: () -> {} | nil } } = {}

for index, value in script.services:GetDescendants() do
	if value.Name:match("Service") and value:IsA("ModuleScript") then
		table.insert(modules, require(value))
	end
end

for _, module in modules do
	if module.init then
		module.init()
	end
end
for _, module in modules do
	if module.start then
		task.spawn(function()
			module.start()
		end)
	end
end
