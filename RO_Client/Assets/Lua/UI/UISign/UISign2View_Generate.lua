---@class UISign2__Generate_rawImage
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage

---@class UISign2__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISign2__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UISign2__Generate_alpha
---@field private rawImage UISign2__Generate_rawImage
local UISign2View = class("UISign2View", require("UIViewBase"))

function UISign2View:ctor()
end

---@private
function UISign2View:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISign2View:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function UISign2View:InitGenerate__1(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISign2View:InitGenerate__2(Root, data)
--[[
	model/RawImage
--]]
	local tmp = Root:Find("model/RawImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rawImage = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function UISign2View:GenerateDestroy()
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.rawImage) ~= nil then
		tolua.setpeer(self.rawImage, nil)
	end
	self.rawImage = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISign2View