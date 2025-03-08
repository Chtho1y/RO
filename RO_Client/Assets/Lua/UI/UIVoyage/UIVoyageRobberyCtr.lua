local UIVoyageRobberyCtr = class("UIVoyageRobberyCtr", require("UICtrBase"))

function UIVoyageRobberyCtr:Init(view)
	self.view = view
end

function UIVoyageRobberyCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIVoyageRobberyCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyageRobberyCtr:GetData()
	return self.data
end

function UIVoyageRobberyCtr:OnDispose()
	self.numLimit = nil
	self.airShipData = nil
	self.quality = nil
	self.beChallengeNum = nil

	self.data = nil
	self.view = nil
end

function UIVoyageRobberyCtr:InitData()
	self.numLimit = GlobalConfig.Instance:GetConfigIntValue(325)
	if self.data then
		self.airShipData = ManagerContainer.DataMgr.VoyageDataMgr:GetAirShipDataByUid(self.data)
	else
		self.airShipData = nil
	end
end

function UIVoyageRobberyCtr:GetAirShipData()
	return self.airShipData
end

function UIVoyageRobberyCtr:RefreshAndGetAirShipData()
	if not self.data then
		return nil
	end
	local airShipData = ManagerContainer.DataMgr.VoyageDataMgr:GetAirShipDataByUid(self.data)
	if not airShipData then
		return nil
	end
	return airShipData
end

function UIVoyageRobberyCtr:GetRemindRobNum()
	local num = ManagerContainer.DataMgr.VoyageDataMgr:GetChallengeNum()
	return Mathf.Max(0, (self.numLimit - num))
end

function UIVoyageRobberyCtr:RefreshQuality()
	if not self.airShipData then
		return nil
	end
	if self.airShipData.quality == self.quality then
		return nil
	end
	self.quality = self.airShipData.quality
	return self.quality
end

function UIVoyageRobberyCtr:RefreshBeChallengeNum()
	if not self.airShipData then
		return nil
	end
	if self.airShipData.beChallengeNum == self.beChallengeNum then
		return nil
	end
	self.beChallengeNum = self.airShipData.beChallengeNum
	return self.beChallengeNum
end

function UIVoyageRobberyCtr:SendChallengeReq(uid, endTime)
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendChallengeReq(uid, endTime) then
		return 100007
	end
	return 0
end

function UIVoyageRobberyCtr:SendCheckInfoReq(uid, endTime)
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendCheckInfoReq(uid, endTime) then
		return 100007
	end
	return 0
end

return UIVoyageRobberyCtr

