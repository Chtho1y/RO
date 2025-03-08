---@class UIGuildDemonReward__Generate_demonRewardItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonReward__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIGuildDemonReward__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonReward__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildDemonReward__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildDemonReward__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildDemonReward__Generate_AnyBtn
---@field private title UIGuildDemonReward__Generate_title
---@field private closeBtn UIGuildDemonReward__Generate_closeBtn
---@field private scrollView UIGuildDemonReward__Generate_scrollView
---@field private RewardContent UnityEngine.GameObject
---@field private demonRewardItem UIGuildDemonReward__Generate_demonRewardItem
local UIGuildDemonRewardView = class("UIGuildDemonRewardView", require("UIViewBase"))

function UIGuildDemonRewardView:ctor()
end

---@private
function UIGuildDemonRewardView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildDemonRewardView:InitGenerate(Root, data)
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
function UIGuildDemonRewardView:InitGenerate__1(Root, data)
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
function UIGuildDemonRewardView:InitGenerate__2(Root, data)
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
function UIGuildDemonRewardView:InitGenerate__3(Root, data)
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
function UIGuildDemonRewardView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/RewardList/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RewardList/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIGuildDemonRewardView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/RewardList/ScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RewardList/ScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.RewardContent = tmp
end

---@private
function UIGuildDemonRewardView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/RewardList/ScrollView/Viewport/Content/DemonRewardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RewardList/ScrollView/Viewport/Content/DemonRewardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.demonRewardItem = CommonUtil.BindGridViewItem2LuaStatic("DemonRewardItem", tmp)
	self.demonRewardItem.prefabName = "DemonRewardItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildDemonRewardView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.RewardContent) ~= nil then
		tolua.setpeer(self.RewardContent, nil)
	end
	self.RewardContent = nil
	if self.demonRewardItem.GenerateDestroy ~= nil then
		self.demonRewardItem:GenerateDestroy()
	end
	if tolua.getpeer(self.demonRewardItem) ~= nil then
		tolua.setpeer(self.demonRewardItem, nil)
	end
	self.demonRewardItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildDemonRewardView