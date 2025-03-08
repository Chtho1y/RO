---@class UIREShop__Generate_redEnvelope_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIREShop__Generate_redEnvelope_desc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIREShop__Generate_redEnvelope
---@field public gameObject UnityEngine.GameObject
---@field public desc UIREShop__Generate_redEnvelope_desc
---@field public btnSure UIREShop__Generate_redEnvelope_btnSure

---@class UIREShop__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIREShop__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIREShop__Generate_runeShopGoodsItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIREShop__Generate_goodsScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIREShop__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIREShop__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIREShop__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIREShop__Generate_uIAnimator
---@field private AnyBtn UIREShop__Generate_AnyBtn
---@field private goodsScrollView UIREShop__Generate_goodsScrollView
---@field private runeShopGoodsItem UIREShop__Generate_runeShopGoodsItem
---@field private btnClose UIREShop__Generate_btnClose
---@field private btnInfo UIREShop__Generate_btnInfo
---@field private resourceBox UnityEngine.GameObject
---@field private shopCurrencyItem UnityEngine.GameObject
---@field private redEnvelope UIREShop__Generate_redEnvelope
local UIREShopView = class("UIREShopView", require("UIViewBase"))

function UIREShopView:ctor()
end

---@private
function UIREShopView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIREShopView:InitGenerate(Root, data)
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


end

---@private
function UIREShopView:InitGenerate__1(Root, data)
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
function UIREShopView:InitGenerate__2(Root, data)
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
function UIREShopView:InitGenerate__3(Root, data)
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
function UIREShopView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/GoodsBox/GoodsScrollView/Viewport/Content/RuneShopGoodsItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsBox/GoodsScrollView/Viewport/Content/RuneShopGoodsItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.runeShopGoodsItem = CommonUtil.BindGridViewItem2LuaStatic("RuneShopGoodsItem", tmp)
	self.runeShopGoodsItem.prefabName = "RuneShopGoodsItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIREShopView:InitGenerate__5(Root, data)
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
function UIREShopView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/TopView/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIREShopView:InitGenerate__7(Root, data)
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
function UIREShopView:InitGenerate__8(Root, data)
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
function UIREShopView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/TopView/RedEnvelope
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/RedEnvelope").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope = tmp
end

---@private
function UIREShopView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TopView/RedEnvelope/Desc
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/RedEnvelope/Desc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope.desc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIREShopView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/TopView/RedEnvelope/BtnSure
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/RedEnvelope/BtnSure").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope.btnSure = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIREShopView:GenerateDestroy()
	if tolua.getpeer(self.redEnvelope.btnSure) ~= nil then
		tolua.setpeer(self.redEnvelope.btnSure, nil)
	end
	if tolua.getpeer(self.redEnvelope.desc) ~= nil then
		tolua.setpeer(self.redEnvelope.desc, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.goodsScrollView) ~= nil then
		tolua.setpeer(self.goodsScrollView, nil)
	end
	self.goodsScrollView = nil
	if self.runeShopGoodsItem.GenerateDestroy ~= nil then
		self.runeShopGoodsItem:GenerateDestroy()
	end
	if tolua.getpeer(self.runeShopGoodsItem) ~= nil then
		tolua.setpeer(self.runeShopGoodsItem, nil)
	end
	self.runeShopGoodsItem = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
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
	if tolua.getpeer(self.redEnvelope) ~= nil then
		tolua.setpeer(self.redEnvelope, nil)
	end
	self.redEnvelope = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIREShopView