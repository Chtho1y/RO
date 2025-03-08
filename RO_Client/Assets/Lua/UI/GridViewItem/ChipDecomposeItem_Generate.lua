---@class ChipDecomposeItem__Generate_btnRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class ChipDecomposeItem__Generate_number_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ChipDecomposeItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text ChipDecomposeItem__Generate_number_text

---@class ChipDecomposeItem__Generate_natureIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChipDecomposeItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChipDecomposeItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ChipDecomposeItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class ChipDecomposeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg ChipDecomposeItem__Generate_bg
---@field private icon ChipDecomposeItem__Generate_icon
---@field private frame ChipDecomposeItem__Generate_frame
---@field private natureIcon ChipDecomposeItem__Generate_natureIcon
---@field private number ChipDecomposeItem__Generate_number
---@field private btnRemove ChipDecomposeItem__Generate_btnRemove
local ChipDecomposeItemView = class("ChipDecomposeItemView")

function ChipDecomposeItemView:ctor()
end

---@private
function ChipDecomposeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ChipDecomposeItemView:InitGenerate(Root, data)
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
function ChipDecomposeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ChipDecomposeItemView:InitGenerate__2(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function ChipDecomposeItemView:InitGenerate__3(Root, data)
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
function ChipDecomposeItemView:InitGenerate__4(Root, data)
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
function ChipDecomposeItemView:InitGenerate__5(Root, data)
--[[
	NatureIcon
--]]
	local tmp = Root:Find("NatureIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.natureIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ChipDecomposeItemView:InitGenerate__6(Root, data)
--[[
	Number
--]]
	local tmp = Root:Find("Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp
end

---@private
function ChipDecomposeItemView:InitGenerate__7(Root, data)
--[[
	Number/Text
--]]
	local tmp = Root:Find("Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ChipDecomposeItemView:InitGenerate__8(Root, data)
--[[
	BtnRemove
--]]
	local tmp = Root:Find("BtnRemove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRemove = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function ChipDecomposeItemView:GenerateDestroy()
	if tolua.getpeer(self.number.text) ~= nil then
		tolua.setpeer(self.number.text, nil)
	end
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
	if tolua.getpeer(self.natureIcon) ~= nil then
		tolua.setpeer(self.natureIcon, nil)
	end
	self.natureIcon = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.btnRemove) ~= nil then
		tolua.setpeer(self.btnRemove, nil)
	end
	self.btnRemove = nil
	self.inited = false
end
return ChipDecomposeItemView