local UIWorldBossRewardCtr = class("UIWorldBossRewardCtr", require("UICtrBase"))

function UIWorldBossRewardCtr:Init(view)
	self.view = view
end

function UIWorldBossRewardCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIWorldBossRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWorldBossRewardCtr:GetData()
	return self.data
end

function UIWorldBossRewardCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.worldBossCfgId = nil
	self.rewardList = nil
	self.rewardDatas = nil
	self.rewardOpenIdx = nil
end

function UIWorldBossRewardCtr:InitData()
	local pointInfo = ManagerContainer.DataMgr.WorldBossData:GetWorldBossPointInfo()
	self.worldBossCfgId = pointInfo and pointInfo.bossId or 1
	self.rewardList = pointInfo and pointInfo.rewardList or {3}
	local worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(self:GetWorldBossCfgId(),0)
	if nil == worldBossCfgData then
		worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(self:GetWorldBossCfgId(),1)
	end

	local rewardDatas = {}
	if worldBossCfgData then
		rewardDatas[1] = self:FormatRewardData(worldBossCfgData.FirstReward)
		rewardDatas[2] = self:FormatRewardData(worldBossCfgData.SecondReward)
		rewardDatas[3] = self:FormatRewardData(worldBossCfgData.ThreeReward)
	end
	self.rewardDatas = rewardDatas
	self.rewardOpenIdx = 1
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	self.vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	self.hasSSR = false
end

function UIWorldBossRewardCtr:GetWorldBossCfgId()
	return self.worldBossCfgId
end

function UIWorldBossRewardCtr:GetCurVaildRewardType()
	return self:GetWorldBossRewardTypeById(self.rewardOpenIdx)
end

function UIWorldBossRewardCtr:OffsetNextVaildRewardType()
	self.rewardOpenIdx = self.rewardOpenIdx + 1
	local rewardType = self:GetWorldBossRewardTypeById(self.rewardOpenIdx)
	if rewardType then
		return true
	end
	return false
end

function UIWorldBossRewardCtr:GetWorldBossRemainNum()
	return #self.rewardList - self.rewardOpenIdx + 1
end

function UIWorldBossRewardCtr:GetWorldBossRewardTypeById(idx)
	return self.rewardList and self.rewardList[idx] or nil
end

function UIWorldBossRewardCtr:GetWorldBossRewardList()
	return self.rewardList
end

function UIWorldBossRewardCtr:GetWorldBossRewardsByType(rewardType)
	if rewardType then
		local rewardData = self.rewardDatas[rewardType]
		if rewardData then
			return rewardData
		end
	end
	return {cfgId = 1, num = 0}
end

function UIWorldBossRewardCtr:FormatRewardData(rewards)
	if rewards then
		if type(rewards[1]) == 'number' then
			rewards = {rewards}
		end
		local reward = {}
		for i = 1, #rewards do
			reward[#reward + 1] = {cfgId = rewards[i][1], num = rewards[i][2]}
		end
		return reward
	end
	return nil
end

function UIWorldBossRewardCtr:GetVipCfg()
	return self.vipCfg
end

return UIWorldBossRewardCtr

