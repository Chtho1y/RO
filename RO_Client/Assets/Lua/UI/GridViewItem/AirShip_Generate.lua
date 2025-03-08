---@class AirShip__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
local AirShipView = class("AirShipView")

function AirShipView:ctor()
end

---@private
function AirShipView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function AirShipView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function AirShipView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function AirShipView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return AirShipView