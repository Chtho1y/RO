---@class TreasureHeroSlotItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TreasureHeroSlotItem__Generate_btnAdd
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TreasureHeroSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private btnAdd TreasureHeroSlotItem__Generate_btnAdd
---@field private headItem TreasureHeroSlotItem__Generate_headItem
local TreasureHeroSlotItemView = class("TreasureHeroSlotItemView")

function TreasureHeroSlotItemView:ctor()
end

---@private
function TreasureHeroSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TreasureHeroSlotItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function TreasureHeroSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function TreasureHeroSlotItemView:InitGenerate__2(Root, data)
--[[
	BtnAdd
--]]
	local tmp = Root:Find("BtnAdd").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAdd = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TreasureHeroSlotItemView:InitGenerate__3(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TreasureHeroSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.btnAdd) ~= nil then
		tolua.setpeer(self.btnAdd, nil)
	end
	self.btnAdd = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	self.inited = false
end
return TreasureHeroSlotItemView