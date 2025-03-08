---@class UIExpeditionRank__Generate_myRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionRank__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIExpeditionRank__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIExpeditionRank__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIExpeditionRank__Generate_AnyBtn
---@field private bottomRoot UnityEngine.GameObject
---@field private closeBtn UIExpeditionRank__Generate_closeBtn
---@field private title UIExpeditionRank__Generate_title
---@field private noRankList UnityEngine.GameObject
---@field private scrollView UIExpeditionRank__Generate_scrollView
---@field private rankContent UnityEngine.GameObject
---@field private myRank UIExpeditionRank__Generate_myRank
local UIExpeditionRankView = class("UIExpeditionRankView", require("UIViewBase"))

function UIExpeditionRankView:ctor()
end

---@private
function UIExpeditionRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionRankView:InitGenerate(Root, data)
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
function UIExpeditionRankView:InitGenerate__1(Root, data)
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
function UIExpeditionRankView:InitGenerate__2(Root, data)
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
function UIExpeditionRankView:InitGenerate__3(Root, data)
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
function UIExpeditionRankView:InitGenerate__4(Root, data)
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
function UIExpeditionRankView:InitGenerate__5(Root, data)
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
function UIExpeditionRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/RankList/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RankList/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIExpeditionRankView:InitGenerate__7(Root, data)
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
function UIExpeditionRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/MyRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/MyRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.myRank = CommonUtil.BindGridViewItem2LuaStatic("ExpeditionRankItem", tmp)
	self.myRank.prefabName = "ExpeditionRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionRankView:GenerateDestroy()
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
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.rankContent) ~= nil then
		tolua.setpeer(self.rankContent, nil)
	end
	self.rankContent = nil
	if self.myRank.GenerateDestroy ~= nil then
		self.myRank:GenerateDestroy()
	end
	if tolua.getpeer(self.myRank) ~= nil then
		tolua.setpeer(self.myRank, nil)
	end
	self.myRank = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionRankView