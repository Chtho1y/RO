---@class GuildBadgeItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildBadgeItem__Generate_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class GuildBadgeItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildBadgeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private bg GuildBadgeItem__Generate_bg
---@field private badge GuildBadgeItem__Generate_badge
---@field private frame GuildBadgeItem__Generate_frame
local GuildBadgeItemView = class("GuildBadgeItemView")

function GuildBadgeItemView:ctor()
end

---@private
function GuildBadgeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildBadgeItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function GuildBadgeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function GuildBadgeItemView:InitGenerate__2(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildBadgeItemView:InitGenerate__3(Root, data)
--[[
	Badge
--]]
	local tmp = Root:Find("Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildBadgeItemView:InitGenerate__4(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildBadgeItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.badge) ~= nil then
		tolua.setpeer(self.badge, nil)
	end
	self.badge = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildBadgeItemView