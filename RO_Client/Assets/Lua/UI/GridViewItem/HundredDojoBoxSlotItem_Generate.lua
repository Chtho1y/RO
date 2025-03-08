---@class HundredDojoBoxSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
local HundredDojoBoxSlotItemView = class("HundredDojoBoxSlotItemView")

function HundredDojoBoxSlotItemView:ctor()
end

---@private
function HundredDojoBoxSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HundredDojoBoxSlotItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function HundredDojoBoxSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HundredDojoBoxSlotItemView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HundredDojoBoxSlotItemView