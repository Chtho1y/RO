---@class CardIconBigItem__Generate_count
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class CardIconBigItem__Generate_cardLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardIconBigItem__Generate_level
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardIconBigItem__Generate_name_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardIconBigItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text CardIconBigItem__Generate_name_text

---@class CardIconBigItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardIconBigItem__Generate_iconCard
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardIconBigItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class CardIconBigItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg CardIconBigItem__Generate_bg
---@field private iconCard CardIconBigItem__Generate_iconCard
---@field private frame CardIconBigItem__Generate_frame
---@field private name CardIconBigItem__Generate_name
---@field private level CardIconBigItem__Generate_level
---@field private cardLabel CardIconBigItem__Generate_cardLabel
---@field private count CardIconBigItem__Generate_count
local CardIconBigItemView = class("CardIconBigItemView")

function CardIconBigItemView:ctor()
end

---@private
function CardIconBigItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardIconBigItemView:InitGenerate(Root, data)
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
function CardIconBigItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardIconBigItemView:InitGenerate__2(Root, data)
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
function CardIconBigItemView:InitGenerate__3(Root, data)
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
function CardIconBigItemView:InitGenerate__4(Root, data)
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
function CardIconBigItemView:InitGenerate__5(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp
end

---@private
function CardIconBigItemView:InitGenerate__6(Root, data)
--[[
	Name/Text
--]]
	local tmp = Root:Find("Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardIconBigItemView:InitGenerate__7(Root, data)
--[[
	Level
--]]
	local tmp = Root:Find("Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.level = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardIconBigItemView:InitGenerate__8(Root, data)
--[[
	CardLabel
--]]
	local tmp = Root:Find("CardLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardIconBigItemView:InitGenerate__9(Root, data)
--[[
	Count
--]]
	local tmp = Root:Find("Count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function CardIconBigItemView:GenerateDestroy()
	if tolua.getpeer(self.name.text) ~= nil then
		tolua.setpeer(self.name.text, nil)
	end
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
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.level) ~= nil then
		tolua.setpeer(self.level, nil)
	end
	self.level = nil
	if tolua.getpeer(self.cardLabel) ~= nil then
		tolua.setpeer(self.cardLabel, nil)
	end
	self.cardLabel = nil
	if tolua.getpeer(self.count) ~= nil then
		tolua.setpeer(self.count, nil)
	end
	self.count = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardIconBigItemView