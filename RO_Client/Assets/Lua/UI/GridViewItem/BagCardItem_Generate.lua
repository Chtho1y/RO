---@class BagCardItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class BagCardItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BagCardItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BagCardItem__Generate_iconCard
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BagCardItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class BagCardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg BagCardItem__Generate_bg
---@field private iconCard BagCardItem__Generate_iconCard
---@field private frame BagCardItem__Generate_frame
---@field private lableMini UnityEngine.GameObject
---@field private lableMVP UnityEngine.GameObject
---@field private lablePosition UnityEngine.GameObject
---@field private icon BagCardItem__Generate_icon
---@field private num BagCardItem__Generate_num
---@field private redPoint UnityEngine.GameObject
local BagCardItemView = class("BagCardItemView")

function BagCardItemView:ctor()
end

---@private
function BagCardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BagCardItemView:InitGenerate(Root, data)
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


end

---@private
function BagCardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function BagCardItemView:InitGenerate__2(Root, data)
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
function BagCardItemView:InitGenerate__3(Root, data)
--[[
	IconCard
--]]
	local tmp = Root:Find("IconCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconCard = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BagCardItemView:InitGenerate__4(Root, data)
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
function BagCardItemView:InitGenerate__5(Root, data)
--[[
	LableMini
--]]
	local tmp = Root:Find("LableMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lableMini = tmp
end

---@private
function BagCardItemView:InitGenerate__6(Root, data)
--[[
	LableMVP
--]]
	local tmp = Root:Find("LableMVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lableMVP = tmp
end

---@private
function BagCardItemView:InitGenerate__7(Root, data)
--[[
	LablePosition
--]]
	local tmp = Root:Find("LablePosition").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lablePosition = tmp
end

---@private
function BagCardItemView:InitGenerate__8(Root, data)
--[[
	LablePosition/icon
--]]
	local tmp = Root:Find("LablePosition/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BagCardItemView:InitGenerate__9(Root, data)
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
function BagCardItemView:InitGenerate__10(Root, data)
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
function BagCardItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.iconCard) ~= nil then
		tolua.setpeer(self.iconCard, nil)
	end
	self.iconCard = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.lableMini) ~= nil then
		tolua.setpeer(self.lableMini, nil)
	end
	self.lableMini = nil
	if tolua.getpeer(self.lableMVP) ~= nil then
		tolua.setpeer(self.lableMVP, nil)
	end
	self.lableMVP = nil
	if tolua.getpeer(self.lablePosition) ~= nil then
		tolua.setpeer(self.lablePosition, nil)
	end
	self.lablePosition = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
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
return BagCardItemView