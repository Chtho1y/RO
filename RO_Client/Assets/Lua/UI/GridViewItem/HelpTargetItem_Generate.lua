---@class HelpTargetItem__Generate_statusLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HelpTargetItem__Generate_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HelpTargetItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HelpTargetItem__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class HelpTargetItem__Generate_helpBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class HelpTargetItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class HelpTargetItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private headItem HelpTargetItem__Generate_headItem
---@field private helpBtn HelpTargetItem__Generate_helpBtn
---@field private btnSure HelpTargetItem__Generate_btnSure
---@field private playerName HelpTargetItem__Generate_playerName
---@field private fightPower HelpTargetItem__Generate_fightPower
---@field private statusLbl HelpTargetItem__Generate_statusLbl
local HelpTargetItemView = class("HelpTargetItemView")

function HelpTargetItemView:ctor()
end

---@private
function HelpTargetItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HelpTargetItemView:InitGenerate(Root, data)
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


end

---@private
function HelpTargetItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function HelpTargetItemView:InitGenerate__2(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function HelpTargetItemView:InitGenerate__3(Root, data)
--[[
	BtnHelp
--]]
	local tmp = Root:Find("BtnHelp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.helpBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HelpTargetItemView:InitGenerate__4(Root, data)
--[[
	BtnHelp/Content/Text
--]]
	local tmp = Root:Find("BtnHelp/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function HelpTargetItemView:InitGenerate__5(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HelpTargetItemView:InitGenerate__6(Root, data)
--[[
	Power/Text
--]]
	local tmp = Root:Find("Power/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HelpTargetItemView:InitGenerate__7(Root, data)
--[[
	Status/Status
--]]
	local tmp = Root:Find("Status/Status").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HelpTargetItemView:GenerateDestroy()
	if tolua.getpeer(self.statusLbl) ~= nil then
		tolua.setpeer(self.statusLbl, nil)
	end
	if tolua.getpeer(self.fightPower) ~= nil then
		tolua.setpeer(self.fightPower, nil)
	end
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	if tolua.getpeer(self.helpBtn) ~= nil then
		tolua.setpeer(self.helpBtn, nil)
	end
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HelpTargetItemView