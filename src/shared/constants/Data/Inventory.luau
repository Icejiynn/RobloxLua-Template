export type Item = "coins" | "gems" | "experience"
export type Structure = { [Item]: number | nil }

local TEMPLATE: Structure = {coins = 500, experience = 0}

local Inventory = {}

Inventory.TEMPLATE = TEMPLATE

return Inventory