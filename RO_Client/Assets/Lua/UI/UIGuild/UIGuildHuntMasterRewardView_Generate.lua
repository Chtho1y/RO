---@class UIGuildHuntMasterReward__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHuntMasterReward__Generate_awardScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIGuildHuntMasterReward__Generate_topDamageMember_damageTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHuntMasterReward__Generate_topDamageMember_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHuntMasterReward__Generate_topDamageMember_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildHuntMasterReward__Generate_topDamageMember
---@field public gameObject UnityEngine.GameObject
---@field public headItem UIGuildHuntMasterReward__Generate_topDamageMember_headItem
---@field public nameTxt UIGuildHuntMasterReward__Generate_topDamageMember_nameTxt
---@field public damageTxt UIGuildHuntMasterReward__Generate_topDamageMember_damageTxt

---@class UIGuildHuntMasterReward__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHuntMasterReward__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHuntMasterReward__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildHuntMasterReward__Generate_AnyBtn
---@field private btnClose UIGuildHuntMasterReward__Generate_btnClose
---@field private notEmpty UnityEngine.GameObject
---@field private topDamageMember UIGuildHuntMasterReward__Generate_topDamageMember
---@field private awardScrollView UIGuildHuntMasterReward__Generate_awardScrollView
---@field private emptyTips UnityEngine.GameObject
---@field private desTxt UIGuildHuntMasterReward__Generate_desTxt
local UIGuildHuntMasterRewardView = class("UIGuildHuntMasterRewardView", require("UIViewBase"))

function UIGuildHuntMasterRewardView:ctor()
end

---@private
function UIGuildHuntMasterRewardView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildHuntMasterRewardView:InitGenerate(Root, data)
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


end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__1(Root, data)
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
function UIGuildHuntMasterRewardView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/NotEmpty
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notEmpty = tmp
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/NotEmpty/TopDamageMember
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty/TopDamageMember").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topDamageMember = tmp
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/NotEmpty/TopDamageMember/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty/TopDamageMember/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topDamageMember.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.topDamageMember.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/NotEmpty/TopDamageMember/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty/TopDamageMember/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topDamageMember.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/NotEmpty/TopDamageMember/DamageTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty/TopDamageMember/DamageTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topDamageMember.damageTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/NotEmpty/Reward/AwardScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/NotEmpty/Reward/AwardScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardScrollView = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/EmptyTips
--]]
	local tmp = Root:Find("UIAnimator/Window/EmptyTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyTips = tmp
end

---@private
function UIGuildHuntMasterRewardView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/EmptyTips/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/EmptyTips/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntMasterRewardView:GenerateDestroy()
	if tolua.getpeer(self.topDamageMember.damageTxt) ~= nil then
		tolua.setpeer(self.topDamageMember.damageTxt, nil)
	end
	if tolua.getpeer(self.topDamageMember.nameTxt) ~= nil then
		tolua.setpeer(self.topDamageMember.nameTxt, nil)
	end
	if self.topDamageMember.headItem.GenerateDestroy ~= nil then
		self.topDamageMember.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.topDamageMember.headItem) ~= nil then
		tolua.setpeer(self.topDamageMember.headItem, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.notEmpty) ~= nil then
		tolua.setpeer(self.notEmpty, nil)
	end
	self.notEmpty = nil
	if tolua.getpeer(self.topDamageMember) ~= nil then
		tolua.setpeer(self.topDamageMember, nil)
	end
	self.topDamageMember = nil
	if tolua.getpeer(self.awardScrollView) ~= nil then
		tolua.setpeer(self.awardScrollView, nil)
	end
	self.awardScrollView = nil
	if tolua.getpeer(self.emptyTips) ~= nil then
		tolua.setpeer(self.emptyTips, nil)
	end
	self.emptyTips = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildHuntMasterRewardView