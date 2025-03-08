---@class LimitedGiftItem__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class LimitedGiftItem__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class LimitedGiftItem__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public number LimitedGiftItem__Generate_presentPrice_number
---@field public currency LimitedGiftItem__Generate_presentPrice_currency

---@class LimitedGiftItem__Generate_endTimeText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class LimitedGiftItem__Generate_value
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class LimitedGiftItem__Generate_levelText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class LimitedGiftItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private banner2 UnityEngine.GameObject
---@field private table1 UnityEngine.GameObject
---@field private table2 UnityEngine.GameObject
---@field private levelText LimitedGiftItem__Generate_levelText
---@field private value LimitedGiftItem__Generate_value
---@field private item1 UnityEngine.GameObject
---@field private item2 UnityEngine.GameObject
---@field private item3 UnityEngine.GameObject
---@field private item4 UnityEngine.GameObject
---@field private endTimeText LimitedGiftItem__Generate_endTimeText
---@field private presentPrice LimitedGiftItem__Generate_presentPrice
local LimitedGiftItemView = class("LimitedGiftItemView")

function LimitedGiftItemView:ctor()
end

---@private
function LimitedGiftItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function LimitedGiftItemView:InitGenerate(Root, data)
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
	self:InitGenerate__14(Root,data)


end

---@private
function LimitedGiftItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function LimitedGiftItemView:InitGenerate__2(Root, data)
--[[
	BG/Banner2
--]]
	local tmp = Root:Find("BG/Banner2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner2 = tmp
end

---@private
function LimitedGiftItemView:InitGenerate__3(Root, data)
--[[
	BG/table1
--]]
	local tmp = Root:Find("BG/table1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.table1 = tmp
end

---@private
function LimitedGiftItemView:InitGenerate__4(Root, data)
--[[
	BG/table2
--]]
	local tmp = Root:Find("BG/table2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.table2 = tmp
end

---@private
function LimitedGiftItemView:InitGenerate__5(Root, data)
--[[
	Talk/Text
--]]
	local tmp = Root:Find("Talk/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function LimitedGiftItemView:InitGenerate__6(Root, data)
--[[
	Value
--]]
	local tmp = Root:Find("Value").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.value = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function LimitedGiftItemView:InitGenerate__7(Root, data)
--[[
	Rewards/Item1
--]]
	local tmp = Root:Find("Rewards/Item1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1 = tmp
	self.item1:SetActive(false)
end

---@private
function LimitedGiftItemView:InitGenerate__8(Root, data)
--[[
	Rewards/Item2
--]]
	local tmp = Root:Find("Rewards/Item2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2 = tmp
	self.item2:SetActive(false)
end

---@private
function LimitedGiftItemView:InitGenerate__9(Root, data)
--[[
	Rewards/Item3
--]]
	local tmp = Root:Find("Rewards/Item3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3 = tmp
	self.item3:SetActive(false)
end

---@private
function LimitedGiftItemView:InitGenerate__10(Root, data)
--[[
	Rewards/Item4
--]]
	local tmp = Root:Find("Rewards/Item4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4 = tmp
	self.item4:SetActive(false)
end

---@private
function LimitedGiftItemView:InitGenerate__11(Root, data)
--[[
	Dsc/Text
--]]
	local tmp = Root:Find("Dsc/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.endTimeText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function LimitedGiftItemView:InitGenerate__12(Root, data)
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
function LimitedGiftItemView:InitGenerate__13(Root, data)
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
function LimitedGiftItemView:InitGenerate__14(Root, data)
--[[
	PresentPrice/Currency
--]]
	local tmp = Root:Find("PresentPrice/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.currency = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function LimitedGiftItemView:GenerateDestroy()
	if tolua.getpeer(self.presentPrice.currency) ~= nil then
		tolua.setpeer(self.presentPrice.currency, nil)
	end
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.banner2) ~= nil then
		tolua.setpeer(self.banner2, nil)
	end
	self.banner2 = nil
	if tolua.getpeer(self.table1) ~= nil then
		tolua.setpeer(self.table1, nil)
	end
	self.table1 = nil
	if tolua.getpeer(self.table2) ~= nil then
		tolua.setpeer(self.table2, nil)
	end
	self.table2 = nil
	if tolua.getpeer(self.levelText) ~= nil then
		tolua.setpeer(self.levelText, nil)
	end
	self.levelText = nil
	if tolua.getpeer(self.value) ~= nil then
		tolua.setpeer(self.value, nil)
	end
	self.value = nil
	if tolua.getpeer(self.item1) ~= nil then
		tolua.setpeer(self.item1, nil)
	end
	self.item1 = nil
	if tolua.getpeer(self.item2) ~= nil then
		tolua.setpeer(self.item2, nil)
	end
	self.item2 = nil
	if tolua.getpeer(self.item3) ~= nil then
		tolua.setpeer(self.item3, nil)
	end
	self.item3 = nil
	if tolua.getpeer(self.item4) ~= nil then
		tolua.setpeer(self.item4, nil)
	end
	self.item4 = nil
	if tolua.getpeer(self.endTimeText) ~= nil then
		tolua.setpeer(self.endTimeText, nil)
	end
	self.endTimeText = nil
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	self.presentPrice = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return LimitedGiftItemView