---@class UIVoyageReforming__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageReforming__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private animator UnityEngine.Animator
---@field private AnyBtn UIVoyageReforming__Generate_AnyBtn
---@field private fail UnityEngine.GameObject
---@field private success UnityEngine.GameObject
local UIVoyageReformingView = class("UIVoyageReformingView", require("UIViewBase"))

function UIVoyageReformingView:ctor()
end

---@private
function UIVoyageReformingView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVoyageReformingView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function UIVoyageReformingView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.animator = Root:GetComponent(Enum.TypeInfo.Animator)
	self.animator.logWarnings = false
end

---@private
function UIVoyageReformingView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageReformingView:InitGenerate__3(Root, data)
--[[
	Result/Fail
--]]
	local tmp = Root:Find("Result/Fail").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fail = tmp
end

---@private
function UIVoyageReformingView:InitGenerate__4(Root, data)
--[[
	Result/Success
--]]
	local tmp = Root:Find("Result/Success").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.success = tmp
end

---@private
function UIVoyageReformingView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.fail) ~= nil then
		tolua.setpeer(self.fail, nil)
	end
	self.fail = nil
	if tolua.getpeer(self.success) ~= nil then
		tolua.setpeer(self.success, nil)
	end
	self.success = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVoyageReformingView