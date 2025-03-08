---@class EquipItem__Generate_textLV
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class EquipItem__Generate_equipLv
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipItem__Generate_lvBG
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipItem__Generate_equip
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class EquipItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg EquipItem__Generate_bg
---@field private equip EquipItem__Generate_equip
---@field private frame EquipItem__Generate_frame
---@field private lvBG EquipItem__Generate_lvBG
---@field private number EquipItem__Generate_number
---@field private equipLv EquipItem__Generate_equipLv
---@field private num EquipItem__Generate_num
---@field private textLV EquipItem__Generate_textLV
---@field private selected UnityEngine.GameObject
---@field private redPoint UnityEngine.GameObject
local EquipItemView = class("EquipItemView")

function EquipItemView:ctor()
end

---@private
function EquipItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipItemView:InitGenerate(Root, data)
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
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)


end

---@private
function EquipItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipItemView:InitGenerate__2(Root, data)
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
function EquipItemView:InitGenerate__3(Root, data)
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
function EquipItemView:InitGenerate__4(Root, data)
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
function EquipItemView:InitGenerate__5(Root, data)
--[[
	LvBG
--]]
	local tmp = Root:Find("LvBG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvBG = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipItemView:InitGenerate__6(Root, data)
--[[
	Number
--]]
	local tmp = Root:Find("Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipItemView:InitGenerate__7(Root, data)
--[[
	EquipLv
--]]
	local tmp = Root:Find("EquipLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipLv = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipItemView:InitGenerate__8(Root, data)
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
function EquipItemView:InitGenerate__9(Root, data)
--[[
	TextLV
--]]
	local tmp = Root:Find("TextLV").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textLV = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipItemView:InitGenerate__10(Root, data)
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
function EquipItemView:InitGenerate__11(Root, data)
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
function EquipItemView:GenerateDestroy()
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
	if tolua.getpeer(self.lvBG) ~= nil then
		tolua.setpeer(self.lvBG, nil)
	end
	self.lvBG = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.equipLv) ~= nil then
		tolua.setpeer(self.equipLv, nil)
	end
	self.equipLv = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.textLV) ~= nil then
		tolua.setpeer(self.textLV, nil)
	end
	self.textLV = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	self.inited = false
end
return EquipItemView