local UIActivityChipRewardComCtr = class("UIActivityChipRewardComCtr", require("UICtrBase"))

function UIActivityChipRewardComCtr:Init(view)
	self.view = view
end

function UIActivityChipRewardComCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityChipRewardComCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityChipRewardComCtr:GetData()
	return self.data
end

function UIActivityChipRewardComCtr:GetActId()
	return self.data.actId
end

function UIActivityChipRewardComCtr:RefreshChipDatas()
	local actId = self:GetActId()
	self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
end

function UIActivityChipRewardComCtr:GetRemainTime()
	return self.activityData:LeftTime()
end

function UIActivityChipRewardComCtr:GetChipShowDataByIdx(idx)
	return self.activityData.data[idx + 1]
end

function UIActivityChipRewardComCtr:GetChipShowDataByCfgId(cfgId)
	return self.activityData:GetShowDataByCfgId(cfgId)
end

function UIActivityChipRewardComCtr:GetGlobalCount(id)
	return self.activityData:GetGlobalCount(id)
end

function UIActivityChipRewardComCtr:GetChipDataLength()
	return #self.activityData.data
end

function UIActivityChipRewardComCtr:SendGetActivityRewardReq(idx, num)
	local data = self.activityData.data[idx + 1]
	ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.activityData.actId, data.cfgId, num)
end

function UIActivityChipRewardComCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.activityData = nil
end

return UIActivityChipRewardComCtr

