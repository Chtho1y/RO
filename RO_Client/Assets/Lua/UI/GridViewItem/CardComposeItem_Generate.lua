---@class CardComposeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private animator UnityEngine.Animator
---@field private cardIconBigItem UnityEngine.GameObject
local CardComposeItemView = class("CardComposeItemView")

function CardComposeItemView:ctor()
end

---@private
function CardComposeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardComposeItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function CardComposeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.animator = Root:GetComponent(Enum.TypeInfo.Animator)
	self.animator.logWarnings = false
end

---@private
function CardComposeItemView:InitGenerate__2(Root, data)
--[[
	CardIconBigItem
--]]
	local tmp = Root:Find("CardIconBigItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIconBigItem = CommonUtil.BindGridViewItem2LuaStatic("CardIconBigItem", tmp)
	self.cardIconBigItem.prefabName = "CardIconBigItem"
end

---@private
function CardComposeItemView:GenerateDestroy()
	if self.cardIconBigItem.GenerateDestroy ~= nil then
		self.cardIconBigItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardIconBigItem) ~= nil then
		tolua.setpeer(self.cardIconBigItem, nil)
	end
	self.cardIconBigItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardComposeItemView