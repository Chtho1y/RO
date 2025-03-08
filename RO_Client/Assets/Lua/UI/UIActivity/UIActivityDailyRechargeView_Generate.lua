---@class UIActivityDailyRecharge__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityDailyRecharge__Generate_btnReceive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public uIRedPointRP UnityEngine.GameObject

---@class UIActivityDailyRecharge__Generate_btnConfirm
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityDailyRecharge__Generate_btnRecharge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityDailyRecharge__Generate_bottomDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIActivityDailyRecharge__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIActivityDailyRecharge__Generate_rewards
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopListView SuperScrollView.LoopListView

---@class UIActivityDailyRecharge__Generate_text3
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityDailyRecharge__Generate_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityDailyRecharge__Generate_text1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityDailyRecharge__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityDailyRecharge__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityDailyRecharge__Generate_AnyBtn
---@field private boli UnityEngine.GameObject
---@field private text1 UIActivityDailyRecharge__Generate_text1
---@field private text2 UIActivityDailyRecharge__Generate_text2
---@field private text3 UIActivityDailyRecharge__Generate_text3
---@field private rewards UIActivityDailyRecharge__Generate_rewards
---@field private iconItem UIActivityDailyRecharge__Generate_iconItem
---@field private bottomDsc UIActivityDailyRecharge__Generate_bottomDsc
---@field private btnRecharge UIActivityDailyRecharge__Generate_btnRecharge
---@field private btnConfirm UIActivityDailyRecharge__Generate_btnConfirm
---@field private btnReceive UIActivityDailyRecharge__Generate_btnReceive
---@field private backBtn UIActivityDailyRecharge__Generate_backBtn
local UIActivityDailyRechargeView = class("UIActivityDailyRechargeView", require("UIViewBase"))

function UIActivityDailyRechargeView:ctor()
end

---@private
function UIActivityDailyRechargeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityDailyRechargeView:InitGenerate(Root, data)
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


end

---@private
function UIActivityDailyRechargeView:InitGenerate__1(Root, data)
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
function UIActivityDailyRechargeView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Boli
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Boli").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boli = tmp
end

---@private
function UIActivityDailyRechargeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Boli/TalkBox/Text3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text3 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Rewards
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/Layout/Rewards/Icons/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Layout/Rewards/Icons/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/Dsc/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/Dsc/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__9(Root, data)
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
function UIActivityDailyRechargeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnConfirm
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnConfirm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnConfirm = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityDailyRechargeView:InitGenerate__11(Root, data)
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
function UIActivityDailyRechargeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnReceive/UIRedPointRP
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnReceive/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReceive.uIRedPointRP = tmp
end

---@private
function UIActivityDailyRechargeView:InitGenerate__13(Root, data)
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
function UIActivityDailyRechargeView:GenerateDestroy()
	if tolua.getpeer(self.btnReceive.uIRedPointRP) ~= nil then
		tolua.setpeer(self.btnReceive.uIRedPointRP, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.boli) ~= nil then
		tolua.setpeer(self.boli, nil)
	end
	self.boli = nil
	if tolua.getpeer(self.text1) ~= nil then
		tolua.setpeer(self.text1, nil)
	end
	self.text1 = nil
	if tolua.getpeer(self.text2) ~= nil then
		tolua.setpeer(self.text2, nil)
	end
	self.text2 = nil
	if tolua.getpeer(self.text3) ~= nil then
		tolua.setpeer(self.text3, nil)
	end
	self.text3 = nil
	if tolua.getpeer(self.rewards) ~= nil then
		tolua.setpeer(self.rewards, nil)
	end
	self.rewards = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.bottomDsc) ~= nil then
		tolua.setpeer(self.bottomDsc, nil)
	end
	self.bottomDsc = nil
	if tolua.getpeer(self.btnRecharge) ~= nil then
		tolua.setpeer(self.btnRecharge, nil)
	end
	self.btnRecharge = nil
	if tolua.getpeer(self.btnConfirm) ~= nil then
		tolua.setpeer(self.btnConfirm, nil)
	end
	self.btnConfirm = nil
	if tolua.getpeer(self.btnReceive) ~= nil then
		tolua.setpeer(self.btnReceive, nil)
	end
	self.btnReceive = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityDailyRechargeView