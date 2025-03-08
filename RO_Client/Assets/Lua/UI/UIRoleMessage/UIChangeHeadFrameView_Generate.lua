---@class UIChangeHeadFrame__Generate_allAtrBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHeadFrame__Generate_btnGet
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHeadFrame__Generate_btnUsed
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHeadFrame__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIChangeHeadFrame__Generate_headFrameList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIChangeHeadFrame__Generate_headFrameDesc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeHeadFrame__Generate_attrNone_nameText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeHeadFrame__Generate_attrNone
---@field public gameObject UnityEngine.GameObject
---@field public nameText UIChangeHeadFrame__Generate_attrNone_nameText

---@class UIChangeHeadFrame__Generate_attrBox
---@field public gameObject UnityEngine.GameObject
---@field public attrItem1 UnityEngine.GameObject
---@field public attrItem2 UnityEngine.GameObject
---@field public attrItem3 UnityEngine.GameObject

---@class UIChangeHeadFrame__Generate_headFrameName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeHeadFrame__Generate_leftTimeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeHeadFrame__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIChangeHeadFrame__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHeadFrame__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeHeadFrame__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChangeHeadFrame__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIChangeHeadFrame__Generate_uIAnimator
---@field private AnyBtn UIChangeHeadFrame__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIChangeHeadFrame__Generate_btnClose
---@field private frameNode UnityEngine.GameObject
---@field private headItem UIChangeHeadFrame__Generate_headItem
---@field private limitedNode UnityEngine.GameObject
---@field private leftTimeTxt UIChangeHeadFrame__Generate_leftTimeTxt
---@field private headFrameName UIChangeHeadFrame__Generate_headFrameName
---@field private attrBox UIChangeHeadFrame__Generate_attrBox
---@field private attrNone UIChangeHeadFrame__Generate_attrNone
---@field private headFrameDesc UIChangeHeadFrame__Generate_headFrameDesc
---@field private headFrameList UIChangeHeadFrame__Generate_headFrameList
---@field private content UIChangeHeadFrame__Generate_content
---@field private bottom UnityEngine.GameObject
---@field private btnUsed UIChangeHeadFrame__Generate_btnUsed
---@field private btnGet UIChangeHeadFrame__Generate_btnGet
---@field private usingTip UnityEngine.GameObject
---@field private allAtrBtn UIChangeHeadFrame__Generate_allAtrBtn
local UIChangeHeadFrameView = class("UIChangeHeadFrameView", require("UIViewBase"))

function UIChangeHeadFrameView:ctor()
end

---@private
function UIChangeHeadFrameView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChangeHeadFrameView:InitGenerate(Root, data)
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
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)


end

---@private
function UIChangeHeadFrameView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIChangeHeadFrameView:InitGenerate__2(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__3(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__4(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__5(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frameNode = tmp
end

---@private
function UIChangeHeadFrameView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIChangeHeadFrameView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/LimitedBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/LimitedBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitedNode = tmp
end

---@private
function UIChangeHeadFrameView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/LimitedBox/LimitedText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/LimitedBox/LimitedText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeHeadFrameView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headFrameName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeHeadFrameView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrBox = tmp
end

---@private
function UIChangeHeadFrameView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrNone
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrNone").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrNone = tmp
end

---@private
function UIChangeHeadFrameView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrNone/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrNone/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrNone.nameText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeHeadFrameView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrBox.attrItem1 = CommonUtil.BindGridViewItem2LuaStatic("AttrItem", tmp)
	self.attrBox.attrItem1.prefabName = "AttrItem"
end

---@private
function UIChangeHeadFrameView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrBox.attrItem2 = CommonUtil.BindGridViewItem2LuaStatic("AttrItem", tmp)
	self.attrBox.attrItem2.prefabName = "AttrItem"
end

---@private
function UIChangeHeadFrameView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/PlayerBox/AttrBox/AttrItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrBox.attrItem3 = CommonUtil.BindGridViewItem2LuaStatic("AttrItem", tmp)
	self.attrBox.attrItem3.prefabName = "AttrItem"
end

---@private
function UIChangeHeadFrameView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/InfoBox/DscBox/DscText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/InfoBox/DscBox/DscText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headFrameDesc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeHeadFrameView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/ChangeList
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ChangeList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headFrameList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChangeHeadFrameView:InitGenerate__19(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__20(Root, data)
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
function UIChangeHeadFrameView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/UsedBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/UsedBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnUsed = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadFrameView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/GetBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/GetBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGet = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadFrameView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/UsingTip
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/UsingTip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.usingTip = tmp
end

---@private
function UIChangeHeadFrameView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/BtnAllAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/BtnAllAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allAtrBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeHeadFrameView:GenerateDestroy()
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	if self.attrBox.attrItem3.GenerateDestroy ~= nil then
		self.attrBox.attrItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.attrBox.attrItem3) ~= nil then
		tolua.setpeer(self.attrBox.attrItem3, nil)
	end
	if self.attrBox.attrItem2.GenerateDestroy ~= nil then
		self.attrBox.attrItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.attrBox.attrItem2) ~= nil then
		tolua.setpeer(self.attrBox.attrItem2, nil)
	end
	if self.attrBox.attrItem1.GenerateDestroy ~= nil then
		self.attrBox.attrItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.attrBox.attrItem1) ~= nil then
		tolua.setpeer(self.attrBox.attrItem1, nil)
	end
	if tolua.getpeer(self.attrNone.nameText) ~= nil then
		tolua.setpeer(self.attrNone.nameText, nil)
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
	if tolua.getpeer(self.frameNode) ~= nil then
		tolua.setpeer(self.frameNode, nil)
	end
	self.frameNode = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.limitedNode) ~= nil then
		tolua.setpeer(self.limitedNode, nil)
	end
	self.limitedNode = nil
	if tolua.getpeer(self.leftTimeTxt) ~= nil then
		tolua.setpeer(self.leftTimeTxt, nil)
	end
	self.leftTimeTxt = nil
	if tolua.getpeer(self.headFrameName) ~= nil then
		tolua.setpeer(self.headFrameName, nil)
	end
	self.headFrameName = nil
	if tolua.getpeer(self.attrBox) ~= nil then
		tolua.setpeer(self.attrBox, nil)
	end
	self.attrBox = nil
	if tolua.getpeer(self.attrNone) ~= nil then
		tolua.setpeer(self.attrNone, nil)
	end
	self.attrNone = nil
	if tolua.getpeer(self.headFrameDesc) ~= nil then
		tolua.setpeer(self.headFrameDesc, nil)
	end
	self.headFrameDesc = nil
	if tolua.getpeer(self.headFrameList) ~= nil then
		tolua.setpeer(self.headFrameList, nil)
	end
	self.headFrameList = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.btnUsed) ~= nil then
		tolua.setpeer(self.btnUsed, nil)
	end
	self.btnUsed = nil
	if tolua.getpeer(self.btnGet) ~= nil then
		tolua.setpeer(self.btnGet, nil)
	end
	self.btnGet = nil
	if tolua.getpeer(self.usingTip) ~= nil then
		tolua.setpeer(self.usingTip, nil)
	end
	self.usingTip = nil
	if tolua.getpeer(self.allAtrBtn) ~= nil then
		tolua.setpeer(self.allAtrBtn, nil)
	end
	self.allAtrBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChangeHeadFrameView