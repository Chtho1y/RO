---@class UIBattleResult__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleResult__Generate_winCount
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIBattleResult__Generate_deltaScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleResult__Generate_newScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleResult__Generate_oldScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleResult__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleResult__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private popWinAnim UnityEngine.GameObject
---@field private AnyBtn UIBattleResult__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private battleWin UnityEngine.GameObject
---@field private battleLose UnityEngine.GameObject
---@field private title UnityEngine.GameObject
---@field private receiveRes UnityEngine.GameObject
---@field private score UnityEngine.GameObject
---@field private oldScoreText UIBattleResult__Generate_oldScoreText
---@field private newScoreText UIBattleResult__Generate_newScoreText
---@field private deltaScoreText UIBattleResult__Generate_deltaScoreText
---@field private winNode UnityEngine.GameObject
---@field private winBg1 UnityEngine.GameObject
---@field private winBg2 UnityEngine.GameObject
---@field private winBg3 UnityEngine.GameObject
---@field private winCount UIBattleResult__Generate_winCount
---@field private dsc UIBattleResult__Generate_dsc
local UIBattleResultView = class("UIBattleResultView", require("UIViewBase"))

function UIBattleResultView:ctor()
end

---@private
function UIBattleResultView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleResultView:InitGenerate(Root, data)
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


end

---@private
function UIBattleResultView:InitGenerate__1(Root, data)
--[[
	PopWinAnim
--]]
	local tmp = Root:Find("PopWinAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.popWinAnim = tmp
end

---@private
function UIBattleResultView:InitGenerate__2(Root, data)
--[[
	PopWinAnim/Alpha
--]]
	local tmp = Root:Find("PopWinAnim/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleResultView:InitGenerate__3(Root, data)
--[[
	PopWinAnim/Window
--]]
	local tmp = Root:Find("PopWinAnim/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIBattleResultView:InitGenerate__4(Root, data)
--[[
	PopWinAnim/Window/BG/BattleWin
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/BattleWin").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleWin = tmp
end

---@private
function UIBattleResultView:InitGenerate__5(Root, data)
--[[
	PopWinAnim/Window/BG/BattleLose
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/BattleLose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleLose = tmp
end

---@private
function UIBattleResultView:InitGenerate__6(Root, data)
--[[
	PopWinAnim/Window/BG/Title
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp
end

---@private
function UIBattleResultView:InitGenerate__7(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes = tmp
end

---@private
function UIBattleResultView:InitGenerate__8(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.score = tmp
end

---@private
function UIBattleResultView:InitGenerate__9(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/Val
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.oldScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleResultView:InitGenerate__10(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/NewVal
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/NewVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.newScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleResultView:InitGenerate__11(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/AddVal
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/AddVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.deltaScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleResultView:InitGenerate__12(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winNode = tmp
end

---@private
function UIBattleResultView:InitGenerate__13(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic01
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winBg1 = tmp
end

---@private
function UIBattleResultView:InitGenerate__14(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic02
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic02").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winBg2 = tmp
end

---@private
function UIBattleResultView:InitGenerate__15(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic03
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Pic03").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winBg3 = tmp
end

---@private
function UIBattleResultView:InitGenerate__16(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Number
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/WinningStreak/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winCount = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIBattleResultView:InitGenerate__17(Root, data)
--[[
	PopWinAnim/Window/BG/Dsc
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleResultView:GenerateDestroy()
	if tolua.getpeer(self.popWinAnim) ~= nil then
		tolua.setpeer(self.popWinAnim, nil)
	end
	self.popWinAnim = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.battleWin) ~= nil then
		tolua.setpeer(self.battleWin, nil)
	end
	self.battleWin = nil
	if tolua.getpeer(self.battleLose) ~= nil then
		tolua.setpeer(self.battleLose, nil)
	end
	self.battleLose = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.receiveRes) ~= nil then
		tolua.setpeer(self.receiveRes, nil)
	end
	self.receiveRes = nil
	if tolua.getpeer(self.score) ~= nil then
		tolua.setpeer(self.score, nil)
	end
	self.score = nil
	if tolua.getpeer(self.oldScoreText) ~= nil then
		tolua.setpeer(self.oldScoreText, nil)
	end
	self.oldScoreText = nil
	if tolua.getpeer(self.newScoreText) ~= nil then
		tolua.setpeer(self.newScoreText, nil)
	end
	self.newScoreText = nil
	if tolua.getpeer(self.deltaScoreText) ~= nil then
		tolua.setpeer(self.deltaScoreText, nil)
	end
	self.deltaScoreText = nil
	if tolua.getpeer(self.winNode) ~= nil then
		tolua.setpeer(self.winNode, nil)
	end
	self.winNode = nil
	if tolua.getpeer(self.winBg1) ~= nil then
		tolua.setpeer(self.winBg1, nil)
	end
	self.winBg1 = nil
	if tolua.getpeer(self.winBg2) ~= nil then
		tolua.setpeer(self.winBg2, nil)
	end
	self.winBg2 = nil
	if tolua.getpeer(self.winBg3) ~= nil then
		tolua.setpeer(self.winBg3, nil)
	end
	self.winBg3 = nil
	if tolua.getpeer(self.winCount) ~= nil then
		tolua.setpeer(self.winCount, nil)
	end
	self.winCount = nil
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	self.dsc = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleResultView