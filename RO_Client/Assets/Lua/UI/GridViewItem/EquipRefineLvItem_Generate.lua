---@class EquipRefineLvItem__Generate_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipRefineLvItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class EquipRefineLvItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private actived UnityEngine.GameObject
---@field private text EquipRefineLvItem__Generate_text
---@field private text2 EquipRefineLvItem__Generate_text2
local EquipRefineLvItemView = class("EquipRefineLvItemView")

function EquipRefineLvItemView:ctor()
end

---@private
function EquipRefineLvItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipRefineLvItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function EquipRefineLvItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipRefineLvItemView:InitGenerate__2(Root, data)
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
function EquipRefineLvItemView:InitGenerate__3(Root, data)
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
function EquipRefineLvItemView:InitGenerate__4(Root, data)
--[[
	Text2
--]]
	local tmp = Root:Find("Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipRefineLvItemView:GenerateDestroy()
	if tolua.getpeer(self.actived) ~= nil then
		tolua.setpeer(self.actived, nil)
	end
	self.actived = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.text2) ~= nil then
		tolua.setpeer(self.text2, nil)
	end
	self.text2 = nil
	self.inited = false
end
return EquipRefineLvItemView