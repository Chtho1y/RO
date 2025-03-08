---@class UIBattleFailed__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleFailed__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIBattleFailed__Generate_AnyBtn
local UIBattleFailedView = class("UIBattleFailedView", require("UIViewBase"))

function UIBattleFailedView:ctor()
end

---@private
function UIBattleFailedView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleFailedView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIBattleFailedView:InitGenerate__1(Root, data)
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
function UIBattleFailedView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleFailedView