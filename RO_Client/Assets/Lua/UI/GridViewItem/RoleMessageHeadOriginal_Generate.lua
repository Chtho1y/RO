---@class RoleMessageHeadOriginal__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RoleMessageHeadOriginal__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private headItem RoleMessageHeadOriginal__Generate_headItem
---@field private checkMark UnityEngine.GameObject
---@field private leaderTag UnityEngine.GameObject
---@field private battleTag UnityEngine.GameObject
local RoleMessageHeadOriginalView = class("RoleMessageHeadOriginalView")

function RoleMessageHeadOriginalView:ctor()
end

---@private
function RoleMessageHeadOriginalView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RoleMessageHeadOriginalView:InitGenerate(Root, data)
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
function RoleMessageHeadOriginalView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RoleMessageHeadOriginalView:InitGenerate__2(Root, data)
--[[
	HeadItemParent/HeadItem
--]]
	local tmp = Root:Find("HeadItemParent/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RoleMessageHeadOriginalView:InitGenerate__3(Root, data)
--[[
	HeadItemParent/CheckMark
--]]
	local tmp = Root:Find("HeadItemParent/CheckMark").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.checkMark = tmp
end

---@private
function RoleMessageHeadOriginalView:InitGenerate__4(Root, data)
--[[
	HeadItemParent/LeaderTag
--]]
	local tmp = Root:Find("HeadItemParent/LeaderTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leaderTag = tmp
end

---@private
function RoleMessageHeadOriginalView:InitGenerate__5(Root, data)
--[[
	HeadItemParent/BattleTag
--]]
	local tmp = Root:Find("HeadItemParent/BattleTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleTag = tmp
end

---@private
function RoleMessageHeadOriginalView:GenerateDestroy()
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.checkMark) ~= nil then
		tolua.setpeer(self.checkMark, nil)
	end
	self.checkMark = nil
	if tolua.getpeer(self.leaderTag) ~= nil then
		tolua.setpeer(self.leaderTag, nil)
	end
	self.leaderTag = nil
	if tolua.getpeer(self.battleTag) ~= nil then
		tolua.setpeer(self.battleTag, nil)
	end
	self.battleTag = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RoleMessageHeadOriginalView