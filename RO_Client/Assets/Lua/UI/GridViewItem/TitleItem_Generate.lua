---@class TitleItem__Generate_img
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class TitleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private img TitleItem__Generate_img
local TitleItemView = class("TitleItemView")

function TitleItemView:ctor()
end

---@private
function TitleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TitleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function TitleItemView:InitGenerate__1(Root, data)
--[[
	Img
--]]
	local tmp = Root:Find("Img").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.img = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TitleItemView:GenerateDestroy()
	if tolua.getpeer(self.img) ~= nil then
		tolua.setpeer(self.img, nil)
	end
	self.img = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TitleItemView