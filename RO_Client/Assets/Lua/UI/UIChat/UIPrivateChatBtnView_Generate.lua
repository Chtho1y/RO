---@class UIPrivateChatBtn__Generate_btnEmoji
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public button UnityEngine.UI.Button
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIPrivateChatBtn__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private btnEmoji UIPrivateChatBtn__Generate_btnEmoji
local UIPrivateChatBtnView = class("UIPrivateChatBtnView", require("UIViewBase"))

function UIPrivateChatBtnView:ctor()
end

---@private
function UIPrivateChatBtnView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPrivateChatBtnView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function UIPrivateChatBtnView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIPrivateChatBtnView:InitGenerate__2(Root, data)
--[[
	BtnEmoji
--]]
	local tmp = Root:Find("BtnEmoji").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEmoji = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIPrivateChatBtnView:GenerateDestroy()
	if tolua.getpeer(self.btnEmoji) ~= nil then
		tolua.setpeer(self.btnEmoji, nil)
	end
	self.btnEmoji = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPrivateChatBtnView