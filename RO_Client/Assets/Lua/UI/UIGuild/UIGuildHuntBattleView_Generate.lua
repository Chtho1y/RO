---@class UIGuildHuntBattle__Generate_buffTemp_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildHuntBattle__Generate_buffTemp_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_buffTemp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public image UIGuildHuntBattle__Generate_buffTemp_image
---@field public num UIGuildHuntBattle__Generate_buffTemp_num

---@class UIGuildHuntBattle__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHuntBattle__Generate_lable10
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable9
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable8
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable7
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable6
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable5
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable4
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable3
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_lable1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIGuildHuntBattle__Generate_bossNature
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_bossIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UIGuildHuntBattle__Generate_iconBox
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_boxBg
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIGuildHuntBattle__Generate_lvNumber
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildHuntBattle__Generate_hPNumber
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildHuntBattle__Generate_bossBlood
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate_bossBlood2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildHuntBattle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private huntGroup UnityEngine.GameObject
---@field private bossBlood2 UIGuildHuntBattle__Generate_bossBlood2
---@field private bossBlood UIGuildHuntBattle__Generate_bossBlood
---@field private hPNumber UIGuildHuntBattle__Generate_hPNumber
---@field private lvNumber UIGuildHuntBattle__Generate_lvNumber
---@field private boxBg UIGuildHuntBattle__Generate_boxBg
---@field private iconBox UIGuildHuntBattle__Generate_iconBox
---@field private demonGroup UnityEngine.GameObject
---@field private bossIcon UIGuildHuntBattle__Generate_bossIcon
---@field private bossNature UIGuildHuntBattle__Generate_bossNature
---@field private number UIGuildHuntBattle__Generate_number
---@field private lable1 UIGuildHuntBattle__Generate_lable1
---@field private lable2 UIGuildHuntBattle__Generate_lable2
---@field private lable3 UIGuildHuntBattle__Generate_lable3
---@field private lable4 UIGuildHuntBattle__Generate_lable4
---@field private lable5 UIGuildHuntBattle__Generate_lable5
---@field private lable6 UIGuildHuntBattle__Generate_lable6
---@field private lable7 UIGuildHuntBattle__Generate_lable7
---@field private lable8 UIGuildHuntBattle__Generate_lable8
---@field private lable9 UIGuildHuntBattle__Generate_lable9
---@field private lable10 UIGuildHuntBattle__Generate_lable10
---@field private leftTime UIGuildHuntBattle__Generate_leftTime
---@field private infinite UnityEngine.GameObject
---@field private buffBox UnityEngine.GameObject
---@field private buffTemp UIGuildHuntBattle__Generate_buffTemp
local UIGuildHuntBattleView = class("UIGuildHuntBattleView", require("UIViewBase"))

function UIGuildHuntBattleView:ctor()
end

---@private
function UIGuildHuntBattleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildHuntBattleView:InitGenerate(Root, data)
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
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)


end

---@private
function UIGuildHuntBattleView:InitGenerate__1(Root, data)
--[[
	HuntGroup
--]]
	local tmp = Root:Find("HuntGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.huntGroup = tmp
end

---@private
function UIGuildHuntBattleView:InitGenerate__2(Root, data)
--[[
	HuntGroup/BossBlood/BloodBar2
--]]
	local tmp = Root:Find("HuntGroup/BossBlood/BloodBar2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossBlood2 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__3(Root, data)
--[[
	HuntGroup/BossBlood/BloodBar
--]]
	local tmp = Root:Find("HuntGroup/BossBlood/BloodBar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossBlood = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__4(Root, data)
--[[
	HuntGroup/BossBlood/HPNumber
--]]
	local tmp = Root:Find("HuntGroup/BossBlood/HPNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hPNumber = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildHuntBattleView:InitGenerate__5(Root, data)
--[[
	HuntGroup/BoxLevel/LvNumber
--]]
	local tmp = Root:Find("HuntGroup/BoxLevel/LvNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvNumber = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildHuntBattleView:InitGenerate__6(Root, data)
--[[
	HuntGroup/BoxBg
--]]
	local tmp = Root:Find("HuntGroup/BoxBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxBg = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIGuildHuntBattleView:InitGenerate__7(Root, data)
--[[
	HuntGroup/BoxBg/IconBox
--]]
	local tmp = Root:Find("HuntGroup/BoxBg/IconBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconBox = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__8(Root, data)
--[[
	DemonGroup
--]]
	local tmp = Root:Find("DemonGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.demonGroup = tmp
end

---@private
function UIGuildHuntBattleView:InitGenerate__9(Root, data)
--[[
	DemonGroup/BossHead/headboss
--]]
	local tmp = Root:Find("DemonGroup/BossHead/headboss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntBattleView:InitGenerate__10(Root, data)
--[[
	DemonGroup/BossHead/nature
--]]
	local tmp = Root:Find("DemonGroup/BossHead/nature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossNature = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__11(Root, data)
--[[
	DemonGroup/Number
--]]
	local tmp = Root:Find("DemonGroup/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIGuildHuntBattleView:InitGenerate__12(Root, data)
--[[
	DemonGroup/Number/Lable1
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable1 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__13(Root, data)
--[[
	DemonGroup/Number/Lable2
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable2 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__14(Root, data)
--[[
	DemonGroup/Number/Lable3
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable3 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__15(Root, data)
--[[
	DemonGroup/Number/Lable4
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable4 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__16(Root, data)
--[[
	DemonGroup/Number/Lable5
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable5 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__17(Root, data)
--[[
	DemonGroup/Number/Lable6
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable6 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__18(Root, data)
--[[
	DemonGroup/Number/Lable7
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable7 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__19(Root, data)
--[[
	DemonGroup/Number/Lable8
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable8 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__20(Root, data)
--[[
	DemonGroup/Number/Lable9
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable9 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__21(Root, data)
--[[
	DemonGroup/Number/Lable10
--]]
	local tmp = Root:Find("DemonGroup/Number/Lable10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lable10 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__22(Root, data)
--[[
	BattleTime/LeftBattleTime
--]]
	local tmp = Root:Find("BattleTime/LeftBattleTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntBattleView:InitGenerate__23(Root, data)
--[[
	BattleTime/infinite
--]]
	local tmp = Root:Find("BattleTime/infinite").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.infinite = tmp
end

---@private
function UIGuildHuntBattleView:InitGenerate__24(Root, data)
--[[
	BossBuff
--]]
	local tmp = Root:Find("BossBuff").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffBox = tmp
end

---@private
function UIGuildHuntBattleView:InitGenerate__25(Root, data)
--[[
	BossBuff/BuffItem
--]]
	local tmp = Root:Find("BossBuff/BuffItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntBattleView:InitGenerate__26(Root, data)
--[[
	BossBuff/BuffItem/Image
--]]
	local tmp = Root:Find("BossBuff/BuffItem/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildHuntBattleView:InitGenerate__27(Root, data)
--[[
	BossBuff/BuffItem/num
--]]
	local tmp = Root:Find("BossBuff/BuffItem/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffTemp.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildHuntBattleView:GenerateDestroy()
	if tolua.getpeer(self.buffTemp.num) ~= nil then
		tolua.setpeer(self.buffTemp.num, nil)
	end
	if tolua.getpeer(self.buffTemp.image) ~= nil then
		tolua.setpeer(self.buffTemp.image, nil)
	end
	if tolua.getpeer(self.huntGroup) ~= nil then
		tolua.setpeer(self.huntGroup, nil)
	end
	self.huntGroup = nil
	if tolua.getpeer(self.bossBlood2) ~= nil then
		tolua.setpeer(self.bossBlood2, nil)
	end
	self.bossBlood2 = nil
	if tolua.getpeer(self.bossBlood) ~= nil then
		tolua.setpeer(self.bossBlood, nil)
	end
	self.bossBlood = nil
	if tolua.getpeer(self.hPNumber) ~= nil then
		tolua.setpeer(self.hPNumber, nil)
	end
	self.hPNumber = nil
	if tolua.getpeer(self.lvNumber) ~= nil then
		tolua.setpeer(self.lvNumber, nil)
	end
	self.lvNumber = nil
	if tolua.getpeer(self.boxBg) ~= nil then
		tolua.setpeer(self.boxBg, nil)
	end
	self.boxBg = nil
	if tolua.getpeer(self.iconBox) ~= nil then
		tolua.setpeer(self.iconBox, nil)
	end
	self.iconBox = nil
	if tolua.getpeer(self.demonGroup) ~= nil then
		tolua.setpeer(self.demonGroup, nil)
	end
	self.demonGroup = nil
	if tolua.getpeer(self.bossIcon) ~= nil then
		tolua.setpeer(self.bossIcon, nil)
	end
	self.bossIcon = nil
	if tolua.getpeer(self.bossNature) ~= nil then
		tolua.setpeer(self.bossNature, nil)
	end
	self.bossNature = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.lable1) ~= nil then
		tolua.setpeer(self.lable1, nil)
	end
	self.lable1 = nil
	if tolua.getpeer(self.lable2) ~= nil then
		tolua.setpeer(self.lable2, nil)
	end
	self.lable2 = nil
	if tolua.getpeer(self.lable3) ~= nil then
		tolua.setpeer(self.lable3, nil)
	end
	self.lable3 = nil
	if tolua.getpeer(self.lable4) ~= nil then
		tolua.setpeer(self.lable4, nil)
	end
	self.lable4 = nil
	if tolua.getpeer(self.lable5) ~= nil then
		tolua.setpeer(self.lable5, nil)
	end
	self.lable5 = nil
	if tolua.getpeer(self.lable6) ~= nil then
		tolua.setpeer(self.lable6, nil)
	end
	self.lable6 = nil
	if tolua.getpeer(self.lable7) ~= nil then
		tolua.setpeer(self.lable7, nil)
	end
	self.lable7 = nil
	if tolua.getpeer(self.lable8) ~= nil then
		tolua.setpeer(self.lable8, nil)
	end
	self.lable8 = nil
	if tolua.getpeer(self.lable9) ~= nil then
		tolua.setpeer(self.lable9, nil)
	end
	self.lable9 = nil
	if tolua.getpeer(self.lable10) ~= nil then
		tolua.setpeer(self.lable10, nil)
	end
	self.lable10 = nil
	if tolua.getpeer(self.leftTime) ~= nil then
		tolua.setpeer(self.leftTime, nil)
	end
	self.leftTime = nil
	if tolua.getpeer(self.infinite) ~= nil then
		tolua.setpeer(self.infinite, nil)
	end
	self.infinite = nil
	if tolua.getpeer(self.buffBox) ~= nil then
		tolua.setpeer(self.buffBox, nil)
	end
	self.buffBox = nil
	if tolua.getpeer(self.buffTemp) ~= nil then
		tolua.setpeer(self.buffTemp, nil)
	end
	self.buffTemp = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildHuntBattleView