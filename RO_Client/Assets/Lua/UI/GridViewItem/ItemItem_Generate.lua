---@class ItemItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ItemItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ItemItem__Generate_equip
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ItemItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class ItemItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg ItemItem__Generate_bg
---@field private equip ItemItem__Generate_equip
---@field private frame ItemItem__Generate_frame
---@field private num ItemItem__Generate_num
---@field private redPoint UnityEngine.GameObject
local ItemItemView = class("ItemItemView")

function ItemItemView:ctor()
end

---@private
function ItemItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ItemItemView:InitGenerate(Root, data)
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
function ItemItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ItemItemView:InitGenerate__2(Root, data)
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
function ItemItemView:InitGenerate__3(Root, data)
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
function ItemItemView:InitGenerate__4(Root, data)
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
function ItemItemView:InitGenerate__5(Root, data)
--[[
	Num
--]]
	local tmp = Root:Find("Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ItemItemView:InitGenerate__6(Root, data)
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
function ItemItemView:GenerateDestroy()
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
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	self.inited = false
end
return ItemItemView