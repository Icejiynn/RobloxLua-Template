local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)

local UIComponent = {}
UIComponent.__index = UIComponent

function UIComponent.new(...)
	local self = {__masterTrove = Trove.new(), rendering = true, __once = false, __func = nil :: (self: Self) -> ()?}
	self.trove = self.__masterTrove:Extend()
	return setmetatable(self, UIComponent)
end

export type Self = typeof(UIComponent.new(...))

function UIComponent.__render(self: Self, func: (self: Self) -> ())
	if not self.__func then
		self.__func = func
	end
	func(self)
end

function UIComponent.toggleRender(self: Self)
	self.trove:Clean()
	self.rendering = not self.rendering
	if self.rendering and self.__func then
		self:__render(self.__func)
	end
end

function UIComponent.once(self: Self, func: () -> ())
	if not self.__once then
		return
	end
	self.__once = true
	self.__masterTrove:Add(task.spawn(func))
end

function UIComponent.destroy(self: Self)
	self.trove:Destroy()
end

return function(func: (component: typeof(UIComponent.new(...))) -> ())
	local component = UIComponent.new()
	component:__render(func)
	return function()
		component:destroy()
	end
end
