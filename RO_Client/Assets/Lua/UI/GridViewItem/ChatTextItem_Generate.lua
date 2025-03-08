---@class ChatTextItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public symbolText WXB.SymbolText
---@field public symbolTextEvent WXB.SymbolTextEvent

---@class ChatTextItem__Generate_titleImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChatTextItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChatTextItem__Generate_nickname
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ChatTextItem__Generate_nameBg
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ChatTextItem__Generate_headImage
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChatTextItem__Generate_player
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ChatTextItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private system UnityEngine.GameObject
---@field private player ChatTextItem__Generate_player
---@field private headImage ChatTextItem__Generate_headImage
---@field private easyPlayer UnityEngine.GameObject
---@field private nameBg ChatTextItem__Generate_nameBg
---@field private nickname ChatTextItem__Generate_nickname
---@field private vipIcon ChatTextItem__Generate_vipIcon
---@field private titleImg ChatTextItem__Generate_titleImg
---@field private chlWorld UnityEngine.GameObject
---@field private chlSystem UnityEngine.GameObject
---@field private chlGuildSystem UnityEngine.GameObject
---@field private text ChatTextItem__Generate_text
local ChatTextItemView = class("ChatTextItemView")

function ChatTextItemView:ctor()
end

---@private
function ChatTextItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ChatTextItemView:InitGenerate(Root, data)
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


end

---@private
function ChatTextItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ChatTextItemView:InitGenerate__2(Root, data)
--[[
	System
--]]
	local tmp = Root:Find("System").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.system = tmp
end

---@private
function ChatTextItemView:InitGenerate__3(Root, data)
--[[
	Player
--]]
	local tmp = Root:Find("Player").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.player = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChatTextItemView:InitGenerate__4(Root, data)
--[[
	Player/HeadImage
--]]
	local tmp = Root:Find("Player/HeadImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headImage = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChatTextItemView:InitGenerate__5(Root, data)
--[[
	EasyPlayer
--]]
	local tmp = Root:Find("EasyPlayer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.easyPlayer = tmp
end

---@private
function ChatTextItemView:InitGenerate__6(Root, data)
--[[
	EasyPlayer/NameBg
--]]
	local tmp = Root:Find("EasyPlayer/NameBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBg = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChatTextItemView:InitGenerate__7(Root, data)
--[[
	EasyPlayer/NameBg/Nickname
--]]
	local tmp = Root:Find("EasyPlayer/NameBg/Nickname").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nickname = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ChatTextItemView:InitGenerate__8(Root, data)
--[[
	EasyPlayer/VipIcon
--]]
	local tmp = Root:Find("EasyPlayer/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChatTextItemView:InitGenerate__9(Root, data)
--[[
	EasyPlayer/TitleImg
--]]
	local tmp = Root:Find("EasyPlayer/TitleImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChatTextItemView:InitGenerate__10(Root, data)
--[[
	Channel/ChlWorld
--]]
	local tmp = Root:Find("Channel/ChlWorld").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chlWorld = tmp
end

---@private
function ChatTextItemView:InitGenerate__11(Root, data)
--[[
	Channel/ChlSystem
--]]
	local tmp = Root:Find("Channel/ChlSystem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chlSystem = tmp
end

---@private
function ChatTextItemView:InitGenerate__12(Root, data)
--[[
	Channel/ChlGuildSystem
--]]
	local tmp = Root:Find("Channel/ChlGuildSystem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chlGuildSystem = tmp
end

---@private
function ChatTextItemView:InitGenerate__13(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)

	tmp.symbolTextEvent = tmp:GetComponent(Enum.TypeInfo.SymbolTextEvent)
end

---@private
function ChatTextItemView:GenerateDestroy()
	if tolua.getpeer(self.system) ~= nil then
		tolua.setpeer(self.system, nil)
	end
	self.system = nil
	if tolua.getpeer(self.player) ~= nil then
		tolua.setpeer(self.player, nil)
	end
	self.player = nil
	if tolua.getpeer(self.headImage) ~= nil then
		tolua.setpeer(self.headImage, nil)
	end
	self.headImage = nil
	if tolua.getpeer(self.easyPlayer) ~= nil then
		tolua.setpeer(self.easyPlayer, nil)
	end
	self.easyPlayer = nil
	if tolua.getpeer(self.nameBg) ~= nil then
		tolua.setpeer(self.nameBg, nil)
	end
	self.nameBg = nil
	if tolua.getpeer(self.nickname) ~= nil then
		tolua.setpeer(self.nickname, nil)
	end
	self.nickname = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.titleImg) ~= nil then
		tolua.setpeer(self.titleImg, nil)
	end
	self.titleImg = nil
	if tolua.getpeer(self.chlWorld) ~= nil then
		tolua.setpeer(self.chlWorld, nil)
	end
	self.chlWorld = nil
	if tolua.getpeer(self.chlSystem) ~= nil then
		tolua.setpeer(self.chlSystem, nil)
	end
	self.chlSystem = nil
	if tolua.getpeer(self.chlGuildSystem) ~= nil then
		tolua.setpeer(self.chlGuildSystem, nil)
	end
	self.chlGuildSystem = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ChatTextItemView