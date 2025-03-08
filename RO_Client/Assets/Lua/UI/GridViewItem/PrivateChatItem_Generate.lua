---@class PrivateChatItem__Generate_chatBubbleRgtItem_helpText1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText
---@field public symbolTextEvent WXB.SymbolTextEvent

---@class PrivateChatItem__Generate_chatBubbleRgtItem_helpText
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText

---@class PrivateChatItem__Generate_chatBubbleRgtItem_helpBg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class PrivateChatItem__Generate_chatBubbleRgtItem_text
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText

---@class PrivateChatItem__Generate_chatBubbleRgtItem_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class PrivateChatItem__Generate_chatBubbleRgtItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public bg PrivateChatItem__Generate_chatBubbleRgtItem_bg
---@field public text PrivateChatItem__Generate_chatBubbleRgtItem_text
---@field public helpBg PrivateChatItem__Generate_chatBubbleRgtItem_helpBg
---@field public helpText PrivateChatItem__Generate_chatBubbleRgtItem_helpText
---@field public helpText1 PrivateChatItem__Generate_chatBubbleRgtItem_helpText1

---@class PrivateChatItem__Generate_chatBubbleLftItem_helpText1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText
---@field public symbolTextEvent WXB.SymbolTextEvent

---@class PrivateChatItem__Generate_chatBubbleLftItem_helpText
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText

---@class PrivateChatItem__Generate_chatBubbleLftItem_helpBg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class PrivateChatItem__Generate_chatBubbleLftItem_text
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText

---@class PrivateChatItem__Generate_chatBubbleLftItem_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class PrivateChatItem__Generate_chatBubbleLftItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public bg PrivateChatItem__Generate_chatBubbleLftItem_bg
---@field public text PrivateChatItem__Generate_chatBubbleLftItem_text
---@field public helpBg PrivateChatItem__Generate_chatBubbleLftItem_helpBg
---@field public helpText PrivateChatItem__Generate_chatBubbleLftItem_helpText
---@field public helpText1 PrivateChatItem__Generate_chatBubbleLftItem_helpText1

---@class PrivateChatItem__Generate_chatTimeStampItem_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PrivateChatItem__Generate_chatTimeStampItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text PrivateChatItem__Generate_chatTimeStampItem_text

---@class PrivateChatItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private chatTimeStampItem PrivateChatItem__Generate_chatTimeStampItem
---@field private chatBubbleLftItem PrivateChatItem__Generate_chatBubbleLftItem
---@field private chatBubbleRgtItem PrivateChatItem__Generate_chatBubbleRgtItem
local PrivateChatItemView = class("PrivateChatItemView")

function PrivateChatItemView:ctor()
end

---@private
function PrivateChatItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PrivateChatItemView:InitGenerate(Root, data)
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


end

---@private
function PrivateChatItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__2(Root, data)
--[[
	ChatTimeStampItem
--]]
	local tmp = Root:Find("ChatTimeStampItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatTimeStampItem = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__3(Root, data)
--[[
	ChatTimeStampItem/BG/Text
--]]
	local tmp = Root:Find("ChatTimeStampItem/BG/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatTimeStampItem.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PrivateChatItemView:InitGenerate__4(Root, data)
--[[
	ChatBubbleLftItem
--]]
	local tmp = Root:Find("ChatBubbleLftItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__5(Root, data)
--[[
	ChatBubbleLftItem/Bg
--]]
	local tmp = Root:Find("ChatBubbleLftItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem.bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__6(Root, data)
--[[
	ChatBubbleLftItem/Bg/Text
--]]
	local tmp = Root:Find("ChatBubbleLftItem/Bg/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem.text = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)
end

---@private
function PrivateChatItemView:InitGenerate__7(Root, data)
--[[
	ChatBubbleLftItem/HelpBg
--]]
	local tmp = Root:Find("ChatBubbleLftItem/HelpBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem.helpBg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__8(Root, data)
--[[
	ChatBubbleLftItem/HelpBg/HelpText
--]]
	local tmp = Root:Find("ChatBubbleLftItem/HelpBg/HelpText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem.helpText = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)
end

---@private
function PrivateChatItemView:InitGenerate__9(Root, data)
--[[
	ChatBubbleLftItem/HelpBg/HelpText1
--]]
	local tmp = Root:Find("ChatBubbleLftItem/HelpBg/HelpText1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleLftItem.helpText1 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)

	tmp.symbolTextEvent = tmp:GetComponent(Enum.TypeInfo.SymbolTextEvent)
end

---@private
function PrivateChatItemView:InitGenerate__10(Root, data)
--[[
	ChatBubbleRgtItem
--]]
	local tmp = Root:Find("ChatBubbleRgtItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__11(Root, data)
--[[
	ChatBubbleRgtItem/Bg
--]]
	local tmp = Root:Find("ChatBubbleRgtItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem.bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__12(Root, data)
--[[
	ChatBubbleRgtItem/Bg/Text
--]]
	local tmp = Root:Find("ChatBubbleRgtItem/Bg/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem.text = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)
end

---@private
function PrivateChatItemView:InitGenerate__13(Root, data)
--[[
	ChatBubbleRgtItem/HelpBg
--]]
	local tmp = Root:Find("ChatBubbleRgtItem/HelpBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem.helpBg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PrivateChatItemView:InitGenerate__14(Root, data)
--[[
	ChatBubbleRgtItem/HelpBg/HelpText
--]]
	local tmp = Root:Find("ChatBubbleRgtItem/HelpBg/HelpText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem.helpText = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)
end

---@private
function PrivateChatItemView:InitGenerate__15(Root, data)
--[[
	ChatBubbleRgtItem/HelpBg/HelpText1
--]]
	local tmp = Root:Find("ChatBubbleRgtItem/HelpBg/HelpText1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBubbleRgtItem.helpText1 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)

	tmp.symbolTextEvent = tmp:GetComponent(Enum.TypeInfo.SymbolTextEvent)
end

---@private
function PrivateChatItemView:GenerateDestroy()
	if tolua.getpeer(self.chatBubbleRgtItem.helpText1) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem.helpText1, nil)
	end
	if tolua.getpeer(self.chatBubbleRgtItem.helpText) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem.helpText, nil)
	end
	if tolua.getpeer(self.chatBubbleRgtItem.helpBg) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem.helpBg, nil)
	end
	if tolua.getpeer(self.chatBubbleRgtItem.text) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem.text, nil)
	end
	if tolua.getpeer(self.chatBubbleRgtItem.bg) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem.bg, nil)
	end
	if tolua.getpeer(self.chatBubbleLftItem.helpText1) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem.helpText1, nil)
	end
	if tolua.getpeer(self.chatBubbleLftItem.helpText) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem.helpText, nil)
	end
	if tolua.getpeer(self.chatBubbleLftItem.helpBg) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem.helpBg, nil)
	end
	if tolua.getpeer(self.chatBubbleLftItem.text) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem.text, nil)
	end
	if tolua.getpeer(self.chatBubbleLftItem.bg) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem.bg, nil)
	end
	if tolua.getpeer(self.chatTimeStampItem.text) ~= nil then
		tolua.setpeer(self.chatTimeStampItem.text, nil)
	end
	if tolua.getpeer(self.chatTimeStampItem) ~= nil then
		tolua.setpeer(self.chatTimeStampItem, nil)
	end
	self.chatTimeStampItem = nil
	if tolua.getpeer(self.chatBubbleLftItem) ~= nil then
		tolua.setpeer(self.chatBubbleLftItem, nil)
	end
	self.chatBubbleLftItem = nil
	if tolua.getpeer(self.chatBubbleRgtItem) ~= nil then
		tolua.setpeer(self.chatBubbleRgtItem, nil)
	end
	self.chatBubbleRgtItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PrivateChatItemView