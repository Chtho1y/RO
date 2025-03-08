---@class UIBagCardListTips__Generate_DscNoCard
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBagCardListTips__Generate_cardScrollView_content
---@field public gameObject UnityEngine.GameObject
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter

---@class UIBagCardListTips__Generate_cardScrollView
---@field public gameObject UnityEngine.GameObject
---@field public content UIBagCardListTips__Generate_cardScrollView_content

---@class UIBagCardListTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBagCardListTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBagCardListTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIBagCardListTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIBagCardListTips__Generate_uIAnimator
---@field private AnyBtn UIBagCardListTips__Generate_AnyBtn
---@field private btnClose UIBagCardListTips__Generate_btnClose
---@field private cardScrollView UIBagCardListTips__Generate_cardScrollView
---@field private dscBox UnityEngine.GameObject
---@field private DscNoCard UIBagCardListTips__Generate_DscNoCard
local UIBagCardListTipsView = class("UIBagCardListTipsView", require("UIViewBase"))

function UIBagCardListTipsView:ctor()
end

---@private
function UIBagCardListTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBagCardListTipsView:InitGenerate(Root, data)
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
function UIBagCardListTipsView:InitGenerate__1(Root, data)
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
function UIBagCardListTipsView:InitGenerate__2(Root, data)
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
function UIBagCardListTipsView:InitGenerate__3(Root, data)
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
function UIBagCardListTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView = tmp
end

---@private
function UIBagCardListTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView.content = tmp

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)
end

---@private
function UIBagCardListTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIBagCardListTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.DscNoCard = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBagCardListTipsView:GenerateDestroy()
	if tolua.getpeer(self.cardScrollView.content) ~= nil then
		tolua.setpeer(self.cardScrollView.content, nil)
	end
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
	if tolua.getpeer(self.cardScrollView) ~= nil then
		tolua.setpeer(self.cardScrollView, nil)
	end
	self.cardScrollView = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if tolua.getpeer(self.DscNoCard) ~= nil then
		tolua.setpeer(self.DscNoCard, nil)
	end
	self.DscNoCard = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBagCardListTipsView