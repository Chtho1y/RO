---@class DungeonItem__Generate_lockNode_lbl
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class DungeonItem__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class DungeonItem__Generate_gotoBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class DungeonItem__Generate_iconItem4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DungeonItem__Generate_iconItem3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DungeonItem__Generate_iconItem2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DungeonItem__Generate_iconItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DungeonItem__Generate_BoxOn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class DungeonItem__Generate_lockNode
---@field public gameObject UnityEngine.GameObject
---@field public lbl DungeonItem__Generate_lockNode_lbl

---@class DungeonItem__Generate_bannerImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DungeonItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private bannerImg DungeonItem__Generate_bannerImg
---@field private lockNode DungeonItem__Generate_lockNode
---@field private completedNode UnityEngine.GameObject
---@field private BoxOn DungeonItem__Generate_BoxOn
---@field private BoxOff UnityEngine.GameObject
---@field private challengeNode UnityEngine.GameObject
---@field private offNode UnityEngine.GameObject
---@field private onNode UnityEngine.GameObject
---@field private itemListNode UnityEngine.GameObject
---@field private iconItem1 DungeonItem__Generate_iconItem1
---@field private iconItem2 DungeonItem__Generate_iconItem2
---@field private iconItem3 DungeonItem__Generate_iconItem3
---@field private iconItem4 DungeonItem__Generate_iconItem4
---@field private gotoBtn DungeonItem__Generate_gotoBtn
---@field private btnSure DungeonItem__Generate_btnSure
---@field private redpoint UnityEngine.GameObject
local DungeonItemView = class("DungeonItemView")

function DungeonItemView:ctor()
end

---@private
function DungeonItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DungeonItemView:InitGenerate(Root, data)
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
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)


end

---@private
function DungeonItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DungeonItemView:InitGenerate__2(Root, data)
--[[
	Bg/Image
--]]
	local tmp = Root:Find("Bg/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bannerImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DungeonItemView:InitGenerate__3(Root, data)
--[[
	Status/Lock
--]]
	local tmp = Root:Find("Status/Lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockNode = tmp
end

---@private
function DungeonItemView:InitGenerate__4(Root, data)
--[[
	Status/Complete
--]]
	local tmp = Root:Find("Status/Complete").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.completedNode = tmp
end

---@private
function DungeonItemView:InitGenerate__5(Root, data)
--[[
	Status/Complete/BoxOn
--]]
	local tmp = Root:Find("Status/Complete/BoxOn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BoxOn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DungeonItemView:InitGenerate__6(Root, data)
--[[
	Status/Complete/BoxOff
--]]
	local tmp = Root:Find("Status/Complete/BoxOff").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BoxOff = tmp
end

---@private
function DungeonItemView:InitGenerate__7(Root, data)
--[[
	Status/InProgress
--]]
	local tmp = Root:Find("Status/InProgress").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.challengeNode = tmp
end

---@private
function DungeonItemView:InitGenerate__8(Root, data)
--[[
	Off
--]]
	local tmp = Root:Find("Off").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.offNode = tmp
end

---@private
function DungeonItemView:InitGenerate__9(Root, data)
--[[
	On
--]]
	local tmp = Root:Find("On").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.onNode = tmp
end

---@private
function DungeonItemView:InitGenerate__10(Root, data)
--[[
	On/ItemGroup
--]]
	local tmp = Root:Find("On/ItemGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemListNode = tmp
end

---@private
function DungeonItemView:InitGenerate__11(Root, data)
--[[
	On/ItemGroup/IconItem1
--]]
	local tmp = Root:Find("On/ItemGroup/IconItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function DungeonItemView:InitGenerate__12(Root, data)
--[[
	On/ItemGroup/IconItem2
--]]
	local tmp = Root:Find("On/ItemGroup/IconItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function DungeonItemView:InitGenerate__13(Root, data)
--[[
	On/ItemGroup/IconItem3
--]]
	local tmp = Root:Find("On/ItemGroup/IconItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem3.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function DungeonItemView:InitGenerate__14(Root, data)
--[[
	On/ItemGroup/IconItem4
--]]
	local tmp = Root:Find("On/ItemGroup/IconItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem4 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem4.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function DungeonItemView:InitGenerate__15(Root, data)
--[[
	On/BtnRight
--]]
	local tmp = Root:Find("On/BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gotoBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DungeonItemView:InitGenerate__16(Root, data)
--[[
	On/BtnRight/Content/Text
--]]
	local tmp = Root:Find("On/BtnRight/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function DungeonItemView:InitGenerate__17(Root, data)
--[[
	On/Text
--]]
	local tmp = Root:Find("On/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockNode.lbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function DungeonItemView:InitGenerate__18(Root, data)
--[[
	Redpoint
--]]
	local tmp = Root:Find("Redpoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redpoint = tmp
end

---@private
function DungeonItemView:GenerateDestroy()
	if tolua.getpeer(self.redpoint) ~= nil then
		tolua.setpeer(self.redpoint, nil)
	end
	if tolua.getpeer(self.lockNode.lbl) ~= nil then
		tolua.setpeer(self.lockNode.lbl, nil)
	end
	if tolua.getpeer(self.bannerImg) ~= nil then
		tolua.setpeer(self.bannerImg, nil)
	end
	if tolua.getpeer(self.lockNode) ~= nil then
		tolua.setpeer(self.lockNode, nil)
	end
	self.lockNode = nil
	if tolua.getpeer(self.completedNode) ~= nil then
		tolua.setpeer(self.completedNode, nil)
	end
	self.completedNode = nil
	if tolua.getpeer(self.BoxOn) ~= nil then
		tolua.setpeer(self.BoxOn, nil)
	end
	self.BoxOn = nil
	if tolua.getpeer(self.BoxOff) ~= nil then
		tolua.setpeer(self.BoxOff, nil)
	end
	self.BoxOff = nil
	if tolua.getpeer(self.challengeNode) ~= nil then
		tolua.setpeer(self.challengeNode, nil)
	end
	self.challengeNode = nil
	if tolua.getpeer(self.offNode) ~= nil then
		tolua.setpeer(self.offNode, nil)
	end
	self.offNode = nil
	if tolua.getpeer(self.onNode) ~= nil then
		tolua.setpeer(self.onNode, nil)
	end
	self.onNode = nil
	if tolua.getpeer(self.itemListNode) ~= nil then
		tolua.setpeer(self.itemListNode, nil)
	end
	self.itemListNode = nil
	if self.iconItem1.GenerateDestroy ~= nil then
		self.iconItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem1) ~= nil then
		tolua.setpeer(self.iconItem1, nil)
	end
	self.iconItem1 = nil
	if self.iconItem2.GenerateDestroy ~= nil then
		self.iconItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem2) ~= nil then
		tolua.setpeer(self.iconItem2, nil)
	end
	self.iconItem2 = nil
	if self.iconItem3.GenerateDestroy ~= nil then
		self.iconItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem3) ~= nil then
		tolua.setpeer(self.iconItem3, nil)
	end
	self.iconItem3 = nil
	if self.iconItem4.GenerateDestroy ~= nil then
		self.iconItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem4) ~= nil then
		tolua.setpeer(self.iconItem4, nil)
	end
	self.iconItem4 = nil
	if tolua.getpeer(self.gotoBtn) ~= nil then
		tolua.setpeer(self.gotoBtn, nil)
	end
	self.gotoBtn = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DungeonItemView