---@class BigMapGridItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BigMapGridItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private nameTxt BigMapGridItem__Generate_nameTxt
---@field private maskIcon UnityEngine.GameObject
---@field private activedIcon UnityEngine.GameObject
local BigMapGridItemView = class("BigMapGridItemView")

function BigMapGridItemView:ctor()
end

---@private
function BigMapGridItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BigMapGridItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function BigMapGridItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function BigMapGridItemView:InitGenerate__2(Root, data)
--[[
	NameTxt
--]]
	local tmp = Root:Find("NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BigMapGridItemView:InitGenerate__3(Root, data)
--[[
	MaskIcon
--]]
	local tmp = Root:Find("MaskIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.maskIcon = tmp
end

---@private
function BigMapGridItemView:InitGenerate__4(Root, data)
--[[
	ActivedIcon
--]]
	local tmp = Root:Find("ActivedIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activedIcon = tmp
end

---@private
function BigMapGridItemView:GenerateDestroy()
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.maskIcon) ~= nil then
		tolua.setpeer(self.maskIcon, nil)
	end
	self.maskIcon = nil
	if tolua.getpeer(self.activedIcon) ~= nil then
		tolua.setpeer(self.activedIcon, nil)
	end
	self.activedIcon = nil
	self.inited = false
end
return BigMapGridItemView