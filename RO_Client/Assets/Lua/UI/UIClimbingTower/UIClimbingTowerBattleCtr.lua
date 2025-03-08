local UIClimbingTowerBattleCtr = class("UIClimbingTowerBattleCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr


function UIClimbingTowerBattleCtr:Init(view)
	self.view = view
end

function UIClimbingTowerBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerBattleCtr:GetData()
	return self.data
end

function UIClimbingTowerBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerBattleCtr:FightingTime()
	return ManagerContainer.LuaTimeBattleMgr:GetLeftFightingTime()
end

function UIClimbingTowerBattleCtr:GetReplayRecord()
	return TowerDataMgr.isPlayRecord, TowerDataMgr.recordLevelId
end

return UIClimbingTowerBattleCtr

