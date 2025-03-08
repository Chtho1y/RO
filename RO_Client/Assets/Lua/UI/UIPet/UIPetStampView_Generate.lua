---@class UIPetStamp__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetStamp__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIPetStamp__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStamp__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetStamp__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStamp__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetStamp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetStamp__Generate_uIAnimator
---@field private AnyBtn UIPetStamp__Generate_AnyBtn
---@field private textTitle UIPetStamp__Generate_textTitle
---@field private btnClose UIPetStamp__Generate_btnClose
---@field private scrollView UIPetStamp__Generate_scrollView
---@field private iconItem UIPetStamp__Generate_iconItem
---@field private noStamp UnityEngine.GameObject
local UIPetStampView = class("UIPetStampView", require("UIViewBase"))

function UIPetStampView:ctor()
end

---@private
function UIPetStampView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetStampView:InitGenerate(Root, data)
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


end

---@private
function UIPetStampView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetStampView:InitGenerate__2(Root, data)
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
function UIPetStampView:InitGenerate__3(Root, data)
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
function UIPetStampView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetStampView:InitGenerate__5(Root, data)
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
function UIPetStampView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIPetStampView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetStampView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/NoStamp
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/NoStamp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noStamp = tmp
end

---@private
function UIPetStampView:GenerateDestroy()
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
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.noStamp) ~= nil then
		tolua.setpeer(self.noStamp, nil)
	end
	self.noStamp = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetStampView