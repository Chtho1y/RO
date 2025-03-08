---@class UIGuildHuntLog__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHuntLog__Generate_guildPeopleHurtItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildHuntLog__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildHuntLog__Generate_damageList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIGuildHuntLog__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHuntLog__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHuntLog__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildHuntLog__Generate_AnyBtn
---@field private btnClose UIGuildHuntLog__Generate_btnClose
---@field private damageList UIGuildHuntLog__Generate_damageList
---@field private loadingItem UIGuildHuntLog__Generate_loadingItem
---@field private guildPeopleHurtItem UIGuildHuntLog__Generate_guildPeopleHurtItem
---@field private emptyTips UnityEngine.GameObject
---@field private desTxt UIGuildHuntLog__Generate_desTxt
local UIGuildHuntLogView = class("UIGuildHuntLogView", require("UIViewBase"))

function UIGuildHuntLogView:ctor()
end

---@private
function UIGuildHuntLogView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildHuntLogView:InitGenerate(Root, data)
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


end

---@private
function UIGuildHuntLogView:InitGenerate__1(Root, data)
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
function UIGuildHuntLogView:InitGenerate__2(Root, data)
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
function UIGuildHuntLogView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/DamageList
--]]
	local tmp = Root:Find("UIAnimator/Window/DamageList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.damageList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIGuildHuntLogView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/DamageList/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DamageList/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildHuntLogView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/DamageList/Viewport/Content/GuildPeopleHurtItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DamageList/Viewport/Content/GuildPeopleHurtItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildPeopleHurtItem = CommonUtil.BindGridViewItem2LuaStatic("GuildPeopleHurtItem", tmp)
	self.guildPeopleHurtItem.prefabName = "GuildPeopleHurtItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildHuntLogView:InitGenerate__6(Root, data)
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
function UIGuildHuntLogView:InitGenerate__7(Root, data)
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
function UIGuildHuntLogView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.damageList) ~= nil then
		tolua.setpeer(self.damageList, nil)
	end
	self.damageList = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if self.guildPeopleHurtItem.GenerateDestroy ~= nil then
		self.guildPeopleHurtItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildPeopleHurtItem) ~= nil then
		tolua.setpeer(self.guildPeopleHurtItem, nil)
	end
	self.guildPeopleHurtItem = nil
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
return UIGuildHuntLogView