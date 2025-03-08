---@class SkillSmallItem__Generate_artifactStatus_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SkillSmallItem__Generate_artifactStatus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public activated UnityEngine.GameObject
---@field public icon SkillSmallItem__Generate_artifactStatus_icon

---@class SkillSmallItem__Generate_skillName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillSmallItem__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class SkillSmallItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private selectSign UnityEngine.GameObject
---@field private skillItem SkillSmallItem__Generate_skillItem
---@field private skillName SkillSmallItem__Generate_skillName
---@field private skillTagItem1 UnityEngine.GameObject
---@field private skillTagItem2 UnityEngine.GameObject
---@field private skillTagItem3 UnityEngine.GameObject
---@field private skillTagItem4 UnityEngine.GameObject
---@field private lock UnityEngine.GameObject
---@field private redPoint UnityEngine.GameObject
---@field private redPointNewItem UnityEngine.GameObject
---@field private newRedPoint UnityEngine.GameObject
---@field private equipSign UnityEngine.GameObject
---@field private artifactStatus SkillSmallItem__Generate_artifactStatus
local SkillSmallItemView = class("SkillSmallItemView")

function SkillSmallItemView:ctor()
end

---@private
function SkillSmallItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillSmallItemView:InitGenerate(Root, data)
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
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)


end

---@private
function SkillSmallItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SkillSmallItemView:InitGenerate__2(Root, data)
--[[
	SelectSign
--]]
	local tmp = Root:Find("SelectSign").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectSign = tmp
end

---@private
function SkillSmallItemView:InitGenerate__3(Root, data)
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
function SkillSmallItemView:InitGenerate__4(Root, data)
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
function SkillSmallItemView:InitGenerate__5(Root, data)
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
function SkillSmallItemView:InitGenerate__6(Root, data)
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
function SkillSmallItemView:InitGenerate__7(Root, data)
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
function SkillSmallItemView:InitGenerate__8(Root, data)
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
function SkillSmallItemView:InitGenerate__9(Root, data)
--[[
	Lock
--]]
	local tmp = Root:Find("Lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock = tmp
end

---@private
function SkillSmallItemView:InitGenerate__10(Root, data)
--[[
	RedPoint
--]]
	local tmp = Root:Find("RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function SkillSmallItemView:InitGenerate__11(Root, data)
--[[
	RedPoint/UINewRP
--]]
	local tmp = Root:Find("RedPoint/UINewRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPointNewItem = tmp
end

---@private
function SkillSmallItemView:InitGenerate__12(Root, data)
--[[
	NewRedPoint
--]]
	local tmp = Root:Find("NewRedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.newRedPoint = tmp
end

---@private
function SkillSmallItemView:InitGenerate__13(Root, data)
--[[
	EquipSign
--]]
	local tmp = Root:Find("EquipSign").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipSign = tmp
end

---@private
function SkillSmallItemView:InitGenerate__14(Root, data)
--[[
	ArtifactStatus
--]]
	local tmp = Root:Find("ArtifactStatus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStatus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SkillSmallItemView:InitGenerate__15(Root, data)
--[[
	ArtifactStatus/activated
--]]
	local tmp = Root:Find("ArtifactStatus/activated").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStatus.activated = tmp
end

---@private
function SkillSmallItemView:InitGenerate__16(Root, data)
--[[
	ArtifactStatus/icon
--]]
	local tmp = Root:Find("ArtifactStatus/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStatus.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function SkillSmallItemView:GenerateDestroy()
	if tolua.getpeer(self.artifactStatus.icon) ~= nil then
		tolua.setpeer(self.artifactStatus.icon, nil)
	end
	if tolua.getpeer(self.artifactStatus.activated) ~= nil then
		tolua.setpeer(self.artifactStatus.activated, nil)
	end
	if tolua.getpeer(self.selectSign) ~= nil then
		tolua.setpeer(self.selectSign, nil)
	end
	self.selectSign = nil
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
	if tolua.getpeer(self.lock) ~= nil then
		tolua.setpeer(self.lock, nil)
	end
	self.lock = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	if tolua.getpeer(self.redPointNewItem) ~= nil then
		tolua.setpeer(self.redPointNewItem, nil)
	end
	self.redPointNewItem = nil
	if tolua.getpeer(self.newRedPoint) ~= nil then
		tolua.setpeer(self.newRedPoint, nil)
	end
	self.newRedPoint = nil
	if tolua.getpeer(self.equipSign) ~= nil then
		tolua.setpeer(self.equipSign, nil)
	end
	self.equipSign = nil
	if tolua.getpeer(self.artifactStatus) ~= nil then
		tolua.setpeer(self.artifactStatus, nil)
	end
	self.artifactStatus = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SkillSmallItemView