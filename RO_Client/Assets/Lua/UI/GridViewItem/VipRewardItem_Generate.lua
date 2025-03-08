---@class VipRewardItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class VipRewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private iconItem VipRewardItem__Generate_iconItem
---@field private check UnityEngine.GameObject
local VipRewardItemView = class("VipRewardItemView")

function VipRewardItemView:ctor()
end

---@private
function VipRewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function VipRewardItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function VipRewardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function VipRewardItemView:InitGenerate__2(Root, data)
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
function VipRewardItemView:InitGenerate__3(Root, data)
--[[
	Check
--]]
	local tmp = Root:Find("Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.check = tmp
end

---@private
function VipRewardItemView:GenerateDestroy()
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.check) ~= nil then
		tolua.setpeer(self.check, nil)
	end
	self.check = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return VipRewardItemView