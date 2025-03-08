---@class UIChangeHead__Generate_unlockBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHead__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIChangeHead__Generate_usedBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHead__Generate_conditionTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeHead__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIChangeHead__Generate_changeList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIChangeHead__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHead__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHead__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChangeHead__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIChangeHead__Generate_uIAnimator
---@field private AnyBtn UIChangeHead__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIChangeHead__Generate_btnClose
---@field private changeList UIChangeHead__Generate_changeList
---@field private content UIChangeHead__Generate_content
---@field private unlockConditions UnityEngine.GameObject
---@field private conditionTxt UIChangeHead__Generate_conditionTxt
---@field private bottom UnityEngine.GameObject
---@field private usedBtn UIChangeHead__Generate_usedBtn
---@field private text UIChangeHead__Generate_text
---@field private unlockBtn UIChangeHead__Generate_unlockBtn
local UIChangeHeadView = class("UIChangeHeadView", require("UIViewBase"))

function UIChangeHeadView:ctor()
end

---@private
function UIChangeHeadView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChangeHeadView:InitGenerate(Root, data)
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
	self:InitGenerate__13(Root,data)


end

---@private
function UIChangeHeadView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIChangeHeadView:InitGenerate__2(Root, data)
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
function UIChangeHeadView:InitGenerate__3(Root, data)
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
function UIChangeHeadView:InitGenerate__4(Root, data)
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
function UIChangeHeadView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ChangeList
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ChangeList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChangeHeadView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ChangeList/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ChangeList/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIChangeHeadView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/UnlockConditions
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/UnlockConditions").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.unlockConditions = tmp
end

---@private
function UIChangeHeadView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/UnlockConditions/ConditionTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/UnlockConditions/ConditionTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.conditionTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeHeadView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIChangeHeadView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/UsedBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/UsedBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.usedBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/UsedBtn/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/UsedBtn/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIChangeHeadView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/UnlockBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/UnlockBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.unlockBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadView:GenerateDestroy()
	if tolua.getpeer(self.unlockBtn) ~= nil then
		tolua.setpeer(self.unlockBtn, nil)
	end
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	if tolua.getpeer(self.usedBtn) ~= nil then
		tolua.setpeer(self.usedBtn, nil)
	end
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	if tolua.getpeer(self.conditionTxt) ~= nil then
		tolua.setpeer(self.conditionTxt, nil)
	end
	if tolua.getpeer(self.unlockConditions) ~= nil then
		tolua.setpeer(self.unlockConditions, nil)
	end
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.changeList) ~= nil then
		tolua.setpeer(self.changeList, nil)
	end
	self.changeList = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChangeHeadView