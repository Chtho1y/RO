---@class UIGuildSettings__Generate_sureBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildSettings__Generate_recruitInput
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGuildSettings__Generate_btnPlus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class UIGuildSettings__Generate_btnMinus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class UIGuildSettings__Generate_lvSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIGuildSettings__Generate_lvInput
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGuildSettings__Generate_toggleGroup_noToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildSettings__Generate_toggleGroup_applyToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildSettings__Generate_toggleGroup_allToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildSettings__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup
---@field public allToggle UIGuildSettings__Generate_toggleGroup_allToggle
---@field public applyToggle UIGuildSettings__Generate_toggleGroup_applyToggle
---@field public noToggle UIGuildSettings__Generate_toggleGroup_noToggle

---@class UIGuildSettings__Generate_costTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildSettings__Generate_name_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildSettings__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIGuildSettings__Generate_name_text

---@class UIGuildSettings__Generate_changeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildSettings__Generate_guildBadgeItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildSettings__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildSettings__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildSettings__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildSettings__Generate_AnyBtn
---@field private btnClose UIGuildSettings__Generate_btnClose
---@field private guildBadgeItem UIGuildSettings__Generate_guildBadgeItem
---@field private changeBtn UIGuildSettings__Generate_changeBtn
---@field private name UIGuildSettings__Generate_name
---@field private costTxt UIGuildSettings__Generate_costTxt
---@field private toggleGroup UIGuildSettings__Generate_toggleGroup
---@field private lvInput UIGuildSettings__Generate_lvInput
---@field private lvSlider UIGuildSettings__Generate_lvSlider
---@field private btnMinus UIGuildSettings__Generate_btnMinus
---@field private btnPlus UIGuildSettings__Generate_btnPlus
---@field private recruitInput UIGuildSettings__Generate_recruitInput
---@field private sureBtn UIGuildSettings__Generate_sureBtn
local UIGuildSettingsView = class("UIGuildSettingsView", require("UIViewBase"))

function UIGuildSettingsView:ctor()
end

---@private
function UIGuildSettingsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildSettingsView:InitGenerate(Root, data)
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


end

---@private
function UIGuildSettingsView:InitGenerate__1(Root, data)
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
function UIGuildSettingsView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildSettingsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ChangeList/Image/GuildBadgeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Image/GuildBadgeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildBadgeItem = CommonUtil.BindGridViewItem2LuaStatic("GuildBadgeItem", tmp)
	self.guildBadgeItem.prefabName = "GuildBadgeItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildSettingsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ChangeList/Image/ChangeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Image/ChangeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildSettingsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ChangeList/Image/Name
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Image/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildSettingsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ChangeList/Image/Name/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Image/Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildSettingsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ChangeList/Image/CostTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Image/CostTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildSettingsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ChangeList/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIGuildSettingsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/ChangeList/ToggleGroup/AllToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/ToggleGroup/AllToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup.allToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildSettingsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/ChangeList/ToggleGroup/ApplyToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/ToggleGroup/ApplyToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup.applyToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildSettingsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/ChangeList/ToggleGroup/NoToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/ToggleGroup/NoToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup.noToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildSettingsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/ChangeList/LvGroup/LvInput
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/LvGroup/LvInput").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvInput = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGuildSettingsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/ChangeList/LvGroup/LvSlider
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/LvGroup/LvSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIGuildSettingsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/ChangeList/LvGroup/BtnMinus
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/LvGroup/BtnMinus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMinus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function UIGuildSettingsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/ChangeList/LvGroup/BtnPlus
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/LvGroup/BtnPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function UIGuildSettingsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/ChangeList/RecruitInput
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/RecruitInput").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recruitInput = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGuildSettingsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom/SureBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/SureBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sureBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildSettingsView:GenerateDestroy()
	if tolua.getpeer(self.toggleGroup.noToggle) ~= nil then
		tolua.setpeer(self.toggleGroup.noToggle, nil)
	end
	if tolua.getpeer(self.toggleGroup.applyToggle) ~= nil then
		tolua.setpeer(self.toggleGroup.applyToggle, nil)
	end
	if tolua.getpeer(self.toggleGroup.allToggle) ~= nil then
		tolua.setpeer(self.toggleGroup.allToggle, nil)
	end
	if tolua.getpeer(self.name.text) ~= nil then
		tolua.setpeer(self.name.text, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.guildBadgeItem.GenerateDestroy ~= nil then
		self.guildBadgeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildBadgeItem) ~= nil then
		tolua.setpeer(self.guildBadgeItem, nil)
	end
	self.guildBadgeItem = nil
	if tolua.getpeer(self.changeBtn) ~= nil then
		tolua.setpeer(self.changeBtn, nil)
	end
	self.changeBtn = nil
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.costTxt) ~= nil then
		tolua.setpeer(self.costTxt, nil)
	end
	self.costTxt = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.lvInput) ~= nil then
		tolua.setpeer(self.lvInput, nil)
	end
	self.lvInput = nil
	if tolua.getpeer(self.lvSlider) ~= nil then
		tolua.setpeer(self.lvSlider, nil)
	end
	self.lvSlider = nil
	if tolua.getpeer(self.btnMinus) ~= nil then
		tolua.setpeer(self.btnMinus, nil)
	end
	self.btnMinus = nil
	if tolua.getpeer(self.btnPlus) ~= nil then
		tolua.setpeer(self.btnPlus, nil)
	end
	self.btnPlus = nil
	if tolua.getpeer(self.recruitInput) ~= nil then
		tolua.setpeer(self.recruitInput, nil)
	end
	self.recruitInput = nil
	if tolua.getpeer(self.sureBtn) ~= nil then
		tolua.setpeer(self.sureBtn, nil)
	end
	self.sureBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildSettingsView