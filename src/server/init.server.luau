local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
local PlaceIDs = require(ReplicatedStorage.Shared.Constants.PlaceIDs)

local inPlace
for i,v in PlaceIDs do
	if v == game.PlaceId then
		inPlace = i
	end
end

local services = Loader.LoadChildren(script.Services.Global, Loader.MatchesName("Service$"))
if inPlace then
	for _, service in Loader.LoadChildren(script.Services:FindFirstChild(inPlace), Loader.MatchesName("Service$")) do
		table.insert(services, service)
	end
else
	warn("No place found! Please edit the PlaceIDs module\n\t(ReplicatedStorage.Shared.Constants.PlaceIDs)")
end

for _, service in services do
    if typeof(service.OnInit) == "function" then
		service:OnInit()
    end
end
Loader.SpawnAll(services, "OnStart")