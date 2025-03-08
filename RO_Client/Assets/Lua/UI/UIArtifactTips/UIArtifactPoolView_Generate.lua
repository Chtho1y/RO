---@class UIArtifactPool__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactPool__Generate_notice_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIArtifactPool__Generate_notice
---@field public gameObject UnityEngine.GameObject
---@field public text UIArtifactPool__Generate_notice_text

---@class UIArtifactPool__Generate_next_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIArtifactPool__Generate_iconitem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIArtifactPool__Generate_next
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public text UIArtifactPool__Generate_next_text

---@class UIArtifactPool__Generate_opend_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIArtifactPool__Generate_iconitem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIArtifactPool__Generate_opend
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public text UIArtifactPool__Generate_opend_text

---@class UIArtifactPool__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactPool__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIArtifactPool__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIArtifactPool__Generate_uIAnimator
---@field private AnyBtn UIArtifactPool__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private opend UIArtifactPool__Generate_opend
---@field private iconitem UIArtifactPool__Generate_iconitem
---@field private next UIArtifactPool__Generate_next
---@field private iconitem1 UIArtifactPool__Generate_iconitem1
---@field private bottomBox UnityEngine.GameObject
---@field private notice UIArtifactPool__Generate_notice
---@field private btnClose UIArtifactPool__Generate_btnClose
local UIArtifactPoolView = class("UIArtifactPoolView", require("UIViewBase"))

function UIArtifactPoolView:ctor()
end

---@private
function UIArtifactPoolView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIArtifactPoolView:InitGenerate(Root, data)
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
function UIArtifactPoolView:InitGenerate__1(Root, data)
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
function UIArtifactPoolView:InitGenerate__2(Root, data)
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
function UIArtifactPoolView:InitGenerate__3(Root, data)
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
function UIArtifactPoolView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/Opend
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Opend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.opend = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIArtifactPoolView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/Opend/Viewport/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Opend/Viewport/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconitem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconitem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIArtifactPoolView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Opend/Title/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Opend/Title/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.opend.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIArtifactPoolView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/Next
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Next").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.next = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIArtifactPoolView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Next/Viewport/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Next/Viewport/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconitem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconitem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIArtifactPoolView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Next/Title/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Next/Title/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.next.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIArtifactPoolView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function UIArtifactPoolView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Notice
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Notice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice = tmp
end

---@private
function UIArtifactPoolView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Notice/TalkBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Notice/TalkBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIArtifactPoolView:InitGenerate__13(Root, data)
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
function UIArtifactPoolView:GenerateDestroy()
	if tolua.getpeer(self.notice.text) ~= nil then
		tolua.setpeer(self.notice.text, nil)
	end
	if tolua.getpeer(self.next.text) ~= nil then
		tolua.setpeer(self.next.text, nil)
	end
	if tolua.getpeer(self.opend.text) ~= nil then
		tolua.setpeer(self.opend.text, nil)
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
	if tolua.getpeer(self.opend) ~= nil then
		tolua.setpeer(self.opend, nil)
	end
	self.opend = nil
	if self.iconitem.GenerateDestroy ~= nil then
		self.iconitem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconitem) ~= nil then
		tolua.setpeer(self.iconitem, nil)
	end
	self.iconitem = nil
	if tolua.getpeer(self.next) ~= nil then
		tolua.setpeer(self.next, nil)
	end
	self.next = nil
	if self.iconitem1.GenerateDestroy ~= nil then
		self.iconitem1:GenerateDestroy()
	end
	if tolua.getpeer(self.iconitem1) ~= nil then
		tolua.setpeer(self.iconitem1, nil)
	end
	self.iconitem1 = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.notice) ~= nil then
		tolua.setpeer(self.notice, nil)
	end
	self.notice = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIArtifactPoolView