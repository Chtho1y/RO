local UIClimbingTowerRankCtr = class("UIClimbingTowerRankCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr
local PeakTowerDataMgr = ManagerContainer.DataMgr.PeakTowerDataMgr

function UIClimbingTowerRankCtr:Init(view)
	self.view = view
end

function UIClimbingTowerRankCtr:SetData(data)
	self:GetLastUITowerType()
	self:SendTowerRankInfoReq()
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerRankCtr:GetData()
	return self.data
end

function UIClimbingTowerRankCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerRankCtr:GetLastUITowerType()
	self.type = PeakTowerDataMgr:GetCurUITowerType()
	return self.type
end

function UIClimbingTowerRankCtr:ChangeToOtherType()
	self.type = 1 - self.type
end

function UIClimbingTowerRankCtr:GetCurTowerType()
	return self.type
end	

function UIClimbingTowerRankCtr:SendTowerRankInfoReq()
	if self.type == Enum.UnlimitTowerType.ClimbingTower then
		TowerDataMgr:SendClimbingTowerRankReq()
	elseif self.type == Enum.UnlimitTowerType.PeakTower then
		PeakTowerDataMgr:SendForceWinRankListReq(1)
	end
end 

function UIClimbingTowerRankCtr:GetSelfPassedTime()
	return TowerDataMgr.lastPassedTime
end

function UIClimbingTowerRankCtr:GetRankData()
	if self.type == Enum.UnlimitTowerType.ClimbingTower then
		return TowerDataMgr:GetRankList()
	elseif self.type == Enum.UnlimitTowerType.PeakTower then
		return PeakTowerDataMgr:GetForceWinRankList()
	end
end

function UIClimbingTowerRankCtr:GetSelfRank()
	return TowerDataMgr.selfRank
end

function UIClimbingTowerRankCtr:GetCurLevelNum()
	return TowerDataMgr:GetCurChallengeLevel()
end

function UIClimbingTowerRankCtr:ReqestRankBriefData()
	if self.type == Enum.UnlimitTowerType.ClimbingTower then
		local uid_list = TowerDataMgr:GetRankUidList(10)
		TowerDataMgr:ReqTowerRankBriefData(uid_list)
	elseif self.type == Enum.UnlimitTowerType.PeakTower then

	end
end

function UIClimbingTowerRankCtr:GetPeakTowerSelfRankIdx()
	return PeakTowerDataMgr:GetSeflRankIdx()
end

function UIClimbingTowerRankCtr:GetPeakTowerSelfRankScore()
	return PeakTowerDataMgr:GetSeflRankScore()
end

return UIClimbingTowerRankCtr

