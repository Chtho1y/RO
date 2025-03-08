---@class RewardItem__Generate_dayTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RewardItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private image UnityEngine.UI.Image
---@field private iconItem RewardItem__Generate_iconItem
---@field private dayTxt RewardItem__Generate_dayTxt
---@field private shad UnityEngine.GameObject
---@field private gotRewardNode UnityEngine.GameObject
---@field private missNode UnityEngine.GameObject
---@field private MakeUpNode UnityEngine.GameObject
local RewardItemView = class("RewardItemView")

function RewardItemView:ctor()
end

---@private
function RewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RewardItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)


end

---@private
function RewardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.image = Root:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RewardItemView:InitGenerate__2(Root, data)
--[[
	IconItem
--]]
	local tmp = Root:Find("IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RewardItemView:InitGenerate__3(Root, data)
--[[
	DayNO
--]]
	local tmp = Root:Find("DayNO").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dayTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RewardItemView:InitGenerate__4(Root, data)
--[[
	shad
--]]
	local tmp = Root:Find("shad").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shad = tmp
end

---@private
function RewardItemView:InitGenerate__5(Root, data)
--[[
	GotRewardNode
--]]
	local tmp = Root:Find("GotRewardNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gotRewardNode = tmp
end

---@private
function RewardItemView:InitGenerate__6(Root, data)
--[[
	MissNode
--]]
	local tmp = Root:Find("MissNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.missNode = tmp
end

---@private
function RewardItemView:InitGenerate__7(Root, data)
--[[
	MakeUpNode
--]]
	local tmp = Root:Find("MakeUpNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.MakeUpNode = tmp
end

---@private
function RewardItemView:GenerateDestroy()
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.dayTxt) ~= nil then
		tolua.setpeer(self.dayTxt, nil)
	end
	self.dayTxt = nil
	if tolua.getpeer(self.shad) ~= nil then
		tolua.setpeer(self.shad, nil)
	end
	self.shad = nil
	if tolua.getpeer(self.gotRewardNode) ~= nil then
		tolua.setpeer(self.gotRewardNode, nil)
	end
	self.gotRewardNode = nil
	if tolua.getpeer(self.missNode) ~= nil then
		tolua.setpeer(self.missNode, nil)
	end
	self.missNode = nil
	if tolua.getpeer(self.MakeUpNode) ~= nil then
		tolua.setpeer(self.MakeUpNode, nil)
	end
	self.MakeUpNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RewardItemView