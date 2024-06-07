local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local UIContainer = require(StarterPlayer.StarterPlayerScripts.Client.Constants.UIContainer)
local Store = require(StarterPlayer.StarterPlayerScripts.Client.Store)
local usePlayerUserId = require(StarterPlayer.StarterPlayerScripts.Client.UI.hooks.usePlayerUserId)
local ScreenGui = require(StarterPlayer.StarterPlayerScripts.Client.UI.components.ui.ScreenGui)
local useDeferedValue = require(StarterPlayer.StarterPlayerScripts.Client.UI.hooks.useDeferedValue)
local useDelayedValue = require(StarterPlayer.StarterPlayerScripts.Client.UI.hooks.useDelayedValue)
local useSelector = require(StarterPlayer.StarterPlayerScripts.Client.UI.hooks.useSelector)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Data = require(ReplicatedStorage.Shared.Constants.Data)

local function selectItem(user: string, key: string)
	return function(state: Store.State)
		return (state.data.inventory[user] or Data.TEMPLATE.inventory)[key] or 0
	end
end

local FRAME = UIContainer.inventory

return function ()
	local frame = FRAME:Clone()
	local screenGui = ScreenGui({
		DisplayOrder = 0,
		[Fusion.Children] = frame,
	})

	local function applyValue(key: string)
		local value = useSelector(selectItem(usePlayerUserId(), key))
		local tween = Fusion.Tween(value, TweenInfo.new(0.6, Enum.EasingStyle.Linear))

		local frame = frame[key] :: typeof(frame.coins)
		Fusion.Hydrate(frame.TextLabel) {
			Text = Fusion.Computed(function()
				return `{math.floor(tween:get() or 0)}`
			end),
			[Fusion.Cleanup] = Store:subscribe(selectItem(tostring(Players.LocalPlayer.UserId), key), function(new, old)
				if (new and old) then
					local effect = frame.TextLabel:Clone()
					local diff = (new :: number) - (old :: number)
					if (diff == 0) then
						return
					end
					local sign = if diff >= 0 then "+" else "-"
					
					Fusion.Hydrate(effect) {
						Parent = frame,
						Text = `{sign}{diff}`,
						Position = Fusion.Tween(useDeferedValue(frame.TextLabel.Position, UDim2.fromScale(frame.TextLabel.Position.X.Scale, 1.5)), TweenInfo.new(1.25)),
						TextTransparency = Fusion.Tween(useDelayedValue(0, 1, 0.9), TweenInfo.new(0.2)),
						Rotation = math.random(-25, 25),
					}
	
					task.delay(1.25, function()
						effect:Destroy()
					end)
				end
			end),
		}
	end

	for _, v in frame:GetChildren() do
		if (v:IsA("Frame")) then
			applyValue(v.Name)
		end
	end

	return screenGui
end