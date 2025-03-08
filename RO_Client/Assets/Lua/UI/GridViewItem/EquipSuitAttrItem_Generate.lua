---@class EquipSuitAttrItem__Generate_actived_textDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class EquipSuitAttrItem__Generate_actived_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipSuitAttrItem__Generate_actived
---@field public gameObject UnityEngine.GameObject
---@field public bg EquipSuitAttrItem__Generate_actived_bg
---@field public textDsc EquipSuitAttrItem__Generate_actived_textDsc

---@class EquipSuitAttrItem__Generate_textDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class EquipSuitAttrItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipSuitAttrItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class EquipSuitAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text EquipSuitAttrItem__Generate_text
---@field private number EquipSuitAttrItem__Generate_number
---@field private textDsc EquipSuitAttrItem__Generate_textDsc
---@field private actived EquipSuitAttrItem__Generate_actived
local EquipSuitAttrItemView = class("EquipSuitAttrItemView")

function EquipSuitAttrItemView:ctor()
end

---@private
function EquipSuitAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipSuitAttrItemView:InitGenerate(Root, data)
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


end

---@private
function EquipSuitAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipSuitAttrItemView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function EquipSuitAttrItemView:InitGenerate__3(Root, data)
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
function EquipSuitAttrItemView:InitGenerate__4(Root, data)
--[[
	TextDsc
--]]
	local tmp = Root:Find("TextDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function EquipSuitAttrItemView:InitGenerate__5(Root, data)
--[[
	Actived
--]]
	local tmp = Root:Find("Actived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.actived = tmp
end

---@private
function EquipSuitAttrItemView:InitGenerate__6(Root, data)
--[[
	Actived/bg
--]]
	local tmp = Root:Find("Actived/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.actived.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipSuitAttrItemView:InitGenerate__7(Root, data)
--[[
	Actived/TextDsc
--]]
	local tmp = Root:Find("Actived/TextDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.actived.textDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function EquipSuitAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.actived.textDsc) ~= nil then
		tolua.setpeer(self.actived.textDsc, nil)
	end
	if tolua.getpeer(self.actived.bg) ~= nil then
		tolua.setpeer(self.actived.bg, nil)
	end
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.textDsc) ~= nil then
		tolua.setpeer(self.textDsc, nil)
	end
	self.textDsc = nil
	if tolua.getpeer(self.actived) ~= nil then
		tolua.setpeer(self.actived, nil)
	end
	self.actived = nil
	self.inited = false
end
return EquipSuitAttrItemView