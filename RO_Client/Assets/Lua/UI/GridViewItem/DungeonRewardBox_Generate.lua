---@class DungeonRewardBox__Generate_levelNum
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class DungeonRewardBox__Generate_openNode
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DungeonRewardBox__Generate_closeNode
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DungeonRewardBox__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private activeNode UnityEngine.GameObject
---@field private closeNode DungeonRewardBox__Generate_closeNode
---@field private openNode DungeonRewardBox__Generate_openNode
---@field private levelNum DungeonRewardBox__Generate_levelNum
---@field private currentNode UnityEngine.GameObject
local DungeonRewardBoxView = class("DungeonRewardBoxView")

function DungeonRewardBoxView:ctor()
end

---@private
function DungeonRewardBoxView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DungeonRewardBoxView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function DungeonRewardBoxView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DungeonRewardBoxView:InitGenerate__2(Root, data)
--[[
	Active
--]]
	local tmp = Root:Find("Active").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activeNode = tmp
end

---@private
function DungeonRewardBoxView:InitGenerate__3(Root, data)
--[[
	Close
--]]
	local tmp = Root:Find("Close").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeNode = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DungeonRewardBoxView:InitGenerate__4(Root, data)
--[[
	Open
--]]
	local tmp = Root:Find("Open").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.openNode = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DungeonRewardBoxView:InitGenerate__5(Root, data)
--[[
	Text (TMP)
--]]
	local tmp = Root:Find("Text (TMP)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function DungeonRewardBoxView:InitGenerate__6(Root, data)
--[[
	Current
--]]
	local tmp = Root:Find("Current").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentNode = tmp
end

---@private
function DungeonRewardBoxView:GenerateDestroy()
	if tolua.getpeer(self.currentNode) ~= nil then
		tolua.setpeer(self.currentNode, nil)
	end
	if tolua.getpeer(self.levelNum) ~= nil then
		tolua.setpeer(self.levelNum, nil)
	end
	if tolua.getpeer(self.activeNode) ~= nil then
		tolua.setpeer(self.activeNode, nil)
	end
	self.activeNode = nil
	if tolua.getpeer(self.closeNode) ~= nil then
		tolua.setpeer(self.closeNode, nil)
	end
	self.closeNode = nil
	if tolua.getpeer(self.openNode) ~= nil then
		tolua.setpeer(self.openNode, nil)
	end
	self.openNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DungeonRewardBoxView