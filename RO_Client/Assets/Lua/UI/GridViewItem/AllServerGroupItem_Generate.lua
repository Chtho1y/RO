---@class AllServerGroupItem__Generate_serverGroupName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class AllServerGroupItem__Generate_bGColor
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class AllServerGroupItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private bGColor AllServerGroupItem__Generate_bGColor
---@field private allChosenTagImage UnityEngine.GameObject
---@field private line UnityEngine.GameObject
---@field private serverGroupName AllServerGroupItem__Generate_serverGroupName
local AllServerGroupItemView = class("AllServerGroupItemView")

function AllServerGroupItemView:ctor()
end

---@private
function AllServerGroupItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function AllServerGroupItemView:InitGenerate(Root, data)
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
function AllServerGroupItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function AllServerGroupItemView:InitGenerate__2(Root, data)
--[[
	BGColor
--]]
	local tmp = Root:Find("BGColor").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGColor = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function AllServerGroupItemView:InitGenerate__3(Root, data)
--[[
	AllChosenTagImage
--]]
	local tmp = Root:Find("AllChosenTagImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allChosenTagImage = tmp
end

---@private
function AllServerGroupItemView:InitGenerate__4(Root, data)
--[[
	AllChosenTagImage/Line
--]]
	local tmp = Root:Find("AllChosenTagImage/Line").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line = tmp
end

---@private
function AllServerGroupItemView:InitGenerate__5(Root, data)
--[[
	ServerGroupName
--]]
	local tmp = Root:Find("ServerGroupName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverGroupName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function AllServerGroupItemView:GenerateDestroy()
	if tolua.getpeer(self.bGColor) ~= nil then
		tolua.setpeer(self.bGColor, nil)
	end
	self.bGColor = nil
	if tolua.getpeer(self.allChosenTagImage) ~= nil then
		tolua.setpeer(self.allChosenTagImage, nil)
	end
	self.allChosenTagImage = nil
	if tolua.getpeer(self.line) ~= nil then
		tolua.setpeer(self.line, nil)
	end
	self.line = nil
	if tolua.getpeer(self.serverGroupName) ~= nil then
		tolua.setpeer(self.serverGroupName, nil)
	end
	self.serverGroupName = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return AllServerGroupItemView