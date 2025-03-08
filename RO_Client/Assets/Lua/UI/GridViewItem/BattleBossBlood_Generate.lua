---@class BattleBossBlood__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleBossBlood__Generate_buffTemp_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class BattleBossBlood__Generate_buffTemp_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleBossBlood__Generate_buffTemp
---@field public gameObject UnityEngine.GameObject
---@field public image BattleBossBlood__Generate_buffTemp_image
---@field public num BattleBossBlood__Generate_buffTemp_num

---@class BattleBossBlood__Generate_bossNature
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleBossBlood__Generate_bossIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class BattleBossBlood__Generate_bossName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleBossBlood__Generate_bossBlood
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleBossBlood__Generate_bossBlood2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleBossBlood__Generate_bossBloodNode
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class BattleBossBlood__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bossBloodNode BattleBossBlood__Generate_bossBloodNode
---@field private bossBlood2 BattleBossBlood__Generate_bossBlood2
---@field private bossBlood BattleBossBlood__Generate_bossBlood
---@field private bloodNum UnityEngine.GameObject
---@field private bossName BattleBossBlood__Generate_bossName
---@field private bossIcon BattleBossBlood__Generate_bossIcon
---@field private bossNature BattleBossBlood__Generate_bossNature
---@field private buffBox UnityEngine.GameObject
---@field private buffTemp BattleBossBlood__Generate_buffTemp
---@field private leftTime BattleBossBlood__Generate_leftTime
---@field private infinite UnityEngine.GameObject
local BattleBossBloodView = class("BattleBossBloodView")

function BattleBossBloodView:ctor()
end

---@private
function BattleBossBloodView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BattleBossBloodView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)


end

---@private
function BattleBossBloodView:InitGenerate__1(Root, data)
--[[
	BossBloodAnim
--]]
	local tmp = Root:Find("BossBloodAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossBloodNode = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function BattleBossBloodView:InitGenerate__2(Root, data)
--[[
	BossBloodAnim/BossBlood/BloodBar2
--]]
	local tmp = Root:Find("BossBloodAnim/BossBlood/BloodBar2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossBlood2 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleBossBloodView:InitGenerate__3(Root, data)
--[[
	BossBloodAnim/BossBlood/BloodBar
--]]
	local tmp = Root:Find("BossBloodAnim/BossBlood/BloodBar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossBlood = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleBossBloodView:InitGenerate__4(Root, data)
--[[
	BossBloodAnim/BossBlood/num
--]]
	local tmp = Root:Find("BossBloodAnim/BossBlood/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bloodNum = tmp
end

---@private
function BattleBossBloodView:InitGenerate__5(Root, data)
--[[
	BossBloodAnim/BossBlood/BossName/TextName
--]]
	local tmp = Root:Find("BossBloodAnim/BossBlood/BossName/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleBossBloodView:InitGenerate__6(Root, data)
--[[
	BossBloodAnim/BossHead/headboss
--]]
	local tmp = Root:Find("BossBloodAnim/BossHead/headboss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleBossBloodView:InitGenerate__7(Root, data)
--[[
	BossBloodAnim/BossHead/nature
--]]
	local tmp = Root:Find("BossBloodAnim/BossHead/nature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossNature = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleBossBloodView:InitGenerate__8(Root, data)
--[[
	BossBloodAnim/BossBuff
--]]
	local tmp = Root:Find("BossBloodAnim/BossBuff").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffBox = tmp
end

---@private
function BattleBossBloodView:InitGenerate__9(Root, data)
--[[
	BossBloodAnim/BossBuff/BuffItem
--]]
	local tmp = Root:Find("BossBloodAnim/BossBuff/BuffItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp = tmp
end

---@private
function BattleBossBloodView:InitGenerate__10(Root, data)
--[[
	BossBloodAnim/BossBuff/BuffItem/Image
--]]
	local tmp = Root:Find("BossBloodAnim/BossBuff/BuffItem/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleBossBloodView:InitGenerate__11(Root, data)
--[[
	BossBloodAnim/BossBuff/BuffItem/num
--]]
	local tmp = Root:Find("BossBloodAnim/BossBuff/BuffItem/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function BattleBossBloodView:InitGenerate__12(Root, data)
--[[
	BossBloodAnim/BattleTime/LeftBattleTime
--]]
	local tmp = Root:Find("BossBloodAnim/BattleTime/LeftBattleTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleBossBloodView:InitGenerate__13(Root, data)
--[[
	BossBloodAnim/BattleTime/infinite
--]]
	local tmp = Root:Find("BossBloodAnim/BattleTime/infinite").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.infinite = tmp
end

---@private
function BattleBossBloodView:GenerateDestroy()
	if tolua.getpeer(self.buffTemp.num) ~= nil then
		tolua.setpeer(self.buffTemp.num, nil)
	end
	if tolua.getpeer(self.buffTemp.image) ~= nil then
		tolua.setpeer(self.buffTemp.image, nil)
	end
	if tolua.getpeer(self.bossBloodNode) ~= nil then
		tolua.setpeer(self.bossBloodNode, nil)
	end
	self.bossBloodNode = nil
	if tolua.getpeer(self.bossBlood2) ~= nil then
		tolua.setpeer(self.bossBlood2, nil)
	end
	self.bossBlood2 = nil
	if tolua.getpeer(self.bossBlood) ~= nil then
		tolua.setpeer(self.bossBlood, nil)
	end
	self.bossBlood = nil
	if tolua.getpeer(self.bloodNum) ~= nil then
		tolua.setpeer(self.bloodNum, nil)
	end
	self.bloodNum = nil
	if tolua.getpeer(self.bossName) ~= nil then
		tolua.setpeer(self.bossName, nil)
	end
	self.bossName = nil
	if tolua.getpeer(self.bossIcon) ~= nil then
		tolua.setpeer(self.bossIcon, nil)
	end
	self.bossIcon = nil
	if tolua.getpeer(self.bossNature) ~= nil then
		tolua.setpeer(self.bossNature, nil)
	end
	self.bossNature = nil
	if tolua.getpeer(self.buffBox) ~= nil then
		tolua.setpeer(self.buffBox, nil)
	end
	self.buffBox = nil
	if tolua.getpeer(self.buffTemp) ~= nil then
		tolua.setpeer(self.buffTemp, nil)
	end
	self.buffTemp = nil
	if tolua.getpeer(self.leftTime) ~= nil then
		tolua.setpeer(self.leftTime, nil)
	end
	self.leftTime = nil
	if tolua.getpeer(self.infinite) ~= nil then
		tolua.setpeer(self.infinite, nil)
	end
	self.infinite = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BattleBossBloodView