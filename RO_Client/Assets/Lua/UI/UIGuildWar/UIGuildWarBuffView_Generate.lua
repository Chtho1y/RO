---@class UIGuildWarBuff__Generate_questionTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIGuildWarBuff__Generate_noticeTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIGuildWarBuff__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarBuff__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarBuff__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIGuildWarBuff__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIGuildWarBuff__Generate_uIAnimator
---@field private AnyBtn UIGuildWarBuff__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIGuildWarBuff__Generate_btnClose
---@field private noticeTitle UIGuildWarBuff__Generate_noticeTitle
---@field private dscBox UnityEngine.GameObject
---@field private guildWarBuyBuffItem UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private title UnityEngine.GameObject
---@field private questionTxt UIGuildWarBuff__Generate_questionTxt
local UIGuildWarBuffView = class("UIGuildWarBuffView", require("UIViewBase"))

function UIGuildWarBuffView:ctor()
end

---@private
function UIGuildWarBuffView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildWarBuffView:InitGenerate(Root, data)
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
function UIGuildWarBuffView:InitGenerate__1(Root, data)
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
function UIGuildWarBuffView:InitGenerate__2(Root, data)
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
function UIGuildWarBuffView:InitGenerate__3(Root, data)
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
function UIGuildWarBuffView:InitGenerate__4(Root, data)
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
function UIGuildWarBuffView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/NoticeTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/NoticeTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noticeTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIGuildWarBuffView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIGuildWarBuffView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/DscBox/GuildWarBuyBuffItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/GuildWarBuyBuffItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildWarBuyBuffItem = CommonUtil.BindGridViewItem2LuaStatic("GuildWarBuyBuffItem", tmp)
	self.guildWarBuyBuffItem.prefabName = "GuildWarBuyBuffItem"
end

---@private
function UIGuildWarBuffView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIGuildWarBuffView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnBox/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp
end

---@private
function UIGuildWarBuffView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnBox/Title/QuestionTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Title/QuestionTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.questionTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIGuildWarBuffView:GenerateDestroy()
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.noticeTitle) ~= nil then
		tolua.setpeer(self.noticeTitle, nil)
	end
	self.noticeTitle = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if self.guildWarBuyBuffItem.GenerateDestroy ~= nil then
		self.guildWarBuyBuffItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildWarBuyBuffItem) ~= nil then
		tolua.setpeer(self.guildWarBuyBuffItem, nil)
	end
	self.guildWarBuyBuffItem = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.questionTxt) ~= nil then
		tolua.setpeer(self.questionTxt, nil)
	end
	self.questionTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildWarBuffView