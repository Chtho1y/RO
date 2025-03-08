---@class RuneShopLimitedItem__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopLimitedItem__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopLimitedItem__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopLimitedItem__Generate_presentPrice_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopLimitedItem__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public shadow RuneShopLimitedItem__Generate_presentPrice_shadow
---@field public number RuneShopLimitedItem__Generate_presentPrice_number
---@field public icon RuneShopLimitedItem__Generate_presentPrice_icon
---@field public currency RuneShopLimitedItem__Generate_presentPrice_currency

---@class RuneShopLimitedItem__Generate_timerLab_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopLimitedItem__Generate_timerLab
---@field public gameObject UnityEngine.GameObject
---@field public text RuneShopLimitedItem__Generate_timerLab_text

---@class RuneShopLimitedItem__Generate_itemIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopLimitedItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private itemIcon RuneShopLimitedItem__Generate_itemIcon
---@field private timerLab RuneShopLimitedItem__Generate_timerLab
---@field private label UnityEngine.GameObject
---@field private presentPrice RuneShopLimitedItem__Generate_presentPrice
---@field private soldout UnityEngine.GameObject
---@field private redPoint UnityEngine.GameObject
---@field private uINewRP UnityEngine.GameObject
local RuneShopLimitedItemView = class("RuneShopLimitedItemView")

function RuneShopLimitedItemView:ctor()
end

---@private
function RuneShopLimitedItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RuneShopLimitedItemView:InitGenerate(Root, data)
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
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)


end

---@private
function RuneShopLimitedItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RuneShopLimitedItemView:InitGenerate__2(Root, data)
--[[
	ItemIcon
--]]
	local tmp = Root:Find("ItemIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopLimitedItemView:InitGenerate__3(Root, data)
--[[
	TimerLab
--]]
	local tmp = Root:Find("TimerLab").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timerLab = tmp
end

---@private
function RuneShopLimitedItemView:InitGenerate__4(Root, data)
--[[
	TimerLab/Label
--]]
	local tmp = Root:Find("TimerLab/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp
end

---@private
function RuneShopLimitedItemView:InitGenerate__5(Root, data)
--[[
	TimerLab/Text
--]]
	local tmp = Root:Find("TimerLab/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timerLab.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RuneShopLimitedItemView:InitGenerate__6(Root, data)
--[[
	PresentPrice
--]]
	local tmp = Root:Find("PresentPrice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RuneShopLimitedItemView:InitGenerate__7(Root, data)
--[[
	PresentPrice/shadow
--]]
	local tmp = Root:Find("PresentPrice/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopLimitedItemView:InitGenerate__8(Root, data)
--[[
	PresentPrice/Number
--]]
	local tmp = Root:Find("PresentPrice/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RuneShopLimitedItemView:InitGenerate__9(Root, data)
--[[
	PresentPrice/Icon
--]]
	local tmp = Root:Find("PresentPrice/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopLimitedItemView:InitGenerate__10(Root, data)
--[[
	PresentPrice/Currency
--]]
	local tmp = Root:Find("PresentPrice/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.currency = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RuneShopLimitedItemView:InitGenerate__11(Root, data)
--[[
	Soldout
--]]
	local tmp = Root:Find("Soldout").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.soldout = tmp
end

---@private
function RuneShopLimitedItemView:InitGenerate__12(Root, data)
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
function RuneShopLimitedItemView:InitGenerate__13(Root, data)
--[[
	RedPoint/UINewRP
--]]
	local tmp = Root:Find("RedPoint/UINewRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uINewRP = tmp
end

---@private
function RuneShopLimitedItemView:GenerateDestroy()
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	if tolua.getpeer(self.soldout) ~= nil then
		tolua.setpeer(self.soldout, nil)
	end
	if tolua.getpeer(self.presentPrice.currency) ~= nil then
		tolua.setpeer(self.presentPrice.currency, nil)
	end
	if tolua.getpeer(self.presentPrice.icon) ~= nil then
		tolua.setpeer(self.presentPrice.icon, nil)
	end
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.presentPrice.shadow) ~= nil then
		tolua.setpeer(self.presentPrice.shadow, nil)
	end
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	if tolua.getpeer(self.timerLab.text) ~= nil then
		tolua.setpeer(self.timerLab.text, nil)
	end
	if tolua.getpeer(self.timerLab) ~= nil then
		tolua.setpeer(self.timerLab, nil)
	end
	if tolua.getpeer(self.itemIcon) ~= nil then
		tolua.setpeer(self.itemIcon, nil)
	end
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.uINewRP) ~= nil then
		tolua.setpeer(self.uINewRP, nil)
	end
	self.uINewRP = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RuneShopLimitedItemView