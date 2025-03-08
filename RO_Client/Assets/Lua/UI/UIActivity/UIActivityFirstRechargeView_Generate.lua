---@class UIActivityFirstRecharge__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFirstRecharge__Generate_btnReceive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFirstRecharge__Generate_btnRecharge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFirstRecharge__Generate_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityFirstRecharge__Generate_toggle3
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityFirstRecharge__Generate_toggle2
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityFirstRecharge__Generate_toggle1
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityFirstRecharge__Generate_firstRechargeItem_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIActivityFirstRecharge__Generate_firstRechargeItem_rewards
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIActivityFirstRecharge__Generate_firstRechargeItem_numValue
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityFirstRecharge__Generate_firstRechargeItem_textDays
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityFirstRecharge__Generate_firstRechargeItem
---@field public gameObject UnityEngine.GameObject
---@field public icon UnityEngine.GameObject
---@field public textDays UIActivityFirstRecharge__Generate_firstRechargeItem_textDays
---@field public numValue UIActivityFirstRecharge__Generate_firstRechargeItem_numValue
---@field public rewards UIActivityFirstRecharge__Generate_firstRechargeItem_rewards
---@field public iconSmallItem UIActivityFirstRecharge__Generate_firstRechargeItem_iconSmallItem
---@field public mask UnityEngine.GameObject
---@field public received UnityEngine.GameObject
---@field public available UnityEngine.GameObject
---@field public wating UnityEngine.GameObject

---@class UIActivityFirstRecharge__Generate_hundredToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityFirstRecharge__Generate_firstToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityFirstRecharge__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIActivityFirstRecharge__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFirstRecharge__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityFirstRecharge__Generate_AnyBtn
---@field private toggleGroup UIActivityFirstRecharge__Generate_toggleGroup
---@field private firstToggle UIActivityFirstRecharge__Generate_firstToggle
---@field private hundredToggle UIActivityFirstRecharge__Generate_hundredToggle
---@field private banner1 UnityEngine.GameObject
---@field private banner2 UnityEngine.GameObject
---@field private firstRechargeItem UIActivityFirstRecharge__Generate_firstRechargeItem
---@field private toggle1 UIActivityFirstRecharge__Generate_toggle1
---@field private toggle2 UIActivityFirstRecharge__Generate_toggle2
---@field private toggle3 UIActivityFirstRecharge__Generate_toggle3
---@field private dscTxt UIActivityFirstRecharge__Generate_dscTxt
---@field private btnRecharge UIActivityFirstRecharge__Generate_btnRecharge
---@field private btnReceive UIActivityFirstRecharge__Generate_btnReceive
---@field private labelReceived UnityEngine.GameObject
---@field private btnWating UnityEngine.GameObject
---@field private backBtn UIActivityFirstRecharge__Generate_backBtn
local UIActivityFirstRechargeView = class("UIActivityFirstRechargeView", require("UIViewBase"))

function UIActivityFirstRechargeView:ctor()
end

---@private
function UIActivityFirstRechargeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityFirstRechargeView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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


end

---@private
function UIActivityFirstRechargeView:InitGenerate__1(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/FirstToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/FirstToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/HundredToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/HundredToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hundredToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/Banner1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Banner1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner1 = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/Banner2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Banner2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner2 = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.icon = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/TextDays
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/TextDays").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.textDays = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/NumValue
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/NumValue").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.numValue = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Rewards
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.rewards = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Rewards/Viewport/Content/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Rewards/Viewport/Content/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.firstRechargeItem.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Mask
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.mask = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Received
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Received").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.received = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Available
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Available").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.available = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Wating
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/List/FirstRechargeItem/Wating").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.firstRechargeItem.wating = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle1 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle2 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxRewards/ToggleDays/Toggle3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle3 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/Dsc/DscTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/Dsc/DscTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnRecharge
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnRecharge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRecharge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnReceive
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnReceive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReceive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityFirstRechargeView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/LabelReceived
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/LabelReceived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelReceived = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnWating
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnWating").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWating = tmp
end

---@private
function UIActivityFirstRechargeView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityFirstRechargeView:GenerateDestroy()
	if tolua.getpeer(self.firstRechargeItem.wating) ~= nil then
		tolua.setpeer(self.firstRechargeItem.wating, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.available) ~= nil then
		tolua.setpeer(self.firstRechargeItem.available, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.received) ~= nil then
		tolua.setpeer(self.firstRechargeItem.received, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.mask) ~= nil then
		tolua.setpeer(self.firstRechargeItem.mask, nil)
	end
	if self.firstRechargeItem.iconSmallItem.GenerateDestroy ~= nil then
		self.firstRechargeItem.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.firstRechargeItem.iconSmallItem) ~= nil then
		tolua.setpeer(self.firstRechargeItem.iconSmallItem, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.rewards) ~= nil then
		tolua.setpeer(self.firstRechargeItem.rewards, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.numValue) ~= nil then
		tolua.setpeer(self.firstRechargeItem.numValue, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.textDays) ~= nil then
		tolua.setpeer(self.firstRechargeItem.textDays, nil)
	end
	if tolua.getpeer(self.firstRechargeItem.icon) ~= nil then
		tolua.setpeer(self.firstRechargeItem.icon, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.firstToggle) ~= nil then
		tolua.setpeer(self.firstToggle, nil)
	end
	self.firstToggle = nil
	if tolua.getpeer(self.hundredToggle) ~= nil then
		tolua.setpeer(self.hundredToggle, nil)
	end
	self.hundredToggle = nil
	if tolua.getpeer(self.banner1) ~= nil then
		tolua.setpeer(self.banner1, nil)
	end
	self.banner1 = nil
	if tolua.getpeer(self.banner2) ~= nil then
		tolua.setpeer(self.banner2, nil)
	end
	self.banner2 = nil
	if tolua.getpeer(self.firstRechargeItem) ~= nil then
		tolua.setpeer(self.firstRechargeItem, nil)
	end
	self.firstRechargeItem = nil
	if tolua.getpeer(self.toggle1) ~= nil then
		tolua.setpeer(self.toggle1, nil)
	end
	self.toggle1 = nil
	if tolua.getpeer(self.toggle2) ~= nil then
		tolua.setpeer(self.toggle2, nil)
	end
	self.toggle2 = nil
	if tolua.getpeer(self.toggle3) ~= nil then
		tolua.setpeer(self.toggle3, nil)
	end
	self.toggle3 = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	if tolua.getpeer(self.btnRecharge) ~= nil then
		tolua.setpeer(self.btnRecharge, nil)
	end
	self.btnRecharge = nil
	if tolua.getpeer(self.btnReceive) ~= nil then
		tolua.setpeer(self.btnReceive, nil)
	end
	self.btnReceive = nil
	if tolua.getpeer(self.labelReceived) ~= nil then
		tolua.setpeer(self.labelReceived, nil)
	end
	self.labelReceived = nil
	if tolua.getpeer(self.btnWating) ~= nil then
		tolua.setpeer(self.btnWating, nil)
	end
	self.btnWating = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityFirstRechargeView