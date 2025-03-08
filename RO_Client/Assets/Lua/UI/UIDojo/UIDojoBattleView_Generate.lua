---@class UIDojoBattle__Generate_rageBoxGo_bg
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIDojoBattle__Generate_rageBoxGo
---@field public gameObject UnityEngine.GameObject
---@field public bg UIDojoBattle__Generate_rageBoxGo_bg

---@class UIDojoBattle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rageBoxGo UIDojoBattle__Generate_rageBoxGo
local UIDojoBattleView = class("UIDojoBattleView", require("UIViewBase"))

function UIDojoBattleView:ctor()
end

---@private
function UIDojoBattleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoBattleView:InitGenerate(Root, data)
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
function UIDojoBattleView:InitGenerate__1(Root, data)
--[[
	RagePvp
--]]
	local tmp = Root:Find("RagePvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rageBoxGo = tmp
end

---@private
function UIDojoBattleView:InitGenerate__2(Root, data)
--[[
	RagePvp/Bg
--]]
	local tmp = Root:Find("RagePvp/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rageBoxGo.bg = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIDojoBattleView:GenerateDestroy()
	if tolua.getpeer(self.rageBoxGo.bg) ~= nil then
		tolua.setpeer(self.rageBoxGo.bg, nil)
	end
	if tolua.getpeer(self.rageBoxGo) ~= nil then
		tolua.setpeer(self.rageBoxGo, nil)
	end
	self.rageBoxGo = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoBattleView