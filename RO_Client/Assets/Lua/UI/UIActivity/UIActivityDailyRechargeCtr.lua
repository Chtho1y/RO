local UIActivityDailyRechargeCtr = class("UIActivityDailyRechargeCtr", require("UICtrBase"))

function UIActivityDailyRechargeCtr:Init(view)
	self.view = view
end

function UIActivityDailyRechargeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityDailyRechargeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityDailyRechargeCtr:GetData()
	return self.data
end

function UIActivityDailyRechargeCtr:GetActId()
	return self.data.actId
end

function UIActivityDailyRechargeCtr:GetNextTiredChargeCfgData()
	local curNum = self:GetDailyTiredChargeCount()
	self.cfgData = ManagerContainer.CfgMgr:GetNextActivitiesTiredChargeCfgByNum(curNum)
	if self.cfgData then
		self.needChargeCount = self.cfgData.RechargeAmount - curNum
	end
	return self.cfgData
end

function UIActivityDailyRechargeCtr:GetDailyTiredChargeCount()
	return ManagerContainer.PayMgr:GetDayRecharge()
end

function UIActivityDailyRechargeCtr:GetDailyRewardState()
	local actId = self:GetActId()
	local activeItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
	if not activeItem then
		return 0
	end
	return activeItem:GetRewardState(), activeItem:GetCurDay()
end

function UIActivityDailyRechargeCtr:GetDailyRPState()
	local actId = self:GetActId()
	local activeItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
	if not activeItem then
		return false
	end
	return activeItem:HasRedPoint()
end

function UIActivityDailyRechargeCtr:GetNeedChargeCount()
	return self.needChargeCount
end

function UIActivityDailyRechargeCtr:SendRewardReq(pageId)
	local actId = self:GetActId()
	ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(actId)
end

function UIActivityDailyRechargeCtr:IsInActivityDrops(cfgId)
	return ManagerContainer.DataMgr.ActsDataMgr:IsInActivityDrop(cfgId)
end

function UIActivityDailyRechargeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIActivityDailyRechargeCtr

