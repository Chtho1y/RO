---@class TeacherLogUI__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TeacherLogUI__Generate_changeList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class TeacherLogUI__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TeacherLogUI__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TeacherLogUI__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private AnyBtn TeacherLogUI__Generate_AnyBtn
---@field private btnClose TeacherLogUI__Generate_btnClose
---@field private changeList TeacherLogUI__Generate_changeList
---@field private loadingItem TeacherLogUI__Generate_loadingItem
---@field private guildLogItem UnityEngine.GameObject
---@field private noSign UnityEngine.GameObject
local TeacherLogUIView = class("TeacherLogUIView")

function TeacherLogUIView:ctor()
end

---@private
function TeacherLogUIView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TeacherLogUIView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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
function TeacherLogUIView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function TeacherLogUIView:InitGenerate__2(Root, data)
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
function TeacherLogUIView:InitGenerate__3(Root, data)
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
function TeacherLogUIView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ChangeList
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function TeacherLogUIView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ChangeList/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TeacherLogUIView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ChangeList/Viewport/Content/GuildLogItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Viewport/Content/GuildLogItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildLogItem = CommonUtil.BindGridViewItem2LuaStatic("GuildLogItem", tmp)
	self.guildLogItem.prefabName = "GuildLogItem"
end

---@private
function TeacherLogUIView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/NoSign
--]]
	local tmp = Root:Find("UIAnimator/Window/NoSign").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noSign = tmp
end

---@private
function TeacherLogUIView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.changeList) ~= nil then
		tolua.setpeer(self.changeList, nil)
	end
	self.changeList = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if self.guildLogItem.GenerateDestroy ~= nil then
		self.guildLogItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildLogItem) ~= nil then
		tolua.setpeer(self.guildLogItem, nil)
	end
	self.guildLogItem = nil
	if tolua.getpeer(self.noSign) ~= nil then
		tolua.setpeer(self.noSign, nil)
	end
	self.noSign = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TeacherLogUIView