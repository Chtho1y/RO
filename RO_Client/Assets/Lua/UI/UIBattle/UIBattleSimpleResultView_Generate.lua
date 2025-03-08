---@class UIBattleSimpleResult__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleSimpleResult__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIBattleSimpleResult__Generate_AnyBtn
---@field private battleLose UnityEngine.GameObject
---@field private battleWin UnityEngine.GameObject
local UIBattleSimpleResultView = class("UIBattleSimpleResultView", require("UIViewBase"))

function UIBattleSimpleResultView:ctor()
end

---@private
function UIBattleSimpleResultView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleSimpleResultView:InitGenerate(Root, data)
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
function UIBattleSimpleResultView:InitGenerate__1(Root, data)
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
function UIBattleSimpleResultView:InitGenerate__2(Root, data)
--[[
	BG/BattleLose
--]]
	local tmp = Root:Find("BG/BattleLose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleLose = tmp
end

---@private
function UIBattleSimpleResultView:InitGenerate__3(Root, data)
--[[
	BG/BattleWin
--]]
	local tmp = Root:Find("BG/BattleWin").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleWin = tmp
end

---@private
function UIBattleSimpleResultView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.battleLose) ~= nil then
		tolua.setpeer(self.battleLose, nil)
	end
	self.battleLose = nil
	if tolua.getpeer(self.battleWin) ~= nil then
		tolua.setpeer(self.battleWin, nil)
	end
	self.battleWin = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleSimpleResultView