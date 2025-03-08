---@class InfoDscItem__Generate_textDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class InfoDscItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class InfoDscItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class InfoDscItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private textName InfoDscItem__Generate_textName
---@field private icon InfoDscItem__Generate_icon
---@field private textDsc InfoDscItem__Generate_textDsc
local InfoDscItemView = class("InfoDscItemView")

function InfoDscItemView:ctor()
end

---@private
function InfoDscItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function InfoDscItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function InfoDscItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function InfoDscItemView:InitGenerate__2(Root, data)
--[[
	Layout/NameBg/TextName
--]]
	local tmp = Root:Find("Layout/NameBg/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function InfoDscItemView:InitGenerate__3(Root, data)
--[[
	Layout/Content/Icon
--]]
	local tmp = Root:Find("Layout/Content/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function InfoDscItemView:InitGenerate__4(Root, data)
--[[
	Layout/Content/TextDsc
--]]
	local tmp = Root:Find("Layout/Content/TextDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function InfoDscItemView:GenerateDestroy()
	if tolua.getpeer(self.textDsc) ~= nil then
		tolua.setpeer(self.textDsc, nil)
	end
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return InfoDscItemView