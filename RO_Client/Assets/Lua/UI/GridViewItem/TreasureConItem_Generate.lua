---@class TreasureConItem__Generate_background
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class TreasureConItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private toggle UnityEngine.UI.Toggle
---@field private background TreasureConItem__Generate_background
local TreasureConItemView = class("TreasureConItemView")

function TreasureConItemView:ctor()
end

---@private
function TreasureConItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TreasureConItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function TreasureConItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.toggle = Root:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function TreasureConItemView:InitGenerate__2(Root, data)
--[[
	Background
--]]
	local tmp = Root:Find("Background").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.background = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function TreasureConItemView:GenerateDestroy()
	if tolua.getpeer(self.background) ~= nil then
		tolua.setpeer(self.background, nil)
	end
	self.background = nil
	self.inited = false
end
return TreasureConItemView