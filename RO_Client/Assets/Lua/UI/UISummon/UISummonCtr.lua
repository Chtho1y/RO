local UISummonCtr = class("UISummonCtr", require("UICtrBase"))

function UISummonCtr:Init(view)
	self.view = view
end

---@param data integer 默认进入的页面Id，参考SummonCfg配置
function UISummonCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	if self.data and type(self.data) == "table" and  self.data.actId then
		self.isFromActivity = true
		if not self.activityData then
			self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(self.data.actId)
		end
	end
	self:InitData()
end

function UISummonCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISummonCtr:GetData()
	return self.data
end

function UISummonCtr:GetActivityId()
	return self.data and type(self.data) == "table" and self.data.actId or nil
end

function UISummonCtr:GetEnterType()
	return self.isFromActivity
end

function UISummonCtr:GetRemainTime()
	if self.activityData then
		return self.activityData:LeftTime()
	end
	return 0
end

function UISummonCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.listIdx = nil
	self.selectIdx = nil
	self.cfgs = nil
	self.cfgLength = nil
end

function UISummonCtr:InitData()
	local cfgs = {}
	local cfgSource = ManagerContainer.CfgMgr:GetAllSummonCfg()
	for id, cfg in pairs(cfgSource) do
		if  self.isFromActivity then
			if cfg.ActivitiesId and cfg.ActivitiesId == self.data.actId then
				cfgs[#cfgs+1] = cfg
			end
		else
			if not (cfg.ActivitiesId and cfg.ActivitiesId > 0) then
				cfgs[#cfgs+1] = cfg
			end
		end
	end
	table.sort(cfgs, function(a, b)
		return a.SortId < b.SortId
	end)
	local idx = nil
	if self.data then
		for i = 1, #cfgs do
			if cfgs[i].Id == self.data then
				idx = i
			end
		end
	end
	if not idx then
		idx = 1
	end

	self.selectIdx = idx
	self.listIdx = idx - 1
	self.cfgs = cfgs
	self.cfgLength = #cfgs
end

function UISummonCtr:GetListIdx()
	return self.listIdx
end

function UISummonCtr:SetListIdx(listIdx)
	if self.listIdx == listIdx then return false end
	self.listIdx = listIdx
	self.selectIdx = self:GetSelectIdxByListIdx(listIdx)
	return true
end

function UISummonCtr:GetSelectIdxByListIdx(listIdx)
	if listIdx >= 0 then
		return listIdx % self.cfgLength + 1
	else
		return self.cfgLength - Mathf.Abs(listIdx + 1) % self.cfgLength
	end
end

function UISummonCtr:GetSelectIdx()
	return self.selectIdx
end

function UISummonCtr:GetCfgByIdx(idx)
	return self.cfgs[idx]
end

function UISummonCtr:GetCfgLength()
	return self.cfgLength
end

function UISummonCtr:GetSummonNumByIdx(idx)
	local cfg = self:GetCfgByIdx(idx)
	return ManagerContainer.DataMgr.SummonDataMgr:GetSummonNum(cfg.Id)
end

function UISummonCtr:GetOwnResCountByItemId(cfgId)
	return CommonUtil.GetOwnResCountByItemId(cfgId)
end

function UISummonCtr:GetSendSummonReqErrorCode(idx)
	local selectIdx = self:GetSelectIdx()
	local cfg = self:GetCfgByIdx(selectIdx)
	return ManagerContainer.DataMgr.SummonDataMgr:GetSendSummonReqErrorCode(cfg.Id, idx)
end

function UISummonCtr:ReadyData()
	ManagerContainer.DataMgr.SummonDataMgr:ClearSummonData()
	ManagerContainer.DataMgr.SummonDataMgr:ClearRedPoint()
end

function UISummonCtr:SendSummonReq(summonNum)
	local selectIdx = self:GetSelectIdx()
	local cfg = self:GetCfgByIdx(selectIdx)
	local IsFromActivity = self:GetEnterType()
	if IsFromActivity then
		if not ManagerContainer.DataMgr.SummonDataMgr:SendActivitySummonReq(cfg.ActivitiesId,summonNum) then
			return 100007
		end	
	else
		if not ManagerContainer.DataMgr.SummonDataMgr:SendSummonReq(cfg.Id,summonNum) then
			return 100007
		end
	end
	return 0
end


return UISummonCtr

