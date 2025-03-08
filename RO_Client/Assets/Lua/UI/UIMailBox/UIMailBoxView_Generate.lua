---@class UIMailBox__Generate_btnOnekeyReceive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMailBox__Generate_btnDeleteRead
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMailBox__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIMailBox__Generate_mailListItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMailBox__Generate_mailList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIMailBox__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMailBox__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMailBox__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMailBox__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIMailBox__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIMailBox__Generate_uIAnimator
---@field private AnyBtn UIMailBox__Generate_AnyBtn
---@field private btnClose UIMailBox__Generate_btnClose
---@field private number UIMailBox__Generate_number
---@field private mailList UIMailBox__Generate_mailList
---@field private mailListItem UIMailBox__Generate_mailListItem
---@field private content UIMailBox__Generate_content
---@field private empty UnityEngine.GameObject
---@field private btnDeleteRead UIMailBox__Generate_btnDeleteRead
---@field private btnOnekeyReceive UIMailBox__Generate_btnOnekeyReceive
local UIMailBoxView = class("UIMailBoxView", require("UIViewBase"))

function UIMailBoxView:ctor()
end

---@private
function UIMailBoxView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIMailBoxView:InitGenerate(Root, data)
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


end

---@private
function UIMailBoxView:InitGenerate__1(Root, data)
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
function UIMailBoxView:InitGenerate__2(Root, data)
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
function UIMailBoxView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailBoxView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/MailNumber/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/MailNumber/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMailBoxView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/MailList
--]]
	local tmp = Root:Find("UIAnimator/Window/MailList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mailList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIMailBoxView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/MailList/Viewport/MailListItem
--]]
	local tmp = Root:Find("UIAnimator/Window/MailList/Viewport/MailListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mailListItem = CommonUtil.BindGridViewItem2LuaStatic("MailListItem", tmp)
	self.mailListItem.prefabName = "MailListItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailBoxView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/MailList/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/MailList/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIMailBoxView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.empty = tmp
end

---@private
function UIMailBoxView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnDeleteRead
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnDeleteRead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDeleteRead = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailBoxView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnOnekeyReceive
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnOnekeyReceive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOnekeyReceive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailBoxView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.mailList) ~= nil then
		tolua.setpeer(self.mailList, nil)
	end
	self.mailList = nil
	if self.mailListItem.GenerateDestroy ~= nil then
		self.mailListItem:GenerateDestroy()
	end
	if tolua.getpeer(self.mailListItem) ~= nil then
		tolua.setpeer(self.mailListItem, nil)
	end
	self.mailListItem = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.empty) ~= nil then
		tolua.setpeer(self.empty, nil)
	end
	self.empty = nil
	if tolua.getpeer(self.btnDeleteRead) ~= nil then
		tolua.setpeer(self.btnDeleteRead, nil)
	end
	self.btnDeleteRead = nil
	if tolua.getpeer(self.btnOnekeyReceive) ~= nil then
		tolua.setpeer(self.btnOnekeyReceive, nil)
	end
	self.btnOnekeyReceive = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIMailBoxView