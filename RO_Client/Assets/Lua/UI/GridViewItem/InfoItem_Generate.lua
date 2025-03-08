---@class InfoItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class InfoItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text InfoItem__Generate_text
local InfoItemView = class("InfoItemView")

function InfoItemView:ctor()
end

---@private
function InfoItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function InfoItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function InfoItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function InfoItemView:InitGenerate__2(Root, data)
--[[
	BG/Text
--]]
	local tmp = Root:Find("BG/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function InfoItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return InfoItemView