---@class AttrItem__Generate_numberText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class AttrItem__Generate_nameText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class AttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private nameText AttrItem__Generate_nameText
---@field private numberText AttrItem__Generate_numberText
local AttrItemView = class("AttrItemView")

function AttrItemView:ctor()
end

---@private
function AttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function AttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function AttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function AttrItemView:InitGenerate__2(Root, data)
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
function AttrItemView:InitGenerate__3(Root, data)
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
function AttrItemView:GenerateDestroy()
	if tolua.getpeer(self.nameText) ~= nil then
		tolua.setpeer(self.nameText, nil)
	end
	self.nameText = nil
	if tolua.getpeer(self.numberText) ~= nil then
		tolua.setpeer(self.numberText, nil)
	end
	self.numberText = nil
	self.inited = false
end
return AttrItemView