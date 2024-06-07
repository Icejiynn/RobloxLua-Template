export type Structure = Model & {
	Humanoid: Humanoid & {
		Animator: Animator
	},
	HumanoidRootPart: BasePart
}

local Character = {}

return Character