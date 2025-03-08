---@class ShopLabelToggleItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class ShopLabelToggleItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ShopLabelToggleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private off UnityEngine.GameObject
---@field private on UnityEngine.GameObject
---@field private icon ShopLabelToggleItem__Generate_icon
---@field private nameTxt ShopLabelToggleItem__Generate_nameTxt
local ShopLabelToggleItemView = class("ShopLabelToggleItemView")

function ShopLabelToggleItemView:ctor()
end

---@private
function ShopLabelToggleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ShopLabelToggleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)


end

---@private
function ShopLabelToggleItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ShopLabelToggleItemView:InitGenerate__2(Root, data)
--[[
	Off
--]]
	local tmp = Root:Find("Off").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.off = tmp
end

---@private
function ShopLabelToggleItemView:InitGenerate__3(Root, data)
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
function ShopLabelToggleItemView:InitGenerate__4(Root, data)
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
function ShopLabelToggleItemView:InitGenerate__5(Root, data)
--[[
	NameTxt
--]]
	local tmp = Root:Find("NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function ShopLabelToggleItemView:GenerateDestroy()
	if tolua.getpeer(self.on) ~= nil then
		tolua.setpeer(self.on, nil)
	end
	if tolua.getpeer(self.off) ~= nil then
		tolua.setpeer(self.off, nil)
	end
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ShopLabelToggleItemView