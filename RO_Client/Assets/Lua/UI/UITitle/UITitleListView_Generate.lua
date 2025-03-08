---@class UITitleList__Generate_allAtrBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITitleList__Generate_toggleItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITitleList__Generate_toggleList
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopGridView SuperScrollView.LoopGridView

---@class UITitleList__Generate_titleList
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UITitleList__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITitleList__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITitleList__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UITitleList__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UITitleList__Generate_uIAnimator
---@field private AnyBtn UITitleList__Generate_AnyBtn
---@field private btnClose UITitleList__Generate_btnClose
---@field private titleList UITitleList__Generate_titleList
---@field private toggleList UITitleList__Generate_toggleList
---@field private toggleContent UnityEngine.GameObject
---@field private toggleItem UITitleList__Generate_toggleItem
---@field private allAtrBtn UITitleList__Generate_allAtrBtn
local UITitleListView = class("UITitleListView", require("UIViewBase"))

function UITitleListView:ctor()
end

---@private
function UITitleListView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UITitleListView:InitGenerate(Root, data)
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
function UITitleListView:InitGenerate__1(Root, data)
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
function UITitleListView:InitGenerate__2(Root, data)
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
function UITitleListView:InitGenerate__3(Root, data)
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
function UITitleListView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TitleList
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleList = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UITitleListView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ToggleList
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleList = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UITitleListView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ToggleList/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleList/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleContent = tmp
end

---@private
function UITitleListView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ToggleList/Viewport/Content/ToggleItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleList/Viewport/Content/ToggleItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleItem = CommonUtil.BindGridViewItem2LuaStatic("ToggleItem", tmp)
	self.toggleItem.prefabName = "ToggleItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITitleListView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnAllAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnAllAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allAtrBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITitleListView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.titleList) ~= nil then
		tolua.setpeer(self.titleList, nil)
	end
	self.titleList = nil
	if tolua.getpeer(self.toggleList) ~= nil then
		tolua.setpeer(self.toggleList, nil)
	end
	self.toggleList = nil
	if tolua.getpeer(self.toggleContent) ~= nil then
		tolua.setpeer(self.toggleContent, nil)
	end
	self.toggleContent = nil
	if self.toggleItem.GenerateDestroy ~= nil then
		self.toggleItem:GenerateDestroy()
	end
	if tolua.getpeer(self.toggleItem) ~= nil then
		tolua.setpeer(self.toggleItem, nil)
	end
	self.toggleItem = nil
	if tolua.getpeer(self.allAtrBtn) ~= nil then
		tolua.setpeer(self.allAtrBtn, nil)
	end
	self.allAtrBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UITitleListView