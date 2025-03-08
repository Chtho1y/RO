---@class NewBattleChat__Generate_btnBlock_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class NewBattleChat__Generate_btnBlock
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text NewBattleChat__Generate_btnBlock_text

---@class NewBattleChat__Generate_btnAddFriend_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class NewBattleChat__Generate_btnAddFriend
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text NewBattleChat__Generate_btnAddFriend_text

---@class NewBattleChat__Generate_btnInfor
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NewBattleChat__Generate_btnPrivateChat
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NewBattleChat__Generate_headOrder
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class NewBattleChat__Generate_funcbg
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NewBattleChat__Generate_btnChat
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NewBattleChat__Generate_battleLogView_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class NewBattleChat__Generate_battleLogView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public uIEventTriggerListener UIEventTriggerListener
---@field public content NewBattleChat__Generate_battleLogView_content

---@class NewBattleChat__Generate_battleLogRoot
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener

---@class NewBattleChat__Generate_togwarlog
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class NewBattleChat__Generate_togsystem
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class NewBattleChat__Generate_togguild
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class NewBattleChat__Generate_togworld
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class NewBattleChat__Generate_chltogBg
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup
---@field public canvasGroup UnityEngine.CanvasGroup

---@class NewBattleChat__Generate_chatTextItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class NewBattleChat__Generate_chatView
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener
---@field public loopListView SuperScrollView.LoopListView

---@class NewBattleChat__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private chatRoot UnityEngine.GameObject
---@field private chatView NewBattleChat__Generate_chatView
---@field private chatTextItem NewBattleChat__Generate_chatTextItem
---@field private chltogBg NewBattleChat__Generate_chltogBg
---@field private togworld NewBattleChat__Generate_togworld
---@field private togguild NewBattleChat__Generate_togguild
---@field private togsystem NewBattleChat__Generate_togsystem
---@field private togwarlog NewBattleChat__Generate_togwarlog
---@field private battleLogRoot NewBattleChat__Generate_battleLogRoot
---@field private battleLogView NewBattleChat__Generate_battleLogView
---@field private btnChat NewBattleChat__Generate_btnChat
---@field private funcbg NewBattleChat__Generate_funcbg
---@field private headOrder NewBattleChat__Generate_headOrder
---@field private btnPrivateChat NewBattleChat__Generate_btnPrivateChat
---@field private btnInfor NewBattleChat__Generate_btnInfor
---@field private btnAddFriend NewBattleChat__Generate_btnAddFriend
---@field private btnBlock NewBattleChat__Generate_btnBlock
local NewBattleChatView = class("NewBattleChatView")

function NewBattleChatView:ctor()
end

---@private
function NewBattleChatView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function NewBattleChatView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function NewBattleChatView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function NewBattleChatView:InitGenerate__2(Root, data)
--[[
	ChatRoot
--]]
	local tmp = Root:Find("ChatRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatRoot = tmp
end

---@private
function NewBattleChatView:InitGenerate__3(Root, data)
--[[
	ChatRoot/ChatView
--]]
	local tmp = Root:Find("ChatRoot/ChatView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatView = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function NewBattleChatView:InitGenerate__4(Root, data)
--[[
	ChatRoot/ChatView/Viewport/Content/ChatTextItem
--]]
	local tmp = Root:Find("ChatRoot/ChatView/Viewport/Content/ChatTextItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatTextItem = CommonUtil.BindGridViewItem2LuaStatic("ChatTextItem", tmp)
	self.chatTextItem.prefabName = "ChatTextItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function NewBattleChatView:InitGenerate__5(Root, data)
--[[
	ChatRoot/ChltogBg
--]]
	local tmp = Root:Find("ChatRoot/ChltogBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chltogBg = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)

	tmp.canvasGroup = tmp:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function NewBattleChatView:InitGenerate__6(Root, data)
--[[
	ChatRoot/ChltogBg/Togworld
--]]
	local tmp = Root:Find("ChatRoot/ChltogBg/Togworld").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.togworld = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function NewBattleChatView:InitGenerate__7(Root, data)
--[[
	ChatRoot/ChltogBg/Togguild
--]]
	local tmp = Root:Find("ChatRoot/ChltogBg/Togguild").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.togguild = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function NewBattleChatView:InitGenerate__8(Root, data)
--[[
	ChatRoot/ChltogBg/Togsystem
--]]
	local tmp = Root:Find("ChatRoot/ChltogBg/Togsystem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.togsystem = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function NewBattleChatView:InitGenerate__9(Root, data)
--[[
	ChatRoot/ChltogBg/Togwarlog
--]]
	local tmp = Root:Find("ChatRoot/ChltogBg/Togwarlog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.togwarlog = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function NewBattleChatView:InitGenerate__10(Root, data)
--[[
	ChatRoot/BattleLogRoot
--]]
	local tmp = Root:Find("ChatRoot/BattleLogRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleLogRoot = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function NewBattleChatView:InitGenerate__11(Root, data)
--[[
	ChatRoot/BattleLogRoot/BattleLogView
--]]
	local tmp = Root:Find("ChatRoot/BattleLogRoot/BattleLogView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleLogView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function NewBattleChatView:InitGenerate__12(Root, data)
--[[
	ChatRoot/BattleLogRoot/BattleLogView/Viewport/Content
--]]
	local tmp = Root:Find("ChatRoot/BattleLogRoot/BattleLogView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleLogView.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function NewBattleChatView:InitGenerate__13(Root, data)
--[[
	ChatRoot/BtnChat
--]]
	local tmp = Root:Find("ChatRoot/BtnChat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChat = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__14(Root, data)
--[[
	funcbg
--]]
	local tmp = Root:Find("funcbg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.funcbg = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__15(Root, data)
--[[
	funcbg/HeadOrder
--]]
	local tmp = Root:Find("funcbg/HeadOrder").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headOrder = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function NewBattleChatView:InitGenerate__16(Root, data)
--[[
	funcbg/HeadOrder/BtnPrivateChat
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnPrivateChat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPrivateChat = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__17(Root, data)
--[[
	funcbg/HeadOrder/BtnInfor
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnInfor").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfor = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__18(Root, data)
--[[
	funcbg/HeadOrder/BtnAddFriend
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnAddFriend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAddFriend = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__19(Root, data)
--[[
	funcbg/HeadOrder/BtnAddFriend/Text
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnAddFriend/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAddFriend.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function NewBattleChatView:InitGenerate__20(Root, data)
--[[
	funcbg/HeadOrder/BtnBlock
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnBlock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBlock = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NewBattleChatView:InitGenerate__21(Root, data)
--[[
	funcbg/HeadOrder/BtnBlock/Text
--]]
	local tmp = Root:Find("funcbg/HeadOrder/BtnBlock/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBlock.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function NewBattleChatView:GenerateDestroy()
	if tolua.getpeer(self.btnBlock.text) ~= nil then
		tolua.setpeer(self.btnBlock.text, nil)
	end
	if tolua.getpeer(self.btnAddFriend.text) ~= nil then
		tolua.setpeer(self.btnAddFriend.text, nil)
	end
	if tolua.getpeer(self.battleLogView.content) ~= nil then
		tolua.setpeer(self.battleLogView.content, nil)
	end
	if tolua.getpeer(self.chatRoot) ~= nil then
		tolua.setpeer(self.chatRoot, nil)
	end
	self.chatRoot = nil
	if tolua.getpeer(self.chatView) ~= nil then
		tolua.setpeer(self.chatView, nil)
	end
	self.chatView = nil
	if self.chatTextItem.GenerateDestroy ~= nil then
		self.chatTextItem:GenerateDestroy()
	end
	if tolua.getpeer(self.chatTextItem) ~= nil then
		tolua.setpeer(self.chatTextItem, nil)
	end
	self.chatTextItem = nil
	if tolua.getpeer(self.chltogBg) ~= nil then
		tolua.setpeer(self.chltogBg, nil)
	end
	self.chltogBg = nil
	if tolua.getpeer(self.togworld) ~= nil then
		tolua.setpeer(self.togworld, nil)
	end
	self.togworld = nil
	if tolua.getpeer(self.togguild) ~= nil then
		tolua.setpeer(self.togguild, nil)
	end
	self.togguild = nil
	if tolua.getpeer(self.togsystem) ~= nil then
		tolua.setpeer(self.togsystem, nil)
	end
	self.togsystem = nil
	if tolua.getpeer(self.togwarlog) ~= nil then
		tolua.setpeer(self.togwarlog, nil)
	end
	self.togwarlog = nil
	if tolua.getpeer(self.battleLogRoot) ~= nil then
		tolua.setpeer(self.battleLogRoot, nil)
	end
	self.battleLogRoot = nil
	if tolua.getpeer(self.battleLogView) ~= nil then
		tolua.setpeer(self.battleLogView, nil)
	end
	self.battleLogView = nil
	if tolua.getpeer(self.btnChat) ~= nil then
		tolua.setpeer(self.btnChat, nil)
	end
	self.btnChat = nil
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
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return NewBattleChatView