---@class UIGuildAuditApply__Generate_allAllowBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildAuditApply__Generate_allRefuseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildAuditApply__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildAuditApply__Generate_peopleList
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIGuildAuditApply__Generate_peopleNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildAuditApply__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildAuditApply__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildAuditApply__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildAuditApply__Generate_AnyBtn
---@field private btnClose UIGuildAuditApply__Generate_btnClose
---@field private peopleNum UIGuildAuditApply__Generate_peopleNum
---@field private peopleList UIGuildAuditApply__Generate_peopleList
---@field private guildPeopleApplyItem UnityEngine.GameObject
---@field private emptyTips UnityEngine.GameObject
---@field private bg UnityEngine.GameObject
---@field private desTxt UIGuildAuditApply__Generate_desTxt
---@field private bottom UnityEngine.GameObject
---@field private allRefuseBtn UIGuildAuditApply__Generate_allRefuseBtn
---@field private allAllowBtn UIGuildAuditApply__Generate_allAllowBtn
local UIGuildAuditApplyView = class("UIGuildAuditApplyView", require("UIViewBase"))

function UIGuildAuditApplyView:ctor()
end

---@private
function UIGuildAuditApplyView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildAuditApplyView:InitGenerate(Root, data)
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
function UIGuildAuditApplyView:InitGenerate__1(Root, data)
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
function UIGuildAuditApplyView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildAuditApplyView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bg/People/PeopleNum
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/People/PeopleNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.peopleNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildAuditApplyView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/PeopleList
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/PeopleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.peopleList = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIGuildAuditApplyView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/PeopleList/Viewport/Content/GuildPeopleApplyItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/PeopleList/Viewport/Content/GuildPeopleApplyItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildPeopleApplyItem = CommonUtil.BindGridViewItem2LuaStatic("GuildPeopleApplyItem", tmp)
	self.guildPeopleApplyItem.prefabName = "GuildPeopleApplyItem"
end

---@private
function UIGuildAuditApplyView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/EmptyTips
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/EmptyTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyTips = tmp
end

---@private
function UIGuildAuditApplyView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/EmptyTips/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/EmptyTips/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function UIGuildAuditApplyView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/EmptyTips/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/EmptyTips/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildAuditApplyView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIGuildAuditApplyView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/AllRefuseBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/AllRefuseBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allRefuseBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildAuditApplyView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/AllAllowBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/AllAllowBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allAllowBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildAuditApplyView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.peopleNum) ~= nil then
		tolua.setpeer(self.peopleNum, nil)
	end
	self.peopleNum = nil
	if tolua.getpeer(self.peopleList) ~= nil then
		tolua.setpeer(self.peopleList, nil)
	end
	self.peopleList = nil
	if self.guildPeopleApplyItem.GenerateDestroy ~= nil then
		self.guildPeopleApplyItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildPeopleApplyItem) ~= nil then
		tolua.setpeer(self.guildPeopleApplyItem, nil)
	end
	self.guildPeopleApplyItem = nil
	if tolua.getpeer(self.emptyTips) ~= nil then
		tolua.setpeer(self.emptyTips, nil)
	end
	self.emptyTips = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	self.bottom = nil
	if tolua.getpeer(self.allRefuseBtn) ~= nil then
		tolua.setpeer(self.allRefuseBtn, nil)
	end
	self.allRefuseBtn = nil
	if tolua.getpeer(self.allAllowBtn) ~= nil then
		tolua.setpeer(self.allAllowBtn, nil)
	end
	self.allAllowBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildAuditApplyView