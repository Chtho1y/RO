---@class UIVip__Generate_btnRight
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_btnLeft
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_curVipNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVip__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVip__Generate_vipFrame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVip__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVip__Generate_expSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIVip__Generate_expTxt_sealIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVip__Generate_btnCustomerService
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_expTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI
---@field public sealIcon UIVip__Generate_expTxt_sealIcon

---@class UIVip__Generate_rewardList
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIVip__Generate_vipUnlockDesItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIVip__Generate_gainList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIVip__Generate_vipNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVip__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIVip__Generate_btnUpLv
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVip__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIVip__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIVip__Generate_uIAnimator
---@field private AnyBtn UIVip__Generate_AnyBtn
---@field private btnBack UIVip__Generate_btnBack
---@field private btnUpLv UIVip__Generate_btnUpLv
---@field private btnSure UIVip__Generate_btnSure
---@field private vipNameTxt UIVip__Generate_vipNameTxt
---@field private gainList UIVip__Generate_gainList
---@field private vipUnlockDesItem UIVip__Generate_vipUnlockDesItem
---@field private rewardList UIVip__Generate_rewardList
---@field private expTxt UIVip__Generate_expTxt
---@field private btnCustomerService UIVip__Generate_btnCustomerService
---@field private expSlider UIVip__Generate_expSlider
---@field private number UIVip__Generate_number
---@field private vipFrame UIVip__Generate_vipFrame
---@field private vipIcon UIVip__Generate_vipIcon
---@field private curVipNameTxt UIVip__Generate_curVipNameTxt
---@field private btnInfo UIVip__Generate_btnInfo
---@field private btnLeft UIVip__Generate_btnLeft
---@field private btnRight UIVip__Generate_btnRight
local UIVipView = class("UIVipView", require("UIViewBase"))

function UIVipView:ctor()
end

---@private
function UIVipView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVipView:InitGenerate(Root, data)
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


end

---@private
function UIVipView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIVipView:InitGenerate__2(Root, data)
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
function UIVipView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnUpLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnUpLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnUpLv = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnUpLv/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnUpLv/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIVipView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Center/Title/VipNameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/Title/VipNameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVipView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Center/GainList
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/GainList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gainList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIVipView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Center/GainList/Viewport/Content/VipUnlockDesItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/GainList/Viewport/Content/VipUnlockDesItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipUnlockDesItem = CommonUtil.BindGridViewItem2LuaStatic("VipUnlockDesItem", tmp)
	self.vipUnlockDesItem.prefabName = "VipUnlockDesItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIVipView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Center/RewardList
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/RewardList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardList = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIVipView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Top/Exp/NextLv/ExpTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Exp/NextLv/ExpTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Top/Exp/NextLv/BtnCustomerService
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Exp/NextLv/BtnCustomerService").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCustomerService = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Top/Exp/NextLv/SealIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Exp/NextLv/SealIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expTxt.sealIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Top/Exp/ExpSlider
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Exp/ExpSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIVipView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Top/Exp/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Exp/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Top/GodSeal/Mask/SealPlay/Seal/VipFrame
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GodSeal/Mask/SealPlay/Seal/VipFrame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipFrame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Top/GodSeal/Mask/SealPlay/Seal/VipIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GodSeal/Mask/SealPlay/Seal/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Top/GodSeal/Frame/Title/CurVipNameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GodSeal/Frame/Title/CurVipNameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curVipNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Top/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/SwitchButtons/BtnLeft
--]]
	local tmp = Root:Find("UIAnimator/Window/SwitchButtons/BtnLeft").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnLeft = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/SwitchButtons/BtnRight
--]]
	local tmp = Root:Find("UIAnimator/Window/SwitchButtons/BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRight = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVipView:GenerateDestroy()
	if tolua.getpeer(self.expTxt.sealIcon) ~= nil then
		tolua.setpeer(self.expTxt.sealIcon, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnUpLv) ~= nil then
		tolua.setpeer(self.btnUpLv, nil)
	end
	self.btnUpLv = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	if tolua.getpeer(self.vipNameTxt) ~= nil then
		tolua.setpeer(self.vipNameTxt, nil)
	end
	self.vipNameTxt = nil
	if tolua.getpeer(self.gainList) ~= nil then
		tolua.setpeer(self.gainList, nil)
	end
	self.gainList = nil
	if self.vipUnlockDesItem.GenerateDestroy ~= nil then
		self.vipUnlockDesItem:GenerateDestroy()
	end
	if tolua.getpeer(self.vipUnlockDesItem) ~= nil then
		tolua.setpeer(self.vipUnlockDesItem, nil)
	end
	self.vipUnlockDesItem = nil
	if tolua.getpeer(self.rewardList) ~= nil then
		tolua.setpeer(self.rewardList, nil)
	end
	self.rewardList = nil
	if tolua.getpeer(self.expTxt) ~= nil then
		tolua.setpeer(self.expTxt, nil)
	end
	self.expTxt = nil
	if tolua.getpeer(self.btnCustomerService) ~= nil then
		tolua.setpeer(self.btnCustomerService, nil)
	end
	self.btnCustomerService = nil
	if tolua.getpeer(self.expSlider) ~= nil then
		tolua.setpeer(self.expSlider, nil)
	end
	self.expSlider = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.vipFrame) ~= nil then
		tolua.setpeer(self.vipFrame, nil)
	end
	self.vipFrame = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.curVipNameTxt) ~= nil then
		tolua.setpeer(self.curVipNameTxt, nil)
	end
	self.curVipNameTxt = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
	if tolua.getpeer(self.btnLeft) ~= nil then
		tolua.setpeer(self.btnLeft, nil)
	end
	self.btnLeft = nil
	if tolua.getpeer(self.btnRight) ~= nil then
		tolua.setpeer(self.btnRight, nil)
	end
	self.btnRight = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVipView