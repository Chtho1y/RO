---@class UIIdolRank__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIIdolRank__Generate_rankScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIIdolRank__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolRank__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIIdolRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIIdolRank__Generate_uIAnimator
---@field private AnyBtn UIIdolRank__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIIdolRank__Generate_closeBtn
---@field private rankScroll UIIdolRank__Generate_rankScroll
---@field private rankContent UnityEngine.GameObject
---@field private uIIdolRankItem UnityEngine.GameObject
---@field private loadingItem UIIdolRank__Generate_loadingItem
---@field private emptyNode UnityEngine.GameObject
---@field private selfRankItem UnityEngine.GameObject
local UIIdolRankView = class("UIIdolRankView", require("UIViewBase"))

function UIIdolRankView:ctor()
end

---@private
function UIIdolRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolRankView:InitGenerate(Root, data)
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
function UIIdolRankView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolRankView:InitGenerate__2(Root, data)
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
function UIIdolRankView:InitGenerate__3(Root, data)
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
function UIIdolRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIIdolRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankScroll = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIIdolRankView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankContent = tmp
end

---@private
function UIIdolRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content/UIIdolRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content/UIIdolRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIIdolRankItem = CommonUtil.BindGridViewItem2LuaStatic("UIIdolRankItem", tmp)
	self.uIIdolRankItem.prefabName = "UIIdolRankItem"
end

---@private
function UIIdolRankView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIIdolRankView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyNode = tmp
end

---@private
function UIIdolRankView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRankItem = CommonUtil.BindGridViewItem2LuaStatic("UIIdolRankItem", tmp)
	self.selfRankItem.prefabName = "UIIdolRankItem"
end

---@private
function UIIdolRankView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.rankScroll) ~= nil then
		tolua.setpeer(self.rankScroll, nil)
	end
	self.rankScroll = nil
	if tolua.getpeer(self.rankContent) ~= nil then
		tolua.setpeer(self.rankContent, nil)
	end
	self.rankContent = nil
	if self.uIIdolRankItem.GenerateDestroy ~= nil then
		self.uIIdolRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.uIIdolRankItem) ~= nil then
		tolua.setpeer(self.uIIdolRankItem, nil)
	end
	self.uIIdolRankItem = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	if self.selfRankItem.GenerateDestroy ~= nil then
		self.selfRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.selfRankItem) ~= nil then
		tolua.setpeer(self.selfRankItem, nil)
	end
	self.selfRankItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolRankView