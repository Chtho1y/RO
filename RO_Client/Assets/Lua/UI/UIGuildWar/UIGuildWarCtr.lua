local UIGuildWarCtr = class("UIGuildWarCtr", require("UICtrBase"))

function UIGuildWarCtr:Init(view)
	self.view = view
end

function UIGuildWarCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarCtr:GetData()
	return self.data
end

function UIGuildWarCtr:OnDispose()
	self.battleIdx = nil
	self.rebornMaxTime = nil
	self.buyChallengeCosts = nil
	self.buyRebornCosts = nil
	self.showRawIdxs = nil
	self.lastAttackAreaId = nil
	local battleFieldData = self:GetBattleFieldData()
	if battleFieldData then
		battleFieldData:Clear()
	end

	self.data = nil
	self.view = nil
end

function UIGuildWarCtr:InitData()
	self.battleIdx = self.data
	self.rebornMaxTime = GlobalConfig.Instance:GetConfigIntValue(291)
	local costStr = GlobalConfig.Instance:GetConfigStrValue(295)
	self.buyChallengeCosts = CommonUtil.DeserializeGlobalStrToNumberTable(costStr)
	costStr = GlobalConfig.Instance:GetConfigStrValue(296)
	self.buyRebornCosts = CommonUtil.DeserializeGlobalStrToNumberTable(costStr)
	self.defaultHeroCute = GlobalConfig.Instance:GetConfigStrValue(259)
	self.showRawIdxs = {}
	local guildWarDataMgr = ManagerContainer.DataMgr.GuildWarDataMgr
	if guildWarDataMgr then
		self.lastAttackAreaId = guildWarDataMgr:GetLastAttackAreaId()
		guildWarDataMgr:ClearLastAttackInfo()
	else
		self.lastAttackAreaId = nil
	end
end

function UIGuildWarCtr:GetDefaultHeroCute()
	return self.defaultHeroCute
end

function UIGuildWarCtr:GetRebornMaxTime()
	return self.rebornMaxTime
end

function UIGuildWarCtr:GetBuyChallengeCountCost()
	if self.buyChallengeCosts then
		local buyCost = self.buyChallengeCosts[1]
		if buyCost then
			return buyCost[1], buyCost[2]
		end
	end
	return 1, 100
end

function UIGuildWarCtr:GetBuyRebornCost()
	if self.buyRebornCosts then
		local buyCost = self.buyRebornCosts[1]
		if buyCost then
			return buyCost[1], buyCost[2]
		end
	end
	return 1, 100
end

function UIGuildWarCtr:GetBattleFieldData()
	return ManagerContainer.DataMgr.GuildWarDataMgr:GetBattleFieldData()
end

function UIGuildWarCtr:GetCurGuildData()
	return ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
end

function UIGuildWarCtr:ResetBattleIdx()
	local battleFieldData = self:GetBattleFieldData()
	if not battleFieldData then
		return
	end
	self.battleIdx = battleFieldData.id
end

function UIGuildWarCtr:GetBattleIdx()
	return self.battleIdx
end

function UIGuildWarCtr:GetUserNickname()
    return ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function UIGuildWarCtr:GetTotalFightPower()
    return ManagerContainer.DataMgr.UserData:GetTotalFightPower()
end

function UIGuildWarCtr:GetUserRoleId()
    return ManagerContainer.DataMgr.UserData:GetUserRoleId()
end

function UIGuildWarCtr:IsSelfArea(id)
	local battleFieldData = self:GetBattleFieldData()
	if battleFieldData then
		local areaData = battleFieldData:GetAreaDataById(id)
		if areaData and areaData:IsValidData() then
			return areaData:IsPeopleUid() == battleFieldData.uid
		end
	end
	return false
end

function UIGuildWarCtr:IsSameGuildArea(id)
	local battleFieldData = self:GetBattleFieldData()
	if battleFieldData then
		local areaData = battleFieldData:GetAreaDataById(id)
		if areaData and areaData:IsValidData() then
			return areaData:GetGuildId() == battleFieldData.guildId
		end
	end
	return false
end

function UIGuildWarCtr:GetAreaDataById(id)
	local battleFieldData = self:GetBattleFieldData()
	if battleFieldData then
		return battleFieldData:GetAreaDataById(id)
	end
	return nil
end

function UIGuildWarCtr:GetLastAttackAreaId()
	return self.lastAttackAreaId
end

function UIGuildWarCtr:GetAreaMaxId()
	local battleFieldData = self:GetBattleFieldData()
	if battleFieldData then
		return battleFieldData:GetAreaMaxId()
	end
	return 0
end

function UIGuildWarCtr:GetRawCount()
	local areaMaxId = self:GetAreaMaxId()
	local rawCount = Mathf.Floor(areaMaxId / 5)
	local remain = (areaMaxId - rawCount * 5)
	rawCount = rawCount * 2
	if remain > 2 then
		rawCount = rawCount + 2
	elseif remain > 0 then
		rawCount = rawCount + 1
	end
	return rawCount
end

function UIGuildWarCtr:GetRawAreaStartAndEnd(rawIdx)
	local normalRawIdx = rawIdx + 1
	local count = Mathf.Floor(normalRawIdx / 2) * 5
	local remain = normalRawIdx % 2
	local startId, endId
	if remain == 1 then
		startId = count + 1
		endId = count + 2
	else
		startId = count - 2
		endId = count
	end
	local areaMaxId = self:GetAreaMaxId()
	if startId > areaMaxId then
		startId = areaMaxId
	end
	if endId > areaMaxId then
		endId = areaMaxId
	end
	return startId, endId
end

function UIGuildWarCtr:GetRawIdxByAreaId(areaId)
	local rawIdx = Mathf.Floor(areaId / 5)
	local remain = (areaId - rawIdx * 5)
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
	return rawIdx, remain
end

function UIGuildWarCtr:GetShowRawIdxs()
	return self.showRawIdxs
end

function UIGuildWarCtr:AddShowRawIdx(rawIdx)
	if not CommonUtil.EleInTable(rawIdx, self.showRawIdxs) then
		self.showRawIdxs[#self.showRawIdxs+1] = rawIdx
	end
end

function UIGuildWarCtr:RemoveShowRawIdx(rawIdx)
	for k,v in pairs(self.showRawIdxs) do
        if v == rawIdx then
			table.remove(self.showRawIdxs, k)
			break
        end
    end
end


function UIGuildWarCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end




function UIGuildWarCtr:SendGuildWarInfoReq()
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarInfoReq(self.battleIdx) then
		return 100007
	end
	return 0
end

function UIGuildWarCtr:SendGuildWarScoreDataReq()
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarScoreDataReq(self.battleIdx) then
		return 100007
	end
	return 0
end

function UIGuildWarCtr:SendGuildWarAreaDatasReq(areaIds)
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarAreaDatasReq(self.battleIdx, areaIds) then
		return 100007
	end
	return 0
end

function UIGuildWarCtr:SendGuildWarChallengeReq(areaId)
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarChallengeReq(self.battleIdx, areaId) then
		return 100007
	end
	return 0
end

function UIGuildWarCtr:SendGuildWarSettingReq(autoChallenge, autoReborn)
	local battleFieldData = self:GetBattleFieldData()
	if not battleFieldData then
		return 'GuildWarBattle10'
	end
	if not battleFieldData:IsBattlingMy() then
		return 'GuildWarBattle11'
	end
	if autoChallenge then
		local costCfgId, costNum = self:GetBuyChallengeCountCost()
		local ownNum = self:GetOwnResCountByItemId(costCfgId)
		if ownNum < costNum then
			return 1, costCfgId
		end
	elseif autoChallenge == nil then
		autoChallenge = battleFieldData.autoChallenge
	end
	if autoReborn then
		local costCfgId, costNum = self:GetBuyRebornCost()
		local ownNum = self:GetOwnResCountByItemId(costCfgId)
		if ownNum < costNum then
			return 1, costCfgId
		end
	elseif autoReborn == nil then
		autoReborn = battleFieldData.autoReborn
	end
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarSettingReq(self.battleIdx, autoChallenge, autoReborn) then
		return 100007
	end
	return 0
end

function UIGuildWarCtr:SendGuildWarBuyChallengeNumReq()
	local costCfgId, costNum = self:GetBuyChallengeCountCost()
	local ownNum = self:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		return 1, costCfgId
	end
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarBuyChallengeNumReq(self.battleIdx) then
		return 100007, nil
	end
	return 0, nil
end

function UIGuildWarCtr:SendGuildWarBuyRebornReq()
	local costCfgId, costNum = self:GetBuyRebornCost()
	local ownNum = self:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		return 1, costCfgId
	end
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarBuyRebornReq(self.battleIdx) then
		return 100007, nil
	end
	return 0, nil
end

return UIGuildWarCtr

