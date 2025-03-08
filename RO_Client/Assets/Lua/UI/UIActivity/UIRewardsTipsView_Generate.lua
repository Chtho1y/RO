---@class UIRewardsTips__Generate_goodsList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIRewardsTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRewardsTips__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRewardsTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRewardsTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIRewardsTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIRewardsTips__Generate_uIAnimator
---@field private AnyBtn UIRewardsTips__Generate_AnyBtn
---@field private textTitle UIRewardsTips__Generate_textTitle
---@field private btnClose UIRewardsTips__Generate_btnClose
---@field private goodsList UIRewardsTips__Generate_goodsList
local UIRewardsTipsView = class("UIRewardsTipsView", require("UIViewBase"))

function UIRewardsTipsView:ctor()
end

---@private
function UIRewardsTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRewardsTipsView:InitGenerate(Root, data)
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


end

---@private
function UIRewardsTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIRewardsTipsView:InitGenerate__2(Root, data)
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
function UIRewardsTipsView:InitGenerate__3(Root, data)
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
function UIRewardsTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIRewardsTipsView:InitGenerate__5(Root, data)
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
function UIRewardsTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GoodsList
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goodsList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIRewardsTipsView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.goodsList) ~= nil then
		tolua.setpeer(self.goodsList, nil)
	end
	self.goodsList = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRewardsTipsView