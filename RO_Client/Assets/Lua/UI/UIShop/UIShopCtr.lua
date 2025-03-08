local UIShopCtr = class("UIShopCtr", require("UICtrBase"))

function UIShopCtr:Init(view)
	self.view = view
end

function UIShopCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self.isResetSelect = true
end

function UIShopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIShopCtr:GetData()
	return self.data
end

function UIShopCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.isResetSelect = false
	self.nearestRemainTime = nil
	self.shopLs = nil
	self.shopEndTimes = nil
	self.curSelectIdx = nil
	self.curShopCfgData = nil
	self.curShopData = nil
end

function UIShopCtr:InitData()
	local shopLs = {}
	local cfgDatas = ManagerContainer.CfgMgr:GetShopTypeCfg()
	for _, cfgData in pairs(cfgDatas) do
		if cfgData.ActShop == 0 then
			if Constant.OpenPay or not cfgDatas.NoPay then
				shopLs[#shopLs+1] = cfgData
			end
		end
	end
	local shopEndTimes = {}
	local nearestRemainTime = nil
	local remainTime = nil
	local actItemList = ManagerContainer.DataMgr.ActsDataMgr.actItemList
	if actItemList then
		for _, actItem in pairs(actItemList) do
			if actItem and actItem.type == Enum.ActivityType.ACTIVITY_TYPE_SHOP then
				if actItem:IsUnlocked() and actItem:IsOpened() then
					if actItem.actShopIds then
						for _, actShopId in pairs(actItem.actShopIds) do
							cfgDatas = ManagerContainer.CfgMgr:GetShopTypeCfgById(actShopId)
							if cfgDatas then
								if Constant.OpenPay or not cfgDatas.NoPay then
									if actItem:IsLimited() then
										if not actItem:IsOutofDate() then
											remainTime = actItem:LeftTime()
											shopEndTimes[actShopId] = actItem.endTime
											if not nearestRemainTime or nearestRemainTime > remainTime then
												nearestRemainTime = remainTime
											end
											shopLs[#shopLs+1] = cfgDatas
										end
									else
										shopLs[#shopLs+1] = cfgDatas
									end
								end
							end
						end
					end
				end
			end
		end
	end
	self.nearestRemainTime = nearestRemainTime
	self.shopEndTimes = shopEndTimes

	table.sort(shopLs, function(a, b)
		return a.SortId < b.SortId
	end)
	self.shopLs = shopLs

	local curSelectIdx = self.curSelectIdx
	local num = #shopLs

	if not curSelectIdx or self.isResetSelect then
		if self.data then
			local shopId = nil
			if type(self.data) ~= 'number' and self.data.actId then
				local actItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(self.data.actId)
				if actItem and actItem.actShopIds and #actItem.actShopIds > 0 then
					shopId = actItem.actShopIds[1]
				end
			else
				shopId = self.data
			end
			if shopId then
				for i = 1, #shopLs do
					if self.shopLs[i].Id == shopId then
						curSelectIdx = i
						break
					end
				end
			end
		end
	end
	if not curSelectIdx then
		curSelectIdx = (num > 0 and 1 or 0)
	end
	self.curSelectIdx = curSelectIdx
end

function UIShopCtr:RefreshCurShopData(forceRefresh)
	self.curShopCfgData = self.shopLs[self.curSelectIdx]
	if self.curShopCfgData then
		self.curShopData = ManagerContainer.DataMgr.ShopDataMgr:GetShopData(self.curShopCfgData.Id, forceRefresh)
	else
		self.curShopData = nil
	end
	if self.curShopData then
		if ManagerContainer.LuaTimerMgr:GetRemainSeconds(self.curShopData:GetNeedRefreshTime()) <= 0 then
			self.curShopData:RefreshShowGoodsDatas()
		end
	end
end

function UIShopCtr:GetNearestRemainTime()
	return self.nearestRemainTime
end

function UIShopCtr:GeCurEndTime()
	if self.shopLs then
		local cfgData = self.shopLs[self.curSelectIdx]
		if cfgData then
			return self.shopEndTimes and self.shopEndTimes[cfgData.Id] or nil
		end
	end
	return nil
end

function UIShopCtr:GetShopLs()
	return self.shopLs
end

function UIShopCtr:GetShopByIdx(idx)
	return self.shopLs and self.shopLs[idx] or nil
end

function UIShopCtr:GetCurSelectIdx()
	return self.curSelectIdx
end

function UIShopCtr:SetCurSelectIdx(newIdx)
	if self.curSelectIdx == newIdx then
		return false
	end
	self.curSelectIdx = newIdx
	self:RefreshCurShopData(true)
	return true
end

function UIShopCtr:GetCurShopCfgData()
	return self.curShopCfgData
end

function UIShopCtr:GetCurShopData()
	return self.curShopData
end

function UIShopCtr:GetRefreshCostInfo()
	local costNum, costCfgId
	if self.curShopData and self.curShopCfgData then
		local payForRefreshs = self.curShopCfgData.PayForRefresh
		local refreshNum = self.curShopData:GetRefreshCount() or 0
		if payForRefreshs and #payForRefreshs > 0 then
			refreshNum = Mathf.Clamp(refreshNum+1, 1, #payForRefreshs)
			local payForRefresh = payForRefreshs[refreshNum]
			if payForRefresh then
				costCfgId = payForRefresh[1]
				costNum = payForRefresh[2]
			end
		end
	end
	return costNum, costCfgId
end

function UIShopCtr:SendShopInfoReq()
	if not self.curShopData then
		return 398
	end
	if not ManagerContainer.DataMgr.ShopDataMgr:SendShopInfoReq(self.curShopData.shopId) then
		return 100007
	end
	return 0
end

function UIShopCtr:SendRefreshShopReq()
	if not self.curShopCfgData or not self.curShopData then
		return 398
	end
	-- if self.curShopCfgData.ShopType ~= 2 then
	-- 	return 397
	-- end
	-- local refreshNum = self.curShopData:GetRefreshCount() or 0
	-- local refreshMaxNum = self.curShopCfgData.RefreshNum or 0
	-- if (refreshMaxNum - refreshNum) <= 0 then
	-- 	return 395
	-- end
	-- local costNum, costCfgId = self:GetRefreshCostInfo()
	-- local ownNum = CommonUtil.GetOwnResCountByItemId(costCfgId)
	-- if ownNum < costNum then
	-- 	return 396, costCfgId
	-- end
	if not ManagerContainer.DataMgr.ShopDataMgr:SendRefreshShopReq(self.curShopData.shopId) then
		return 100007
	end
	return 0
end

return UIShopCtr

