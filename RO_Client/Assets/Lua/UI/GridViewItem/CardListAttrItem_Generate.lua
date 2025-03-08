---@class CardListAttrItem__Generate_numBless
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardListAttrItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardListAttrItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardListAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private name CardListAttrItem__Generate_name
---@field private number CardListAttrItem__Generate_number
---@field private blessLv UnityEngine.GameObject
---@field private numBless CardListAttrItem__Generate_numBless
local CardListAttrItemView = class("CardListAttrItemView")

function CardListAttrItemView:ctor()
end

---@private
function CardListAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardListAttrItemView:InitGenerate(Root, data)
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
function CardListAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardListAttrItemView:InitGenerate__2(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardListAttrItemView:InitGenerate__3(Root, data)
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
function CardListAttrItemView:InitGenerate__4(Root, data)
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
function CardListAttrItemView:InitGenerate__5(Root, data)
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
function CardListAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
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
return CardListAttrItemView