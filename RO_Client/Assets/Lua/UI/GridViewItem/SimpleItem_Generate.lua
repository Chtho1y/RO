---@class SimpleItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SimpleItem__Generate_equip
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SimpleItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class SimpleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg SimpleItem__Generate_bg
---@field private equip SimpleItem__Generate_equip
---@field private frame SimpleItem__Generate_frame
local SimpleItemView = class("SimpleItemView")

function SimpleItemView:ctor()
end

---@private
function SimpleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SimpleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function SimpleItemView:InitGenerate__1(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SimpleItemView:InitGenerate__2(Root, data)
--[[
	Equip
--]]
	local tmp = Root:Find("Equip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equip = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function SimpleItemView:InitGenerate__3(Root, data)
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
function SimpleItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.equip) ~= nil then
		tolua.setpeer(self.equip, nil)
	end
	self.equip = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	self.inited = false
end
return SimpleItemView