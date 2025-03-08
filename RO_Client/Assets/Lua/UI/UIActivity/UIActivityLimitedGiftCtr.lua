local UIActivityLimitedGiftCtr = class("UIActivityLimitedGiftCtr", require("UICtrBase"))

function UIActivityLimitedGiftCtr:Init(view)
	self.view = view
end

function UIActivityLimitedGiftCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityLimitedGiftCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityLimitedGiftCtr:GetData()
	return self.data
end

function UIActivityLimitedGiftCtr:InitLimitedGiftIdx()
	self.limitRechargeData = ManagerContainer.DataMgr.ActsDataMgr:GetLimitRechargeItem()
	self.limitRechargeData.needOpen = false

	self.curId, self.idx = self.limitRechargeData:AutoGetOpenActivityId()
	self:SetSelectedIdx(self.idx - 1)
end

function UIActivityLimitedGiftCtr:SetCurId(id)
	self.curId = id
	self.idx = self.limitRechargeData:GetIdxById(id)
end

function UIActivityLimitedGiftCtr:SetSelectedIdx(idx)
	self.selectedIdx = idx
end

function UIActivityLimitedGiftCtr:SetIdBySelectedIdx()
	self.idx = self.selectedIdx + 1
	self.curId = self.limitRechargeData:GetIdByIdx(self.idx)
end

function UIActivityLimitedGiftCtr:GetSelectedIdx()
	return self.selectedIdx
end

function UIActivityLimitedGiftCtr:GetLimitRechargeId()
	return self.curId
end

function UIActivityLimitedGiftCtr:GetLimitRechargeIdx()
	return self.idx
end

function UIActivityLimitedGiftCtr:GetCurLimitRechargeData(itemIndex)
	local count = self:GetLimitRechargeCount()
	local index = itemIndex % count + 1
	return self.limitRechargeData:GetLimitDataByIdx(index)
end

function UIActivityLimitedGiftCtr:GetLimitRechargeCount()
	return self.limitRechargeData:GetCount()
end

function UIActivityLimitedGiftCtr:GetRemainTime(id)
	return self.limitRechargeData:GetRemainTime(id)
end

function UIActivityLimitedGiftCtr:IsExist()
	return self.limitRechargeData:IsLimitRechargeExist()
end

function UIActivityLimitedGiftCtr:RefreshRemainTime(id)
	return self.limitRechargeData:RefreshRemainTime(id)
end

function UIActivityLimitedGiftCtr:HasOpened(id)
	return self.limitRechargeData:HasOpened(id)
end

function UIActivityLimitedGiftCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.limitRechargeData = nil
end

return UIActivityLimitedGiftCtr

