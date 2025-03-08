---@class FansItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FansItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text FansItem__Generate_text
local FansItemView = class("FansItemView")

function FansItemView:ctor()
end

---@private
function FansItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FansItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function FansItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FansItemView:InitGenerate__2(Root, data)
--[[
	text
--]]
	local tmp = Root:Find("text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FansItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return FansItemView