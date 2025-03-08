local UIGuildLogCtr = class("UIGuildLogCtr", require("UICtrBase"))

function UIGuildLogCtr:Init(view)
	self.view = view
end

function UIGuildLogCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	if self.guildData then
		self.guildData:ClearLogs()
	end
end

function UIGuildLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildLogCtr:GetData()
	return self.data
end

function UIGuildLogCtr:OnDispose()
	self.data = nil
	self.view = nil
	if self.guildData then
		self.guildData:ClearLogs()
	end
	self.guildData = nil
end

function UIGuildLogCtr:GetLogMaxNum()
	return GlobalConfig.Instance:GetConfigIntValue(202)
end

function UIGuildLogCtr:GetReloadLogStartTime()
    return self.guildData:GetReloadLogStartTime()
end

function UIGuildLogCtr:GetNextLoadLogStartTime()
    return self.guildData:GetNextLoadLogStartTime()
end

function UIGuildLogCtr:GetLogById(idx)
    return self.guildData:GetLogById(idx + 1)
end

function UIGuildLogCtr:GetLogs()
    return self.guildData:GetLogs()
end

function UIGuildLogCtr:GetLogNum()
    return self.guildData:GetLogNum()
end

function UIGuildLogCtr:GetLogWhole()
    return self.guildData:GetLogWhole()
end


function UIGuildLogCtr:SendGetGuildLogInfoReq(isBegin)
	local errorCode = 0
	if isBegin then
		if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildLogInfoReq(self:GetReloadLogStartTime()) then
			return 100007
		end
	else
		if self:GetLogWhole() then
			return 1
		end
		if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildLogInfoReq(self:GetNextLoadLogStartTime()) then
			return 100007
		end
	end

	return errorCode
end


return UIGuildLogCtr

