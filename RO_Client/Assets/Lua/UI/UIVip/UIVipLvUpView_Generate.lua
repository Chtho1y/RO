---@class UIVipLvUp__Generate_curVipNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVipLvUp__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVipLvUp__Generate_vipFrame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVipLvUp__Generate_reward
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIVipLvUp__Generate_vipUnlockDesItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIVipLvUp__Generate_gainList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIVipLvUp__Generate_godSeal
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIVipLvUp__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVipLvUp__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIVipLvUp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIVipLvUp__Generate_uIAnimator
---@field private AnyBtn UIVipLvUp__Generate_AnyBtn
---@field private godSeal UIVipLvUp__Generate_godSeal
---@field private gainList UIVipLvUp__Generate_gainList
---@field private vipUnlockDesItem UIVipLvUp__Generate_vipUnlockDesItem
---@field private reward UIVipLvUp__Generate_reward
---@field private vipFrame UIVipLvUp__Generate_vipFrame
---@field private vipIcon UIVipLvUp__Generate_vipIcon
---@field private curVipNameTxt UIVipLvUp__Generate_curVipNameTxt
local UIVipLvUpView = class("UIVipLvUpView", require("UIViewBase"))

function UIVipLvUpView:ctor()
end

---@private
function UIVipLvUpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVipLvUpView:InitGenerate(Root, data)
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


end

---@private
function UIVipLvUpView:InitGenerate__1(Root, data)
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
function UIVipLvUpView:InitGenerate__2(Root, data)
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
function UIVipLvUpView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/GodSeal
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.godSeal = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIVipLvUpView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/GodSeal/Content/Gain/GainList
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Content/Gain/GainList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gainList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIVipLvUpView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/GodSeal/Content/Gain/GainList/Viewport/Content/VipUnlockDesItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Content/Gain/GainList/Viewport/Content/VipUnlockDesItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipUnlockDesItem = CommonUtil.BindGridViewItem2LuaStatic("VipUnlockDesItem", tmp)
	self.vipUnlockDesItem.prefabName = "VipUnlockDesItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIVipLvUpView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GodSeal/Content/Reward
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Content/Reward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIVipLvUpView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/GodSeal/Mask/SealPlay/Seal/VipFrame
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Mask/SealPlay/Seal/VipFrame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipFrame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipLvUpView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/GodSeal/Mask/SealPlay/Seal/VipIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Mask/SealPlay/Seal/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipLvUpView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/GodSeal/Frame/Title/CurVipNameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/GodSeal/Frame/Title/CurVipNameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curVipNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipLvUpView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.godSeal) ~= nil then
		tolua.setpeer(self.godSeal, nil)
	end
	self.godSeal = nil
	if tolua.getpeer(self.gainList) ~= nil then
		tolua.setpeer(self.gainList, nil)
	end
	self.gainList = nil
	if self.vipUnlockDesItem.GenerateDestroy ~= nil then
		self.vipUnlockDesItem:GenerateDestroy()
	end
	if tolua.getpeer(self.vipUnlockDesItem) ~= nil then
		tolua.setpeer(self.vipUnlockDesItem, nil)
	end
	self.vipUnlockDesItem = nil
	if tolua.getpeer(self.reward) ~= nil then
		tolua.setpeer(self.reward, nil)
	end
	self.reward = nil
	if tolua.getpeer(self.vipFrame) ~= nil then
		tolua.setpeer(self.vipFrame, nil)
	end
	self.vipFrame = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.curVipNameTxt) ~= nil then
		tolua.setpeer(self.curVipNameTxt, nil)
	end
	self.curVipNameTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVipLvUpView