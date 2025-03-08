---@class BigMapBgGridItem__Generate_image
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class BigMapBgGridItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private image BigMapBgGridItem__Generate_image
local BigMapBgGridItemView = class("BigMapBgGridItemView")

function BigMapBgGridItemView:ctor()
end

---@private
function BigMapBgGridItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BigMapBgGridItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function BigMapBgGridItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function BigMapBgGridItemView:InitGenerate__2(Root, data)
--[[
	Image
--]]
	local tmp = Root:Find("Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BigMapBgGridItemView:GenerateDestroy()
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	self.inited = false
end
return BigMapBgGridItemView