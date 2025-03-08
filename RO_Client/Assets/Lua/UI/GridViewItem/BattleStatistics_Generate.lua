---@class BattleStatistics__Generate_btnQuit
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class BattleStatistics__Generate_btnSpeed
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public speed1 UnityEngine.GameObject
---@field public speed2 UnityEngine.GameObject

---@class BattleStatistics__Generate_hideBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class BattleStatistics__Generate_viewDetailBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class BattleStatistics__Generate_playerNode4_progress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode4_totalProgress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode4_percent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode4_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode4_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode4
---@field public gameObject UnityEngine.GameObject
---@field public playerName BattleStatistics__Generate_playerNode4_playerName
---@field public jobIcon BattleStatistics__Generate_playerNode4_jobIcon
---@field public percent BattleStatistics__Generate_playerNode4_percent
---@field public totalProgress BattleStatistics__Generate_playerNode4_totalProgress
---@field public progress BattleStatistics__Generate_playerNode4_progress

---@class BattleStatistics__Generate_playerNode3_progress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode3_totalProgress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode3_percent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode3_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode3_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode3
---@field public gameObject UnityEngine.GameObject
---@field public playerName BattleStatistics__Generate_playerNode3_playerName
---@field public jobIcon BattleStatistics__Generate_playerNode3_jobIcon
---@field public percent BattleStatistics__Generate_playerNode3_percent
---@field public totalProgress BattleStatistics__Generate_playerNode3_totalProgress
---@field public progress BattleStatistics__Generate_playerNode3_progress

---@class BattleStatistics__Generate_playerNode2_progress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode2_totalProgress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode2_percent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode2_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode2_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode2
---@field public gameObject UnityEngine.GameObject
---@field public playerName BattleStatistics__Generate_playerNode2_playerName
---@field public jobIcon BattleStatistics__Generate_playerNode2_jobIcon
---@field public percent BattleStatistics__Generate_playerNode2_percent
---@field public totalProgress BattleStatistics__Generate_playerNode2_totalProgress
---@field public progress BattleStatistics__Generate_playerNode2_progress

---@class BattleStatistics__Generate_playerNode1_progress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode1_totalProgress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode1_percent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode1_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class BattleStatistics__Generate_playerNode1_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleStatistics__Generate_playerNode1
---@field public gameObject UnityEngine.GameObject
---@field public playerName BattleStatistics__Generate_playerNode1_playerName
---@field public jobIcon BattleStatistics__Generate_playerNode1_jobIcon
---@field public percent BattleStatistics__Generate_playerNode1_percent
---@field public totalProgress BattleStatistics__Generate_playerNode1_totalProgress
---@field public progress BattleStatistics__Generate_playerNode1_progress

---@class BattleStatistics__Generate_battleCountAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class BattleStatistics__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private canvas UnityEngine.Canvas
---@field private battleCountAnim BattleStatistics__Generate_battleCountAnim
---@field private playerNode1 BattleStatistics__Generate_playerNode1
---@field private playerNode2 BattleStatistics__Generate_playerNode2
---@field private playerNode3 BattleStatistics__Generate_playerNode3
---@field private playerNode4 BattleStatistics__Generate_playerNode4
---@field private viewDetailBtn BattleStatistics__Generate_viewDetailBtn
---@field private hideBtn BattleStatistics__Generate_hideBtn
---@field private btnSpeed BattleStatistics__Generate_btnSpeed
---@field private btnQuit BattleStatistics__Generate_btnQuit
local BattleStatisticsView = class("BattleStatisticsView")

function BattleStatisticsView:ctor()
end

---@private
function BattleStatisticsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BattleStatisticsView:InitGenerate(Root, data)
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
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)


end

---@private
function BattleStatisticsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.canvas = Root:GetComponent(Enum.TypeInfo.Canvas)
end

---@private
function BattleStatisticsView:InitGenerate__2(Root, data)
--[[
	BattleCountAnim
--]]
	local tmp = Root:Find("BattleCountAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleCountAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function BattleStatisticsView:InitGenerate__3(Root, data)
--[[
	BattleCountAnim/Player1
--]]
	local tmp = Root:Find("BattleCountAnim/Player1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__4(Root, data)
--[[
	BattleCountAnim/Player1/Name
--]]
	local tmp = Root:Find("BattleCountAnim/Player1/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__5(Root, data)
--[[
	BattleCountAnim/Player1/Icon
--]]
	local tmp = Root:Find("BattleCountAnim/Player1/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__6(Root, data)
--[[
	BattleCountAnim/Player1/Percentage
--]]
	local tmp = Root:Find("BattleCountAnim/Player1/Percentage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.percent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__7(Root, data)
--[[
	BattleCountAnim/Player1/Value/TotalSlider
--]]
	local tmp = Root:Find("BattleCountAnim/Player1/Value/TotalSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.totalProgress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__8(Root, data)
--[[
	BattleCountAnim/Player1/Value/Slider
--]]
	local tmp = Root:Find("BattleCountAnim/Player1/Value/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode1.progress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__9(Root, data)
--[[
	BattleCountAnim/Player2
--]]
	local tmp = Root:Find("BattleCountAnim/Player2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__10(Root, data)
--[[
	BattleCountAnim/Player2/Name
--]]
	local tmp = Root:Find("BattleCountAnim/Player2/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__11(Root, data)
--[[
	BattleCountAnim/Player2/Icon
--]]
	local tmp = Root:Find("BattleCountAnim/Player2/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__12(Root, data)
--[[
	BattleCountAnim/Player2/Percentage
--]]
	local tmp = Root:Find("BattleCountAnim/Player2/Percentage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.percent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__13(Root, data)
--[[
	BattleCountAnim/Player2/Value/TotalSlider
--]]
	local tmp = Root:Find("BattleCountAnim/Player2/Value/TotalSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.totalProgress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__14(Root, data)
--[[
	BattleCountAnim/Player2/Value/Slider
--]]
	local tmp = Root:Find("BattleCountAnim/Player2/Value/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode2.progress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__15(Root, data)
--[[
	BattleCountAnim/Player3
--]]
	local tmp = Root:Find("BattleCountAnim/Player3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__16(Root, data)
--[[
	BattleCountAnim/Player3/Name
--]]
	local tmp = Root:Find("BattleCountAnim/Player3/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__17(Root, data)
--[[
	BattleCountAnim/Player3/Icon
--]]
	local tmp = Root:Find("BattleCountAnim/Player3/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__18(Root, data)
--[[
	BattleCountAnim/Player3/Percentage
--]]
	local tmp = Root:Find("BattleCountAnim/Player3/Percentage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.percent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__19(Root, data)
--[[
	BattleCountAnim/Player3/Value/TotalSlider
--]]
	local tmp = Root:Find("BattleCountAnim/Player3/Value/TotalSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.totalProgress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__20(Root, data)
--[[
	BattleCountAnim/Player3/Value/Slider
--]]
	local tmp = Root:Find("BattleCountAnim/Player3/Value/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode3.progress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__21(Root, data)
--[[
	BattleCountAnim/Player4
--]]
	local tmp = Root:Find("BattleCountAnim/Player4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__22(Root, data)
--[[
	BattleCountAnim/Player4/Name
--]]
	local tmp = Root:Find("BattleCountAnim/Player4/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__23(Root, data)
--[[
	BattleCountAnim/Player4/Icon
--]]
	local tmp = Root:Find("BattleCountAnim/Player4/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__24(Root, data)
--[[
	BattleCountAnim/Player4/Percentage
--]]
	local tmp = Root:Find("BattleCountAnim/Player4/Percentage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.percent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleStatisticsView:InitGenerate__25(Root, data)
--[[
	BattleCountAnim/Player4/Value/TotalSlider
--]]
	local tmp = Root:Find("BattleCountAnim/Player4/Value/TotalSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.totalProgress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__26(Root, data)
--[[
	BattleCountAnim/Player4/Value/Slider
--]]
	local tmp = Root:Find("BattleCountAnim/Player4/Value/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode4.progress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function BattleStatisticsView:InitGenerate__27(Root, data)
--[[
	BattleCountAnim/ClickToMore/RaycastArea
--]]
	local tmp = Root:Find("BattleCountAnim/ClickToMore/RaycastArea").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.viewDetailBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleStatisticsView:InitGenerate__28(Root, data)
--[[
	BattleCountAnim/Button
--]]
	local tmp = Root:Find("BattleCountAnim/Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hideBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleStatisticsView:InitGenerate__29(Root, data)
--[[
	BtnSpeed
--]]
	local tmp = Root:Find("BtnSpeed").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSpeed = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleStatisticsView:InitGenerate__30(Root, data)
--[[
	BtnSpeed/Speed1
--]]
	local tmp = Root:Find("BtnSpeed/Speed1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSpeed.speed1 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__31(Root, data)
--[[
	BtnSpeed/Speed2
--]]
	local tmp = Root:Find("BtnSpeed/Speed2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSpeed.speed2 = tmp
end

---@private
function BattleStatisticsView:InitGenerate__32(Root, data)
--[[
	BtnQuit
--]]
	local tmp = Root:Find("BtnQuit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnQuit = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleStatisticsView:GenerateDestroy()
	if tolua.getpeer(self.btnSpeed.speed2) ~= nil then
		tolua.setpeer(self.btnSpeed.speed2, nil)
	end
	if tolua.getpeer(self.btnSpeed.speed1) ~= nil then
		tolua.setpeer(self.btnSpeed.speed1, nil)
	end
	if tolua.getpeer(self.playerNode4.progress) ~= nil then
		tolua.setpeer(self.playerNode4.progress, nil)
	end
	if tolua.getpeer(self.playerNode4.totalProgress) ~= nil then
		tolua.setpeer(self.playerNode4.totalProgress, nil)
	end
	if tolua.getpeer(self.playerNode4.percent) ~= nil then
		tolua.setpeer(self.playerNode4.percent, nil)
	end
	if tolua.getpeer(self.playerNode4.jobIcon) ~= nil then
		tolua.setpeer(self.playerNode4.jobIcon, nil)
	end
	if tolua.getpeer(self.playerNode4.playerName) ~= nil then
		tolua.setpeer(self.playerNode4.playerName, nil)
	end
	if tolua.getpeer(self.playerNode3.progress) ~= nil then
		tolua.setpeer(self.playerNode3.progress, nil)
	end
	if tolua.getpeer(self.playerNode3.totalProgress) ~= nil then
		tolua.setpeer(self.playerNode3.totalProgress, nil)
	end
	if tolua.getpeer(self.playerNode3.percent) ~= nil then
		tolua.setpeer(self.playerNode3.percent, nil)
	end
	if tolua.getpeer(self.playerNode3.jobIcon) ~= nil then
		tolua.setpeer(self.playerNode3.jobIcon, nil)
	end
	if tolua.getpeer(self.playerNode3.playerName) ~= nil then
		tolua.setpeer(self.playerNode3.playerName, nil)
	end
	if tolua.getpeer(self.playerNode2.progress) ~= nil then
		tolua.setpeer(self.playerNode2.progress, nil)
	end
	if tolua.getpeer(self.playerNode2.totalProgress) ~= nil then
		tolua.setpeer(self.playerNode2.totalProgress, nil)
	end
	if tolua.getpeer(self.playerNode2.percent) ~= nil then
		tolua.setpeer(self.playerNode2.percent, nil)
	end
	if tolua.getpeer(self.playerNode2.jobIcon) ~= nil then
		tolua.setpeer(self.playerNode2.jobIcon, nil)
	end
	if tolua.getpeer(self.playerNode2.playerName) ~= nil then
		tolua.setpeer(self.playerNode2.playerName, nil)
	end
	if tolua.getpeer(self.playerNode1.progress) ~= nil then
		tolua.setpeer(self.playerNode1.progress, nil)
	end
	if tolua.getpeer(self.playerNode1.totalProgress) ~= nil then
		tolua.setpeer(self.playerNode1.totalProgress, nil)
	end
	if tolua.getpeer(self.playerNode1.percent) ~= nil then
		tolua.setpeer(self.playerNode1.percent, nil)
	end
	if tolua.getpeer(self.playerNode1.jobIcon) ~= nil then
		tolua.setpeer(self.playerNode1.jobIcon, nil)
	end
	if tolua.getpeer(self.playerNode1.playerName) ~= nil then
		tolua.setpeer(self.playerNode1.playerName, nil)
	end
	if tolua.getpeer(self.battleCountAnim) ~= nil then
		tolua.setpeer(self.battleCountAnim, nil)
	end
	self.battleCountAnim = nil
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
	if tolua.getpeer(self.viewDetailBtn) ~= nil then
		tolua.setpeer(self.viewDetailBtn, nil)
	end
	self.viewDetailBtn = nil
	if tolua.getpeer(self.hideBtn) ~= nil then
		tolua.setpeer(self.hideBtn, nil)
	end
	self.hideBtn = nil
	if tolua.getpeer(self.btnSpeed) ~= nil then
		tolua.setpeer(self.btnSpeed, nil)
	end
	self.btnSpeed = nil
	if tolua.getpeer(self.btnQuit) ~= nil then
		tolua.setpeer(self.btnQuit, nil)
	end
	self.btnQuit = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BattleStatisticsView