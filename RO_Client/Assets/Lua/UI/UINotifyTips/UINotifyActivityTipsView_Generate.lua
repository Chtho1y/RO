---@class UINotifyActivityTips__Generate_txtDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UINotifyActivityTips__Generate_activityScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UINotifyActivityTips__Generate_activityScrollList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UINotifyActivityTips__Generate_activityScrollList_content

---@class UINotifyActivityTips__Generate_notifyScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UINotifyActivityTips__Generate_notifyScrollList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UINotifyActivityTips__Generate_notifyScrollList_content

---@class UINotifyActivityTips__Generate_toggleNotify
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UINotifyActivityTips__Generate_toggleActivity
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UINotifyActivityTips__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyActivityTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyActivityTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UINotifyActivityTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UINotifyActivityTips__Generate_uIAnimator
---@field private AnyBtn UINotifyActivityTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private BtnClose UINotifyActivityTips__Generate_BtnClose
---@field private toggleActivity UINotifyActivityTips__Generate_toggleActivity
---@field private toggleNotify UINotifyActivityTips__Generate_toggleNotify
---@field private notifyScrollList UINotifyActivityTips__Generate_notifyScrollList
---@field private activityScrollList UINotifyActivityTips__Generate_activityScrollList
---@field private actEmptyNode UnityEngine.GameObject
---@field private txtDsc UINotifyActivityTips__Generate_txtDsc
local UINotifyActivityTipsView = class("UINotifyActivityTipsView", require("UIViewBase"))

function UINotifyActivityTipsView:ctor()
end

---@private
function UINotifyActivityTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UINotifyActivityTipsView:InitGenerate(Root, data)
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
function UINotifyActivityTipsView:InitGenerate__1(Root, data)
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
function UINotifyActivityTipsView:InitGenerate__2(Root, data)
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
function UINotifyActivityTipsView:InitGenerate__3(Root, data)
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
function UINotifyActivityTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ClostBox/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/ClostBox/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UINotifyActivityTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleActivity
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleActivity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleActivity = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UINotifyActivityTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleNotify
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleNotify").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleNotify = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UINotifyActivityTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ScrollViewNotify
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewNotify").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notifyScrollList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UINotifyActivityTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ScrollViewNotify/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewNotify/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notifyScrollList.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UINotifyActivityTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/ScrollViewActivity
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewActivity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activityScrollList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UINotifyActivityTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/ScrollViewActivity/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewActivity/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activityScrollList.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UINotifyActivityTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/ActivityEmpty
--]]
	local tmp = Root:Find("UIAnimator/Window/ActivityEmpty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.actEmptyNode = tmp
end

---@private
function UINotifyActivityTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/ActivityEmpty/TalkBox/TxtDsc
--]]
	local tmp = Root:Find("UIAnimator/Window/ActivityEmpty/TalkBox/TxtDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.txtDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UINotifyActivityTipsView:GenerateDestroy()
	if tolua.getpeer(self.activityScrollList.content) ~= nil then
		tolua.setpeer(self.activityScrollList.content, nil)
	end
	if tolua.getpeer(self.notifyScrollList.content) ~= nil then
		tolua.setpeer(self.notifyScrollList.content, nil)
	end
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
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	if tolua.getpeer(self.toggleActivity) ~= nil then
		tolua.setpeer(self.toggleActivity, nil)
	end
	self.toggleActivity = nil
	if tolua.getpeer(self.toggleNotify) ~= nil then
		tolua.setpeer(self.toggleNotify, nil)
	end
	self.toggleNotify = nil
	if tolua.getpeer(self.notifyScrollList) ~= nil then
		tolua.setpeer(self.notifyScrollList, nil)
	end
	self.notifyScrollList = nil
	if tolua.getpeer(self.activityScrollList) ~= nil then
		tolua.setpeer(self.activityScrollList, nil)
	end
	self.activityScrollList = nil
	if tolua.getpeer(self.actEmptyNode) ~= nil then
		tolua.setpeer(self.actEmptyNode, nil)
	end
	self.actEmptyNode = nil
	if tolua.getpeer(self.txtDsc) ~= nil then
		tolua.setpeer(self.txtDsc, nil)
	end
	self.txtDsc = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UINotifyActivityTipsView