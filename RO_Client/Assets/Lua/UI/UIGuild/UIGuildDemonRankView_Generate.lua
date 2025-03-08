---@class UIGuildDemonRank__Generate_myGuildRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate_mvpRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate_playerRank
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildDemonRank__Generate_guildRank
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildDemonRank__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildDemonRank__Generate_demonChampRankItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate_demonGuildRankItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopListView SuperScrollView.LoopListView

---@class UIGuildDemonRank__Generate_noRankListTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildDemonRank__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildDemonRank__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildDemonRank__Generate_AnyBtn
---@field private bottomRoot UnityEngine.GameObject
---@field private closeBtn UIGuildDemonRank__Generate_closeBtn
---@field private title UIGuildDemonRank__Generate_title
---@field private noRankList UnityEngine.GameObject
---@field private noRankListTxt UIGuildDemonRank__Generate_noRankListTxt
---@field private scrollView UIGuildDemonRank__Generate_scrollView
---@field private rankContent UnityEngine.GameObject
---@field private demonGuildRankItem UIGuildDemonRank__Generate_demonGuildRankItem
---@field private demonChampRankItem UIGuildDemonRank__Generate_demonChampRankItem
---@field private loadingItem UIGuildDemonRank__Generate_loadingItem
---@field private guildRank UIGuildDemonRank__Generate_guildRank
---@field private playerRank UIGuildDemonRank__Generate_playerRank
---@field private mvpRank UIGuildDemonRank__Generate_mvpRank
---@field private myGuildRank UIGuildDemonRank__Generate_myGuildRank
local UIGuildDemonRankView = class("UIGuildDemonRankView", require("UIViewBase"))

function UIGuildDemonRankView:ctor()
end

---@private
function UIGuildDemonRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildDemonRankView:InitGenerate(Root, data)
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
function UIGuildDemonRankView:InitGenerate__1(Root, data)
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
function UIGuildDemonRankView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bg/BottomRoot
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomRoot = tmp
end

---@private
function UIGuildDemonRankView:InitGenerate__3(Root, data)
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
function UIGuildDemonRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/Title/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Title/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildDemonRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/NoRankList
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/NoRankList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noRankList = tmp
end

---@private
function UIGuildDemonRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/NoRankList/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/NoRankList/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noRankListTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildDemonRankView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIGuildDemonRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankContent = tmp
end

---@private
function UIGuildDemonRankView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/DemonGuildRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/DemonGuildRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.demonGuildRankItem = CommonUtil.BindGridViewItem2LuaStatic("DemonGuildRankItem", tmp)
	self.demonGuildRankItem.prefabName = "DemonGuildRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildDemonRankView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/DemonChampRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/DemonChampRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.demonChampRankItem = CommonUtil.BindGridViewItem2LuaStatic("DemonChampRankItem", tmp)
	self.demonChampRankItem.prefabName = "DemonChampRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildDemonRankView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildDemonRankView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/TgooleGroup/GuildRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/TgooleGroup/GuildRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildRank = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildDemonRankView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/TgooleGroup/PlayerRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/TgooleGroup/PlayerRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerRank = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildDemonRankView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/MvpRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/MvpRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mvpRank = CommonUtil.BindGridViewItem2LuaStatic("DemonChampRankItem", tmp)
	self.mvpRank.prefabName = "DemonChampRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildDemonRankView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/MyGuildRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/MyGuildRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.myGuildRank = CommonUtil.BindGridViewItem2LuaStatic("DemonGuildRankItem", tmp)
	self.myGuildRank.prefabName = "DemonGuildRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildDemonRankView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.bottomRoot) ~= nil then
		tolua.setpeer(self.bottomRoot, nil)
	end
	self.bottomRoot = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.noRankList) ~= nil then
		tolua.setpeer(self.noRankList, nil)
	end
	self.noRankList = nil
	if tolua.getpeer(self.noRankListTxt) ~= nil then
		tolua.setpeer(self.noRankListTxt, nil)
	end
	self.noRankListTxt = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.rankContent) ~= nil then
		tolua.setpeer(self.rankContent, nil)
	end
	self.rankContent = nil
	if self.demonGuildRankItem.GenerateDestroy ~= nil then
		self.demonGuildRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.demonGuildRankItem) ~= nil then
		tolua.setpeer(self.demonGuildRankItem, nil)
	end
	self.demonGuildRankItem = nil
	if self.demonChampRankItem.GenerateDestroy ~= nil then
		self.demonChampRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.demonChampRankItem) ~= nil then
		tolua.setpeer(self.demonChampRankItem, nil)
	end
	self.demonChampRankItem = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if tolua.getpeer(self.guildRank) ~= nil then
		tolua.setpeer(self.guildRank, nil)
	end
	self.guildRank = nil
	if tolua.getpeer(self.playerRank) ~= nil then
		tolua.setpeer(self.playerRank, nil)
	end
	self.playerRank = nil
	if self.mvpRank.GenerateDestroy ~= nil then
		self.mvpRank:GenerateDestroy()
	end
	if tolua.getpeer(self.mvpRank) ~= nil then
		tolua.setpeer(self.mvpRank, nil)
	end
	self.mvpRank = nil
	if self.myGuildRank.GenerateDestroy ~= nil then
		self.myGuildRank:GenerateDestroy()
	end
	if tolua.getpeer(self.myGuildRank) ~= nil then
		tolua.setpeer(self.myGuildRank, nil)
	end
	self.myGuildRank = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildDemonRankView