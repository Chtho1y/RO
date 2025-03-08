---@class TowerHeadInfoItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TowerHeadInfoItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TowerHeadInfoItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private headItem TowerHeadInfoItem__Generate_headItem
---@field private playerName TowerHeadInfoItem__Generate_playerName
---@field private guildNode UnityEngine.GameObject
---@field private friendNode UnityEngine.GameObject
local TowerHeadInfoItemView = class("TowerHeadInfoItemView")

function TowerHeadInfoItemView:ctor()
end

---@private
function TowerHeadInfoItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TowerHeadInfoItemView:InitGenerate(Root, data)
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
function TowerHeadInfoItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function TowerHeadInfoItemView:InitGenerate__2(Root, data)
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
function TowerHeadInfoItemView:InitGenerate__3(Root, data)
--[[
	NamePlayer
--]]
	local tmp = Root:Find("NamePlayer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TowerHeadInfoItemView:InitGenerate__4(Root, data)
--[[
	LabelGuild
--]]
	local tmp = Root:Find("LabelGuild").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildNode = tmp
end

---@private
function TowerHeadInfoItemView:InitGenerate__5(Root, data)
--[[
	LabelFriend
--]]
	local tmp = Root:Find("LabelFriend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.friendNode = tmp
end

---@private
function TowerHeadInfoItemView:GenerateDestroy()
	if tolua.getpeer(self.friendNode) ~= nil then
		tolua.setpeer(self.friendNode, nil)
	end
	if tolua.getpeer(self.guildNode) ~= nil then
		tolua.setpeer(self.guildNode, nil)
	end
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TowerHeadInfoItemView