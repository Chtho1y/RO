local UIGuildWarLogCtr = class("UIGuildWarLogCtr", require("UICtrBase"))

local GUILD_COLOR_ID1 = string.formatbykey('ColorID3')
local GUILD_COLOR_ID2 = string.formatbykey('ColorID6')
local GUILD_COLOR_DEFAULT = string.formatbykey('ColorID3')

function UIGuildWarLogCtr:Init(view)
	self.view = view
end

function UIGuildWarLogCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarLogCtr:GetData()
	return self.data
end

function UIGuildWarLogCtr:OnDispose()
	self.logData = nil
	self.guildId1 = nil
	self.guildName1 = nil
	self.guildId2 = nil
	self.guildName2 = nil

	self.data = nil
	self.view = nil
end

function UIGuildWarLogCtr:InitData()
	self.battleIdx = self.data
	self:RefreshLogData()
end

function UIGuildWarLogCtr:RefreshLogData()
	self.logData = nil
	local battleFieldData = ManagerContainer.DataMgr.GuildWarDataMgr:GetBattleFieldData()
	if battleFieldData and battleFieldData.id == self.battleIdx then
		self.logData = battleFieldData:GetLogsData()
		self.guildId1 = battleFieldData.guildId1
		self.guildName1 = battleFieldData.guildName1
		self.guildId2 = battleFieldData.guildId2
		self.guildName2 = battleFieldData.guildName2
	end
end

function UIGuildWarLogCtr:GetLogData()
	return self.logData
end

function UIGuildWarLogCtr:GetLogMaxNum()
	return 50
end

function UIGuildWarLogCtr:GetReloadLogStartTime()
    return self.logData and self.logData:GetReloadLogStartTime() or 0
end

function UIGuildWarLogCtr:GetNextLoadLogStartTime()
    return self.logData and self.logData:GetNextLoadLogStartTime() or 0
end

function UIGuildWarLogCtr:GetLogById(idx)
    return self.logData and self.logData:GetLogById(idx + 1) or nil
end

function UIGuildWarLogCtr:GetLogs()
    return self.logData and self.logData:GetLogs() or nil
end

function UIGuildWarLogCtr:GetLogNum()
    return self.logData and self.logData:GetLogNum() or 0
end

function UIGuildWarLogCtr:GetLogWhole()
    return self.logData and self.logData:GetLogWhole() or false
end

function UIGuildWarLogCtr:GetGuildNameAndColor(guildId)
	if guildId == self.guildId1 then
		return self.guildName1, GUILD_COLOR_ID1
	elseif guildId == self.guildId2 then
		return self.guildName2, GUILD_COLOR_ID2
	end
	return '', GUILD_COLOR_DEFAULT
end

function UIGuildWarLogCtr:SendGetLogInfoReq(isBegin)
	local errorCode = 0
	if isBegin then
		if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarLogReq(self.battleIdx, self:GetReloadLogStartTime()) then
			return 100007
		end
	else
		if self:GetLogWhole() then
			return 1
		end
		if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarLogReq(self.battleIdx, self:GetNextLoadLogStartTime()) then
			return 100007
		end
	end

	return errorCode
end

return UIGuildWarLogCtr

