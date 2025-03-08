---@class UIShop__Generate_talkBoxTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIShop__Generate_shopLabelToggleItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShop__Generate_labelScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIShop__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShop__Generate_shopGoodsItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShop__Generate_goodsScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIShop__Generate_btnRefresh
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShop__Generate_textTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShop__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShop__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIShop__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIShop__Generate_uIAnimator
---@field private AnyBtn UIShop__Generate_AnyBtn
---@field private timeBox UnityEngine.GameObject
---@field private textTime UIShop__Generate_textTime
---@field private btnRefresh UIShop__Generate_btnRefresh
---@field private goodsScrollView UIShop__Generate_goodsScrollView
---@field private shopGoodsItem UIShop__Generate_shopGoodsItem
---@field private btnClose UIShop__Generate_btnClose
---@field private labelScrollView UIShop__Generate_labelScrollView
---@field private shopLabelToggleItem UIShop__Generate_shopLabelToggleItem
---@field private rightArrow UnityEngine.GameObject
---@field private leftArrow UnityEngine.GameObject
---@field private talkBoxTxt UIShop__Generate_talkBoxTxt
---@field private resourceBox UnityEngine.GameObject
---@field private shopCurrencyItem UnityEngine.GameObject
local UIShopView = class("UIShopView", require("UIViewBase"))

function UIShopView:ctor()
end

---@private
function UIShopView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIShopView:InitGenerate(Root, data)
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


end

---@private
function UIShopView:InitGenerate__1(Root, data)
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
function UIShopView:InitGenerate__2(Root, data)
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
function UIShopView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/GoodsBox/TimeBox
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/TimeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeBox = tmp
end

---@private
function UIShopView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/GoodsBox/TimeBox/TextTime
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/TimeBox/TextTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/GoodsBox/TimeBox/BtnRefresh
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/TimeBox/BtnRefresh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRefresh = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GoodsBox/GoodsScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/GoodsScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goodsScrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIShopView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/GoodsBox/GoodsScrollView/Viewport/Content/ShopGoodsItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/GoodsScrollView/Viewport/Content/ShopGoodsItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shopGoodsItem = CommonUtil.BindGridViewItem2LuaStatic("ShopGoodsItem", tmp)
	self.shopGoodsItem.prefabName = "ShopGoodsItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BottomAnim/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomAnim/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/TopView/LabelScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/LabelScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelScrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIShopView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TopView/LabelScrollView/Viewport/Content/ShopLabelToggleItem
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/LabelScrollView/Viewport/Content/ShopLabelToggleItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shopLabelToggleItem = CommonUtil.BindGridViewItem2LuaStatic("ShopLabelToggleItem", tmp)
	self.shopLabelToggleItem.prefabName = "ShopLabelToggleItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/TopView/RightArrow
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/RightArrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rightArrow = tmp
end

---@private
function UIShopView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/TopView/LeftArrow
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/LeftArrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftArrow = tmp
end

---@private
function UIShopView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/TopView/TalkBox/TalkBoxTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/TalkBox/TalkBoxTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkBoxTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIShopView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.resourceBox = tmp
end

---@private
function UIShopView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox/ShopCurrencyItem
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox/ShopCurrencyItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shopCurrencyItem = CommonUtil.BindGridViewItem2LuaStatic("ShopCurrencyItem", tmp)
	self.shopCurrencyItem.prefabName = "ShopCurrencyItem"
end

---@private
function UIShopView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.timeBox) ~= nil then
		tolua.setpeer(self.timeBox, nil)
	end
	self.timeBox = nil
	if tolua.getpeer(self.textTime) ~= nil then
		tolua.setpeer(self.textTime, nil)
	end
	self.textTime = nil
	if tolua.getpeer(self.btnRefresh) ~= nil then
		tolua.setpeer(self.btnRefresh, nil)
	end
	self.btnRefresh = nil
	if tolua.getpeer(self.goodsScrollView) ~= nil then
		tolua.setpeer(self.goodsScrollView, nil)
	end
	self.goodsScrollView = nil
	if self.shopGoodsItem.GenerateDestroy ~= nil then
		self.shopGoodsItem:GenerateDestroy()
	end
	if tolua.getpeer(self.shopGoodsItem) ~= nil then
		tolua.setpeer(self.shopGoodsItem, nil)
	end
	self.shopGoodsItem = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.labelScrollView) ~= nil then
		tolua.setpeer(self.labelScrollView, nil)
	end
	self.labelScrollView = nil
	if self.shopLabelToggleItem.GenerateDestroy ~= nil then
		self.shopLabelToggleItem:GenerateDestroy()
	end
	if tolua.getpeer(self.shopLabelToggleItem) ~= nil then
		tolua.setpeer(self.shopLabelToggleItem, nil)
	end
	self.shopLabelToggleItem = nil
	if tolua.getpeer(self.rightArrow) ~= nil then
		tolua.setpeer(self.rightArrow, nil)
	end
	self.rightArrow = nil
	if tolua.getpeer(self.leftArrow) ~= nil then
		tolua.setpeer(self.leftArrow, nil)
	end
	self.leftArrow = nil
	if tolua.getpeer(self.talkBoxTxt) ~= nil then
		tolua.setpeer(self.talkBoxTxt, nil)
	end
	self.talkBoxTxt = nil
	if tolua.getpeer(self.resourceBox) ~= nil then
		tolua.setpeer(self.resourceBox, nil)
	end
	self.resourceBox = nil
	if self.shopCurrencyItem.GenerateDestroy ~= nil then
		self.shopCurrencyItem:GenerateDestroy()
	end
	if tolua.getpeer(self.shopCurrencyItem) ~= nil then
		tolua.setpeer(self.shopCurrencyItem, nil)
	end
	self.shopCurrencyItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIShopView