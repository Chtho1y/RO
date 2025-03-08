---@class UIActivityLimitedGift__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityLimitedGift__Generate_btnArrowR
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityLimitedGift__Generate_btnArrowL
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityLimitedGift__Generate_limitedGiftItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIActivityLimitedGift__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopListView SuperScrollView.LoopListView

---@class UIActivityLimitedGift__Generate_dot
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIActivityLimitedGift__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityLimitedGift__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityLimitedGift__Generate_AnyBtn
---@field private dotToggleGroup UnityEngine.GameObject
---@field private dot UIActivityLimitedGift__Generate_dot
---@field private scrollView UIActivityLimitedGift__Generate_scrollView
---@field private limitedGiftItem UIActivityLimitedGift__Generate_limitedGiftItem
---@field private btnArrowL UIActivityLimitedGift__Generate_btnArrowL
---@field private btnArrowR UIActivityLimitedGift__Generate_btnArrowR
---@field private BtnClose UIActivityLimitedGift__Generate_BtnClose
local UIActivityLimitedGiftView = class("UIActivityLimitedGiftView", require("UIViewBase"))

function UIActivityLimitedGiftView:ctor()
end

---@private
function UIActivityLimitedGiftView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityLimitedGiftView:InitGenerate(Root, data)
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


end

---@private
function UIActivityLimitedGiftView:InitGenerate__1(Root, data)
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
function UIActivityLimitedGiftView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/DotToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/DotToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dotToggleGroup = tmp
end

---@private
function UIActivityLimitedGiftView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/DotToggleGroup/Dot
--]]
	local tmp = Root:Find("UIAnimator/Window/DotToggleGroup/Dot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dot = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityLimitedGiftView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIActivityLimitedGiftView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/LimitedGiftItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/LimitedGiftItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitedGiftItem = CommonUtil.BindGridViewItem2LuaStatic("LimitedGiftItem", tmp)
	self.limitedGiftItem.prefabName = "LimitedGiftItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIActivityLimitedGiftView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BtnArrowL
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnArrowL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnArrowL = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityLimitedGiftView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnArrowR
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnArrowR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnArrowR = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityLimitedGiftView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityLimitedGiftView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.dotToggleGroup) ~= nil then
		tolua.setpeer(self.dotToggleGroup, nil)
	end
	self.dotToggleGroup = nil
	if tolua.getpeer(self.dot) ~= nil then
		tolua.setpeer(self.dot, nil)
	end
	self.dot = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.limitedGiftItem.GenerateDestroy ~= nil then
		self.limitedGiftItem:GenerateDestroy()
	end
	if tolua.getpeer(self.limitedGiftItem) ~= nil then
		tolua.setpeer(self.limitedGiftItem, nil)
	end
	self.limitedGiftItem = nil
	if tolua.getpeer(self.btnArrowL) ~= nil then
		tolua.setpeer(self.btnArrowL, nil)
	end
	self.btnArrowL = nil
	if tolua.getpeer(self.btnArrowR) ~= nil then
		tolua.setpeer(self.btnArrowR, nil)
	end
	self.btnArrowR = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityLimitedGiftView