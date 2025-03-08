---@class UICardGot__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardGot__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardGot__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UICardGot__Generate_alpha
---@field private window UICardGot__Generate_window
---@field private cardIconBigItem UnityEngine.GameObject
---@field private cardListAttrItem UnityEngine.GameObject
---@field private attBox UnityEngine.GameObject
local UICardGotView = class("UICardGotView", require("UIViewBase"))

function UICardGotView:ctor()
end

---@private
function UICardGotView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardGotView:InitGenerate(Root, data)
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
function UICardGotView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UICardGotView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardGotView:InitGenerate__3(Root, data)
--[[
	Window
--]]
	local tmp = Root:Find("Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UICardGotView:InitGenerate__4(Root, data)
--[[
	Window/Box/CardIconBigItem
--]]
	local tmp = Root:Find("Window/Box/CardIconBigItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIconBigItem = CommonUtil.BindGridViewItem2LuaStatic("CardIconBigItem", tmp)
	self.cardIconBigItem.prefabName = "CardIconBigItem"
end

---@private
function UICardGotView:InitGenerate__5(Root, data)
--[[
	Window/Box/CardListAttrItem
--]]
	local tmp = Root:Find("Window/Box/CardListAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardListAttrItem = CommonUtil.BindGridViewItem2LuaStatic("CardListAttrItem", tmp)
	self.cardListAttrItem.prefabName = "CardListAttrItem"
end

---@private
function UICardGotView:InitGenerate__6(Root, data)
--[[
	Window/Box/AttBox
--]]
	local tmp = Root:Find("Window/Box/AttBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attBox = tmp
end

---@private
function UICardGotView:GenerateDestroy()
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if self.cardIconBigItem.GenerateDestroy ~= nil then
		self.cardIconBigItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardIconBigItem) ~= nil then
		tolua.setpeer(self.cardIconBigItem, nil)
	end
	self.cardIconBigItem = nil
	if self.cardListAttrItem.GenerateDestroy ~= nil then
		self.cardListAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardListAttrItem) ~= nil then
		tolua.setpeer(self.cardListAttrItem, nil)
	end
	self.cardListAttrItem = nil
	if tolua.getpeer(self.attBox) ~= nil then
		tolua.setpeer(self.attBox, nil)
	end
	self.attBox = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardGotView