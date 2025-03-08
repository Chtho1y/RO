---@class BattleEnemy__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleEnemy__Generate_playerNode4_headBoxItemNew_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode4_headBoxItemNew_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode4_headBoxItemNew_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class BattleEnemy__Generate_playerNode4_headBoxItemNew
---@field public gameObject UnityEngine.GameObject
---@field public headItem BattleEnemy__Generate_playerNode4_headBoxItemNew_headItem
---@field public hp BattleEnemy__Generate_playerNode4_headBoxItemNew_hp
---@field public sp BattleEnemy__Generate_playerNode4_headBoxItemNew_sp
---@field public deadNode UnityEngine.GameObject

---@class BattleEnemy__Generate_playerNode4
---@field public gameObject UnityEngine.GameObject
---@field public headBoxItemNew BattleEnemy__Generate_playerNode4_headBoxItemNew

---@class BattleEnemy__Generate_playerNode3_headBoxItemNew_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode3_headBoxItemNew_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode3_headBoxItemNew_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class BattleEnemy__Generate_playerNode3_headBoxItemNew
---@field public gameObject UnityEngine.GameObject
---@field public headItem BattleEnemy__Generate_playerNode3_headBoxItemNew_headItem
---@field public hp BattleEnemy__Generate_playerNode3_headBoxItemNew_hp
---@field public sp BattleEnemy__Generate_playerNode3_headBoxItemNew_sp
---@field public deadNode UnityEngine.GameObject

---@class BattleEnemy__Generate_playerNode3
---@field public gameObject UnityEngine.GameObject
---@field public headBoxItemNew BattleEnemy__Generate_playerNode3_headBoxItemNew

---@class BattleEnemy__Generate_playerNode2_headBoxItemNew_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode2_headBoxItemNew_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode2_headBoxItemNew_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class BattleEnemy__Generate_playerNode2_headBoxItemNew
---@field public gameObject UnityEngine.GameObject
---@field public headItem BattleEnemy__Generate_playerNode2_headBoxItemNew_headItem
---@field public hp BattleEnemy__Generate_playerNode2_headBoxItemNew_hp
---@field public sp BattleEnemy__Generate_playerNode2_headBoxItemNew_sp
---@field public deadNode UnityEngine.GameObject

---@class BattleEnemy__Generate_playerNode2
---@field public gameObject UnityEngine.GameObject
---@field public headBoxItemNew BattleEnemy__Generate_playerNode2_headBoxItemNew

---@class BattleEnemy__Generate_playerNode1_headBoxItemNew_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode1_headBoxItemNew_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate_playerNode1_headBoxItemNew_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class BattleEnemy__Generate_playerNode1_headBoxItemNew
---@field public gameObject UnityEngine.GameObject
---@field public headItem BattleEnemy__Generate_playerNode1_headBoxItemNew_headItem
---@field public hp BattleEnemy__Generate_playerNode1_headBoxItemNew_hp
---@field public sp BattleEnemy__Generate_playerNode1_headBoxItemNew_sp
---@field public deadNode UnityEngine.GameObject

---@class BattleEnemy__Generate_playerNode1
---@field public gameObject UnityEngine.GameObject
---@field public headBoxItemNew BattleEnemy__Generate_playerNode1_headBoxItemNew

---@class BattleEnemy__Generate_enemyNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class BattleEnemy__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleEnemy__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg BattleEnemy__Generate_bg
---@field private enemyNameTxt BattleEnemy__Generate_enemyNameTxt
---@field private playerNode1 BattleEnemy__Generate_playerNode1
---@field private playerNode2 BattleEnemy__Generate_playerNode2
---@field private playerNode3 BattleEnemy__Generate_playerNode3
---@field private playerNode4 BattleEnemy__Generate_playerNode4
---@field private leftTime BattleEnemy__Generate_leftTime
---@field private infinite UnityEngine.GameObject
local BattleEnemyView = class("BattleEnemyView")

function BattleEnemyView:ctor()
end

---@private
function BattleEnemyView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BattleEnemyView:InitGenerate(Root, data)
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
	self:InitGenerate__28(Root,data)


end

---@private
function BattleEnemyView:InitGenerate__1(Root, data)
--[[
	UIBattleEnemyAnim/NameBox/bg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/NameBox/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__2(Root, data)
--[[
	UIBattleEnemyAnim/NameBox/Text
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/NameBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.enemyNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function BattleEnemyView:InitGenerate__3(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1 = tmp
end

---@private
function BattleEnemyView:InitGenerate__4(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.headBoxItemNew = tmp
end

---@private
function BattleEnemyView:InitGenerate__5(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/HeadItem
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.headBoxItemNew.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.playerNode1.headBoxItemNew.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function BattleEnemyView:InitGenerate__6(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Bar/HP/bloodImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Bar/HP/bloodImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.headBoxItemNew.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__7(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Bar/Sp/spImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Bar/Sp/spImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.headBoxItemNew.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__8(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Dead
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player1/HeadBoxItemNew/Dead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.headBoxItemNew.deadNode = tmp
end

---@private
function BattleEnemyView:InitGenerate__9(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2 = tmp
end

---@private
function BattleEnemyView:InitGenerate__10(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.headBoxItemNew = tmp
end

---@private
function BattleEnemyView:InitGenerate__11(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/HeadItem
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.headBoxItemNew.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.playerNode2.headBoxItemNew.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function BattleEnemyView:InitGenerate__12(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Bar/HP/bloodImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Bar/HP/bloodImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.headBoxItemNew.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__13(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Bar/Sp/spImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Bar/Sp/spImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.headBoxItemNew.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__14(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Dead
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player2/HeadBoxItemNew/Dead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.headBoxItemNew.deadNode = tmp
end

---@private
function BattleEnemyView:InitGenerate__15(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3 = tmp
end

---@private
function BattleEnemyView:InitGenerate__16(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.headBoxItemNew = tmp
end

---@private
function BattleEnemyView:InitGenerate__17(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/HeadItem
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.headBoxItemNew.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.playerNode3.headBoxItemNew.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function BattleEnemyView:InitGenerate__18(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Bar/HP/bloodImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Bar/HP/bloodImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.headBoxItemNew.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__19(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Bar/Sp/spImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Bar/Sp/spImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.headBoxItemNew.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__20(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Dead
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player3/HeadBoxItemNew/Dead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.headBoxItemNew.deadNode = tmp
end

---@private
function BattleEnemyView:InitGenerate__21(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4 = tmp
end

---@private
function BattleEnemyView:InitGenerate__22(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.headBoxItemNew = tmp
end

---@private
function BattleEnemyView:InitGenerate__23(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/HeadItem
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.headBoxItemNew.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.playerNode4.headBoxItemNew.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function BattleEnemyView:InitGenerate__24(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Bar/HP/bloodImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Bar/HP/bloodImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.headBoxItemNew.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__25(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Bar/Sp/spImg
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Bar/Sp/spImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.headBoxItemNew.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleEnemyView:InitGenerate__26(Root, data)
--[[
	UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Dead
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/PlayerList/Player4/HeadBoxItemNew/Dead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.headBoxItemNew.deadNode = tmp
end

---@private
function BattleEnemyView:InitGenerate__27(Root, data)
--[[
	UIBattleEnemyAnim/BattleTime/LeftBattleTime
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/BattleTime/LeftBattleTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleEnemyView:InitGenerate__28(Root, data)
--[[
	UIBattleEnemyAnim/BattleTime/infinite
--]]
	local tmp = Root:Find("UIBattleEnemyAnim/BattleTime/infinite").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.infinite = tmp
end

---@private
function BattleEnemyView:GenerateDestroy()
	if tolua.getpeer(self.playerNode4.headBoxItemNew.deadNode) ~= nil then
		tolua.setpeer(self.playerNode4.headBoxItemNew.deadNode, nil)
	end
	if tolua.getpeer(self.playerNode4.headBoxItemNew.sp) ~= nil then
		tolua.setpeer(self.playerNode4.headBoxItemNew.sp, nil)
	end
	if tolua.getpeer(self.playerNode4.headBoxItemNew.hp) ~= nil then
		tolua.setpeer(self.playerNode4.headBoxItemNew.hp, nil)
	end
	if self.playerNode4.headBoxItemNew.headItem.GenerateDestroy ~= nil then
		self.playerNode4.headBoxItemNew.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode4.headBoxItemNew.headItem) ~= nil then
		tolua.setpeer(self.playerNode4.headBoxItemNew.headItem, nil)
	end
	if tolua.getpeer(self.playerNode4.headBoxItemNew) ~= nil then
		tolua.setpeer(self.playerNode4.headBoxItemNew, nil)
	end
	if tolua.getpeer(self.playerNode3.headBoxItemNew.deadNode) ~= nil then
		tolua.setpeer(self.playerNode3.headBoxItemNew.deadNode, nil)
	end
	if tolua.getpeer(self.playerNode3.headBoxItemNew.sp) ~= nil then
		tolua.setpeer(self.playerNode3.headBoxItemNew.sp, nil)
	end
	if tolua.getpeer(self.playerNode3.headBoxItemNew.hp) ~= nil then
		tolua.setpeer(self.playerNode3.headBoxItemNew.hp, nil)
	end
	if self.playerNode3.headBoxItemNew.headItem.GenerateDestroy ~= nil then
		self.playerNode3.headBoxItemNew.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode3.headBoxItemNew.headItem) ~= nil then
		tolua.setpeer(self.playerNode3.headBoxItemNew.headItem, nil)
	end
	if tolua.getpeer(self.playerNode3.headBoxItemNew) ~= nil then
		tolua.setpeer(self.playerNode3.headBoxItemNew, nil)
	end
	if tolua.getpeer(self.playerNode2.headBoxItemNew.deadNode) ~= nil then
		tolua.setpeer(self.playerNode2.headBoxItemNew.deadNode, nil)
	end
	if tolua.getpeer(self.playerNode2.headBoxItemNew.sp) ~= nil then
		tolua.setpeer(self.playerNode2.headBoxItemNew.sp, nil)
	end
	if tolua.getpeer(self.playerNode2.headBoxItemNew.hp) ~= nil then
		tolua.setpeer(self.playerNode2.headBoxItemNew.hp, nil)
	end
	if self.playerNode2.headBoxItemNew.headItem.GenerateDestroy ~= nil then
		self.playerNode2.headBoxItemNew.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode2.headBoxItemNew.headItem) ~= nil then
		tolua.setpeer(self.playerNode2.headBoxItemNew.headItem, nil)
	end
	if tolua.getpeer(self.playerNode2.headBoxItemNew) ~= nil then
		tolua.setpeer(self.playerNode2.headBoxItemNew, nil)
	end
	if tolua.getpeer(self.playerNode1.headBoxItemNew.deadNode) ~= nil then
		tolua.setpeer(self.playerNode1.headBoxItemNew.deadNode, nil)
	end
	if tolua.getpeer(self.playerNode1.headBoxItemNew.sp) ~= nil then
		tolua.setpeer(self.playerNode1.headBoxItemNew.sp, nil)
	end
	if tolua.getpeer(self.playerNode1.headBoxItemNew.hp) ~= nil then
		tolua.setpeer(self.playerNode1.headBoxItemNew.hp, nil)
	end
	if self.playerNode1.headBoxItemNew.headItem.GenerateDestroy ~= nil then
		self.playerNode1.headBoxItemNew.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode1.headBoxItemNew.headItem) ~= nil then
		tolua.setpeer(self.playerNode1.headBoxItemNew.headItem, nil)
	end
	if tolua.getpeer(self.playerNode1.headBoxItemNew) ~= nil then
		tolua.setpeer(self.playerNode1.headBoxItemNew, nil)
	end
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.enemyNameTxt) ~= nil then
		tolua.setpeer(self.enemyNameTxt, nil)
	end
	self.enemyNameTxt = nil
	if tolua.getpeer(self.playerNode1) ~= nil then
		tolua.setpeer(self.playerNode1, nil)
	end
	self.playerNode1 = nil
	if tolua.getpeer(self.playerNode2) ~= nil then
		tolua.setpeer(self.playerNode2, nil)
	end
	self.playerNode2 = nil
	if tolua.getpeer(self.playerNode3) ~= nil then
		tolua.setpeer(self.playerNode3, nil)
	end
	self.playerNode3 = nil
	if tolua.getpeer(self.playerNode4) ~= nil then
		tolua.setpeer(self.playerNode4, nil)
	end
	self.playerNode4 = nil
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
return BattleEnemyView