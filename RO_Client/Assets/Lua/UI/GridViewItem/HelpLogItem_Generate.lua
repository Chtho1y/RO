---@class HelpLogItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class HelpLogItem__Generate_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HelpLogItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HelpLogItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private playerName HelpLogItem__Generate_playerName
---@field private timeTxt HelpLogItem__Generate_timeTxt
---@field private headItem HelpLogItem__Generate_headItem
local HelpLogItemView = class("HelpLogItemView")

function HelpLogItemView:ctor()
end

---@private
function HelpLogItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HelpLogItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function HelpLogItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function HelpLogItemView:InitGenerate__2(Root, data)
--[[
	Title/Name
--]]
	local tmp = Root:Find("Title/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HelpLogItemView:InitGenerate__3(Root, data)
--[[
	TimeStamp/Time
--]]
	local tmp = Root:Find("TimeStamp/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HelpLogItemView:InitGenerate__4(Root, data)
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
function HelpLogItemView:GenerateDestroy()
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	if tolua.getpeer(self.timeTxt) ~= nil then
		tolua.setpeer(self.timeTxt, nil)
	end
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HelpLogItemView