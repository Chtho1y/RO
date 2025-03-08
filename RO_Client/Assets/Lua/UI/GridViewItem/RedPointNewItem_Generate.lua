---@class RedPointNewItem__Generate_new
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointNewItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private new RedPointNewItem__Generate_new
local RedPointNewItemView = class("RedPointNewItemView")

function RedPointNewItemView:ctor()
end

---@private
function RedPointNewItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RedPointNewItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function RedPointNewItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RedPointNewItemView:InitGenerate__2(Root, data)
--[[
	RedPoint/New
--]]
	local tmp = Root:Find("RedPoint/New").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.new = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointNewItemView:GenerateDestroy()
	if tolua.getpeer(self.new) ~= nil then
		tolua.setpeer(self.new, nil)
	end
	self.new = nil
	self.inited = false
end
return RedPointNewItemView