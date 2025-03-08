local UIHundredDojoCtr = class("UIHundredDojoCtr", require("UICtrBase"))

function UIHundredDojoCtr:Init(view)
	self.view = view
end

function UIHundredDojoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoCtr:GetData()
	return self.data
end

function UIHundredDojoCtr:OnDispose()
	self.areaMaxId = nil
	self.rawCount = nil
	self.rewardMaxTime = nil
	self.rewardInterval = nil
	self.rewardRate = nil
	self.baseRewards = nil
	self.buyCosts = nil
	self.defaultHeroCute = nil
	self.robotHeroCute = nil
	self.showRawIdxs = nil
	self.sloganStartTime = nil
	self.sloganShowTime = nil
	self.sloganHideTime = nil
	self.sloganNumMax = nil
	self.lastAttackAreaId = nil

	self.data = nil
	self.view = nil
end

function UIHundredDojoCtr:InitData()
	self.areaMaxId = ManagerContainer.DataMgr.HundredDojoDataMgr:GetAreaMaxId()
	self:CalcRawCount()
	self.rewardMaxTime = GlobalConfig.Instance:GetConfigIntValue(255) * 3600
	self.rewardInterval = GlobalConfig.Instance:GetConfigIntValue(252)
	if self.rewardInterval <= 0 then self.rewardInterval = 1 end
	self.rewardRate = 60 / self.rewardInterval
	local baseRewardStr = GlobalConfig.Instance:GetConfigStrValue(301)
	self.baseRewards = CommonUtil.DeserializeGlobalStrToNumberTable(baseRewardStr)
	local costStr = GlobalConfig.Instance:GetConfigStrValue(265)
	self.buyCosts = CommonUtil.DeserializeGlobalStrToNumberTable(costStr)
	self.defaultHeroCute = GlobalConfig.Instance:GetConfigStrValue(259)
	self.robotHeroCute = GlobalConfig.Instance:GetConfigStrValue(258)
	local sloganShowStr = GlobalConfig.Instance:GetConfigStrValue(277)
	local sloganShowInfos = CommonUtil.DeserializeGlobalStrToNumberTable(sloganShowStr)
	self.sloganStartTime = 2
	self.sloganShowTime = 5
	self.sloganHideTime = 5
	if sloganShowInfos then
		if sloganShowInfos[1] then
			self.sloganStartTime = sloganShowInfos[1]
		end
		if sloganShowInfos[2] then
			self.sloganShowTime = sloganShowInfos[2]
		end
		if sloganShowInfos[3] then
			self.sloganHideTime = sloganShowInfos[3]
		end
	end
	self.sloganNumMax = GlobalConfig.Instance:GetConfigIntValue(278) or 5

	self.showRawIdxs = {}
	self.lastAttackAreaId = ManagerContainer.DataMgr.HundredDojoDataMgr:GetLastAttackAreaId()
	ManagerContainer.DataMgr.HundredDojoDataMgr:ClearLastAttackAreaId()
end

function UIHundredDojoCtr:GetChallengeCount()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetChallengeCount()
end

function UIHundredDojoCtr:GetBuyChallengeCount()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetBuyChallengeCount()
end

function UIHundredDojoCtr:GetBuyChallengeCountCost()
	local buyCount = self:GetBuyChallengeCount()
	if self.buyCosts then
		buyCount = Mathf.Clamp(buyCount + 1, 1, #self.buyCosts)
		local buyCost = self.buyCosts[buyCount]
		if buyCost then
			return buyCost[1], buyCost[2]
		end
	end
	return 1, 100
end

function UIHundredDojoCtr:GetAreaMaxId()
	return self.areaMaxId
end

function UIHundredDojoCtr:CalcRawCount()
	local normalAreaMaxId = (self.areaMaxId - 1)
	local rawCount = Mathf.Floor(normalAreaMaxId / 5)
	local remain = (normalAreaMaxId - rawCount * 5)
	rawCount = rawCount * 2
	if remain > 2 then
		rawCount = rawCount + 2
	elseif remain > 0 then
		rawCount = rawCount + 1
	end
	self.rawCount = rawCount + 1
end

function UIHundredDojoCtr:GetRawCount()
	return self.rawCount
end

function UIHundredDojoCtr:GetRawAreaStartAndEnd(rawIdx)
	if rawIdx == 0 then
		return 1, 1
	end
	local count = Mathf.Floor(rawIdx / 2) * 5 + 1
	local remain = rawIdx % 2
	local startId, endId
	if remain == 1 then
		startId = count + 1
		endId = count + 2
	else
		startId = count - 2
		endId = count
	end
	if startId > self.areaMaxId then
		startId = self.areaMaxId
	end
	if endId > self.areaMaxId then
		endId = self.areaMaxId
	end
	return startId, endId
end

function UIHundredDojoCtr:GetRawIdxByAreaId(areaId)
	if areaId == 1 then
		return 0, 1
	end
	local normalAreaMaxId = (areaId - 1)
	local rawIdx = Mathf.Floor(normalAreaMaxId / 5)
	local remain = (normalAreaMaxId - rawIdx * 5)
	rawIdx = rawIdx * 2
	if remain > 2 then
		rawIdx = rawIdx + 1
		remain = remain - 2
	elseif remain == 0 then
		rawIdx = rawIdx - 1
		remain = 3
	elseif remain < 0 then
		LogError('[wboy] calc error ' .. tostring(areaId))
	end
	return rawIdx + 1, remain
end

function UIHundredDojoCtr:AddShowRawIdx(rawIdx)
	if not CommonUtil.EleInTable(rawIdx, self.showRawIdxs) then
		self.showRawIdxs[#self.showRawIdxs+1] = rawIdx
	end
end

function UIHundredDojoCtr:RemoveShowRawIdx(rawIdx)
	for k,v in pairs(self.showRawIdxs) do
        if v == rawIdx then
			table.remove(self.showRawIdxs, k)
			break
        end
    end
end

function UIHundredDojoCtr:GetShowRawIdxs()
	return self.showRawIdxs
end

function UIHundredDojoCtr:IsSelfArea(id)
	local selfAreaData = self:GetSelfAreaData()
	if selfAreaData and selfAreaData:IsValidData() and (selfAreaData.id == id) then
		return true
	end
	return false
end

function UIHundredDojoCtr:IsLastBeAtkArea(uid)
	if not uid then
		return false
	end
	local lastBeAtkUid = ManagerContainer.DataMgr.HundredDojoDataMgr:GetLastBeAttackUid()
	if not lastBeAtkUid then
		return false
	end
	return int64.equals(lastBeAtkUid, uid)
end

function UIHundredDojoCtr:IsSameGuild(guildId)
	local guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	if guildData then
		return guildData:IsSameGuild(guildId)
	end
	return false
end

function UIHundredDojoCtr:ForceHandleRewardRedPoint()
	ManagerContainer.DataMgr.HundredDojoDataMgr:HandleRewardRedPoint()
end

function UIHundredDojoCtr:GetUserNickname()
    return ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function UIHundredDojoCtr:GetTotalFightPower()
    return ManagerContainer.DataMgr.UserData:GetTotalFightPower()
end

function UIHundredDojoCtr:GetUserRoleId()
    return ManagerContainer.DataMgr.UserData:GetUserRoleId()
end

function UIHundredDojoCtr:GetSelfAreaData()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetSelfAreaData()
end

function UIHundredDojoCtr:GetAreaDataById(id)
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetAreaDataById(id)
end

function UIHundredDojoCtr:GetBaseRewardStartTime()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetBaseRewardStartTime()
end

function UIHundredDojoCtr:GetLastAttackAreaId()
    return self.lastAttackAreaId
end

function UIHundredDojoCtr:GetRewardMaxTime()
	return self.rewardMaxTime
end

function UIHundredDojoCtr:GetRewardInterval()
	return self.rewardInterval
end

function UIHundredDojoCtr:GetRewardRate()
	return self.rewardRate
end

function UIHundredDojoCtr:GetBaseRewards()
	return self.baseRewards
end

function UIHundredDojoCtr:GetDefaultHeroCute()
	return self.defaultHeroCute
end

function UIHundredDojoCtr:GetRobotHeroCute()
	return self.robotHeroCute
end

function UIHundredDojoCtr:GetSloganStartTime()
	return self.sloganStartTime
end

function UIHundredDojoCtr:GetSloganShowTime()
	return self.sloganShowTime
end

function UIHundredDojoCtr:GetSloganHideTime()
	return self.sloganHideTime
end

function UIHundredDojoCtr:GetSloganNumMax()
	return self.sloganNumMax
end

function UIHundredDojoCtr:IsTreasureShow()
	if (ManagerContainer.DataMgr.CompetitionData:GetCurMaxSeason() == 3) then
		local stage = ManagerContainer.DataMgr.CompetitionData:GetCurStageAndNextTime(true)
		return (stage == 2)
	end
	return false
end


function UIHundredDojoCtr:GetSelfSlogan()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetSlogan()
end

function UIHundredDojoCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end


function UIHundredDojoCtr:SendGetSelfInfoReq()
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetAreaInfoReq(ManagerContainer.DataMgr.UserData:GetUserId()) then
		return 100007
	end
	return 0
end

function UIHundredDojoCtr:SendGetOtherInfosReq(areaIds)
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetOtherInfosReq(areaIds) then
		return 100007
	end
	return 0
end

function UIHundredDojoCtr:SendGetRewardReq()
	local baseRewardTime = self:GetBaseRewardStartTime()
	local remainTime = 0
	if baseRewardTime then
		remainTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime() - baseRewardTime
		remainTime = remainTime / 1000
		if type(remainTime) == 'userdata' then
			remainTime = #remainTime
		end
	end
	if remainTime < self:GetRewardInterval() then
		return 250
	end
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetRewardReq() then
		return 100007
	end
	return 0
end

function UIHundredDojoCtr:SendBuyChallengeNumReq()
	local costCfgId, costNum = self:GetBuyChallengeCountCost()
	local ownNum = self:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		return 1, costCfgId
	end
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendBuyChallengeNumReq() then
		return 100007, nil
	end
	return 0, nil
end

return UIHundredDojoCtr

