---@class BlessCardItem__Generate_buffDesc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BlessCardItem__Generate_buffName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class BlessCardItem__Generate_buffIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BlessCardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private buffIcon BlessCardItem__Generate_buffIcon
---@field private buffName BlessCardItem__Generate_buffName
---@field private buffDesc BlessCardItem__Generate_buffDesc
local BlessCardItemView = class("BlessCardItemView")

function BlessCardItemView:ctor()
end

---@private
function BlessCardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BlessCardItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function BlessCardItemView:InitGenerate__1(Root, data)
--[[
	Image
--]]
	local tmp = Root:Find("Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BlessCardItemView:InitGenerate__2(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function BlessCardItemView:InitGenerate__3(Root, data)
--[[
	Dsc
--]]
	local tmp = Root:Find("Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffDesc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BlessCardItemView:GenerateDestroy()
	if tolua.getpeer(self.buffIcon) ~= nil then
		tolua.setpeer(self.buffIcon, nil)
	end
	self.buffIcon = nil
	if tolua.getpeer(self.buffName) ~= nil then
		tolua.setpeer(self.buffName, nil)
	end
	self.buffName = nil
	if tolua.getpeer(self.buffDesc) ~= nil then
		tolua.setpeer(self.buffDesc, nil)
	end
	self.buffDesc = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BlessCardItemView