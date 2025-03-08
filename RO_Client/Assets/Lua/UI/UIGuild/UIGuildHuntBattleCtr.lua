local UIGuildHuntBattleCtr = class("UIGuildHuntBattleCtr", require("UICtrBase"))

function UIGuildHuntBattleCtr:Init(view)
	self.view = view
end

function UIGuildHuntBattleCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
end

function UIGuildHuntBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildHuntBattleCtr:GetData()
	return self.data
end

function UIGuildHuntBattleCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.rewardRanges = nil
	self.rewards = nil
	self.rewardIcons = nil
	self.bossName = nil
end


function UIGuildHuntBattleCtr:InitData()
	self.rewardRanges = nil
	self.rewardIcons = nil
	self.rewardIdx = nil

	local bossId = ManagerContainer.DataMgr.GuildDataMgr:GetHuntBattleBossId()
	if not bossId then return end
	local bossCfgData = ManagerContainer.CfgMgr:GetGuildHuntBossCfgById(bossId)
	if not bossCfgData then return end
	local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(bossCfgData.SummonId)
	if npcCfgData then
		self.bossName = npcCfgData.Name
	end
	local damageSegment = bossCfgData.DamageSegment
	if not damageSegment or damageSegment <= 0 then
		return
	end
	local rewardRanges = bossCfgData.RewardRange
	if not rewardRanges then
		return
	end
	local rewardRangeLength = #rewardRanges
	if rewardRangeLength < damageSegment then
		return
	end
	self.rewardRanges = rewardRanges
	self.rewardIcons = bossCfgData.DamageSegmeReward
	self.rewardIdx = 1

	-- self:RefreshDamage()
end

function UIGuildHuntBattleCtr:RefreshDamage()
	local damage = self:GetCurDamage()
	if not self.rewardRanges then return false end
	local newRewardIdx = self.rewardIdx
	for i = self.rewardIdx, #self.rewardRanges do
		local rewardRange = self.rewardRanges[i]
		if damage < rewardRange[1] then
			break
		end
		newRewardIdx = i
		if damage < rewardRange[2] then
			break
		end
	end
	if newRewardIdx == self.rewardIdx then
		return false
	end
	self.rewardIdx = newRewardIdx
	return true
end

function UIGuildHuntBattleCtr:GetCurDamage()
	local hurtValue = ManagerContainer.DataMgr.GuildDataMgr:GetRecordHurtValue()
	hurtValue = Mathf.Floor(hurtValue)
	return hurtValue
end

function UIGuildHuntBattleCtr:GetCurDamagePercent()
	if not self.rewardRanges then return 1 end
	local rewardRange = self.rewardRanges[self.rewardIdx]
	if not rewardRange then return 1 end
	local damage = self:GetCurDamage()
	damage = damage - rewardRange[1]
	local maxDamage = rewardRange[2] - rewardRange[1]
	if maxDamage <= 0 then return 1 end
	return Mathf.Clamp01(damage / maxDamage)
end

function UIGuildHuntBattleCtr:GetCurRewardRange()
	if not self.rewardRanges then return 0, 0 end
	local rewardRange = self.rewardRanges[self.rewardIdx]
	if not rewardRange then return 0, 0 end
	return rewardRange[1] or 0, rewardRange[2] or 0
end

function UIGuildHuntBattleCtr:GetRewardIcon()
	if not self.rewardIcons then return nil end
	return self.rewardIcons[self.rewardIdx]
end

function UIGuildHuntBattleCtr:GetRewardNum()
	return self.rewardIdx or 0
end


function UIGuildHuntBattleCtr:GetBossName()
	return self.bossName
end

function UIGuildHuntBattleCtr:FightingTime()
	return ManagerContainer.LuaTimeBattleMgr:GetLeftFightingTime()
end

return UIGuildHuntBattleCtr

