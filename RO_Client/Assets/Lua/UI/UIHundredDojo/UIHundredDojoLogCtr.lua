local UIHundredDojoLogCtr = class("UIHundredDojoLogCtr", require("UICtrBase"))

function UIHundredDojoLogCtr:Init(view)
	self.view = view
end

function UIHundredDojoLogCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoLogCtr:GetData()
	return self.data
end

function UIHundredDojoLogCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIHundredDojoLogCtr:RefreshLogData()
	self.logData = ManagerContainer.DataMgr.HundredDojoDataMgr:GetLogData()
end

function UIHundredDojoLogCtr:GetLogData()
	return self.logData
end

function UIHundredDojoLogCtr:GetLogMaxNum()
	return 50
end

function UIHundredDojoLogCtr:GetReloadLogStartTime()
    return self.logData and self.logData:GetReloadLogStartTime() or 0
end

function UIHundredDojoLogCtr:GetNextLoadLogStartTime()
    return self.logData and self.logData:GetNextLoadLogStartTime() or 0
end

function UIHundredDojoLogCtr:GetLogById(idx)
    return self.logData and self.logData:GetLogById(idx + 1) or nil
end

function UIHundredDojoLogCtr:GetLogs()
    return self.logData and self.logData:GetLogs() or nil
end

function UIHundredDojoLogCtr:GetLogNum()
    return self.logData and self.logData:GetLogNum() or 0
end

function UIHundredDojoLogCtr:GetLogWhole()
    return self.logData and self.logData:GetLogWhole() or false
end

function UIHundredDojoLogCtr:ClearLogState()
	ManagerContainer.DataMgr.HundredDojoDataMgr:SetLogState(false)
end

function UIHundredDojoLogCtr:SendGetLogInfoReq(isBegin)
	local errorCode = 0
	if isBegin then
		if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetLogReq(self:GetReloadLogStartTime()) then
			return 100007
		end
	else
		if self:GetLogWhole() then
			return 1
		end
		if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetLogReq(self:GetNextLoadLogStartTime()) then
			return 100007
		end
	end

	return errorCode
end

function UIHundredDojoLogCtr:SendGetAreaInfoReq(uid)
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendGetAreaInfoReq(uid) then
		return 100007
	end
	return 0
end

return UIHundredDojoLogCtr

