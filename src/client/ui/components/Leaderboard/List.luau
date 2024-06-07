local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local UserService = game:GetService("UserService")
local useAsync = require(StarterPlayer.StarterPlayerScripts.Client.ui.hooks.useAsync)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Properties = {
	Instance: typeof(workspace.Leaderboards.leaderboard.SurfaceGui),
	Data: {{key: string, value: number}}
}

return function(props: Properties)
	local template = props.Instance.main.list.scroll.template :: Frame
	template.Visible = false

	return Fusion.Hydrate(template.Parent :: ScrollingFrame) {
		[Fusion.Children] = Fusion.ForPairs(props.Data, function(index, data)
			local info, infoDisconnect = useAsync(function()  
				return UserService:GetUserInfosByUserIdsAsync({tonumber(data.key)})[1]
			end)
			local thumbnail, thumbnailDisconnect = useAsync(function()  
				return Players:GetUserThumbnailAsync(tonumber(data.key), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
			end)
			local instance = Fusion.Hydrate(template:Clone()) {
				LayoutOrder = index,
				Visible = true,
				Parent = template.Parent,
				[Fusion.Cleanup] = function()
					infoDisconnect()
					thumbnailDisconnect()
				end
			}

			Fusion.Hydrate(instance:FindFirstChild("name") :: TextLabel) {
				Text = Fusion.Computed(function()
					local info = info:get() 
					return `{index}.  {if info then info.Username else ""}`
				end)
			}
			Fusion.Hydrate(instance:FindFirstChild("image") :: ImageLabel) {
				Image = Fusion.Computed(function()  
					return thumbnail:get() or ""
				end)
			}
			Fusion.Hydrate(instance:FindFirstChild("value") :: TextLabel) {
				Text = `{data.value}`
			}

			return index, instance
		end, function(a0: number, a1: Instance, a2)  
			a1:Destroy()
		end)
	}
end
