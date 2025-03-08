---@class ChangeHeadItem__Generate_used
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadItem__Generate_head
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChangeHeadItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private bg ChangeHeadItem__Generate_bg
---@field private head ChangeHeadItem__Generate_head
---@field private frame ChangeHeadItem__Generate_frame
---@field private used ChangeHeadItem__Generate_used
---@field private locked UnityEngine.GameObject
---@field private icon UnityEngine.GameObject
---@field private selected UnityEngine.GameObject
local ChangeHeadItemView = class("ChangeHeadItemView")

function ChangeHeadItemView:ctor()
end

---@private
function ChangeHeadItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ChangeHeadItemView:InitGenerate(Root, data)
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


end

---@private
function ChangeHeadItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ChangeHeadItemView:InitGenerate__2(Root, data)
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
function ChangeHeadItemView:InitGenerate__3(Root, data)
--[[
	Head
--]]
	local tmp = Root:Find("Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.head = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChangeHeadItemView:InitGenerate__4(Root, data)
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
function ChangeHeadItemView:InitGenerate__5(Root, data)
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
function ChangeHeadItemView:InitGenerate__6(Root, data)
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
function ChangeHeadItemView:InitGenerate__7(Root, data)
--[[
	Locked/Icon
--]]
	local tmp = Root:Find("Locked/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp
end

---@private
function ChangeHeadItemView:InitGenerate__8(Root, data)
--[[
	selected
--]]
	local tmp = Root:Find("selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function ChangeHeadItemView:GenerateDestroy()
	if tolua.getpeer(self.used) ~= nil then
		tolua.setpeer(self.used, nil)
	end
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	if tolua.getpeer(self.head) ~= nil then
		tolua.setpeer(self.head, nil)
	end
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	self.locked = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	self.inited = false
end
return ChangeHeadItemView