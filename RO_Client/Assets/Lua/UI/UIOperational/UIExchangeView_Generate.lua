---@class UIExchange__Generate_item4_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIExchange__Generate_item4_btnExchange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_item4_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_item4
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_item4_num
---@field public btnExchange UIExchange__Generate_item4_btnExchange
---@field public iconSmallItem UIExchange__Generate_item4_iconSmallItem

---@class UIExchange__Generate_item3_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIExchange__Generate_item3_btnExchange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_item3_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_item3
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_item3_num
---@field public btnExchange UIExchange__Generate_item3_btnExchange
---@field public iconSmallItem UIExchange__Generate_item3_iconSmallItem

---@class UIExchange__Generate_item2_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIExchange__Generate_item2_btnExchange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_item2_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_item2
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_item2_num
---@field public btnExchange UIExchange__Generate_item2_btnExchange
---@field public iconSmallItem UIExchange__Generate_item2_iconSmallItem

---@class UIExchange__Generate_item1_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIExchange__Generate_item1_btnExchange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_item1_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_item1
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_item1_num
---@field public btnExchange UIExchange__Generate_item1_btnExchange
---@field public iconSmallItem UIExchange__Generate_item1_iconSmallItem

---@class UIExchange__Generate_next_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_next
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_next_num

---@class UIExchange__Generate_myScore_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExchange__Generate_myScore
---@field public gameObject UnityEngine.GameObject
---@field public num UIExchange__Generate_myScore_num

---@class UIExchange__Generate_reward_num
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIExchange__Generate_reward_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIExchange__Generate_reward
---@field public gameObject UnityEngine.GameObject
---@field public icon UIExchange__Generate_reward_icon
---@field public num UIExchange__Generate_reward_num

---@class UIExchange__Generate_collection_num
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIExchange__Generate_collection_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIExchange__Generate_collection
---@field public gameObject UnityEngine.GameObject
---@field public text UIExchange__Generate_collection_text
---@field public num UIExchange__Generate_collection_num

---@class UIExchange__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchange__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIExchange__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIExchange__Generate_uIAnimator
---@field private AnyBtn UIExchange__Generate_AnyBtn
---@field private btnClose UIExchange__Generate_btnClose
---@field private collection UIExchange__Generate_collection
---@field private reward UIExchange__Generate_reward
---@field private myScore UIExchange__Generate_myScore
---@field private next UIExchange__Generate_next
---@field private exchangeBox UnityEngine.GameObject
---@field private item1 UIExchange__Generate_item1
---@field private item2 UIExchange__Generate_item2
---@field private item3 UIExchange__Generate_item3
---@field private item4 UIExchange__Generate_item4
local UIExchangeView = class("UIExchangeView", require("UIViewBase"))

function UIExchangeView:ctor()
end

---@private
function UIExchangeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExchangeView:InitGenerate(Root, data)
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


end

---@private
function UIExchangeView:InitGenerate__1(Root, data)
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
function UIExchangeView:InitGenerate__2(Root, data)
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
function UIExchangeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Collection
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Collection").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.collection = tmp
end

---@private
function UIExchangeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Collection/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Collection/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.collection.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIExchangeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Collection/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Collection/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.collection.num = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIExchangeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Reward
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Reward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward = tmp
end

---@private
function UIExchangeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Reward/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Reward/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIExchangeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Reward/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Reward/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reward.num = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIExchangeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/MyScore
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/MyScore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.myScore = tmp
end

---@private
function UIExchangeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/MyScore/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/MyScore/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.myScore.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Next
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Next").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.next = tmp
end

---@private
function UIExchangeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/ScoreBox/Next/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ScoreBox/Next/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.next.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exchangeBox = tmp
end

---@private
function UIExchangeView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1 = tmp
end

---@private
function UIExchangeView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item1/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item1/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item1/BtnExchange
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item1/BtnExchange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1.btnExchange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item1/Icon/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item1/Icon/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item1.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIExchangeView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2 = tmp
end

---@private
function UIExchangeView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item2/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item2/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item2/BtnExchange
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item2/BtnExchange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2.btnExchange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item2/Icon/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item2/Icon/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item2.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIExchangeView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3 = tmp
end

---@private
function UIExchangeView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item3/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item3/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item3/BtnExchange
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item3/BtnExchange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3.btnExchange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item3/Icon/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item3/Icon/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item3.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIExchangeView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item4
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4 = tmp
end

---@private
function UIExchangeView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item4/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item4/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExchangeView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item4/BtnExchange
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item4/BtnExchange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4.btnExchange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/BG/ExchangeBox/Item4/Icon/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExchangeBox/Item4/Icon/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item4.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIExchangeView:GenerateDestroy()
	if self.item4.iconSmallItem.GenerateDestroy ~= nil then
		self.item4.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item4.iconSmallItem) ~= nil then
		tolua.setpeer(self.item4.iconSmallItem, nil)
	end
	if tolua.getpeer(self.item4.btnExchange) ~= nil then
		tolua.setpeer(self.item4.btnExchange, nil)
	end
	if tolua.getpeer(self.item4.num) ~= nil then
		tolua.setpeer(self.item4.num, nil)
	end
	if self.item3.iconSmallItem.GenerateDestroy ~= nil then
		self.item3.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item3.iconSmallItem) ~= nil then
		tolua.setpeer(self.item3.iconSmallItem, nil)
	end
	if tolua.getpeer(self.item3.btnExchange) ~= nil then
		tolua.setpeer(self.item3.btnExchange, nil)
	end
	if tolua.getpeer(self.item3.num) ~= nil then
		tolua.setpeer(self.item3.num, nil)
	end
	if self.item2.iconSmallItem.GenerateDestroy ~= nil then
		self.item2.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item2.iconSmallItem) ~= nil then
		tolua.setpeer(self.item2.iconSmallItem, nil)
	end
	if tolua.getpeer(self.item2.btnExchange) ~= nil then
		tolua.setpeer(self.item2.btnExchange, nil)
	end
	if tolua.getpeer(self.item2.num) ~= nil then
		tolua.setpeer(self.item2.num, nil)
	end
	if self.item1.iconSmallItem.GenerateDestroy ~= nil then
		self.item1.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item1.iconSmallItem) ~= nil then
		tolua.setpeer(self.item1.iconSmallItem, nil)
	end
	if tolua.getpeer(self.item1.btnExchange) ~= nil then
		tolua.setpeer(self.item1.btnExchange, nil)
	end
	if tolua.getpeer(self.item1.num) ~= nil then
		tolua.setpeer(self.item1.num, nil)
	end
	if tolua.getpeer(self.next.num) ~= nil then
		tolua.setpeer(self.next.num, nil)
	end
	if tolua.getpeer(self.myScore.num) ~= nil then
		tolua.setpeer(self.myScore.num, nil)
	end
	if tolua.getpeer(self.reward.num) ~= nil then
		tolua.setpeer(self.reward.num, nil)
	end
	if tolua.getpeer(self.reward.icon) ~= nil then
		tolua.setpeer(self.reward.icon, nil)
	end
	if tolua.getpeer(self.collection.num) ~= nil then
		tolua.setpeer(self.collection.num, nil)
	end
	if tolua.getpeer(self.collection.text) ~= nil then
		tolua.setpeer(self.collection.text, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.collection) ~= nil then
		tolua.setpeer(self.collection, nil)
	end
	self.collection = nil
	if tolua.getpeer(self.reward) ~= nil then
		tolua.setpeer(self.reward, nil)
	end
	self.reward = nil
	if tolua.getpeer(self.myScore) ~= nil then
		tolua.setpeer(self.myScore, nil)
	end
	self.myScore = nil
	if tolua.getpeer(self.next) ~= nil then
		tolua.setpeer(self.next, nil)
	end
	self.next = nil
	if tolua.getpeer(self.exchangeBox) ~= nil then
		tolua.setpeer(self.exchangeBox, nil)
	end
	self.exchangeBox = nil
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
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExchangeView