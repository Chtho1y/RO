---@class UISeasonIdol__Generate_btnSeason
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_btnIdolRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_btnIdolFans
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_btnIdolGift
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public giftShow UnityEngine.GameObject

---@class UISeasonIdol__Generate_btnIdolShop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_rewards2_btnOnlineRewards
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_rewards2_timetext
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISeasonIdol__Generate_rewards2_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UISeasonIdol__Generate_rewards2_idolRewardsAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISeasonIdol__Generate_rewards2
---@field public gameObject UnityEngine.GameObject
---@field public idolRewardsAnim UISeasonIdol__Generate_rewards2_idolRewardsAnim
---@field public available UnityEngine.GameObject
---@field public iconSmallItem UISeasonIdol__Generate_rewards2_iconSmallItem
---@field public received UnityEngine.GameObject
---@field public overdue UnityEngine.GameObject
---@field public timetext UISeasonIdol__Generate_rewards2_timetext
---@field public btnOnlineRewards UISeasonIdol__Generate_rewards2_btnOnlineRewards

---@class UISeasonIdol__Generate_rewards1_btnOnlineRewards
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_rewards1_timetext
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISeasonIdol__Generate_rewards1_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UISeasonIdol__Generate_rewards1_idolRewardsAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISeasonIdol__Generate_rewards1
---@field public gameObject UnityEngine.GameObject
---@field public idolRewardsAnim UISeasonIdol__Generate_rewards1_idolRewardsAnim
---@field public available UnityEngine.GameObject
---@field public iconSmallItem UISeasonIdol__Generate_rewards1_iconSmallItem
---@field public received UnityEngine.GameObject
---@field public overdue UnityEngine.GameObject
---@field public timetext UISeasonIdol__Generate_rewards1_timetext
---@field public btnOnlineRewards UISeasonIdol__Generate_rewards1_btnOnlineRewards

---@class UISeasonIdol__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_glowstick_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISeasonIdol__Generate_glowstick_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISeasonIdol__Generate_glowstick
---@field public gameObject UnityEngine.GameObject
---@field public icon UISeasonIdol__Generate_glowstick_icon
---@field public number UISeasonIdol__Generate_glowstick_number

---@class UISeasonIdol__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISeasonIdol__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISeasonIdol__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISeasonIdol__Generate_uIAnimator
---@field private AnyBtn UISeasonIdol__Generate_AnyBtn
---@field private btnPlayRule UISeasonIdol__Generate_btnPlayRule
---@field private glowstick UISeasonIdol__Generate_glowstick
---@field private btnBuy UISeasonIdol__Generate_btnBuy
---@field private rewards1 UISeasonIdol__Generate_rewards1
---@field private rewards2 UISeasonIdol__Generate_rewards2
---@field private playerNode1 UnityEngine.GameObject
---@field private playerNode2 UnityEngine.GameObject
---@field private playerNode3 UnityEngine.GameObject
---@field private btnIdolShop UISeasonIdol__Generate_btnIdolShop
---@field private btnIdolGift UISeasonIdol__Generate_btnIdolGift
---@field private btnIdolFans UISeasonIdol__Generate_btnIdolFans
---@field private btnIdolRank UISeasonIdol__Generate_btnIdolRank
---@field private selfRankItem UnityEngine.GameObject
---@field private btnBack UISeasonIdol__Generate_btnBack
---@field private btnSeason UISeasonIdol__Generate_btnSeason
local UISeasonIdolView = class("UISeasonIdolView", require("UIViewBase"))

function UISeasonIdolView:ctor()
end

---@private
function UISeasonIdolView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISeasonIdolView:InitGenerate(Root, data)
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
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)


end

---@private
function UISeasonIdolView:InitGenerate__1(Root, data)
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
function UISeasonIdolView:InitGenerate__2(Root, data)
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
function UISeasonIdolView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/TopView/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TopView/Glowstick
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Glowstick").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.glowstick = tmp
end

---@private
function UISeasonIdolView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/TopView/Glowstick/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Glowstick/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.glowstick.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISeasonIdolView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/TopView/Glowstick/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Glowstick/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.glowstick.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISeasonIdolView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/TopView/Glowstick/BtnBuy
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Glowstick/BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1 = tmp
end

---@private
function UISeasonIdolView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.idolRewardsAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISeasonIdolView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Available
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Available").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.available = tmp
end

---@private
function UISeasonIdolView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.rewards1.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UISeasonIdolView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Received
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Received").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.received = tmp
end

---@private
function UISeasonIdolView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Overdue
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/IdolRewardsAnim/Overdue").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.overdue = tmp
end

---@private
function UISeasonIdolView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/Time/timetext
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/Time/timetext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.timetext = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISeasonIdolView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards1/BtnOnlineRewards
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards1/BtnOnlineRewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards1.btnOnlineRewards = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2 = tmp
end

---@private
function UISeasonIdolView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.idolRewardsAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISeasonIdolView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Available
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Available").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.available = tmp
end

---@private
function UISeasonIdolView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.rewards2.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UISeasonIdolView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Received
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Received").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.received = tmp
end

---@private
function UISeasonIdolView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Overdue
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/IdolRewardsAnim/Overdue").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.overdue = tmp
end

---@private
function UISeasonIdolView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/Time/timetext
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/Time/timetext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.timetext = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISeasonIdolView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/TopView/Rewards2/BtnOnlineRewards
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Rewards2/BtnOnlineRewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards2.btnOnlineRewards = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/PlayerNode1
--]]
	local tmp = Root:Find("UIAnimator/Window/PlayerNode1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1 = CommonUtil.BindGridViewItem2LuaStatic("PlayerNode", tmp)
	self.playerNode1.prefabName = "PlayerNode"
end

---@private
function UISeasonIdolView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/PlayerNode2
--]]
	local tmp = Root:Find("UIAnimator/Window/PlayerNode2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2 = CommonUtil.BindGridViewItem2LuaStatic("PlayerNode", tmp)
	self.playerNode2.prefabName = "PlayerNode"
end

---@private
function UISeasonIdolView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/PlayerNode3
--]]
	local tmp = Root:Find("UIAnimator/Window/PlayerNode3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3 = CommonUtil.BindGridViewItem2LuaStatic("PlayerNode", tmp)
	self.playerNode3.prefabName = "PlayerNode"
end

---@private
function UISeasonIdolView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBox/BtnIdolShop
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBox/BtnIdolShop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnIdolShop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBox/BtnIdolGift
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBox/BtnIdolGift").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnIdolGift = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBox/BtnIdolGift/GiftShow
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBox/BtnIdolGift/GiftShow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnIdolGift.giftShow = tmp
end

---@private
function UISeasonIdolView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBox/BtnIdolFans
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBox/BtnIdolFans").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnIdolFans = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBox/BtnIdolRank
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBox/BtnIdolRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnIdolRank = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/BottomView/Rank/SelfRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/Rank/SelfRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRankItem = CommonUtil.BindGridViewItem2LuaStatic("UIIdolRankItem", tmp)
	self.selfRankItem.prefabName = "UIIdolRankItem"
end

---@private
function UISeasonIdolView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnSeason
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnSeason").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSeason = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISeasonIdolView:GenerateDestroy()
	if tolua.getpeer(self.btnIdolGift.giftShow) ~= nil then
		tolua.setpeer(self.btnIdolGift.giftShow, nil)
	end
	if tolua.getpeer(self.rewards2.btnOnlineRewards) ~= nil then
		tolua.setpeer(self.rewards2.btnOnlineRewards, nil)
	end
	if tolua.getpeer(self.rewards2.timetext) ~= nil then
		tolua.setpeer(self.rewards2.timetext, nil)
	end
	if tolua.getpeer(self.rewards2.overdue) ~= nil then
		tolua.setpeer(self.rewards2.overdue, nil)
	end
	if tolua.getpeer(self.rewards2.received) ~= nil then
		tolua.setpeer(self.rewards2.received, nil)
	end
	if self.rewards2.iconSmallItem.GenerateDestroy ~= nil then
		self.rewards2.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.rewards2.iconSmallItem) ~= nil then
		tolua.setpeer(self.rewards2.iconSmallItem, nil)
	end
	if tolua.getpeer(self.rewards2.available) ~= nil then
		tolua.setpeer(self.rewards2.available, nil)
	end
	if tolua.getpeer(self.rewards2.idolRewardsAnim) ~= nil then
		tolua.setpeer(self.rewards2.idolRewardsAnim, nil)
	end
	if tolua.getpeer(self.rewards1.btnOnlineRewards) ~= nil then
		tolua.setpeer(self.rewards1.btnOnlineRewards, nil)
	end
	if tolua.getpeer(self.rewards1.timetext) ~= nil then
		tolua.setpeer(self.rewards1.timetext, nil)
	end
	if tolua.getpeer(self.rewards1.overdue) ~= nil then
		tolua.setpeer(self.rewards1.overdue, nil)
	end
	if tolua.getpeer(self.rewards1.received) ~= nil then
		tolua.setpeer(self.rewards1.received, nil)
	end
	if self.rewards1.iconSmallItem.GenerateDestroy ~= nil then
		self.rewards1.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.rewards1.iconSmallItem) ~= nil then
		tolua.setpeer(self.rewards1.iconSmallItem, nil)
	end
	if tolua.getpeer(self.rewards1.available) ~= nil then
		tolua.setpeer(self.rewards1.available, nil)
	end
	if tolua.getpeer(self.rewards1.idolRewardsAnim) ~= nil then
		tolua.setpeer(self.rewards1.idolRewardsAnim, nil)
	end
	if tolua.getpeer(self.glowstick.number) ~= nil then
		tolua.setpeer(self.glowstick.number, nil)
	end
	if tolua.getpeer(self.glowstick.icon) ~= nil then
		tolua.setpeer(self.glowstick.icon, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.glowstick) ~= nil then
		tolua.setpeer(self.glowstick, nil)
	end
	self.glowstick = nil
	if tolua.getpeer(self.btnBuy) ~= nil then
		tolua.setpeer(self.btnBuy, nil)
	end
	self.btnBuy = nil
	if tolua.getpeer(self.rewards1) ~= nil then
		tolua.setpeer(self.rewards1, nil)
	end
	self.rewards1 = nil
	if tolua.getpeer(self.rewards2) ~= nil then
		tolua.setpeer(self.rewards2, nil)
	end
	self.rewards2 = nil
	if self.playerNode1.GenerateDestroy ~= nil then
		self.playerNode1:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode1) ~= nil then
		tolua.setpeer(self.playerNode1, nil)
	end
	self.playerNode1 = nil
	if self.playerNode2.GenerateDestroy ~= nil then
		self.playerNode2:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode2) ~= nil then
		tolua.setpeer(self.playerNode2, nil)
	end
	self.playerNode2 = nil
	if self.playerNode3.GenerateDestroy ~= nil then
		self.playerNode3:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode3) ~= nil then
		tolua.setpeer(self.playerNode3, nil)
	end
	self.playerNode3 = nil
	if tolua.getpeer(self.btnIdolShop) ~= nil then
		tolua.setpeer(self.btnIdolShop, nil)
	end
	self.btnIdolShop = nil
	if tolua.getpeer(self.btnIdolGift) ~= nil then
		tolua.setpeer(self.btnIdolGift, nil)
	end
	self.btnIdolGift = nil
	if tolua.getpeer(self.btnIdolFans) ~= nil then
		tolua.setpeer(self.btnIdolFans, nil)
	end
	self.btnIdolFans = nil
	if tolua.getpeer(self.btnIdolRank) ~= nil then
		tolua.setpeer(self.btnIdolRank, nil)
	end
	self.btnIdolRank = nil
	if self.selfRankItem.GenerateDestroy ~= nil then
		self.selfRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.selfRankItem) ~= nil then
		tolua.setpeer(self.selfRankItem, nil)
	end
	self.selfRankItem = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnSeason) ~= nil then
		tolua.setpeer(self.btnSeason, nil)
	end
	self.btnSeason = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISeasonIdolView