---@class ChangeHeadFrameItem__Generate_used
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadFrameItem__Generate_frameImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class ChangeHeadFrameItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadFrameItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private selected UnityEngine.GameObject
---@field private icon ChangeHeadFrameItem__Generate_icon
---@field private frameImg ChangeHeadFrameItem__Generate_frameImg
---@field private locked UnityEngine.GameObject
---@field private lock UnityEngine.GameObject
---@field private limited UnityEngine.GameObject
---@field private used ChangeHeadFrameItem__Generate_used
---@field private redPoint UnityEngine.GameObject
local ChangeHeadFrameItemView = class("ChangeHeadFrameItemView")

function ChangeHeadFrameItemView:ctor()
end

---@private
function ChangeHeadFrameItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ChangeHeadFrameItemView:InitGenerate(Root, data)
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


end

---@private
function ChangeHeadFrameItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChangeHeadFrameItemView:InitGenerate__2(Root, data)
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
function ChangeHeadFrameItemView:InitGenerate__3(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChangeHeadFrameItemView:InitGenerate__4(Root, data)
--[[
	FrameLead
--]]
	local tmp = Root:Find("FrameLead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frameImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChangeHeadFrameItemView:InitGenerate__5(Root, data)
--[[
	Locked
--]]
	local tmp = Root:Find("Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked = tmp
end

---@private
function ChangeHeadFrameItemView:InitGenerate__6(Root, data)
--[[
	Locked/lock
--]]
	local tmp = Root:Find("Locked/lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock = tmp
end

---@private
function ChangeHeadFrameItemView:InitGenerate__7(Root, data)
--[[
	Limited
--]]
	local tmp = Root:Find("Limited").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limited = tmp
end

---@private
function ChangeHeadFrameItemView:InitGenerate__8(Root, data)
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
function ChangeHeadFrameItemView:InitGenerate__9(Root, data)
--[[
	RedPoint
--]]
	local tmp = Root:Find("RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function ChangeHeadFrameItemView:GenerateDestroy()
	if tolua.getpeer(self.used) ~= nil then
		tolua.setpeer(self.used, nil)
	end
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frameImg) ~= nil then
		tolua.setpeer(self.frameImg, nil)
	end
	self.frameImg = nil
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	self.locked = nil
	if tolua.getpeer(self.lock) ~= nil then
		tolua.setpeer(self.lock, nil)
	end
	self.lock = nil
	if tolua.getpeer(self.limited) ~= nil then
		tolua.setpeer(self.limited, nil)
	end
	self.limited = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ChangeHeadFrameItemView