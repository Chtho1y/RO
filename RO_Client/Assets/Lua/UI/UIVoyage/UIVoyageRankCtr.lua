local UIVoyageRankCtr = class("UIVoyageRankCtr", require("UICtrBase"))

function UIVoyageRankCtr:Init(view)
	self.view = view
end

function UIVoyageRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIVoyageRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyageRankCtr:GetData()
	return self.data
end

function UIVoyageRankCtr:OnDispose()
	self.maxNum = nil

	self.data = nil
	self.view = nil

	ManagerContainer.DataMgr.VoyageDataMgr:ClearRankData()
end

function UIVoyageRankCtr:InitData()
	self.maxNum = GlobalConfig.Instance:GetConfigIntValue(329)
end

function UIVoyageRankCtr:GetMaxNum()
	return self.maxNum
end

function UIVoyageRankCtr:GetRankDataById(idx)
	local rankDatas = ManagerContainer.DataMgr.VoyageDataMgr:GetRankDatas()
    return rankDatas and rankDatas[idx] or nil
end

function UIVoyageRankCtr:GetRankDatas()
    return ManagerContainer.DataMgr.VoyageDataMgr:GetRankDatas()
end

function UIVoyageRankCtr:GetSelfRank()
	return ManagerContainer.DataMgr.VoyageDataMgr:GetSelfRank()
end

function UIVoyageRankCtr:GetSelfScore()
	return ManagerContainer.DataMgr.VoyageDataMgr:GetSelfScore()
end

function UIVoyageRankCtr:SendGetVoyageRankDatasReq(isBegin)
	local errorCode = 0
	if isBegin then
		if not ManagerContainer.DataMgr.VoyageDataMgr:SendGetVoyageRankDatasReq(1) then
			return 100007
		end
	else
		local rankDatas = ManagerContainer.DataMgr.VoyageDataMgr:GetRankDatas()
		local whole = false
		if rankDatas then
			whole = (#rankDatas >= self.maxNum)
		end
		if whole then
			return 1
		end
		if not ManagerContainer.DataMgr.VoyageDataMgr:SendGetVoyageRankDatasReq(#rankDatas + 1) then
			return 100007
		end
	end

	return errorCode
end

return UIVoyageRankCtr

