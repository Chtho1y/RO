---@class UIStarRewardsTips__Generate_buyLimitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIStarRewardsTips__Generate_goodsList
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIStarRewardsTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIStarRewardsTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIStarRewardsTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIStarRewardsTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIStarRewardsTips__Generate_uIAnimator
---@field private AnyBtn UIStarRewardsTips__Generate_AnyBtn
---@field private btnClose UIStarRewardsTips__Generate_btnClose
---@field private goodsList UIStarRewardsTips__Generate_goodsList
---@field private starSingItem UnityEngine.GameObject
---@field private buyLimitTxt UIStarRewardsTips__Generate_buyLimitTxt
local UIStarRewardsTipsView = class("UIStarRewardsTipsView", require("UIViewBase"))

function UIStarRewardsTipsView:ctor()
end

---@private
function UIStarRewardsTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIStarRewardsTipsView:InitGenerate(Root, data)
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


end

---@private
function UIStarRewardsTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIStarRewardsTipsView:InitGenerate__2(Root, data)
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
function UIStarRewardsTipsView:InitGenerate__3(Root, data)
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
function UIStarRewardsTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStarRewardsTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/GoodsList
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goodsList = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIStarRewardsTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GoodsList/Viewport/Content/StarSingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList/Viewport/Content/StarSingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starSingItem = CommonUtil.BindGridViewItem2LuaStatic("StarSingItem", tmp)
	self.starSingItem.prefabName = "StarSingItem"
end

---@private
function UIStarRewardsTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/Title/BuyLimitTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Title/BuyLimitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyLimitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIStarRewardsTipsView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.goodsList) ~= nil then
		tolua.setpeer(self.goodsList, nil)
	end
	self.goodsList = nil
	if self.starSingItem.GenerateDestroy ~= nil then
		self.starSingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.starSingItem) ~= nil then
		tolua.setpeer(self.starSingItem, nil)
	end
	self.starSingItem = nil
	if tolua.getpeer(self.buyLimitTxt) ~= nil then
		tolua.setpeer(self.buyLimitTxt, nil)
	end
	self.buyLimitTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIStarRewardsTipsView