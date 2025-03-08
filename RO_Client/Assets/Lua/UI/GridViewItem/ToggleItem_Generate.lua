---@class ToggleItem__Generate_label
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ToggleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private on UnityEngine.GameObject
---@field private label ToggleItem__Generate_label
local ToggleItemView = class("ToggleItemView")

function ToggleItemView:ctor()
end

---@private
function ToggleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ToggleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function ToggleItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ToggleItemView:InitGenerate__2(Root, data)
--[[
	On
--]]
	local tmp = Root:Find("On").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.on = tmp
end

---@private
function ToggleItemView:InitGenerate__3(Root, data)
--[[
	Label
--]]
	local tmp = Root:Find("Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ToggleItemView:GenerateDestroy()
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	if tolua.getpeer(self.on) ~= nil then
		tolua.setpeer(self.on, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ToggleItemView