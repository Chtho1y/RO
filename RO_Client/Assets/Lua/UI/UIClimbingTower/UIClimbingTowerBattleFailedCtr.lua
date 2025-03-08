local UIClimbingTowerBattleFailedCtr = class("UIClimbingTowerBattleFailedCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr

function UIClimbingTowerBattleFailedCtr:Init(view)
	self.view = view
end

function UIClimbingTowerBattleFailedCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerBattleFailedCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerBattleFailedCtr:GetData()
	return self.data
end

function UIClimbingTowerBattleFailedCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerBattleFailedCtr:ReEnterBattle()
	-- TowerDataMgr:EnterBattle(TowerDataMgr:GetCurChallengeLevel())
	TowerDataMgr:SendClimbingTowerBeginReq(TowerDataMgr:GetCurChallengeLevel())
end

return UIClimbingTowerBattleFailedCtr

