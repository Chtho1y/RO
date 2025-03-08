---@class UIRefineExtraPop__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRefineExtraPop__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UIRefineExtraPop__Generate_alpha
---@field private box UnityEngine.GameObject
local UIRefineExtraPopView = class("UIRefineExtraPopView", require("UIViewBase"))

function UIRefineExtraPopView:ctor()
end

---@private
function UIRefineExtraPopView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRefineExtraPopView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function UIRefineExtraPopView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIRefineExtraPopView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRefineExtraPopView:InitGenerate__3(Root, data)
--[[
	Window/Box
--]]
	local tmp = Root:Find("Window/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp
end

---@private
function UIRefineExtraPopView:GenerateDestroy()
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.box) ~= nil then
		tolua.setpeer(self.box, nil)
	end
	self.box = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRefineExtraPopView