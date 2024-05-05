local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Store = require(StarterPlayer.StarterPlayerScripts.Client.Store)
local ScreenGui = require(StarterPlayer.StarterPlayerScripts.Client.ui.components.ui.ScreenGui)
local useDeferedValue = require(StarterPlayer.StarterPlayerScripts.Client.ui.hooks.useDeferedValue)
local useDelayedValue = require(StarterPlayer.StarterPlayerScripts.Client.ui.hooks.useDelayedValue)
local useSelector = require(StarterPlayer.StarterPlayerScripts.Client.ui.hooks.useSelector)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local selectors = require(ReplicatedStorage.Shared.store.selectors)

local FRAME = ReplicatedStorage.UI.balance

return function ()
	local frame = FRAME:Clone()
	local screenGui = ScreenGui({
		DisplayOrder = 0,
		[Fusion.Children] = frame,
	})

	local function applyValue(key: string)
		local disconnect: () -> ()
		local value = useSelector(
			selectors.selectPlayerBalanceValue(tostring(Players.LocalPlayer.UserId), key)
		)
		local tween = Fusion.Tween(value, TweenInfo.new(0.6, Enum.EasingStyle.Linear))

		local frame = frame[key] :: typeof(frame.coins)
		Fusion.Hydrate(frame.TextLabel) {
			Text = Fusion.Computed(function()
				return `{math.floor(tween:get() or 0)}`
			end),
			[Fusion.Cleanup] = disconnect,
		}

		disconnect = Store:subscribe(selectors.selectPlayerBalanceValue(tostring(Players.LocalPlayer.UserId), key), function(new, old)
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
		end)
	end

	for _, v in frame:GetChildren() do
		if (v:IsA("Frame")) then
			applyValue(v.Name)
		end
	end

	return screenGui, function ()
		screenGui:Destroy()
	end
end