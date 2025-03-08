---@class UIHundredDojoGuildRank__Generate_selfRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoGuildRank__Generate_hundredDojoGuildRankItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoGuildRank__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIHundredDojoGuildRank__Generate_bubbleTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoGuildRank__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoGuildRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoGuildRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIHundredDojoGuildRank__Generate_AnyBtn
---@field private btnClose UIHundredDojoGuildRank__Generate_btnClose
---@field private bubbleTxt UIHundredDojoGuildRank__Generate_bubbleTxt
---@field private noGuildList UnityEngine.GameObject
---@field private scrollView UIHundredDojoGuildRank__Generate_scrollView
---@field private hundredDojoGuildRankItem UIHundredDojoGuildRank__Generate_hundredDojoGuildRankItem
---@field private selfRank UIHundredDojoGuildRank__Generate_selfRank
---@field private noGuild UnityEngine.GameObject
local UIHundredDojoGuildRankView = class("UIHundredDojoGuildRankView", require("UIViewBase"))

function UIHundredDojoGuildRankView:ctor()
end

---@private
function UIHundredDojoGuildRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIHundredDojoGuildRankView:InitGenerate(Root, data)
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
function UIHundredDojoGuildRankView:InitGenerate__1(Root, data)
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
function UIHundredDojoGuildRankView:InitGenerate__2(Root, data)
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
function UIHundredDojoGuildRankView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Top/Bubble/BubbleTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Bubble/BubbleTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bubbleTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoGuildRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/RankList/NoGuildList
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList/NoGuildList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noGuildList = tmp
end

---@private
function UIHundredDojoGuildRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/RankList/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIHundredDojoGuildRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/RankList/ScrollView/Viewport/Content/HundredDojoGuildRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/RankList/ScrollView/Viewport/Content/HundredDojoGuildRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hundredDojoGuildRankItem = CommonUtil.BindGridViewItem2LuaStatic("HundredDojoGuildRankItem", tmp)
	self.hundredDojoGuildRankItem.prefabName = "HundredDojoGuildRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIHundredDojoGuildRankView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/SelfRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/SelfRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank = CommonUtil.BindGridViewItem2LuaStatic("HundredDojoGuildRankItem", tmp)
	self.selfRank.prefabName = "HundredDojoGuildRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIHundredDojoGuildRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/NoGuild
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/NoGuild").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noGuild = tmp
end

---@private
function UIHundredDojoGuildRankView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.bubbleTxt) ~= nil then
		tolua.setpeer(self.bubbleTxt, nil)
	end
	self.bubbleTxt = nil
	if tolua.getpeer(self.noGuildList) ~= nil then
		tolua.setpeer(self.noGuildList, nil)
	end
	self.noGuildList = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.hundredDojoGuildRankItem.GenerateDestroy ~= nil then
		self.hundredDojoGuildRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.hundredDojoGuildRankItem) ~= nil then
		tolua.setpeer(self.hundredDojoGuildRankItem, nil)
	end
	self.hundredDojoGuildRankItem = nil
	if self.selfRank.GenerateDestroy ~= nil then
		self.selfRank:GenerateDestroy()
	end
	if tolua.getpeer(self.selfRank) ~= nil then
		tolua.setpeer(self.selfRank, nil)
	end
	self.selfRank = nil
	if tolua.getpeer(self.noGuild) ~= nil then
		tolua.setpeer(self.noGuild, nil)
	end
	self.noGuild = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIHundredDojoGuildRankView