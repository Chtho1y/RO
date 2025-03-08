---@class UIHundredDojoLog__Generate_lastSeasonToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIHundredDojoLog__Generate_curSeasonToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIHundredDojoLog__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIHundredDojoLog__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIHundredDojoLog__Generate_changeList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIHundredDojoLog__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoLog__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIHundredDojoLog__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoLog__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIHundredDojoLog__Generate_AnyBtn
---@field private textTitle UIHundredDojoLog__Generate_textTitle
---@field private btnClose UIHundredDojoLog__Generate_btnClose
---@field private changeList UIHundredDojoLog__Generate_changeList
---@field private loadingItem UIHundredDojoLog__Generate_loadingItem
---@field private hundredDojoLogItem UnityEngine.GameObject
---@field private toggleGroup UIHundredDojoLog__Generate_toggleGroup
---@field private curSeasonToggle UIHundredDojoLog__Generate_curSeasonToggle
---@field private lastSeasonToggle UIHundredDojoLog__Generate_lastSeasonToggle
---@field private noSign UnityEngine.GameObject
local UIHundredDojoLogView = class("UIHundredDojoLogView", require("UIViewBase"))

function UIHundredDojoLogView:ctor()
end

---@private
function UIHundredDojoLogView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIHundredDojoLogView:InitGenerate(Root, data)
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
function UIHundredDojoLogView:InitGenerate__1(Root, data)
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
function UIHundredDojoLogView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/UIWindowTitle/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowTitle/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIHundredDojoLogView:InitGenerate__3(Root, data)
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
function UIHundredDojoLogView:InitGenerate__4(Root, data)
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
function UIHundredDojoLogView:InitGenerate__5(Root, data)
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
function UIHundredDojoLogView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ChangeList/Viewport/Content/HundredDojoLogItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Viewport/Content/HundredDojoLogItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hundredDojoLogItem = CommonUtil.BindGridViewItem2LuaStatic("HundredDojoLogItem", tmp)
	self.hundredDojoLogItem.prefabName = "HundredDojoLogItem"
end

---@private
function UIHundredDojoLogView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIHundredDojoLogView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/CurrentSeason
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/CurrentSeason").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curSeasonToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIHundredDojoLogView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/LastSeason
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/LastSeason").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lastSeasonToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIHundredDojoLogView:InitGenerate__10(Root, data)
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
function UIHundredDojoLogView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
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
	if self.hundredDojoLogItem.GenerateDestroy ~= nil then
		self.hundredDojoLogItem:GenerateDestroy()
	end
	if tolua.getpeer(self.hundredDojoLogItem) ~= nil then
		tolua.setpeer(self.hundredDojoLogItem, nil)
	end
	self.hundredDojoLogItem = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.curSeasonToggle) ~= nil then
		tolua.setpeer(self.curSeasonToggle, nil)
	end
	self.curSeasonToggle = nil
	if tolua.getpeer(self.lastSeasonToggle) ~= nil then
		tolua.setpeer(self.lastSeasonToggle, nil)
	end
	self.lastSeasonToggle = nil
	if tolua.getpeer(self.noSign) ~= nil then
		tolua.setpeer(self.noSign, nil)
	end
	self.noSign = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIHundredDojoLogView