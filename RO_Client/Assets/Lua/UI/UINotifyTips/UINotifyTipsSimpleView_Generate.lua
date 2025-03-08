---@class UINotifyTipsSimple__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyTipsSimple__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UINotifyTipsSimple__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UINotifyTipsSimple__Generate_boardTitle
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UINotifyTipsSimple__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyTipsSimple__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UINotifyTipsSimple__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UINotifyTipsSimple__Generate_uIAnimator
---@field private AnyBtn UINotifyTipsSimple__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private boardTitle UINotifyTipsSimple__Generate_boardTitle
---@field private scrollView UINotifyTipsSimple__Generate_scrollView
---@field private desTxt UINotifyTipsSimple__Generate_desTxt
---@field private BtnClose UINotifyTipsSimple__Generate_BtnClose
local UINotifyTipsSimpleView = class("UINotifyTipsSimpleView", require("UIViewBase"))

function UINotifyTipsSimpleView:ctor()
end

---@private
function UINotifyTipsSimpleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UINotifyTipsSimpleView:InitGenerate(Root, data)
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
function UINotifyTipsSimpleView:InitGenerate__1(Root, data)
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
function UINotifyTipsSimpleView:InitGenerate__2(Root, data)
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
function UINotifyTipsSimpleView:InitGenerate__3(Root, data)
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
function UINotifyTipsSimpleView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BoardTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/BoardTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boardTitle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UINotifyTipsSimpleView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UINotifyTipsSimpleView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UINotifyTipsSimpleView:InitGenerate__7(Root, data)
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
function UINotifyTipsSimpleView:GenerateDestroy()
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
	if tolua.getpeer(self.boardTitle) ~= nil then
		tolua.setpeer(self.boardTitle, nil)
	end
	self.boardTitle = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UINotifyTipsSimpleView