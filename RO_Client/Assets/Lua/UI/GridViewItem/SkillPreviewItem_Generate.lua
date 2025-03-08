---@class SkillPreviewItem__Generate_desText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillPreviewItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class SkillPreviewItem__Generate_skillName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillPreviewItem__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class SkillPreviewItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private skillItem SkillPreviewItem__Generate_skillItem
---@field private skillName SkillPreviewItem__Generate_skillName
---@field private skillTagItem1 UnityEngine.GameObject
---@field private skillTagItem2 UnityEngine.GameObject
---@field private skillTagItem3 UnityEngine.GameObject
---@field private skillTagItem4 UnityEngine.GameObject
---@field private scrollView SkillPreviewItem__Generate_scrollView
---@field private desText SkillPreviewItem__Generate_desText
local SkillPreviewItemView = class("SkillPreviewItemView")

function SkillPreviewItemView:ctor()
end

---@private
function SkillPreviewItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillPreviewItemView:InitGenerate(Root, data)
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
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)


end

---@private
function SkillPreviewItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SkillPreviewItemView:InitGenerate__2(Root, data)
--[[
	Icon/SkillItem
--]]
	local tmp = Root:Find("Icon/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function SkillPreviewItemView:InitGenerate__3(Root, data)
--[[
	TextsBox/SkillName
--]]
	local tmp = Root:Find("TextsBox/SkillName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillPreviewItemView:InitGenerate__4(Root, data)
--[[
	TextsBox/TagBox/SkillTagItem1
--]]
	local tmp = Root:Find("TextsBox/TagBox/SkillTagItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem1 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem1.prefabName = "SkillTagItem"
end

---@private
function SkillPreviewItemView:InitGenerate__5(Root, data)
--[[
	TextsBox/TagBox/SkillTagItem2
--]]
	local tmp = Root:Find("TextsBox/TagBox/SkillTagItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem2 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem2.prefabName = "SkillTagItem"
end

---@private
function SkillPreviewItemView:InitGenerate__6(Root, data)
--[[
	TextsBox/TagBox/SkillTagItem3
--]]
	local tmp = Root:Find("TextsBox/TagBox/SkillTagItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem3 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem3.prefabName = "SkillTagItem"
end

---@private
function SkillPreviewItemView:InitGenerate__7(Root, data)
--[[
	TextsBox/TagBox/SkillTagItem4
--]]
	local tmp = Root:Find("TextsBox/TagBox/SkillTagItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem4 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem4.prefabName = "SkillTagItem"
end

---@private
function SkillPreviewItemView:InitGenerate__8(Root, data)
--[[
	ScrollView
--]]
	local tmp = Root:Find("ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function SkillPreviewItemView:InitGenerate__9(Root, data)
--[[
	ScrollView/Viewport/Content/DesText
--]]
	local tmp = Root:Find("ScrollView/Viewport/Content/DesText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillPreviewItemView:GenerateDestroy()
	if self.skillItem.GenerateDestroy ~= nil then
		self.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem) ~= nil then
		tolua.setpeer(self.skillItem, nil)
	end
	self.skillItem = nil
	if tolua.getpeer(self.skillName) ~= nil then
		tolua.setpeer(self.skillName, nil)
	end
	self.skillName = nil
	if self.skillTagItem1.GenerateDestroy ~= nil then
		self.skillTagItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem1) ~= nil then
		tolua.setpeer(self.skillTagItem1, nil)
	end
	self.skillTagItem1 = nil
	if self.skillTagItem2.GenerateDestroy ~= nil then
		self.skillTagItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem2) ~= nil then
		tolua.setpeer(self.skillTagItem2, nil)
	end
	self.skillTagItem2 = nil
	if self.skillTagItem3.GenerateDestroy ~= nil then
		self.skillTagItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem3) ~= nil then
		tolua.setpeer(self.skillTagItem3, nil)
	end
	self.skillTagItem3 = nil
	if self.skillTagItem4.GenerateDestroy ~= nil then
		self.skillTagItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem4) ~= nil then
		tolua.setpeer(self.skillTagItem4, nil)
	end
	self.skillTagItem4 = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.desText) ~= nil then
		tolua.setpeer(self.desText, nil)
	end
	self.desText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SkillPreviewItemView