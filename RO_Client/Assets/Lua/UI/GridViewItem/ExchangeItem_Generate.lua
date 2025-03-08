---@class ExchangeItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ExchangeItem__Generate_dscReminder
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ExchangeItem__Generate_textR
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class ExchangeItem__Generate_button
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ExchangeItem__Generate_reward_iconSmallItem2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExchangeItem__Generate_numberReward
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExchangeItem__Generate_reward
---@field public gameObject UnityEngine.GameObject
---@field public iconSmallItem2 ExchangeItem__Generate_reward_iconSmallItem2

---@class ExchangeItem__Generate_text4
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExchangeItem__Generate_coastItem3_iconSmallItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExchangeItem__Generate_coastItem3
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem1 ExchangeItem__Generate_coastItem3_iconSmallItem1

---@class ExchangeItem__Generate_text3
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExchangeItem__Generate_coastItem2_iconSmallItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExchangeItem__Generate_coastItem2
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem1 ExchangeItem__Generate_coastItem2_iconSmallItem1

---@class ExchangeItem__Generate_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExchangeItem__Generate_coastItem1_iconSmallItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExchangeItem__Generate_coastItem1
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem1 ExchangeItem__Generate_coastItem1_iconSmallItem1

---@class ExchangeItem__Generate_text1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExchangeItem__Generate_coastItem0_iconSmallItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExchangeItem__Generate_coastItem0
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem1 ExchangeItem__Generate_coastItem0_iconSmallItem1

---@class ExchangeItem__Generate_coast
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class ExchangeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private coast ExchangeItem__Generate_coast
---@field private coastItem0 ExchangeItem__Generate_coastItem0
---@field private text1 ExchangeItem__Generate_text1
---@field private coastItem1 ExchangeItem__Generate_coastItem1
---@field private text2 ExchangeItem__Generate_text2
---@field private coastItem2 ExchangeItem__Generate_coastItem2
---@field private text3 ExchangeItem__Generate_text3
---@field private coastItem3 ExchangeItem__Generate_coastItem3
---@field private text4 ExchangeItem__Generate_text4
---@field private reward ExchangeItem__Generate_reward
---@field private numberReward ExchangeItem__Generate_numberReward
---@field private button ExchangeItem__Generate_button
---@field private textR ExchangeItem__Generate_textR
---@field private uIRedPointRP UnityEngine.GameObject
---@field private dscReminder ExchangeItem__Generate_dscReminder
---@field private checkmark UnityEngine.GameObject
---@field private mask UnityEngine.GameObject
---@field private labelReceived UnityEngine.GameObject
---@field private serverLimit UnityEngine.GameObject
---@field private green UnityEngine.GameObject
---@field private red UnityEngine.GameObject
---@field private number ExchangeItem__Generate_number
local ExchangeItemView = class("ExchangeItemView")

function ExchangeItemView:ctor()
end

---@private
function ExchangeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ExchangeItemView:InitGenerate(Root, data)
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
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)


end

---@private
function ExchangeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function ExchangeItemView:InitGenerate__2(Root, data)
--[[
	Coast
--]]
	local tmp = Root:Find("Coast").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coast = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function ExchangeItemView:InitGenerate__3(Root, data)
--[[
	Coast/Viewport/Content/CoastItem0
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem0").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem0 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__4(Root, data)
--[[
	Coast/Viewport/Content/CoastItem0/icon/IconSmallItem1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem0/icon/IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem0.iconSmallItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.coastItem0.iconSmallItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ExchangeItemView:InitGenerate__5(Root, data)
--[[
	Coast/Viewport/Content/CoastItem0/Number/Text1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem0/Number/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ExchangeItemView:InitGenerate__6(Root, data)
--[[
	Coast/Viewport/Content/CoastItem1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem1 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__7(Root, data)
--[[
	Coast/Viewport/Content/CoastItem1/icon/IconSmallItem1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem1/icon/IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem1.iconSmallItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.coastItem1.iconSmallItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ExchangeItemView:InitGenerate__8(Root, data)
--[[
	Coast/Viewport/Content/CoastItem1/Number/Text2
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem1/Number/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ExchangeItemView:InitGenerate__9(Root, data)
--[[
	Coast/Viewport/Content/CoastItem2
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem2 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__10(Root, data)
--[[
	Coast/Viewport/Content/CoastItem2/icon/IconSmallItem1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem2/icon/IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem2.iconSmallItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.coastItem2.iconSmallItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ExchangeItemView:InitGenerate__11(Root, data)
--[[
	Coast/Viewport/Content/CoastItem2/Number/Text3
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem2/Number/Text3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text3 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ExchangeItemView:InitGenerate__12(Root, data)
--[[
	Coast/Viewport/Content/CoastItem3
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem3 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__13(Root, data)
--[[
	Coast/Viewport/Content/CoastItem3/icon/IconSmallItem1
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem3/icon/IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coastItem3.iconSmallItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.coastItem3.iconSmallItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ExchangeItemView:InitGenerate__14(Root, data)
--[[
	Coast/Viewport/Content/CoastItem3/Number/Text4
--]]
	local tmp = Root:Find("Coast/Viewport/Content/CoastItem3/Number/Text4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text4 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ExchangeItemView:InitGenerate__15(Root, data)
--[[
	Reward
--]]
	local tmp = Root:Find("Reward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward = tmp
end

---@private
function ExchangeItemView:InitGenerate__16(Root, data)
--[[
	Reward/Limit/NumberReward
--]]
	local tmp = Root:Find("Reward/Limit/NumberReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberReward = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ExchangeItemView:InitGenerate__17(Root, data)
--[[
	Reward/IconSmallItem2
--]]
	local tmp = Root:Find("Reward/IconSmallItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward.iconSmallItem2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.reward.iconSmallItem2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ExchangeItemView:InitGenerate__18(Root, data)
--[[
	Reward/Button
--]]
	local tmp = Root:Find("Reward/Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.button = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__19(Root, data)
--[[
	Reward/Button/TextR
--]]
	local tmp = Root:Find("Reward/Button/TextR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textR = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function ExchangeItemView:InitGenerate__20(Root, data)
--[[
	Reward/Button/UIRedPointRP
--]]
	local tmp = Root:Find("Reward/Button/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIRedPointRP = tmp
end

---@private
function ExchangeItemView:InitGenerate__21(Root, data)
--[[
	DscReminder
--]]
	local tmp = Root:Find("DscReminder").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscReminder = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExchangeItemView:InitGenerate__22(Root, data)
--[[
	DscReminder/Checkmark
--]]
	local tmp = Root:Find("DscReminder/Checkmark").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.checkmark = tmp
end

---@private
function ExchangeItemView:InitGenerate__23(Root, data)
--[[
	Mask
--]]
	local tmp = Root:Find("Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function ExchangeItemView:InitGenerate__24(Root, data)
--[[
	Mask/LabelReceived
--]]
	local tmp = Root:Find("Mask/LabelReceived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelReceived = tmp
end

---@private
function ExchangeItemView:InitGenerate__25(Root, data)
--[[
	ServerLimit
--]]
	local tmp = Root:Find("ServerLimit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverLimit = tmp
end

---@private
function ExchangeItemView:InitGenerate__26(Root, data)
--[[
	ServerLimit/Green
--]]
	local tmp = Root:Find("ServerLimit/Green").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.green = tmp
end

---@private
function ExchangeItemView:InitGenerate__27(Root, data)
--[[
	ServerLimit/Red
--]]
	local tmp = Root:Find("ServerLimit/Red").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.red = tmp
end

---@private
function ExchangeItemView:InitGenerate__28(Root, data)
--[[
	ServerLimit/Number
--]]
	local tmp = Root:Find("ServerLimit/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ExchangeItemView:GenerateDestroy()
	if self.reward.iconSmallItem2.GenerateDestroy ~= nil then
		self.reward.iconSmallItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.reward.iconSmallItem2) ~= nil then
		tolua.setpeer(self.reward.iconSmallItem2, nil)
	end
	if self.coastItem3.iconSmallItem1.GenerateDestroy ~= nil then
		self.coastItem3.iconSmallItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.coastItem3.iconSmallItem1) ~= nil then
		tolua.setpeer(self.coastItem3.iconSmallItem1, nil)
	end
	if self.coastItem2.iconSmallItem1.GenerateDestroy ~= nil then
		self.coastItem2.iconSmallItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.coastItem2.iconSmallItem1) ~= nil then
		tolua.setpeer(self.coastItem2.iconSmallItem1, nil)
	end
	if self.coastItem1.iconSmallItem1.GenerateDestroy ~= nil then
		self.coastItem1.iconSmallItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.coastItem1.iconSmallItem1) ~= nil then
		tolua.setpeer(self.coastItem1.iconSmallItem1, nil)
	end
	if self.coastItem0.iconSmallItem1.GenerateDestroy ~= nil then
		self.coastItem0.iconSmallItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.coastItem0.iconSmallItem1) ~= nil then
		tolua.setpeer(self.coastItem0.iconSmallItem1, nil)
	end
	if tolua.getpeer(self.coast) ~= nil then
		tolua.setpeer(self.coast, nil)
	end
	self.coast = nil
	if tolua.getpeer(self.coastItem0) ~= nil then
		tolua.setpeer(self.coastItem0, nil)
	end
	self.coastItem0 = nil
	if tolua.getpeer(self.text1) ~= nil then
		tolua.setpeer(self.text1, nil)
	end
	self.text1 = nil
	if tolua.getpeer(self.coastItem1) ~= nil then
		tolua.setpeer(self.coastItem1, nil)
	end
	self.coastItem1 = nil
	if tolua.getpeer(self.text2) ~= nil then
		tolua.setpeer(self.text2, nil)
	end
	self.text2 = nil
	if tolua.getpeer(self.coastItem2) ~= nil then
		tolua.setpeer(self.coastItem2, nil)
	end
	self.coastItem2 = nil
	if tolua.getpeer(self.text3) ~= nil then
		tolua.setpeer(self.text3, nil)
	end
	self.text3 = nil
	if tolua.getpeer(self.coastItem3) ~= nil then
		tolua.setpeer(self.coastItem3, nil)
	end
	self.coastItem3 = nil
	if tolua.getpeer(self.text4) ~= nil then
		tolua.setpeer(self.text4, nil)
	end
	self.text4 = nil
	if tolua.getpeer(self.reward) ~= nil then
		tolua.setpeer(self.reward, nil)
	end
	self.reward = nil
	if tolua.getpeer(self.numberReward) ~= nil then
		tolua.setpeer(self.numberReward, nil)
	end
	self.numberReward = nil
	if tolua.getpeer(self.button) ~= nil then
		tolua.setpeer(self.button, nil)
	end
	self.button = nil
	if tolua.getpeer(self.textR) ~= nil then
		tolua.setpeer(self.textR, nil)
	end
	self.textR = nil
	if tolua.getpeer(self.uIRedPointRP) ~= nil then
		tolua.setpeer(self.uIRedPointRP, nil)
	end
	self.uIRedPointRP = nil
	if tolua.getpeer(self.dscReminder) ~= nil then
		tolua.setpeer(self.dscReminder, nil)
	end
	self.dscReminder = nil
	if tolua.getpeer(self.checkmark) ~= nil then
		tolua.setpeer(self.checkmark, nil)
	end
	self.checkmark = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.labelReceived) ~= nil then
		tolua.setpeer(self.labelReceived, nil)
	end
	self.labelReceived = nil
	if tolua.getpeer(self.serverLimit) ~= nil then
		tolua.setpeer(self.serverLimit, nil)
	end
	self.serverLimit = nil
	if tolua.getpeer(self.green) ~= nil then
		tolua.setpeer(self.green, nil)
	end
	self.green = nil
	if tolua.getpeer(self.red) ~= nil then
		tolua.setpeer(self.red, nil)
	end
	self.red = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ExchangeItemView