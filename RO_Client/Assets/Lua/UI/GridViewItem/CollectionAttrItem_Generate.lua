---@class CollectionAttrItem__Generate_numberText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CollectionAttrItem__Generate_nameText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CollectionAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private nameText CollectionAttrItem__Generate_nameText
---@field private numberText CollectionAttrItem__Generate_numberText
local CollectionAttrItemView = class("CollectionAttrItemView")

function CollectionAttrItemView:ctor()
end

---@private
function CollectionAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CollectionAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function CollectionAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CollectionAttrItemView:InitGenerate__2(Root, data)
--[[
	NameText
--]]
	local tmp = Root:Find("NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CollectionAttrItemView:InitGenerate__3(Root, data)
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
function CollectionAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.nameText) ~= nil then
		tolua.setpeer(self.nameText, nil)
	end
	self.nameText = nil
	if tolua.getpeer(self.numberText) ~= nil then
		tolua.setpeer(self.numberText, nil)
	end
	self.numberText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CollectionAttrItemView