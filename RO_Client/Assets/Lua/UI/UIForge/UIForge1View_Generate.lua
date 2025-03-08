---@class UIForge1__Generate_btnOneKey
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIForge1__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIForge1__Generate_toggle_txt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIForge1__Generate_toggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public txt UIForge1__Generate_toggle_txt

---@class UIForge1__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIForge1__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIForge1__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIForge1__Generate_AnyBtn
---@field private scrollView UIForge1__Generate_scrollView
---@field private equipComposeItem UnityEngine.GameObject
---@field private toggleScrollView UnityEngine.GameObject
---@field private toggle UIForge1__Generate_toggle
---@field private toggleGroup UnityEngine.GameObject
---@field private btnClose UIForge1__Generate_btnClose
---@field private btnOneKey UIForge1__Generate_btnOneKey
local UIForge1View = class("UIForge1View", require("UIViewBase"))

function UIForge1View:ctor()
end

---@private
function UIForge1View:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIForge1View:InitGenerate(Root, data)
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


end

---@private
function UIForge1View:InitGenerate__1(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIForge1View:InitGenerate__2(Root, data)
--[[
	Root/Window/bg/Scroll View
--]]
	local tmp = Root:Find("Root/Window/bg/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIForge1View:InitGenerate__3(Root, data)
--[[
	Root/Window/bg/Scroll View/Viewport/Content/EquipComposeItem
--]]
	local tmp = Root:Find("Root/Window/bg/Scroll View/Viewport/Content/EquipComposeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipComposeItem = CommonUtil.BindGridViewItem2LuaStatic("EquipComposeItem", tmp)
	self.equipComposeItem.prefabName = "EquipComposeItem"
end

---@private
function UIForge1View:InitGenerate__4(Root, data)
--[[
	Root/Window/bg/ToggleScrollView
--]]
	local tmp = Root:Find("Root/Window/bg/ToggleScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleScrollView = tmp
end

---@private
function UIForge1View:InitGenerate__5(Root, data)
--[[
	Root/Window/bg/ToggleScrollView/Viewport/toggle
--]]
	local tmp = Root:Find("Root/Window/bg/ToggleScrollView/Viewport/toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIForge1View:InitGenerate__6(Root, data)
--[[
	Root/Window/bg/ToggleScrollView/Viewport/toggle/Txt
--]]
	local tmp = Root:Find("Root/Window/bg/ToggleScrollView/Viewport/toggle/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIForge1View:InitGenerate__7(Root, data)
--[[
	Root/Window/bg/ToggleScrollView/Viewport/ToggleGroup
--]]
	local tmp = Root:Find("Root/Window/bg/ToggleScrollView/Viewport/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp
end

---@private
function UIForge1View:InitGenerate__8(Root, data)
--[[
	Root/Window/bg/BtnClose
--]]
	local tmp = Root:Find("Root/Window/bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIForge1View:InitGenerate__9(Root, data)
--[[
	Root/Window/bg/BtnOneKey
--]]
	local tmp = Root:Find("Root/Window/bg/BtnOneKey").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKey = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIForge1View:GenerateDestroy()
	if tolua.getpeer(self.toggle.txt) ~= nil then
		tolua.setpeer(self.toggle.txt, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.equipComposeItem.GenerateDestroy ~= nil then
		self.equipComposeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipComposeItem) ~= nil then
		tolua.setpeer(self.equipComposeItem, nil)
	end
	self.equipComposeItem = nil
	if tolua.getpeer(self.toggleScrollView) ~= nil then
		tolua.setpeer(self.toggleScrollView, nil)
	end
	self.toggleScrollView = nil
	if tolua.getpeer(self.toggle) ~= nil then
		tolua.setpeer(self.toggle, nil)
	end
	self.toggle = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.btnOneKey) ~= nil then
		tolua.setpeer(self.btnOneKey, nil)
	end
	self.btnOneKey = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIForge1View