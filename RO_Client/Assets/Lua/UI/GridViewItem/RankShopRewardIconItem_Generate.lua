---@class RankShopRewardIconItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankShopRewardIconItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private iconSmallItem RankShopRewardIconItem__Generate_iconSmallItem
local RankShopRewardIconItemView = class("RankShopRewardIconItemView")

function RankShopRewardIconItemView:ctor()
end

---@private
function RankShopRewardIconItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RankShopRewardIconItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function RankShopRewardIconItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RankShopRewardIconItemView:InitGenerate__2(Root, data)
--[[
	IconSmallItem
--]]
	local tmp = Root:Find("IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconSmallItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankShopRewardIconItemView:GenerateDestroy()
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RankShopRewardIconItemView