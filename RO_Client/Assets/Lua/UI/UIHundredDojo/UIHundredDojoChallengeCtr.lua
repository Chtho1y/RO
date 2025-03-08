local UIHundredDojoChallengeCtr = class("UIHundredDojoChallengeCtr", require("UICtrBase"))

function UIHundredDojoChallengeCtr:Init(view)
	self.view = view
end

function UIHundredDojoChallengeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoChallengeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoChallengeCtr:GetData()
	return self.data
end

function UIHundredDojoChallengeCtr:OnDispose()
	self.rewardRate = nil
	self.defaultHeroCute = nil
	self.robotHeroCute = nil
	self.buyCosts = nil
	self.data = nil
	self.view = nil
end

function UIHundredDojoChallengeCtr:InitData()
	local rewardInterval = GlobalConfig.Instance:GetConfigIntValue(252)
	if rewardInterval <= 0 then rewardInterval = 1 end
	self.rewardRate = 60 / rewardInterval
	local costStr = GlobalConfig.Instance:GetConfigStrValue(265)
	self.buyCosts = CommonUtil.DeserializeGlobalStrToNumberTable(costStr)
	self.defaultHeroCute = GlobalConfig.Instance:GetConfigStrValue(259)
	self.robotHeroCute = GlobalConfig.Instance:GetConfigStrValue(258)
end

function UIHundredDojoChallengeCtr:GetRewardRate()
	return self.rewardRate
end

function UIHundredDojoChallengeCtr:GetAreaData()
	if self.data then
		return ManagerContainer.DataMgr.HundredDojoDataMgr:GetAreaDataById(self.data)
	end
	return nil
end

function UIHundredDojoChallengeCtr:GetUserNickname()
    return ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function UIHundredDojoChallengeCtr:GetTotalFightPower()
    return ManagerContainer.DataMgr.UserData:GetTotalFightPower()
end

function UIHundredDojoChallengeCtr:GetUserRoleId()
    return ManagerContainer.DataMgr.UserData:GetUserRoleId()
end


function UIHundredDojoChallengeCtr:GetSelfAreaData()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetSelfAreaData()
end

function UIHundredDojoChallengeCtr:IsSelfArea(id)
	local selfAreaData = self:GetSelfAreaData()
	if selfAreaData and selfAreaData:IsValidData() and (selfAreaData.id == id) then
		return true
	end
	return false
end

function UIHundredDojoChallengeCtr:IsLastBeAtkArea(uid)
	if not uid then
		return false
	end
	local lastBeAtkUid = ManagerContainer.DataMgr.HundredDojoDataMgr:GetLastBeAttackUid()
	if not lastBeAtkUid then
		return false
	end
	return int64.equals(lastBeAtkUid, uid)
end

function UIHundredDojoChallengeCtr:IsSameGuild(guildId)
	local guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	if guildData then
		return guildData:IsSameGuild(guildId)
	end
	return false
end

function UIHundredDojoChallengeCtr:GetDefaultHeroCute()
	return self.defaultHeroCute
end

function UIHundredDojoChallengeCtr:GetRobotHeroCute()
	return self.robotHeroCute
end

function UIHundredDojoChallengeCtr:GetChallengeCount()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetChallengeCount()
end

function UIHundredDojoChallengeCtr:GetBuyChallengeCount()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetBuyChallengeCount()
end

function UIHundredDojoChallengeCtr:GetBuyChallengeCountCost()
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

function UIHundredDojoChallengeCtr:GetSelfSlogan()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetSlogan()
end



function UIHundredDojoChallengeCtr:SendChallengeReq()
	local areaData = self:GetAreaData()
	if not areaData or not areaData:IsValidData() then
		return 1
	end
	if areaData:IsOccupy() then
		local count = self:GetChallengeCount()
		if count < 1 then
			return 2
		end
	end

	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendChallengeReq(self.data) then
		return 100007
	end
	return 0
end

function UIHundredDojoChallengeCtr:SendBuyChallengeNumReq()
	local costCfgId, costNum = self:GetBuyChallengeCountCost()
	local ownNum = CommonUtil.GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		return 1, costCfgId
	end
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendBuyChallengeNumReq() then
		return 100007, nil
	end
	return 0, nil
end

return UIHundredDojoChallengeCtr

