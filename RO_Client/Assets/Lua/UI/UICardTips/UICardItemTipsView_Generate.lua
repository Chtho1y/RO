---@class UICardItemTips__Generate_btnRefine
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardItemTips__Generate_text1
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardItemTips__Generate_position
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardItemTips__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardItemTips__Generate_type
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardItemTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardItemTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardItemTips__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardItemTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private window UICardItemTips__Generate_window
---@field private btnClose UICardItemTips__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private cardIconItem UnityEngine.GameObject
---@field private textName UICardItemTips__Generate_textName
---@field private type UICardItemTips__Generate_type
---@field private text UICardItemTips__Generate_text
---@field private position UICardItemTips__Generate_position
---@field private text1 UICardItemTips__Generate_text1
---@field private cardBox UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btnRefine UICardItemTips__Generate_btnRefine
local UICardItemTipsView = class("UICardItemTipsView", require("UIViewBase"))

function UICardItemTipsView:ctor()
end

---@private
function UICardItemTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardItemTipsView:InitGenerate(Root, data)
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
function UICardItemTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UICardItemTipsView:InitGenerate__2(Root, data)
--[[
	Window
--]]
	local tmp = Root:Find("Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UICardItemTipsView:InitGenerate__3(Root, data)
--[[
	Window/Bg/BtnClose
--]]
	local tmp = Root:Find("Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardItemTipsView:InitGenerate__4(Root, data)
--[[
	Window/Bg/TopItem/ContentItem
--]]
	local tmp = Root:Find("Window/Bg/TopItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UICardItemTipsView:InitGenerate__5(Root, data)
--[[
	Window/Bg/TopItem/ContentItem/CardIconItem
--]]
	local tmp = Root:Find("Window/Bg/TopItem/ContentItem/CardIconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIconItem = CommonUtil.BindGridViewItem2LuaStatic("CardIconItem", tmp)
	self.cardIconItem.prefabName = "CardIconItem"
end

---@private
function UICardItemTipsView:InitGenerate__6(Root, data)
--[[
	Window/Bg/TopItem/Texts/TextName
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardItemTipsView:InitGenerate__7(Root, data)
--[[
	Window/Bg/TopItem/Texts/Type
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/Type").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardItemTipsView:InitGenerate__8(Root, data)
--[[
	Window/Bg/TopItem/Texts/Text
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardItemTipsView:InitGenerate__9(Root, data)
--[[
	Window/Bg/TopItem/Texts/Position
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/Position").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.position = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardItemTipsView:InitGenerate__10(Root, data)
--[[
	Window/Bg/TopItem/Texts/Text1
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text1 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardItemTipsView:InitGenerate__11(Root, data)
--[[
	Window/Bg/CardBox
--]]
	local tmp = Root:Find("Window/Bg/CardBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBox = tmp
end

---@private
function UICardItemTipsView:InitGenerate__12(Root, data)
--[[
	Window/Bg/BtnBox
--]]
	local tmp = Root:Find("Window/Bg/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UICardItemTipsView:InitGenerate__13(Root, data)
--[[
	Window/Bg/BtnBox/BtnRefine
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnRefine").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRefine = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardItemTipsView:GenerateDestroy()
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if self.cardIconItem.GenerateDestroy ~= nil then
		self.cardIconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardIconItem) ~= nil then
		tolua.setpeer(self.cardIconItem, nil)
	end
	self.cardIconItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.type) ~= nil then
		tolua.setpeer(self.type, nil)
	end
	self.type = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.position) ~= nil then
		tolua.setpeer(self.position, nil)
	end
	self.position = nil
	if tolua.getpeer(self.text1) ~= nil then
		tolua.setpeer(self.text1, nil)
	end
	self.text1 = nil
	if tolua.getpeer(self.cardBox) ~= nil then
		tolua.setpeer(self.cardBox, nil)
	end
	self.cardBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnRefine) ~= nil then
		tolua.setpeer(self.btnRefine, nil)
	end
	self.btnRefine = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardItemTipsView