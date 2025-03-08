---@class AttrTipItem__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class AttrTipItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class AttrTipItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field private canvasGroup UnityEngine.CanvasGroup
---@field private bg AttrTipItem__Generate_bg
---@field private numberNewItem UnityEngine.GameObject
---@field private content AttrTipItem__Generate_content
local AttrTipItemView = class("AttrTipItemView")

function AttrTipItemView:ctor()
end

---@private
function AttrTipItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function AttrTipItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function AttrTipItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.loopVerticalScrollRect = Root:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)

	self.canvasGroup = Root:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function AttrTipItemView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function AttrTipItemView:InitGenerate__3(Root, data)
--[[
	bg/NumberNewItem
--]]
	local tmp = Root:Find("bg/NumberNewItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberNewItem = CommonUtil.BindGridViewItem2LuaStatic("NumberNewItem", tmp)
	self.numberNewItem.prefabName = "NumberNewItem"
end

---@private
function AttrTipItemView:InitGenerate__4(Root, data)
--[[
	bg/content
--]]
	local tmp = Root:Find("bg/content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function AttrTipItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if self.numberNewItem.GenerateDestroy ~= nil then
		self.numberNewItem:GenerateDestroy()
	end
	if tolua.getpeer(self.numberNewItem) ~= nil then
		tolua.setpeer(self.numberNewItem, nil)
	end
	self.numberNewItem = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	self.inited = false
end
return AttrTipItemView