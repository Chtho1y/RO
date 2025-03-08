---@class UIChat__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_btnBlock_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIChat__Generate_btnBlock
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIChat__Generate_btnBlock_text

---@class UIChat__Generate_btnAddFriend_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIChat__Generate_btnAddFriend
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIChat__Generate_btnAddFriend_text

---@class UIChat__Generate_btnInfor
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_btnPrivateChat
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_headOrder
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIChat__Generate_funcbg
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_emojiWindow
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UnityEngine.GameObject

---@class UIChat__Generate_btnSend
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_btnEmoji
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIChat__Generate_chatTextItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIChat__Generate_chatWindow
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener
---@field public loopListView SuperScrollView.LoopListView

---@class UIChat__Generate_chSystem
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIChat__Generate_chGuild
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIChat__Generate_chWorld
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIChat__Generate_toggle
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIChat__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChat__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChat__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIChat__Generate_uIAnimator
---@field private AnyBtn UIChat__Generate_AnyBtn
---@field private toggle UIChat__Generate_toggle
---@field private chWorld UIChat__Generate_chWorld
---@field private chGuild UIChat__Generate_chGuild
---@field private chSystem UIChat__Generate_chSystem
---@field private chatWindow UIChat__Generate_chatWindow
---@field private chatTextItem UIChat__Generate_chatTextItem
---@field private input UnityEngine.GameObject
---@field private inputField UIChat__Generate_inputField
---@field private btnEmoji UIChat__Generate_btnEmoji
---@field private btnSend UIChat__Generate_btnSend
---@field private emojiWindow UIChat__Generate_emojiWindow
---@field private funcbg UIChat__Generate_funcbg
---@field private headOrder UIChat__Generate_headOrder
---@field private btnPrivateChat UIChat__Generate_btnPrivateChat
---@field private btnInfor UIChat__Generate_btnInfor
---@field private btnAddFriend UIChat__Generate_btnAddFriend
---@field private btnBlock UIChat__Generate_btnBlock
---@field private emojiItem UnityEngine.GameObject
---@field private BtnClose UIChat__Generate_BtnClose
local UIChatView = class("UIChatView", require("UIViewBase"))

function UIChatView:ctor()
end

---@private
function UIChatView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChatView:InitGenerate(Root, data)
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
function UIChatView:InitGenerate__1(Root, data)
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
function UIChatView:InitGenerate__2(Root, data)
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
function UIChatView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ChannelToggle/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ChannelToggle/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIChatView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ChannelToggle/Viewport/Content/ChWorld
--]]
	local tmp = Root:Find("UIAnimator/Window/ChannelToggle/Viewport/Content/ChWorld").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chWorld = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChatView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ChannelToggle/Viewport/Content/ChGuild
--]]
	local tmp = Root:Find("UIAnimator/Window/ChannelToggle/Viewport/Content/ChGuild").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chGuild = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChatView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ChannelToggle/Viewport/Content/ChSystem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChannelToggle/Viewport/Content/ChSystem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chSystem = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChatView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ChatWindow
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatWindow = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIChatView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ChatWindow/Viewport/ChatTextItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/Viewport/ChatTextItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatTextItem = CommonUtil.BindGridViewItem2LuaStatic("ChatTextItem", tmp)
	self.chatTextItem.prefabName = "ChatTextItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIChatView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/ChatWindow/Input
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/Input").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.input = tmp
end

---@private
function UIChatView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/ChatWindow/Input/InputField
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/Input/InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIChatView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/ChatWindow/Input/BtnEmoji
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/Input/BtnEmoji").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEmoji = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/ChatWindow/Input/BtnSend
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/Input/BtnSend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSend = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/ChatWindow/EmojiWindow
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/EmojiWindow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiWindow = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChatView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/ChatWindow/EmojiWindow/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ChatWindow/EmojiWindow/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiWindow.content = tmp
end

---@private
function UIChatView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/funcbg
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.funcbg = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headOrder = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIChatView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnPrivateChat
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnPrivateChat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPrivateChat = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnInfor
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnInfor").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfor = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnAddFriend
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnAddFriend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAddFriend = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnAddFriend/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnAddFriend/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAddFriend.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIChatView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnBlock
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnBlock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBlock = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/funcbg/HeadOrder/BtnBlock/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/funcbg/HeadOrder/BtnBlock/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBlock.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIChatView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/emojiItem
--]]
	local tmp = Root:Find("UIAnimator/Window/emojiItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emojiItem = tmp
end

---@private
function UIChatView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChatView:GenerateDestroy()
	if tolua.getpeer(self.btnBlock.text) ~= nil then
		tolua.setpeer(self.btnBlock.text, nil)
	end
	if tolua.getpeer(self.btnAddFriend.text) ~= nil then
		tolua.setpeer(self.btnAddFriend.text, nil)
	end
	if tolua.getpeer(self.emojiWindow.content) ~= nil then
		tolua.setpeer(self.emojiWindow.content, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.toggle) ~= nil then
		tolua.setpeer(self.toggle, nil)
	end
	self.toggle = nil
	if tolua.getpeer(self.chWorld) ~= nil then
		tolua.setpeer(self.chWorld, nil)
	end
	self.chWorld = nil
	if tolua.getpeer(self.chGuild) ~= nil then
		tolua.setpeer(self.chGuild, nil)
	end
	self.chGuild = nil
	if tolua.getpeer(self.chSystem) ~= nil then
		tolua.setpeer(self.chSystem, nil)
	end
	self.chSystem = nil
	if tolua.getpeer(self.chatWindow) ~= nil then
		tolua.setpeer(self.chatWindow, nil)
	end
	self.chatWindow = nil
	if self.chatTextItem.GenerateDestroy ~= nil then
		self.chatTextItem:GenerateDestroy()
	end
	if tolua.getpeer(self.chatTextItem) ~= nil then
		tolua.setpeer(self.chatTextItem, nil)
	end
	self.chatTextItem = nil
	if tolua.getpeer(self.input) ~= nil then
		tolua.setpeer(self.input, nil)
	end
	self.input = nil
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
	if tolua.getpeer(self.emojiWindow) ~= nil then
		tolua.setpeer(self.emojiWindow, nil)
	end
	self.emojiWindow = nil
	if tolua.getpeer(self.funcbg) ~= nil then
		tolua.setpeer(self.funcbg, nil)
	end
	self.funcbg = nil
	if tolua.getpeer(self.headOrder) ~= nil then
		tolua.setpeer(self.headOrder, nil)
	end
	self.headOrder = nil
	if tolua.getpeer(self.btnPrivateChat) ~= nil then
		tolua.setpeer(self.btnPrivateChat, nil)
	end
	self.btnPrivateChat = nil
	if tolua.getpeer(self.btnInfor) ~= nil then
		tolua.setpeer(self.btnInfor, nil)
	end
	self.btnInfor = nil
	if tolua.getpeer(self.btnAddFriend) ~= nil then
		tolua.setpeer(self.btnAddFriend, nil)
	end
	self.btnAddFriend = nil
	if tolua.getpeer(self.btnBlock) ~= nil then
		tolua.setpeer(self.btnBlock, nil)
	end
	self.btnBlock = nil
	if tolua.getpeer(self.emojiItem) ~= nil then
		tolua.setpeer(self.emojiItem, nil)
	end
	self.emojiItem = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChatView