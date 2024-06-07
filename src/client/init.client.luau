local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
local PlaceIDs = require(ReplicatedStorage.Shared.Constants.PlaceIDs)

local inPlace
for i,v in PlaceIDs do
	if v == game.PlaceId then
		inPlace = i
	end
end

local controllers = Loader.LoadChildren(script.Controllers.Global, Loader.MatchesName("Controller$"))
if inPlace then
	for _, controller in Loader.LoadChildren(script.Controllers:FindFirstChild(inPlace), Loader.MatchesName("Controller$")) do
		table.insert(controllers, controller)
	end
else
	warn("No place found! Please edit the PlaceIDs module\n\t(ReplicatedStorage.Shared.Constants.PlaceIDs)")
end

for _, controller in controllers do
    if typeof(controller.OnInit) == "function" then
		controller:OnInit()
    end
end
Loader.SpawnAll(controllers, "OnStart")