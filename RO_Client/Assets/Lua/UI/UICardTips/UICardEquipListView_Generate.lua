---@class UICardEquipList__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardEquipList__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardEquipList__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardEquipList__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UICardEquipList__Generate_uIAnimator
---@field private AnyBtn UICardEquipList__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bg UnityEngine.GameObject
---@field private btnClose UICardEquipList__Generate_btnClose
---@field private card1 UnityEngine.GameObject
---@field private card2 UnityEngine.GameObject
---@field private card3 UnityEngine.GameObject
---@field private card4 UnityEngine.GameObject
---@field private card5 UnityEngine.GameObject
---@field private card6 UnityEngine.GameObject
local UICardEquipListView = class("UICardEquipListView", require("UIViewBase"))

function UICardEquipListView:ctor()
end

---@private
function UICardEquipListView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardEquipListView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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


end

---@private
function UICardEquipListView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UICardEquipListView:InitGenerate__2(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UICardEquipListView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardEquipListView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UICardEquipListView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function UICardEquipListView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardEquipListView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card1 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card1.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card2 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card2.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card3 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card3.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card4 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card4.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card5 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card5.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/CardEquipItem5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardEquipItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card6 = CommonUtil.BindGridViewItem2LuaStatic("CardEquipItem", tmp)
	self.card6.prefabName = "CardEquipItem"
end

---@private
function UICardEquipListView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.card1.GenerateDestroy ~= nil then
		self.card1:GenerateDestroy()
	end
	if tolua.getpeer(self.card1) ~= nil then
		tolua.setpeer(self.card1, nil)
	end
	self.card1 = nil
	if self.card2.GenerateDestroy ~= nil then
		self.card2:GenerateDestroy()
	end
	if tolua.getpeer(self.card2) ~= nil then
		tolua.setpeer(self.card2, nil)
	end
	self.card2 = nil
	if self.card3.GenerateDestroy ~= nil then
		self.card3:GenerateDestroy()
	end
	if tolua.getpeer(self.card3) ~= nil then
		tolua.setpeer(self.card3, nil)
	end
	self.card3 = nil
	if self.card4.GenerateDestroy ~= nil then
		self.card4:GenerateDestroy()
	end
	if tolua.getpeer(self.card4) ~= nil then
		tolua.setpeer(self.card4, nil)
	end
	self.card4 = nil
	if self.card5.GenerateDestroy ~= nil then
		self.card5:GenerateDestroy()
	end
	if tolua.getpeer(self.card5) ~= nil then
		tolua.setpeer(self.card5, nil)
	end
	self.card5 = nil
	if self.card6.GenerateDestroy ~= nil then
		self.card6:GenerateDestroy()
	end
	if tolua.getpeer(self.card6) ~= nil then
		tolua.setpeer(self.card6, nil)
	end
	self.card6 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardEquipListView