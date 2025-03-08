---@class PetRuneItem__Generate_lv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class PetRuneItem__Generate_slot
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PetRuneItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PetRuneItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PetRuneItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class PetRuneItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg PetRuneItem__Generate_bg
---@field private icon PetRuneItem__Generate_icon
---@field private frame PetRuneItem__Generate_frame
---@field private slot PetRuneItem__Generate_slot
---@field private lv PetRuneItem__Generate_lv
local PetRuneItemView = class("PetRuneItemView")

function PetRuneItemView:ctor()
end

---@private
function PetRuneItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PetRuneItemView:InitGenerate(Root, data)
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
function PetRuneItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PetRuneItemView:InitGenerate__2(Root, data)
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
function PetRuneItemView:InitGenerate__3(Root, data)
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
function PetRuneItemView:InitGenerate__4(Root, data)
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
function PetRuneItemView:InitGenerate__5(Root, data)
--[[
	Slot
--]]
	local tmp = Root:Find("Slot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PetRuneItemView:InitGenerate__6(Root, data)
--[[
	Lv
--]]
	local tmp = Root:Find("Lv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function PetRuneItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.slot) ~= nil then
		tolua.setpeer(self.slot, nil)
	end
	self.slot = nil
	if tolua.getpeer(self.lv) ~= nil then
		tolua.setpeer(self.lv, nil)
	end
	self.lv = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PetRuneItemView