---@class UIMinTips__Generate_iconsNode
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIMinTips__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMinTips__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIMinTips__Generate_node
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIMinTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private node UIMinTips__Generate_node
---@field private bg UIMinTips__Generate_bg
---@field private content UIMinTips__Generate_content
---@field private iconsNode UIMinTips__Generate_iconsNode
---@field private templateItem UnityEngine.GameObject
local UIMinTipsView = class("UIMinTipsView", require("UIViewBase"))

function UIMinTipsView:ctor()
end

---@private
function UIMinTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIMinTipsView:InitGenerate(Root, data)
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


end

---@private
function UIMinTipsView:InitGenerate__1(Root, data)
--[[
	Node
--]]
	local tmp = Root:Find("Node").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.node = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIMinTipsView:InitGenerate__2(Root, data)
--[[
	Node/BG
--]]
	local tmp = Root:Find("Node/BG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIMinTipsView:InitGenerate__3(Root, data)
--[[
	Node/BG/Text
--]]
	local tmp = Root:Find("Node/BG/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMinTipsView:InitGenerate__4(Root, data)
--[[
	Node/BG/Icons
--]]
	local tmp = Root:Find("Node/BG/Icons").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconsNode = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIMinTipsView:InitGenerate__5(Root, data)
--[[
	Node/BG/Icons/TipItem
--]]
	local tmp = Root:Find("Node/BG/Icons/TipItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.templateItem = CommonUtil.BindGridViewItem2LuaStatic("TipItem", tmp)
	self.templateItem.prefabName = "TipItem"
end

---@private
function UIMinTipsView:GenerateDestroy()
	if tolua.getpeer(self.node) ~= nil then
		tolua.setpeer(self.node, nil)
	end
	self.node = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.iconsNode) ~= nil then
		tolua.setpeer(self.iconsNode, nil)
	end
	self.iconsNode = nil
	if self.templateItem.GenerateDestroy ~= nil then
		self.templateItem:GenerateDestroy()
	end
	if tolua.getpeer(self.templateItem) ~= nil then
		tolua.setpeer(self.templateItem, nil)
	end
	self.templateItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIMinTipsView