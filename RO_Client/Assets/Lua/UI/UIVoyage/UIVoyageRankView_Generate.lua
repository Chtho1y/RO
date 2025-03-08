---@class UIVoyageRank__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIVoyageRank__Generate_rankList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIVoyageRank__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIVoyageRank__Generate_AnyBtn
---@field private btnClose UIVoyageRank__Generate_btnClose
---@field private rankList UIVoyageRank__Generate_rankList
---@field private loadingItem UIVoyageRank__Generate_loadingItem
---@field private voyageRankItem UnityEngine.GameObject
---@field private selfVoyageRankItem UnityEngine.GameObject
local UIVoyageRankView = class("UIVoyageRankView", require("UIViewBase"))

function UIVoyageRankView:ctor()
end

---@private
function UIVoyageRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVoyageRankView:InitGenerate(Root, data)
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


end

---@private
function UIVoyageRankView:InitGenerate__1(Root, data)
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
function UIVoyageRankView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageRankView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/RankList
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIVoyageRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/RankList/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIVoyageRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/RankList/Viewport/Content/VoyageRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList/Viewport/Content/VoyageRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.voyageRankItem = CommonUtil.BindGridViewItem2LuaStatic("VoyageRankItem", tmp)
	self.voyageRankItem.prefabName = "VoyageRankItem"
end

---@private
function UIVoyageRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/VoyageRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/VoyageRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfVoyageRankItem = CommonUtil.BindGridViewItem2LuaStatic("VoyageRankItem", tmp)
	self.selfVoyageRankItem.prefabName = "VoyageRankItem"
end

---@private
function UIVoyageRankView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.rankList) ~= nil then
		tolua.setpeer(self.rankList, nil)
	end
	self.rankList = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if self.voyageRankItem.GenerateDestroy ~= nil then
		self.voyageRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.voyageRankItem) ~= nil then
		tolua.setpeer(self.voyageRankItem, nil)
	end
	self.voyageRankItem = nil
	if self.selfVoyageRankItem.GenerateDestroy ~= nil then
		self.selfVoyageRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.selfVoyageRankItem) ~= nil then
		tolua.setpeer(self.selfVoyageRankItem, nil)
	end
	self.selfVoyageRankItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVoyageRankView