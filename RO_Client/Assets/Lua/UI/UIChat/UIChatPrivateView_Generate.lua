---@class UIChatPrivate__Generate_emojiWindow
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UnityEngine.GameObject

---@class UIChatPrivate__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIChatPrivate__Generate_headList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIChatPrivate__Generate_btnSend
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChatPrivate__Generate_btnEmoji
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChatPrivate__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIChatPrivate__Generate_privateChatItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIChatPrivate__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIChatPrivate__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChatPrivate__Generate_btnLog
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChatPrivate__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChatPrivate__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIChatPrivate__Generate_AnyBtn
---@field private btnLog UIChatPrivate__Generate_btnLog
---@field private btnClose UIChatPrivate__Generate_btnClose
---@field private empty UnityEngine.GameObject
---@field private exist UnityEngine.GameObject
---@field private scrollView UIChatPrivate__Generate_scrollView
---@field private privateChatItem UIChatPrivate__Generate_privateChatItem
---@field private inputField UIChatPrivate__Generate_inputField
---@field private btnEmoji UIChatPrivate__Generate_btnEmoji
---@field private btnSend UIChatPrivate__Generate_btnSend
---@field private headList UIChatPrivate__Generate_headList
---@field private headItem UIChatPrivate__Generate_headItem
---@field private emojiWindow UIChatPrivate__Generate_emojiWindow
---@field private emojiItem UnityEngine.GameObject
local UIChatPrivateView = class("UIChatPrivateView", require("UIViewBase"))

function UIChatPrivateView:ctor()
end

---@private
function UIChatPrivateView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChatPrivateView:InitGenerate(Root, data)
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


end

---@private
function UIChatPrivateView:InitGenerate__1(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatPrivateView:InitGenerate__2(Root, data)
--[[
	Window/BtnLog
--]]
	local tmp = Root:Find("Window/BtnLog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnLog = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatPrivateView:InitGenerate__3(Root, data)
--[[
	Window/BtnClose
--]]
	local tmp = Root:Find("Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatPrivateView:InitGenerate__4(Root, data)
--[[
	Window/empty
--]]
	local tmp = Root:Find("Window/empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.empty = tmp
end

---@private
function UIChatPrivateView:InitGenerate__5(Root, data)
--[[
	Window/exist
--]]
	local tmp = Root:Find("Window/exist").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exist = tmp
end

---@private
function UIChatPrivateView:InitGenerate__6(Root, data)
--[[
	Window/exist/Scroll View
--]]
	local tmp = Root:Find("Window/exist/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIChatPrivateView:InitGenerate__7(Root, data)
--[[
	Window/exist/Scroll View/Viewport/PrivateChatItem
--]]
	local tmp = Root:Find("Window/exist/Scroll View/Viewport/PrivateChatItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.privateChatItem = CommonUtil.BindGridViewItem2LuaStatic("PrivateChatItem", tmp)
	self.privateChatItem.prefabName = "PrivateChatItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIChatPrivateView:InitGenerate__8(Root, data)
--[[
	Window/exist/Input/InputField
--]]
	local tmp = Root:Find("Window/exist/Input/InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIChatPrivateView:InitGenerate__9(Root, data)
--[[
	Window/exist/Input/BtnEmoji
--]]
	local tmp = Root:Find("Window/exist/Input/BtnEmoji").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEmoji = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatPrivateView:InitGenerate__10(Root, data)
--[[
	Window/exist/Input/BtnSend
--]]
	local tmp = Root:Find("Window/exist/Input/BtnSend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSend = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatPrivateView:InitGenerate__11(Root, data)
--[[
	Window/exist/HeadList
--]]
	local tmp = Root:Find("Window/exist/HeadList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChatPrivateView:InitGenerate__12(Root, data)
--[[
	Window/exist/HeadList/Viewport/ChatTarget/HeadBox/HeadItem
--]]
	local tmp = Root:Find("Window/exist/HeadList/Viewport/ChatTarget/HeadBox/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIChatPrivateView:InitGenerate__13(Root, data)
--[[
	Window/exist/EmojiWindow
--]]
	local tmp = Root:Find("Window/exist/EmojiWindow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiWindow = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChatPrivateView:InitGenerate__14(Root, data)
--[[
	Window/exist/EmojiWindow/Viewport/Content
--]]
	local tmp = Root:Find("Window/exist/EmojiWindow/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiWindow.content = tmp
end

---@private
function UIChatPrivateView:InitGenerate__15(Root, data)
--[[
	Window/exist/emojiItem
--]]
	local tmp = Root:Find("Window/exist/emojiItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiItem = tmp
end

---@private
function UIChatPrivateView:GenerateDestroy()
	if tolua.getpeer(self.emojiWindow.content) ~= nil then
		tolua.setpeer(self.emojiWindow.content, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnLog) ~= nil then
		tolua.setpeer(self.btnLog, nil)
	end
	self.btnLog = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.empty) ~= nil then
		tolua.setpeer(self.empty, nil)
	end
	self.empty = nil
	if tolua.getpeer(self.exist) ~= nil then
		tolua.setpeer(self.exist, nil)
	end
	self.exist = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.privateChatItem.GenerateDestroy ~= nil then
		self.privateChatItem:GenerateDestroy()
	end
	if tolua.getpeer(self.privateChatItem) ~= nil then
		tolua.setpeer(self.privateChatItem, nil)
	end
	self.privateChatItem = nil
	if tolua.getpeer(self.inputField) ~= nil then
		tolua.setpeer(self.inputField, nil)
	end
	self.inputField = nil
	if tolua.getpeer(self.btnEmoji) ~= nil then
		tolua.setpeer(self.btnEmoji, nil)
	end
	self.btnEmoji = nil
	if tolua.getpeer(self.btnSend) ~= nil then
		tolua.setpeer(self.btnSend, nil)
	end
	self.btnSend = nil
	if tolua.getpeer(self.headList) ~= nil then
		tolua.setpeer(self.headList, nil)
	end
	self.headList = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.emojiWindow) ~= nil then
		tolua.setpeer(self.emojiWindow, nil)
	end
	self.emojiWindow = nil
	if tolua.getpeer(self.emojiItem) ~= nil then
		tolua.setpeer(self.emojiItem, nil)
	end
	self.emojiItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChatPrivateView