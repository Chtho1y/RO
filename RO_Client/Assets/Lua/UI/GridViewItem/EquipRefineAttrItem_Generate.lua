---@class EquipRefineAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private equipBaseAttrItem UnityEngine.GameObject
---@field private image UnityEngine.GameObject
---@field private refinePercentItem UnityEngine.GameObject
local EquipRefineAttrItemView = class("EquipRefineAttrItemView")

function EquipRefineAttrItemView:ctor()
end

---@private
function EquipRefineAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipRefineAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function EquipRefineAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipRefineAttrItemView:InitGenerate__2(Root, data)
--[[
	EquipBaseAttrItem
--]]
	local tmp = Root:Find("EquipBaseAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBaseAttrItem = CommonUtil.BindGridViewItem2LuaStatic("EquipBaseAttrItem", tmp)
	self.equipBaseAttrItem.prefabName = "EquipBaseAttrItem"
end

---@private
function EquipRefineAttrItemView:InitGenerate__3(Root, data)
--[[
	Image
--]]
	local tmp = Root:Find("Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp
end

---@private
function EquipRefineAttrItemView:InitGenerate__4(Root, data)
--[[
	RefinePercentItem
--]]
	local tmp = Root:Find("RefinePercentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refinePercentItem = CommonUtil.BindGridViewItem2LuaStatic("RefinePercentItem", tmp)
	self.refinePercentItem.prefabName = "RefinePercentItem"
end

---@private
function EquipRefineAttrItemView:GenerateDestroy()
	if self.equipBaseAttrItem.GenerateDestroy ~= nil then
		self.equipBaseAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipBaseAttrItem) ~= nil then
		tolua.setpeer(self.equipBaseAttrItem, nil)
	end
	self.equipBaseAttrItem = nil
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	if self.refinePercentItem.GenerateDestroy ~= nil then
		self.refinePercentItem:GenerateDestroy()
	end
	if tolua.getpeer(self.refinePercentItem) ~= nil then
		tolua.setpeer(self.refinePercentItem, nil)
	end
	self.refinePercentItem = nil
	self.inited = false
end
return EquipRefineAttrItemView