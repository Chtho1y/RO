---@class RefinePercentItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RefinePercentItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text RefinePercentItem__Generate_text
local RefinePercentItemView = class("RefinePercentItemView")

function RefinePercentItemView:ctor()
end

---@private
function RefinePercentItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RefinePercentItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function RefinePercentItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RefinePercentItemView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RefinePercentItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.inited = false
end
return RefinePercentItemView