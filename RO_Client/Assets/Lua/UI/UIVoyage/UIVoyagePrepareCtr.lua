local UIVoyagePrepareCtr = class("UIVoyagePrepareCtr", require("UICtrBase"))

function UIVoyagePrepareCtr:Init(view)
	self.view = view
end

function UIVoyagePrepareCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
end

function UIVoyagePrepareCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyagePrepareCtr:GetData()
	return self.data
end

function UIVoyagePrepareCtr:OnDispose()
	self.numLimit = nil
	self.lastSelectId = nil
	self.curSelectId = nil
	self.data = nil
	self.view = nil
end

function UIVoyagePrepareCtr:InitData()
	self.numLimit = GlobalConfig.Instance:GetConfigIntValue(323)
	self.lastSelectId = nil
	self.curSelectId = nil
	self:RefreshSelectId()
end

function UIVoyagePrepareCtr:GetSelfAirShipData()
    return ManagerContainer.DataMgr.VoyageDataMgr:GetSelfAirShipData()
end

function UIVoyagePrepareCtr:GetNum()
	return ManagerContainer.DataMgr.VoyageDataMgr:GetVoyageNum()
end

function UIVoyagePrepareCtr:GetNumLimit()
	return self.numLimit
end


function UIVoyagePrepareCtr:GetNotifyAirShipUpTip()
    return ManagerContainer.DataMgr.VoyageDataMgr:GetNotifyAirShipUpTip()
end

function UIVoyagePrepareCtr:SetNotifyAirShipUpTip(status)
    return ManagerContainer.DataMgr.VoyageDataMgr:SetNotifyAirShipUpTip(status)
end

function UIVoyagePrepareCtr:RefreshSelectId()
	local newSelectId = ManagerContainer.DataMgr.VoyageDataMgr:GetCurAirShipId()
	if self.curSelectId == newSelectId then
		return false
	end
	self.lastSelectId = self.curSelectId
	self.curSelectId = newSelectId
	return true
end

function UIVoyagePrepareCtr:GetLastSelectId()
	return self.lastSelectId
end

function UIVoyagePrepareCtr:GetCurSelectId()
	return self.curSelectId
end

function UIVoyagePrepareCtr:GetSendRefreshAirShipReqErrorCode(upHighest)
	if not self.curSelectId then
		return 2
	end
	local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(self.curSelectId + 1)
	if not cfgData then
		return 2
	end
	cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(self.curSelectId)
	if not cfgData then
		return 3
	end
	local costs
	if upHighest then
		costs = cfgData.TopLevel
	else
		costs = cfgData.Consume
	end
	if not costs then
		return 4
	end
	local costLength = #costs
	if costLength <= 0 then
		return 4
	end
	local validCosts = {}
	local remainNum = 1
	local cost, costCfgId, costNum, costRemainNum, ownNum
	for i = 1, costLength do
		cost = costs[i]
		costCfgId = tonumber(cost[1])
		costNum = tonumber(cost[2])
		ownNum = CommonUtil.GetOwnResCountByItemId(costCfgId)
		costRemainNum = Mathf.Floor(ownNum / costNum)
		if costRemainNum >= remainNum then
			validCosts[#validCosts + 1] = {costCfgId, ownNum, costNum, remainNum}
			return 0, 1, 0, validCosts
		else
			validCosts[#validCosts + 1] = {costCfgId, ownNum, costNum, costRemainNum}
		end
	end
	return 1, 1, remainNum, validCosts
end

function UIVoyagePrepareCtr:SendRefreshAirShipReq(upHighest)
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendRefreshAirShipReq(upHighest) then
		return 100007
	end
	return 0
end

function UIVoyagePrepareCtr:SendTakeOffAirShipReq()
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendTakeOffAirShipReq() then
		return 100007
	end
	return 0
end

return UIVoyagePrepareCtr

