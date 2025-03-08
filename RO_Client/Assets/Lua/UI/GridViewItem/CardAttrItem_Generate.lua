---@class CardAttrItem__Generate_numBless
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardAttrItem__Generate_numberText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardAttrItem__Generate_nameText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class CardAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private nameText CardAttrItem__Generate_nameText
---@field private numberText CardAttrItem__Generate_numberText
---@field private blessLv UnityEngine.GameObject
---@field private numBless CardAttrItem__Generate_numBless
local CardAttrItemView = class("CardAttrItemView")

function CardAttrItemView:ctor()
end

---@private
function CardAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardAttrItemView:InitGenerate(Root, data)
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
function CardAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardAttrItemView:InitGenerate__2(Root, data)
--[[
	NameText
--]]
	local tmp = Root:Find("NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardAttrItemView:InitGenerate__3(Root, data)
--[[
	NumberText
--]]
	local tmp = Root:Find("NumberText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardAttrItemView:InitGenerate__4(Root, data)
--[[
	BlessLv
--]]
	local tmp = Root:Find("BlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.blessLv = tmp
	self.blessLv:SetActive(false)
end

---@private
function CardAttrItemView:InitGenerate__5(Root, data)
--[[
	BlessLv/NumBless
--]]
	local tmp = Root:Find("BlessLv/NumBless").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numBless = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.nameText) ~= nil then
		tolua.setpeer(self.nameText, nil)
	end
	self.nameText = nil
	if tolua.getpeer(self.numberText) ~= nil then
		tolua.setpeer(self.numberText, nil)
	end
	self.numberText = nil
	if tolua.getpeer(self.blessLv) ~= nil then
		tolua.setpeer(self.blessLv, nil)
	end
	self.blessLv = nil
	if tolua.getpeer(self.numBless) ~= nil then
		tolua.setpeer(self.numBless, nil)
	end
	self.numBless = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardAttrItemView