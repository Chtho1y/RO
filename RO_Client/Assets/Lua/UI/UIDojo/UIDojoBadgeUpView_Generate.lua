---@class UIDojoBadgeUp__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIDojoBadgeUp__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoBadgeUp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private icon UIDojoBadgeUp__Generate_icon
---@field private textName UIDojoBadgeUp__Generate_textName
local UIDojoBadgeUpView = class("UIDojoBadgeUpView", require("UIViewBase"))

function UIDojoBadgeUpView:ctor()
end

---@private
function UIDojoBadgeUpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoBadgeUpView:InitGenerate(Root, data)
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
function UIDojoBadgeUpView:InitGenerate__1(Root, data)
--[[
	Window/Badge/Icon
--]]
	local tmp = Root:Find("Window/Badge/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoBadgeUpView:InitGenerate__2(Root, data)
--[[
	Window/Badge/TextName
--]]
	local tmp = Root:Find("Window/Badge/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIDojoBadgeUpView:GenerateDestroy()
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoBadgeUpView