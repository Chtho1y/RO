local UIGuildHuntLogCtr = class("UIGuildHuntLogCtr", require("UICtrBase"))

function UIGuildHuntLogCtr:Init(view)
	self.view = view
end

function UIGuildHuntLogCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildHuntLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildHuntLogCtr:GetData()
	return self.data
end

function UIGuildHuntLogCtr:OnDispose()
	-- if self.guildData then
	-- 	self.guildData:ClearHuntBossLogs(self.data)
	-- end
	self.guildData = nil

	self.data = nil
	self.view = nil
end

function UIGuildHuntLogCtr:InitData()
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
end

function UIGuildHuntLogCtr:GetBossId()
	return self.data
end

function UIGuildHuntLogCtr:GetLogWhole()
	return self.guildData:GetHuntBossLogWhole(self:GetBossId())
end

function UIGuildHuntLogCtr:GetLogNum()
	return self.guildData:GetHuntBossLogNum(self:GetBossId())
end

function UIGuildHuntLogCtr:GetLogMaxNum()
	return 50
end

function UIGuildHuntLogCtr:GetLogById(idx)
    return self.guildData:GetHuntBossLogById(self:GetBossId(), idx + 1)
end

function UIGuildHuntLogCtr:GetReloadLogStartTime()
    return self.guildData:GetReloadHuntBossLogStartTime(self:GetBossId())
end

function UIGuildHuntLogCtr:GetNextLoadLogStartTime()
    return self.guildData:GetNextLoadHuntBossLogStartTime(self:GetBossId())
end



function UIGuildHuntLogCtr:SendGuildHuntBossLogReq(isBegin)
	local errorCode = 0
	if isBegin then
		local time = self:GetReloadLogStartTime()
		if not time then
			return 1
		end
		if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildHuntBossLogReq(self:GetBossId(), time) then
			return 100007
		end
	else
		if self:GetLogWhole() then
			return 1
		end
		local time = self:GetNextLoadLogStartTime()
		if not time then
			return 1
		end
		if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildHuntBossLogReq(self:GetBossId(), time) then
			return 100007
		end
	end

	return errorCode
end

return UIGuildHuntLogCtr

