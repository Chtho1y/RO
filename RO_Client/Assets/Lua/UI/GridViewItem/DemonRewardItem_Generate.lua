---@class DemonRewardItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DemonRewardItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopGridView SuperScrollView.LoopGridView

---@class DemonRewardItem__Generate_boxIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class DemonRewardItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DemonRewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private nameTxt DemonRewardItem__Generate_nameTxt
---@field private boxIcon DemonRewardItem__Generate_boxIcon
---@field private scrollView DemonRewardItem__Generate_scrollView
---@field private iconSmallItem DemonRewardItem__Generate_iconSmallItem
local DemonRewardItemView = class("DemonRewardItemView")

function DemonRewardItemView:ctor()
end

---@private
function DemonRewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DemonRewardItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)


end

---@private
function DemonRewardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DemonRewardItemView:InitGenerate__2(Root, data)
--[[
	NameTxt
--]]
	local tmp = Root:Find("NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DemonRewardItemView:InitGenerate__3(Root, data)
--[[
	BoxIcon
--]]
	local tmp = Root:Find("BoxIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DemonRewardItemView:InitGenerate__4(Root, data)
--[[
	Scroll View
--]]
	local tmp = Root:Find("Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function DemonRewardItemView:InitGenerate__5(Root, data)
--[[
	Scroll View/Viewport/Content/IconSmallItem
--]]
	local tmp = Root:Find("Scroll View/Viewport/Content/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function DemonRewardItemView:GenerateDestroy()
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.boxIcon) ~= nil then
		tolua.setpeer(self.boxIcon, nil)
	end
	self.boxIcon = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DemonRewardItemView