---@class SignRewardItem__Generate_dayTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SignRewardItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class SignRewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private image UnityEngine.UI.Image
---@field private iconItem SignRewardItem__Generate_iconItem
---@field private dayTxt SignRewardItem__Generate_dayTxt
---@field private uIRedPointRP UnityEngine.GameObject
---@field private gotRewardNode UnityEngine.GameObject
local SignRewardItemView = class("SignRewardItemView")

function SignRewardItemView:ctor()
end

---@private
function SignRewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SignRewardItemView:InitGenerate(Root, data)
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
function SignRewardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.image = Root:GetComponent(Enum.TypeInfo.Image)
end

---@private
function SignRewardItemView:InitGenerate__2(Root, data)
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
function SignRewardItemView:InitGenerate__3(Root, data)
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
function SignRewardItemView:InitGenerate__4(Root, data)
--[[
	UIRedPointRP
--]]
	local tmp = Root:Find("UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIRedPointRP = tmp
end

---@private
function SignRewardItemView:InitGenerate__5(Root, data)
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
function SignRewardItemView:GenerateDestroy()
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
	if tolua.getpeer(self.uIRedPointRP) ~= nil then
		tolua.setpeer(self.uIRedPointRP, nil)
	end
	self.uIRedPointRP = nil
	if tolua.getpeer(self.gotRewardNode) ~= nil then
		tolua.setpeer(self.gotRewardNode, nil)
	end
	self.gotRewardNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SignRewardItemView