---@class CardBlessAttrItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardBlessAttrItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardBlessAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text CardBlessAttrItem__Generate_text
---@field private number CardBlessAttrItem__Generate_number
local CardBlessAttrItemView = class("CardBlessAttrItemView")

function CardBlessAttrItemView:ctor()
end

---@private
function CardBlessAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardBlessAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function CardBlessAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardBlessAttrItemView:InitGenerate__2(Root, data)
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
function CardBlessAttrItemView:InitGenerate__3(Root, data)
--[[
	Number
--]]
	local tmp = Root:Find("Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardBlessAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardBlessAttrItemView