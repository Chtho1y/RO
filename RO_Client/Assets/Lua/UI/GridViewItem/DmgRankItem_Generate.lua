---@class DmgRankItem__Generate_medalIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public switchSprite SwitchSprite

---@class DmgRankItem__Generate_rank
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class DmgRankItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DmgRankItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DmgRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class DmgRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private headItem DmgRankItem__Generate_headItem
---@field private name DmgRankItem__Generate_name
---@field private number DmgRankItem__Generate_number
---@field private rank DmgRankItem__Generate_rank
---@field private medalIcon DmgRankItem__Generate_medalIcon
local DmgRankItemView = class("DmgRankItemView")

function DmgRankItemView:ctor()
end

---@private
function DmgRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DmgRankItemView:InitGenerate(Root, data)
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
function DmgRankItemView:InitGenerate__1(Root, data)
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
function DmgRankItemView:InitGenerate__2(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DmgRankItemView:InitGenerate__3(Root, data)
--[[
	Number
--]]
	local tmp = Root:Find("Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DmgRankItemView:InitGenerate__4(Root, data)
--[[
	Rank
--]]
	local tmp = Root:Find("Rank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function DmgRankItemView:InitGenerate__5(Root, data)
--[[
	MedalIcon
--]]
	local tmp = Root:Find("MedalIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.medalIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.switchSprite = tmp:GetComponent(Enum.TypeInfo.SwitchSprite)
end

---@private
function DmgRankItemView:GenerateDestroy()
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.rank) ~= nil then
		tolua.setpeer(self.rank, nil)
	end
	self.rank = nil
	if tolua.getpeer(self.medalIcon) ~= nil then
		tolua.setpeer(self.medalIcon, nil)
	end
	self.medalIcon = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DmgRankItemView