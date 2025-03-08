local UIGuildWarRankCtr = class("UIGuildWarRankCtr", require("UICtrBase"))

function UIGuildWarRankCtr:Init(view)
	self.view = view
end

function UIGuildWarRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarRankCtr:GetData()
	return self.data
end

function UIGuildWarRankCtr:OnDispose()
	self.battleIdx = nil
	self.guildName1 = nil
	self.guildName2 = nil
	self.battleRankData = nil
	self.battleRankPageType = nil
	self.battleRankPageData = nil
	ManagerContainer.DataMgr.GuildWarDataMgr:ClearBattleRankData()

	self.data = nil
	self.view = nil
end

function UIGuildWarRankCtr:InitData()
	self.battleIdx = self.data
	self.battleRankPageType = 1
	self:RefreshBattleRankData()
end

function UIGuildWarRankCtr:RefreshBattleRankData()
	self.battleRankData = nil
	self.guildName1 = nil
	self.guildName2 = nil
	local battleRankData = ManagerContainer.DataMgr.GuildWarDataMgr:GetBattleRankData()
	if battleRankData and battleRankData.id == self.battleIdx then
		self.battleRankData = battleRankData
		self.guildName1 = string.formatbykey('GuildWarBattle5', battleRankData.guildName1)
		self.guildName2 = string.formatbykey('GuildWarBattle7', battleRankData.guildName2)
	end
	self:RefreshBattleRankPageData()
end

function UIGuildWarRankCtr:RefreshBattleRankPageData()
	self.battleRankPageData = nil
	if self.battleRankData then
		self.battleRankPageData = self.battleRankData:GetRankDataByType(self.battleRankPageType)
	end
end

function UIGuildWarRankCtr:GetBattleIdx()
	return self.battleIdx
end

function UIGuildWarRankCtr:GetBattleFieldData()
	return ManagerContainer.DataMgr.GuildWarDataMgr:GetBattleFieldData()
end

function UIGuildWarRankCtr:GetBattleRankData()
	return self.battleRankData
end

function UIGuildWarRankCtr:GetBattleRankPageType()
	return self.battleRankPageType
end

function UIGuildWarRankCtr:SetBattleRankPageType(battleRankPageType)
	if self.battleRankPageType == battleRankPageType then
		return false
	end
	self.battleRankPageType = battleRankPageType
	self:RefreshBattleRankPageData()
	return true
end

function UIGuildWarRankCtr:GetBattleRankPageData()
	return self.battleRankPageData
end

function UIGuildWarRankCtr:GetGuildName(guildId)
	if self.battleRankData then
		if guildId == self.battleRankData.guildId1 then
			return self.guildName1
		end
		if guildId == self.battleRankData.guildId2 then
			return self.guildName2
		end
	end
	return ''
end




function UIGuildWarRankCtr:SendGuildWarRankReq(isBegin)
	if not self.battleRankPageData then
		if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarRankReq(self.battleIdx, self.battleRankPageType, 1) then
			return 100007
		end
		return 0
	end
	local pageIdx = self.battleRankPageData:GetPageIdx(isBegin)
	if not pageIdx then
		return 1
	end
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarRankReq(self.battleIdx, self.battleRankPageType, pageIdx) then
		return 100007
	end
	return 0
end

return UIGuildWarRankCtr

