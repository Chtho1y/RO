---@class RuneShopRewardsItem__Generate_numlv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopRewardsItem__Generate_airShip
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class RuneShopRewardsItem__Generate_levelSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class RuneShopRewardsItem__Generate_rewardsRight_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RuneShopRewardsItem__Generate_rewardsRight
---@field public gameObject UnityEngine.GameObject
---@field public arrived UnityEngine.GameObject
---@field public iconItem RuneShopRewardsItem__Generate_rewardsRight_iconItem
---@field public received UnityEngine.GameObject

---@class RuneShopRewardsItem__Generate_rewardsLeft
---@field public gameObject UnityEngine.GameObject
---@field public arrived UnityEngine.GameObject
---@field public iconItem UnityEngine.GameObject
---@field public received UnityEngine.GameObject

---@class RuneShopRewardsItem__Generate_rewardsBox2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public bgyellow UnityEngine.GameObject

---@class RuneShopRewardsItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rewardsBox2 RuneShopRewardsItem__Generate_rewardsBox2
---@field private rewardsLeft RuneShopRewardsItem__Generate_rewardsLeft
---@field private rewardsRight RuneShopRewardsItem__Generate_rewardsRight
---@field private levelBox2 UnityEngine.GameObject
---@field private levelSlider RuneShopRewardsItem__Generate_levelSlider
---@field private airShip RuneShopRewardsItem__Generate_airShip
---@field private numlv RuneShopRewardsItem__Generate_numlv
---@field private activity UnityEngine.GameObject
---@field private startItem UnityEngine.GameObject
local RuneShopRewardsItemView = class("RuneShopRewardsItemView")

function RuneShopRewardsItemView:ctor()
end

---@private
function RuneShopRewardsItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RuneShopRewardsItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)


end

---@private
function RuneShopRewardsItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RuneShopRewardsItemView:InitGenerate__2(Root, data)
--[[
	RewardsBox2
--]]
	local tmp = Root:Find("RewardsBox2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsBox2 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RuneShopRewardsItemView:InitGenerate__3(Root, data)
--[[
	RewardsBox2/bgyellow
--]]
	local tmp = Root:Find("RewardsBox2/bgyellow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsBox2.bgyellow = tmp
end

---@private
function RuneShopRewardsItemView:InitGenerate__4(Root, data)
--[[
	RewardsBox2/RewardsLeft
--]]
	local tmp = Root:Find("RewardsBox2/RewardsLeft").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsLeft = tmp
end

---@private
function RuneShopRewardsItemView:InitGenerate__5(Root, data)
--[[
	RewardsBox2/RewardsLeft/Arrived
--]]
	local tmp = Root:Find("RewardsBox2/RewardsLeft/Arrived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsLeft.arrived = tmp
	self.rewardsLeft.arrived:SetActive(false)
end

---@private
function RuneShopRewardsItemView:InitGenerate__6(Root, data)
--[[
	RewardsBox2/RewardsLeft/IconItem
--]]
	local tmp = Root:Find("RewardsBox2/RewardsLeft/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsLeft.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.rewardsLeft.iconItem.prefabName = "IconItem"
end

---@private
function RuneShopRewardsItemView:InitGenerate__7(Root, data)
--[[
	RewardsBox2/RewardsLeft/Received
--]]
	local tmp = Root:Find("RewardsBox2/RewardsLeft/Received").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsLeft.received = tmp
	self.rewardsLeft.received:SetActive(false)
end

---@private
function RuneShopRewardsItemView:InitGenerate__8(Root, data)
--[[
	RewardsBox2/RewardsRight
--]]
	local tmp = Root:Find("RewardsBox2/RewardsRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsRight = tmp
end

---@private
function RuneShopRewardsItemView:InitGenerate__9(Root, data)
--[[
	RewardsBox2/RewardsRight/Arrived
--]]
	local tmp = Root:Find("RewardsBox2/RewardsRight/Arrived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsRight.arrived = tmp
	self.rewardsRight.arrived:SetActive(false)
end

---@private
function RuneShopRewardsItemView:InitGenerate__10(Root, data)
--[[
	RewardsBox2/RewardsRight/IconItem
--]]
	local tmp = Root:Find("RewardsBox2/RewardsRight/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsRight.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.rewardsRight.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RuneShopRewardsItemView:InitGenerate__11(Root, data)
--[[
	RewardsBox2/RewardsRight/Received
--]]
	local tmp = Root:Find("RewardsBox2/RewardsRight/Received").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsRight.received = tmp
	self.rewardsRight.received:SetActive(false)
end

---@private
function RuneShopRewardsItemView:InitGenerate__12(Root, data)
--[[
	LevelBox2
--]]
	local tmp = Root:Find("LevelBox2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelBox2 = tmp
end

---@private
function RuneShopRewardsItemView:InitGenerate__13(Root, data)
--[[
	LevelBox2/LevelSlider
--]]
	local tmp = Root:Find("LevelBox2/LevelSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function RuneShopRewardsItemView:InitGenerate__14(Root, data)
--[[
	LevelBox2/LevelSlider/AirShip
--]]
	local tmp = Root:Find("LevelBox2/LevelSlider/AirShip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShip = CommonUtil.BindGridViewItem2LuaStatic("AirShip", tmp)
	self.airShip.prefabName = "AirShip"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RuneShopRewardsItemView:InitGenerate__15(Root, data)
--[[
	LevelBox2/Number/numlv
--]]
	local tmp = Root:Find("LevelBox2/Number/numlv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numlv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RuneShopRewardsItemView:InitGenerate__16(Root, data)
--[[
	LevelBox2/activity
--]]
	local tmp = Root:Find("LevelBox2/activity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activity = tmp
	self.activity:SetActive(false)
end

---@private
function RuneShopRewardsItemView:InitGenerate__17(Root, data)
--[[
	StartItem
--]]
	local tmp = Root:Find("StartItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.startItem = CommonUtil.BindGridViewItem2LuaStatic("StartItem", tmp)
	self.startItem.prefabName = "StartItem"
end

---@private
function RuneShopRewardsItemView:GenerateDestroy()
	if tolua.getpeer(self.activity) ~= nil then
		tolua.setpeer(self.activity, nil)
	end
	if tolua.getpeer(self.numlv) ~= nil then
		tolua.setpeer(self.numlv, nil)
	end
	if tolua.getpeer(self.levelSlider) ~= nil then
		tolua.setpeer(self.levelSlider, nil)
	end
	if tolua.getpeer(self.rewardsRight.received) ~= nil then
		tolua.setpeer(self.rewardsRight.received, nil)
	end
	if self.rewardsRight.iconItem.GenerateDestroy ~= nil then
		self.rewardsRight.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.rewardsRight.iconItem) ~= nil then
		tolua.setpeer(self.rewardsRight.iconItem, nil)
	end
	if tolua.getpeer(self.rewardsRight.arrived) ~= nil then
		tolua.setpeer(self.rewardsRight.arrived, nil)
	end
	if tolua.getpeer(self.rewardsLeft.received) ~= nil then
		tolua.setpeer(self.rewardsLeft.received, nil)
	end
	if self.rewardsLeft.iconItem.GenerateDestroy ~= nil then
		self.rewardsLeft.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.rewardsLeft.iconItem) ~= nil then
		tolua.setpeer(self.rewardsLeft.iconItem, nil)
	end
	if tolua.getpeer(self.rewardsLeft.arrived) ~= nil then
		tolua.setpeer(self.rewardsLeft.arrived, nil)
	end
	if tolua.getpeer(self.rewardsBox2.bgyellow) ~= nil then
		tolua.setpeer(self.rewardsBox2.bgyellow, nil)
	end
	if tolua.getpeer(self.rewardsBox2) ~= nil then
		tolua.setpeer(self.rewardsBox2, nil)
	end
	if tolua.getpeer(self.rewardsLeft) ~= nil then
		tolua.setpeer(self.rewardsLeft, nil)
	end
	self.rewardsLeft = nil
	if tolua.getpeer(self.rewardsRight) ~= nil then
		tolua.setpeer(self.rewardsRight, nil)
	end
	self.rewardsRight = nil
	if tolua.getpeer(self.levelBox2) ~= nil then
		tolua.setpeer(self.levelBox2, nil)
	end
	self.levelBox2 = nil
	if self.airShip.GenerateDestroy ~= nil then
		self.airShip:GenerateDestroy()
	end
	if tolua.getpeer(self.airShip) ~= nil then
		tolua.setpeer(self.airShip, nil)
	end
	self.airShip = nil
	if self.startItem.GenerateDestroy ~= nil then
		self.startItem:GenerateDestroy()
	end
	if tolua.getpeer(self.startItem) ~= nil then
		tolua.setpeer(self.startItem, nil)
	end
	self.startItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RuneShopRewardsItemView