local UIGuildHuntCtr = class("UIGuildHuntCtr", require("UICtrBase"))

function UIGuildHuntCtr:Init(view)
	self.view = view
end

function UIGuildHuntCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildHuntCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildHuntCtr:GetData()
	return self.data
end

function UIGuildHuntCtr:OnDispose()
	self.data = nil
	self.view = nil

	if self.guildData then
		self.guildData:ClearHuntBoss()
	end

	self.guildData = nil
	self.curBossIdx = nil
	self.bossListNum = nil
	self.bossList = nil
end

function UIGuildHuntCtr:InitData()
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	self.bossList = nil
	self.curBossIdx = nil
end

function UIGuildHuntCtr:GetGuildMinePost()
	return self.guildData:GetGuildMemberPost(ManagerContainer.DataMgr.UserData:GetUserId())
end

function UIGuildHuntCtr:GetGuildLv()
	local briefData = self.guildData:GetBriefData()
	return briefData and briefData.level or 0
end

function UIGuildHuntCtr:RefreshBossList()
	local ls = {}
	local lastSelectBoss = nil
	if self.bossList then
		if self.curBossIdx then
			lastSelectBoss = self.bossList[self.curBossIdx]
			if lastSelectBoss then
				lastSelectBoss = lastSelectBoss.Id
			end
		elseif self.data then
			lastSelectBoss = self.data
		end
	else
		lastSelectBoss = self.data
	end
	local cfgDatas = ManagerContainer.CfgMgr:GetGuildHuntBossCfg()
	if cfgDatas then
		for id, value in pairs(cfgDatas) do
			if self.guildData:GetHuntBossInfoById(id) then
				ls[#ls + 1] = value
			end
		end
	end
	table.sort(ls, function (a, b)
		return a.Id < b.Id
	end)

	local num = #ls
	local curBossIdx = nil
	if lastSelectBoss then
		for i = 1, num do
			if ls[i].Id == lastSelectBoss then
				curBossIdx = i
				break
			end
		end
	end
	if curBossIdx then
		self.curBossIdx = curBossIdx
	else
		if num > 0 then
			self.curBossIdx = 1
		else
			self.curBossIdx = nil
		end
	end
	self.bossListNum = num
	self.bossList = ls
end

function UIGuildHuntCtr:ContainBoss(id)
	if not self.bossList then return false end
	for _, value in pairs(self.bossList) do
		if value.Id == id then
			return true
		end
	end
	return false
end

function UIGuildHuntCtr:GetBossInfoList()
	return self.bossList
end

function UIGuildHuntCtr:GetCurGuildActive()
	local briefData = self.guildData:GetBriefData()
	return briefData and briefData.active or 0
end

function UIGuildHuntCtr:CanMove()
	if not self.curBossIdx or not self.bossListNum or self.bossListNum <= 0 then
		return false, false
	end
	return (self.curBossIdx > 1), (self.curBossIdx < self.bossListNum)
end

function UIGuildHuntCtr:GetCurBossId()
	if not self.bossList then return nil end
	local curBossCfgData = self.bossList[self.curBossIdx]
	if curBossCfgData then
		return curBossCfgData.Id
	end
	return nil
end

function UIGuildHuntCtr:GetCurBossInfo()
	if not self.bossList then return nil, nil end
	local curBossCfgData = self.bossList[self.curBossIdx]
	if curBossCfgData then
		return curBossCfgData, self.guildData:GetHuntBossInfoById(curBossCfgData.Id)
	end
	return nil, nil
end

function UIGuildHuntCtr:GetHuntBossCd()
	return self.guildData:GetHuntBossCd()
end

function UIGuildHuntCtr:ChangeBoss(next)
	if self.bossListNum <= 0 then return false end
	local newBossIdx = nil
	if next then
		newBossIdx = self.curBossIdx + 1
	else
		newBossIdx = self.curBossIdx - 1
	end
	if newBossIdx <= 0 then
		return false
	end
	if newBossIdx > self.bossListNum then
		return false
	end
	self.curBossIdx = newBossIdx
	return true
end

function UIGuildHuntCtr:GetNearNeedUpdateRemainTime()
	if not self.bossList then return 0 end
	local remainTime = nil
	for _, value in pairs(self.bossList) do
		local bossData = self.guildData:GetHuntBossInfoById(value.Id)
		if bossData then
			if bossData.fightTime and bossData.fightTime > 0 then
				local newRemainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightTime + 2000)
				if newRemainTime > 0 then
					if not remainTime or remainTime > newRemainTime then
						remainTime = newRemainTime
					end
				end
			elseif bossData.fightCdTime and bossData.fightCdTime > 0 then
				local newRemainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightCdTime + 2000)
				if newRemainTime > 0 then
					if not remainTime or remainTime > newRemainTime then
						remainTime = newRemainTime
					end
				end
			end
		end
	end
	return remainTime
end

function UIGuildHuntCtr:ExtraChallengeNum()
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	return vipCfg and vipCfg.GuildBossChallenge or 0
end

function UIGuildHuntCtr:ChallengeBoss()
	local bossId = self:GetCurBossId()
	if not bossId then
		return
	end
	ManagerContainer.DataMgr.GuildDataMgr:StartGuildHuntBattle(bossId)
end

function UIGuildHuntCtr:SendGuildHuntBossListInfoReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildHuntBossListInfoReq() then
		return 100007
	end
	return 0
end

function UIGuildHuntCtr:SendGuildHuntBossSummonReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildHuntBossSummonReq(self:GetCurBossId()) then
		return 100007
	end
	return 0
end

return UIGuildHuntCtr

