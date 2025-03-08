---@class WorldBossItem__Generate_textLock
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class WorldBossItem__Generate_lock
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class WorldBossItem__Generate_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class WorldBossItem__Generate_bossHP
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class WorldBossItem__Generate_slot3_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class WorldBossItem__Generate_slot3
---@field public gameObject UnityEngine.GameObject
---@field public iconSmallItem WorldBossItem__Generate_slot3_iconSmallItem

---@class WorldBossItem__Generate_slot2_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class WorldBossItem__Generate_slot2
---@field public gameObject UnityEngine.GameObject
---@field public iconSmallItem WorldBossItem__Generate_slot2_iconSmallItem

---@class WorldBossItem__Generate_slot1_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class WorldBossItem__Generate_slot1
---@field public gameObject UnityEngine.GameObject
---@field public iconSmallItem WorldBossItem__Generate_slot1_iconSmallItem

---@class WorldBossItem__Generate_reviveTimer_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class WorldBossItem__Generate_reviveTimer
---@field public gameObject UnityEngine.GameObject
---@field public text WorldBossItem__Generate_reviveTimer_text

---@class WorldBossItem__Generate_leaveTimer_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class WorldBossItem__Generate_leaveTimer
---@field public gameObject UnityEngine.GameObject
---@field public text WorldBossItem__Generate_leaveTimer_text

---@class WorldBossItem__Generate_CostNum
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class WorldBossItem__Generate_CostIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class WorldBossItem__Generate_btnChallengeCoast
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class WorldBossItem__Generate_btnChallenge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class WorldBossItem__Generate_bossName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class WorldBossItem__Generate_bossImage
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class WorldBossItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bossImage WorldBossItem__Generate_bossImage
---@field private bossName WorldBossItem__Generate_bossName
---@field private btnChallenge WorldBossItem__Generate_btnChallenge
---@field private btnChallengeCoast WorldBossItem__Generate_btnChallengeCoast
---@field private CostIcon WorldBossItem__Generate_CostIcon
---@field private CostNum WorldBossItem__Generate_CostNum
---@field private labelLeave UnityEngine.GameObject
---@field private leaveTimer WorldBossItem__Generate_leaveTimer
---@field private reviveTimer WorldBossItem__Generate_reviveTimer
---@field private slot1 WorldBossItem__Generate_slot1
---@field private slot2 WorldBossItem__Generate_slot2
---@field private slot3 WorldBossItem__Generate_slot3
---@field private hp UnityEngine.GameObject
---@field private bossHP WorldBossItem__Generate_bossHP
---@field private slider WorldBossItem__Generate_slider
---@field private lock WorldBossItem__Generate_lock
---@field private textLock WorldBossItem__Generate_textLock
---@field private labelWating UnityEngine.GameObject
local WorldBossItemView = class("WorldBossItemView")

function WorldBossItemView:ctor()
end

---@private
function WorldBossItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function WorldBossItemView:InitGenerate(Root, data)
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


end

---@private
function WorldBossItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function WorldBossItemView:InitGenerate__2(Root, data)
--[[
	BossImage
--]]
	local tmp = Root:Find("BossImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossImage = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function WorldBossItemView:InitGenerate__3(Root, data)
--[[
	BossName
--]]
	local tmp = Root:Find("BossName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function WorldBossItemView:InitGenerate__4(Root, data)
--[[
	BtnChallenge
--]]
	local tmp = Root:Find("BtnChallenge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChallenge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function WorldBossItemView:InitGenerate__5(Root, data)
--[[
	BtnChallengeCoast
--]]
	local tmp = Root:Find("BtnChallengeCoast").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChallengeCoast = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function WorldBossItemView:InitGenerate__6(Root, data)
--[[
	BtnChallengeCoast/Content/cost/Icon
--]]
	local tmp = Root:Find("BtnChallengeCoast/Content/cost/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CostIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function WorldBossItemView:InitGenerate__7(Root, data)
--[[
	BtnChallengeCoast/Content/cost/Number
--]]
	local tmp = Root:Find("BtnChallengeCoast/Content/cost/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CostNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function WorldBossItemView:InitGenerate__8(Root, data)
--[[
	LabelLeave
--]]
	local tmp = Root:Find("LabelLeave").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelLeave = tmp
end

---@private
function WorldBossItemView:InitGenerate__9(Root, data)
--[[
	LeaveTimer
--]]
	local tmp = Root:Find("LeaveTimer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leaveTimer = tmp
end

---@private
function WorldBossItemView:InitGenerate__10(Root, data)
--[[
	LeaveTimer/Text
--]]
	local tmp = Root:Find("LeaveTimer/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leaveTimer.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function WorldBossItemView:InitGenerate__11(Root, data)
--[[
	ReviveTimer
--]]
	local tmp = Root:Find("ReviveTimer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reviveTimer = tmp
end

---@private
function WorldBossItemView:InitGenerate__12(Root, data)
--[[
	ReviveTimer/Text
--]]
	local tmp = Root:Find("ReviveTimer/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reviveTimer.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function WorldBossItemView:InitGenerate__13(Root, data)
--[[
	Rewards/Content/Slot1
--]]
	local tmp = Root:Find("Rewards/Content/Slot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1 = tmp
end

---@private
function WorldBossItemView:InitGenerate__14(Root, data)
--[[
	Rewards/Content/Slot1/IconSmallItem
--]]
	local tmp = Root:Find("Rewards/Content/Slot1/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.slot1.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function WorldBossItemView:InitGenerate__15(Root, data)
--[[
	Rewards/Content/Slot2
--]]
	local tmp = Root:Find("Rewards/Content/Slot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2 = tmp
end

---@private
function WorldBossItemView:InitGenerate__16(Root, data)
--[[
	Rewards/Content/Slot2/IconSmallItem
--]]
	local tmp = Root:Find("Rewards/Content/Slot2/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.slot2.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function WorldBossItemView:InitGenerate__17(Root, data)
--[[
	Rewards/Content/Slot3
--]]
	local tmp = Root:Find("Rewards/Content/Slot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3 = tmp
end

---@private
function WorldBossItemView:InitGenerate__18(Root, data)
--[[
	Rewards/Content/Slot3/IconSmallItem
--]]
	local tmp = Root:Find("Rewards/Content/Slot3/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.slot3.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function WorldBossItemView:InitGenerate__19(Root, data)
--[[
	Hp
--]]
	local tmp = Root:Find("Hp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hp = tmp
end

---@private
function WorldBossItemView:InitGenerate__20(Root, data)
--[[
	Hp/BossHP
--]]
	local tmp = Root:Find("Hp/BossHP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossHP = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function WorldBossItemView:InitGenerate__21(Root, data)
--[[
	Hp/Slider
--]]
	local tmp = Root:Find("Hp/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function WorldBossItemView:InitGenerate__22(Root, data)
--[[
	Lock
--]]
	local tmp = Root:Find("Lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock = tmp
	self.lock:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function WorldBossItemView:InitGenerate__23(Root, data)
--[[
	Lock/Label/TextLock
--]]
	local tmp = Root:Find("Lock/Label/TextLock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textLock = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function WorldBossItemView:InitGenerate__24(Root, data)
--[[
	Lock/LabelWating
--]]
	local tmp = Root:Find("Lock/LabelWating").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelWating = tmp
end

---@private
function WorldBossItemView:GenerateDestroy()
	if self.slot3.iconSmallItem.GenerateDestroy ~= nil then
		self.slot3.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.slot3.iconSmallItem) ~= nil then
		tolua.setpeer(self.slot3.iconSmallItem, nil)
	end
	if self.slot2.iconSmallItem.GenerateDestroy ~= nil then
		self.slot2.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.slot2.iconSmallItem) ~= nil then
		tolua.setpeer(self.slot2.iconSmallItem, nil)
	end
	if self.slot1.iconSmallItem.GenerateDestroy ~= nil then
		self.slot1.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.slot1.iconSmallItem) ~= nil then
		tolua.setpeer(self.slot1.iconSmallItem, nil)
	end
	if tolua.getpeer(self.reviveTimer.text) ~= nil then
		tolua.setpeer(self.reviveTimer.text, nil)
	end
	if tolua.getpeer(self.leaveTimer.text) ~= nil then
		tolua.setpeer(self.leaveTimer.text, nil)
	end
	if tolua.getpeer(self.bossImage) ~= nil then
		tolua.setpeer(self.bossImage, nil)
	end
	self.bossImage = nil
	if tolua.getpeer(self.bossName) ~= nil then
		tolua.setpeer(self.bossName, nil)
	end
	self.bossName = nil
	if tolua.getpeer(self.btnChallenge) ~= nil then
		tolua.setpeer(self.btnChallenge, nil)
	end
	self.btnChallenge = nil
	if tolua.getpeer(self.btnChallengeCoast) ~= nil then
		tolua.setpeer(self.btnChallengeCoast, nil)
	end
	self.btnChallengeCoast = nil
	if tolua.getpeer(self.CostIcon) ~= nil then
		tolua.setpeer(self.CostIcon, nil)
	end
	self.CostIcon = nil
	if tolua.getpeer(self.CostNum) ~= nil then
		tolua.setpeer(self.CostNum, nil)
	end
	self.CostNum = nil
	if tolua.getpeer(self.labelLeave) ~= nil then
		tolua.setpeer(self.labelLeave, nil)
	end
	self.labelLeave = nil
	if tolua.getpeer(self.leaveTimer) ~= nil then
		tolua.setpeer(self.leaveTimer, nil)
	end
	self.leaveTimer = nil
	if tolua.getpeer(self.reviveTimer) ~= nil then
		tolua.setpeer(self.reviveTimer, nil)
	end
	self.reviveTimer = nil
	if tolua.getpeer(self.slot1) ~= nil then
		tolua.setpeer(self.slot1, nil)
	end
	self.slot1 = nil
	if tolua.getpeer(self.slot2) ~= nil then
		tolua.setpeer(self.slot2, nil)
	end
	self.slot2 = nil
	if tolua.getpeer(self.slot3) ~= nil then
		tolua.setpeer(self.slot3, nil)
	end
	self.slot3 = nil
	if tolua.getpeer(self.hp) ~= nil then
		tolua.setpeer(self.hp, nil)
	end
	self.hp = nil
	if tolua.getpeer(self.bossHP) ~= nil then
		tolua.setpeer(self.bossHP, nil)
	end
	self.bossHP = nil
	if tolua.getpeer(self.slider) ~= nil then
		tolua.setpeer(self.slider, nil)
	end
	self.slider = nil
	if tolua.getpeer(self.lock) ~= nil then
		tolua.setpeer(self.lock, nil)
	end
	self.lock = nil
	if tolua.getpeer(self.textLock) ~= nil then
		tolua.setpeer(self.textLock, nil)
	end
	self.textLock = nil
	if tolua.getpeer(self.labelWating) ~= nil then
		tolua.setpeer(self.labelWating, nil)
	end
	self.labelWating = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return WorldBossItemView