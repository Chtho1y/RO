---@class UIAttrAddTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
local UIAttrAddTipsView = class("UIAttrAddTipsView", require("UIViewBase"))

function UIAttrAddTipsView:ctor()
end

---@private
function UIAttrAddTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIAttrAddTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIAttrAddTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIAttrAddTipsView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIAttrAddTipsView