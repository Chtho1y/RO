---@class RankShopLimitedItem__Generate_labelLimited_textLimited
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class RankShopLimitedItem__Generate_labelLimited
---@field public gameObject UnityEngine.GameObject
---@field public textLimited RankShopLimitedItem__Generate_labelLimited_textLimited

---@class RankShopLimitedItem__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RankShopLimitedItem__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankShopLimitedItem__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RankShopLimitedItem__Generate_presentPrice_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankShopLimitedItem__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public shadow RankShopLimitedItem__Generate_presentPrice_shadow
---@field public number RankShopLimitedItem__Generate_presentPrice_number
---@field public icon RankShopLimitedItem__Generate_presentPrice_icon
---@field public currency RankShopLimitedItem__Generate_presentPrice_currency

---@class RankShopLimitedItem__Generate_saveLabel_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RankShopLimitedItem__Generate_saveLabel
---@field public gameObject UnityEngine.GameObject
---@field public text RankShopLimitedItem__Generate_saveLabel_text

---@class RankShopLimitedItem__Generate_itemText
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankShopLimitedItem__Generate_RewardsNode
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class RankShopLimitedItem__Generate_itemBg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankShopLimitedItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private itemBg RankShopLimitedItem__Generate_itemBg
---@field private RewardsNode RankShopLimitedItem__Generate_RewardsNode
---@field private itemText RankShopLimitedItem__Generate_itemText
---@field private saveLabel RankShopLimitedItem__Generate_saveLabel
---@field private image UnityEngine.GameObject
---@field private presentPrice RankShopLimitedItem__Generate_presentPrice
---@field private soldout UnityEngine.GameObject
---@field private labelLimited RankShopLimitedItem__Generate_labelLimited
local RankShopLimitedItemView = class("RankShopLimitedItemView")

function RankShopLimitedItemView:ctor()
end

---@private
function RankShopLimitedItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RankShopLimitedItemView:InitGenerate(Root, data)
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
	self:InitGenerate__15(Root,data)


end

---@private
function RankShopLimitedItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RankShopLimitedItemView:InitGenerate__2(Root, data)
--[[
	ItemBg
--]]
	local tmp = Root:Find("ItemBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemBg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankShopLimitedItemView:InitGenerate__3(Root, data)
--[[
	RewardsList/Viewport/Content/Rewards
--]]
	local tmp = Root:Find("RewardsList/Viewport/Content/Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.RewardsNode = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RankShopLimitedItemView:InitGenerate__4(Root, data)
--[[
	ItemText
--]]
	local tmp = Root:Find("ItemText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemText = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankShopLimitedItemView:InitGenerate__5(Root, data)
--[[
	SaveLabel
--]]
	local tmp = Root:Find("SaveLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.saveLabel = tmp
end

---@private
function RankShopLimitedItemView:InitGenerate__6(Root, data)
--[[
	SaveLabel/Image
--]]
	local tmp = Root:Find("SaveLabel/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp
end

---@private
function RankShopLimitedItemView:InitGenerate__7(Root, data)
--[[
	SaveLabel/Text
--]]
	local tmp = Root:Find("SaveLabel/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.saveLabel.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RankShopLimitedItemView:InitGenerate__8(Root, data)
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
function RankShopLimitedItemView:InitGenerate__9(Root, data)
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
function RankShopLimitedItemView:InitGenerate__10(Root, data)
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
function RankShopLimitedItemView:InitGenerate__11(Root, data)
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
function RankShopLimitedItemView:InitGenerate__12(Root, data)
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
function RankShopLimitedItemView:InitGenerate__13(Root, data)
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
function RankShopLimitedItemView:InitGenerate__14(Root, data)
--[[
	LabelLimited
--]]
	local tmp = Root:Find("LabelLimited").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelLimited = tmp
end

---@private
function RankShopLimitedItemView:InitGenerate__15(Root, data)
--[[
	LabelLimited/TextLimited
--]]
	local tmp = Root:Find("LabelLimited/TextLimited").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelLimited.textLimited = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function RankShopLimitedItemView:GenerateDestroy()
	if tolua.getpeer(self.labelLimited.textLimited) ~= nil then
		tolua.setpeer(self.labelLimited.textLimited, nil)
	end
	if tolua.getpeer(self.labelLimited) ~= nil then
		tolua.setpeer(self.labelLimited, nil)
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
	if tolua.getpeer(self.saveLabel.text) ~= nil then
		tolua.setpeer(self.saveLabel.text, nil)
	end
	if tolua.getpeer(self.saveLabel) ~= nil then
		tolua.setpeer(self.saveLabel, nil)
	end
	if tolua.getpeer(self.itemText) ~= nil then
		tolua.setpeer(self.itemText, nil)
	end
	if tolua.getpeer(self.itemBg) ~= nil then
		tolua.setpeer(self.itemBg, nil)
	end
	self.itemBg = nil
	if tolua.getpeer(self.RewardsNode) ~= nil then
		tolua.setpeer(self.RewardsNode, nil)
	end
	self.RewardsNode = nil
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RankShopLimitedItemView