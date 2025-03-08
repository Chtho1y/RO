local UIClimbingTowerBattleWinCtr = class("UIClimbingTowerBattleWinCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr


function UIClimbingTowerBattleWinCtr:Init(view)
	self.view = view
end

function UIClimbingTowerBattleWinCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerBattleWinCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerBattleWinCtr:GetData()
	return self.data
end

function UIClimbingTowerBattleWinCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerBattleWinCtr:BackPageId()
	if self.data == nil then
		return 0
	end

	return self.data[1]
end

function UIClimbingTowerBattleWinCtr:EnterNextBattle()
	TowerDataMgr:SendClimbingTowerBeginReq(TowerDataMgr:GetCurChallengeLevel())
end

function UIClimbingTowerBattleWinCtr:GetLevelRewards()
	if self.data == nil then
		return nil
	end

	return self.data[2]
	-- local levelInfo = TowerDataMgr:GetCurrentLevelInfo()
	-- if levelInfo ~= nil then
	-- 	return levelInfo:GetRewards()
	-- end
	-- return nil
end

function UIClimbingTowerBattleWinCtr:GetLastUITowerType()
	self.type = ManagerContainer.DataMgr.PeakTowerDataMgr:GetCurUITowerType()
	return self.type
end

return UIClimbingTowerBattleWinCtr

