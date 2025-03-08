local UIVoyageLogCtr = class("UIVoyageLogCtr", require("UICtrBase"))

local GUILD_COLOR_ID1 = string.formatbykey('ColorID3')
local GUILD_COLOR_ID2 = string.formatbykey('ColorID6')
local GUILD_COLOR_DEFAULT = string.formatbykey('ColorID3')

function UIVoyageLogCtr:Init(view)
	self.view = view
end

function UIVoyageLogCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIVoyageLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyageLogCtr:GetData()
	return self.data
end

function UIVoyageLogCtr:OnDispose()
	self.logData = nil

	self.data = nil
	self.view = nil
end

function UIVoyageLogCtr:InitData()
	self.battleIdx = self.data
	self:RefreshLogData()
end

function UIVoyageLogCtr:RefreshLogData()
	self.logData = ManagerContainer.DataMgr.VoyageDataMgr:GetLogsData()
end

function UIVoyageLogCtr:GetLogData()
	return self.logData
end

function UIVoyageLogCtr:GetLogMaxNum()
	return 50
end

function UIVoyageLogCtr:GetReloadLogStartTime()
    return self.logData and self.logData:GetReloadLogStartTime() or 0
end

function UIVoyageLogCtr:GetNextLoadLogStartTime()
    return self.logData and self.logData:GetNextLoadLogStartTime() or 0
end

function UIVoyageLogCtr:GetLogById(idx)
    return self.logData and self.logData:GetLogById(idx + 1) or nil
end

function UIVoyageLogCtr:GetLogs()
    return self.logData and self.logData:GetLogs() or nil
end

function UIVoyageLogCtr:GetLogNum()
    return self.logData and self.logData:GetLogNum() or 0
end

function UIVoyageLogCtr:GetLogWhole()
    return self.logData and self.logData:GetLogWhole() or false
end



function UIVoyageLogCtr:SendGetLogInfoReq(isBegin)
	local errorCode = 0
	if isBegin then
		if not ManagerContainer.DataMgr.VoyageDataMgr:SendLogReq(self:GetReloadLogStartTime()) then
			return 100007
		end
	else
		if self:GetLogWhole() then
			return 1
		end
		if not ManagerContainer.DataMgr.VoyageDataMgr:SendLogReq(self:GetNextLoadLogStartTime()) then
			return 100007
		end
	end

	return errorCode
end

function UIVoyageLogCtr:SendCheckInfoReq(uid, endTime)
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendCheckInfoReq(uid, endTime) then
		return 100007
	end
	return 0
end

return UIVoyageLogCtr

