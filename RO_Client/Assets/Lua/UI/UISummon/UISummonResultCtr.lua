local UISummonResultCtr = class("UISummonResultCtr", require("UICtrBase"))

function UISummonResultCtr:Init(view)
	self.view = view
end

function UISummonResultCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
end

function UISummonResultCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISummonResultCtr:GetData()
	return self.data
end

function UISummonResultCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UISummonResultCtr:InitData()
	local summonData = ManagerContainer.DataMgr.SummonDataMgr:GetSummonData()
	local cfgData, summonNum, rewards, extraReward, extraRewards, lastPercent, percent
	if summonData then
		cfgData = ManagerContainer.CfgMgr:GetSummonCfgById(summonData.summonType)
		summonNum = summonData.summonNum
		rewards = summonData.rewards
		extraRewards = summonData.extraRewards
		if cfgData.Total > 0 then
			if extraRewards and #extraRewards >= 1 then
				lastPercent = (cfgData.Total - summonData.summonAdd + summonData.summonTotal) / cfgData.Total
				percent = 1
				extraReward = extraRewards[1]
			else
				lastPercent = (summonData.summonTotal - summonData.summonAdd) / cfgData.Total
				percent = (summonData.summonTotal) / cfgData.Total
			end
		end
	end

	self.cfgData = cfgData
	self.summonNum = summonNum
	self.rewards = rewards
	self.extraReward = extraReward
	self.lastPercent = lastPercent or 0
	self.percent = percent or 0

	self:ClearSummonData()
end

function UISummonResultCtr:GetCfgData()
	return self.cfgData
end

function UISummonResultCtr:GetSummonNum()
	return self.summonNum
end

function UISummonResultCtr:IsHasExtra()
	return self.cfgData.Total > 0 or false
end

function UISummonResultCtr:GetRewards()
	return self.rewards
end

function UISummonResultCtr:GetExtraReward()
	return self.extraReward
end

function UISummonResultCtr:GetLastSummonPercent()
	return self.lastPercent
end

function UISummonResultCtr:GetSummonPercent()
	return self.percent
end

function UISummonResultCtr:ClearSummonData()
	ManagerContainer.DataMgr.SummonDataMgr:ClearSummonData()
end

function UISummonResultCtr:GetOwnResCountByItemId(cfgId)
	return CommonUtil.GetOwnResCountByItemId(cfgId)
end

function UISummonResultCtr:GetShowQuality(cfgId)
	if cfgId then
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if itemCfgData then
			if itemCfgData.ResType == Enum.ItemType.Compose then
				if itemCfgData.Quality > 4 then
					return 3, false
				elseif itemCfgData.Quality == 4 then
					return 2, false
				else
					return 0, false
				end
			end
			local qualityLv = 1
			if itemCfgData.ResType == Enum.ItemType.Equip then
				local cfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
				if cfgData then
					qualityLv = cfgData.EquipLevel
				end
			elseif itemCfgData.ResType == Enum.ItemType.Card then
				local cfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
				if cfgData then
					qualityLv = cfgData.CardLevel
				end
			end
			if itemCfgData.Quality > 4 then
				return 3, true
			elseif itemCfgData.Quality == 4 then
				return 2, true
			elseif itemCfgData.Quality == 3 then
				return 1, qualityLv >= 3
			end
		end
	end
	return 0, false
end

function UISummonResultCtr:GetSendSummonReqErrorCode(idx)
	return ManagerContainer.DataMgr.SummonDataMgr:GetSendSummonReqErrorCode(self.cfgData.Id, idx)
end

function UISummonResultCtr:SendSummonReq(summonNum)
	if self.cfgData and self.cfgData.ActivitiesId and self.cfgData.ActivitiesId > 0 then
		if not ManagerContainer.DataMgr.SummonDataMgr:SendActivitySummonReq(self.cfgData.ActivitiesId,summonNum) then
			return 100007
		end	
		local activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(self.cfgData.ActivitiesId)
		if activityData then
			if activityData:LeftTime() <= 0 then
				self.view:OnClickConfirmBtn()
			end
		else
			self.view:OnClickConfirmBtn()
		end
	else
		if not ManagerContainer.DataMgr.SummonDataMgr:SendSummonReq(self.cfgData.Id, summonNum) then
			return 100007
		end
	end
	return 0
end

return UISummonResultCtr

