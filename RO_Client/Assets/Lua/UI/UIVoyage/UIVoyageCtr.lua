local UIVoyageCtr = class("UIVoyageCtr", require("UICtrBase"))

function UIVoyageCtr:Init(view)
	self.view = view
end

function UIVoyageCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIVoyageCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyageCtr:GetData()
	return self.data
end

function UIVoyageCtr:OnDispose()
	self.numLimit = nil
	self.data = nil
	self.view = nil
	ManagerContainer.DataMgr.VoyageDataMgr:SetKeepVoyageState(false)
end

function UIVoyageCtr:InitData()
	ManagerContainer.DataMgr.VoyageDataMgr:SetKeepVoyageState(true)
	ManagerContainer.DataMgr.VoyageDataMgr:SetRpStatus(false)
	self.numLimit = GlobalConfig.Instance:GetConfigIntValue(323)
	self.lastAttackUid = ManagerContainer.DataMgr.VoyageDataMgr:GetLastAttackUid()
	ManagerContainer.DataMgr.VoyageDataMgr:ClearLastAttackData()
end

function UIVoyageCtr:GetUserId()
	return ManagerContainer.DataMgr.UserData:GetUserId()
end

function UIVoyageCtr:GetLastAttackUserId()
	return self.lastAttackUid
end

function UIVoyageCtr:GetRemindNum()
	local num = ManagerContainer.DataMgr.VoyageDataMgr:GetVoyageNum()
	return (self.numLimit - num)
end

function UIVoyageCtr:GetSelfAirShipData()
    return ManagerContainer.DataMgr.VoyageDataMgr:GetSelfAirShipData()
end

function UIVoyageCtr:GetAirShipDatas()
    return ManagerContainer.DataMgr.VoyageDataMgr:GetAirShipDatas()
end

function UIVoyageCtr:GetAirShipDataByUid(uid)
    return ManagerContainer.DataMgr.VoyageDataMgr:GetAirShipDataByUid(uid)
end


function UIVoyageCtr:SendGetRewardReq()
	if not ManagerContainer.DataMgr.VoyageDataMgr:SendGetRewardReq() then
		return 100007
	end
	return 0
end

return UIVoyageCtr

