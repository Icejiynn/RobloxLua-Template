local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local useButtonState = require(script.Parent.useButtonState)

type Properties = {
	Button: Instance,
	HoverScale: number | nil,
	ClickScale: number | nil
}

return function (props: Properties)
	props.HoverScale = 1.2
	props.ClickScale = 0.9
	
	local hover,click,event = useButtonState()

	return Fusion.Hydrate(props.Button) {
		[Fusion.OnEvent("MouseEnter")] = event.MouseEnter,
		[Fusion.OnEvent("MouseLeave")] = event.MouseLeave,
		[Fusion.OnEvent("MouseButton1Down")] = event.MouseButton1Down,
		[Fusion.OnEvent("MouseButton1Up")] = event.MouseButton1Up,
		[Fusion.Children] = {
			Fusion.New("UIScale") {
				Scale = Fusion.Spring(Fusion.Computed(function() 
					return if click:get() then props.ClickScale 
							else if hover:get() then props.HoverScale 
							else 1
				end), 30, 0.35)
			}
		}
	}
end
