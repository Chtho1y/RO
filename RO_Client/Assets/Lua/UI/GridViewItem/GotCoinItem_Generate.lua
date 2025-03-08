---@class GotCoinItem__Generate_jobParCtr
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class GotCoinItem__Generate_baseParCtr
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class GotCoinItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GotCoinItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private icon GotCoinItem__Generate_icon
---@field private baseParCtr GotCoinItem__Generate_baseParCtr
---@field private jobParCtr GotCoinItem__Generate_jobParCtr
---@field private basePar UnityEngine.GameObject
---@field private jobPar UnityEngine.GameObject
local GotCoinItemView = class("GotCoinItemView")

function GotCoinItemView:ctor()
end

---@private
function GotCoinItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GotCoinItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function GotCoinItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function GotCoinItemView:InitGenerate__2(Root, data)
--[[
	icon
--]]
	local tmp = Root:Find("icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GotCoinItemView:InitGenerate__3(Root, data)
--[[
	baseParCtr
--]]
	local tmp = Root:Find("baseParCtr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseParCtr = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function GotCoinItemView:InitGenerate__4(Root, data)
--[[
	jobParCtr
--]]
	local tmp = Root:Find("jobParCtr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobParCtr = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function GotCoinItemView:InitGenerate__5(Root, data)
--[[
	FX_UI_Baseexp
--]]
	local tmp = Root:Find("FX_UI_Baseexp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.basePar = tmp
end

---@private
function GotCoinItemView:InitGenerate__6(Root, data)
--[[
	FX_UI_Jobexp
--]]
	local tmp = Root:Find("FX_UI_Jobexp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobPar = tmp
end

---@private
function GotCoinItemView:GenerateDestroy()
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.baseParCtr) ~= nil then
		tolua.setpeer(self.baseParCtr, nil)
	end
	self.baseParCtr = nil
	if tolua.getpeer(self.jobParCtr) ~= nil then
		tolua.setpeer(self.jobParCtr, nil)
	end
	self.jobParCtr = nil
	if tolua.getpeer(self.basePar) ~= nil then
		tolua.setpeer(self.basePar, nil)
	end
	self.basePar = nil
	if tolua.getpeer(self.jobPar) ~= nil then
		tolua.setpeer(self.jobPar, nil)
	end
	self.jobPar = nil
	self.inited = false
end
return GotCoinItemView