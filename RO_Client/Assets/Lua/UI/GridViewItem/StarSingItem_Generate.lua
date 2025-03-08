---@class StarSingItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class StarSingItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class StarSingItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private num StarSingItem__Generate_num
---@field private iconItem StarSingItem__Generate_iconItem
local StarSingItemView = class("StarSingItemView")

function StarSingItemView:ctor()
end

---@private
function StarSingItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function StarSingItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function StarSingItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function StarSingItemView:InitGenerate__2(Root, data)
--[[
	num
--]]
	local tmp = Root:Find("num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function StarSingItemView:InitGenerate__3(Root, data)
--[[
	IconItem
--]]
	local tmp = Root:Find("IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function StarSingItemView:GenerateDestroy()
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return StarSingItemView