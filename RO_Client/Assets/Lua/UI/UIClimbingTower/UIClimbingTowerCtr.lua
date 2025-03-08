local UIClimbingTowerCtr = class("UIClimbingTowerCtr", require("UICtrBase"))

local TowerDataMgr = ManagerContainer.DataMgr.TowerDataMgr
local PeakTowerDataMgr = ManagerContainer.DataMgr.PeakTowerDataMgr

function UIClimbingTowerCtr:Init(view)
	self.view = view
end

function UIClimbingTowerCtr:SetData(data)
	self:GetLastUITowerType()
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerCtr:GetData()
	return self.data
end

function UIClimbingTowerCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerCtr:GetLastUITowerType()
	self.type = PeakTowerDataMgr:GetCurUITowerType()
	return self.type
end

function UIClimbingTowerCtr:ChangeToOtherType()
	self.type = 1 - self.type
	self:SaveCurUITowerType(self.type)
end

function UIClimbingTowerCtr:SaveCurUITowerType()
	PeakTowerDataMgr:SaveCurUITowerType(self.type)
end

function UIClimbingTowerCtr:GetCurTowerType()
	return self.type
end	

function UIClimbingTowerCtr:SendTowerInfoReq(type)
	local changeTower = type ~= nil
	if not type then
		type = self.type
	end
	local needQuery = self:NeedQueryNewDataList(type)
	if type == Enum.UnlimitTowerType.ClimbingTower then
		if needQuery then
			TowerDataMgr:SendClimbingTowerInfoReq(changeTower)
		end
	elseif type == Enum.UnlimitTowerType.PeakTower then
		if needQuery then
			PeakTowerDataMgr:SendTowerFightListReq(changeTower)
		end
	end
	return needQuery
end 

function UIClimbingTowerCtr:GetLevelsData()
	return TowerDataMgr:GetShowLevels()
end

function UIClimbingTowerCtr:CurrentLevel()
	self.curPeakTowerFloorIdx = TowerDataMgr:GetCurChallengeLevel()
end

function UIClimbingTowerCtr:GetLevelInfo(levelId)
	return TowerDataMgr:FindLevelData(levelId)
end

function UIClimbingTowerCtr:EnterBattle(levelId)
	-- TowerDataMgr:EnterBattle(levelId)
	TowerDataMgr:SendClimbingTowerBeginReq(levelId)
end

function UIClimbingTowerCtr:SendFriendPassTowerInfo()
	if self.tempFriendLevelNum  < 1 then
		return
	end

	local startIdx = self.tempFriendLevelNum - 10
	if startIdx < 1 then
		startIdx = 1
	end

	TowerDataMgr:SendFriendPassTowerInfoReq(startIdx,self.tempFriendLevelNum)

	self.tempFriendLevelNum = self.tempFriendLevelNum - 10
end

function UIClimbingTowerCtr:SetTempFriendLevelNum()
	self.tempFriendLevelNum = TowerDataMgr:GetCurChallengeLevel()
end

function UIClimbingTowerCtr:GetPeakTowerListDatas()
	return PeakTowerDataMgr:GetTowerFightList()
end

function UIClimbingTowerCtr:RefreshTowerDatas()
	if self.type == Enum.UnlimitTowerType.ClimbingTower then
		self:SetTempFriendLevelNum()
		self:CurrentLevel()
		self.showDatas = self:GetLevelsData()
	elseif self.type == Enum.UnlimitTowerType.PeakTower then
		self.showDatas = self:GetPeakTowerListDatas()
		self.curPeakTowerFloorIdx = 1000
		for _,v in pairs(self.showDatas) do
			local idx = v.floorIdx
			local rewardState = v:GetRoleRewardState()
			if self.curPeakTowerFloorIdx > idx and not rewardState then
				self.curPeakTowerFloorIdx = idx
			end
		end
	end
end

function UIClimbingTowerCtr:GetCurTowerFloorIdx()
	return self.curPeakTowerFloorIdx
end

function UIClimbingTowerCtr:GetShowDataLength()
	return self.showDatas and #self.showDatas or 0
end

function UIClimbingTowerCtr:GetShowDataByIdx(idx)
	return self.showDatas and self.showDatas[idx + 1] or nil
end

function UIClimbingTowerCtr:SendPeakTowerBuyReq(idx)
	PeakTowerDataMgr:SendTowerForceWinReq(idx)
end

function UIClimbingTowerCtr:SendChallengeReq(idx)
	PeakTowerDataMgr:SendChallengeReq(idx)
end

function UIClimbingTowerCtr:EnterPeakTowerChallengeBattle(idx)
	PeakTowerDataMgr:EnterBattle(idx, {})
end

function UIClimbingTowerCtr:ShowPlayerInfo(uid)
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIClimbingTowerCtr:NeedQueryNewDataList(type)
	if type == Enum.UnlimitTowerType.ClimbingTower then
		return true
	elseif type == Enum.UnlimitTowerType.PeakTower then
		return ManagerContainer.DataMgr.PeakTowerDataMgr:NeedRefreshFightList()
	end
	return false
end

function UIClimbingTowerCtr:QueryCrossFightInfo(idx)
	PeakTowerDataMgr:QueryCrossChallengeInfoReq(idx)
end

return UIClimbingTowerCtr

