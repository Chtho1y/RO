---@class ChangeGuildBadgeItem__Generate_used
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeGuildBadgeItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeGuildBadgeItem__Generate_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeGuildBadgeItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeGuildBadgeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private bg ChangeGuildBadgeItem__Generate_bg
---@field private badge ChangeGuildBadgeItem__Generate_badge
---@field private frame ChangeGuildBadgeItem__Generate_frame
---@field private used ChangeGuildBadgeItem__Generate_used
---@field private selected UnityEngine.GameObject
local ChangeGuildBadgeItemView = class("ChangeGuildBadgeItemView")

function ChangeGuildBadgeItemView:ctor()
end

---@private
function ChangeGuildBadgeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ChangeGuildBadgeItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function ChangeGuildBadgeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChangeGuildBadgeItemView:InitGenerate__2(Root, data)
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
function ChangeGuildBadgeItemView:InitGenerate__3(Root, data)
--[[
	Badge
--]]
	local tmp = Root:Find("Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChangeGuildBadgeItemView:InitGenerate__4(Root, data)
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
function ChangeGuildBadgeItemView:InitGenerate__5(Root, data)
--[[
	Used
--]]
	local tmp = Root:Find("Used").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.used = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChangeGuildBadgeItemView:InitGenerate__6(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function ChangeGuildBadgeItemView:GenerateDestroy()
	if tolua.getpeer(self.used) ~= nil then
		tolua.setpeer(self.used, nil)
	end
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	if tolua.getpeer(self.badge) ~= nil then
		tolua.setpeer(self.badge, nil)
	end
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ChangeGuildBadgeItemView