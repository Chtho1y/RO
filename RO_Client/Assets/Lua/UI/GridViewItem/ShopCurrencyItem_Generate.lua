---@class ShopCurrencyItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ShopCurrencyItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ShopCurrencyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private icon ShopCurrencyItem__Generate_icon
---@field private number ShopCurrencyItem__Generate_number
local ShopCurrencyItemView = class("ShopCurrencyItemView")

function ShopCurrencyItemView:ctor()
end

---@private
function ShopCurrencyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ShopCurrencyItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function ShopCurrencyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ShopCurrencyItemView:InitGenerate__2(Root, data)
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
function ShopCurrencyItemView:InitGenerate__3(Root, data)
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
function ShopCurrencyItemView:GenerateDestroy()
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ShopCurrencyItemView