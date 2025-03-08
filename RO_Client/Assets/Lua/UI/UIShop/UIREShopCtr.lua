local UIREShopCtr = class("UIREShopCtr", require("UICtrBase"))

local reShopTypeId = 50
function UIREShopCtr:Init(view)
	self.view = view
end

function UIREShopCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self.isResetSelect = true
end

function UIREShopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIREShopCtr:GetData()
	return self.data
end

function UIREShopCtr:OnDispose()
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

function UIREShopCtr:InitData()
	local shopLs = {}
	local cfgDatas
	local shopEndTimes = {}
	local nearestRemainTime = nil
	local remainTime = nil
	cfgDatas = ManagerContainer.CfgMgr:GetShopTypeCfgById(reShopTypeId)
	shopLs[#shopLs+1] = cfgDatas
	--local actItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(reShopTypeId)
	--if actItem and actItem.type == Enum.ActivityType.ACTIVITY_TYPE_SHOP then
	--	if actItem:IsUnlocked() and actItem:IsOpened() then
	--		if actItem.actShopIds then
	--			for _, actShopId in pairs(actItem.actShopIds) do
	--				cfgDatas = ManagerContainer.CfgMgr:GetShopTypeCfgById(actShopId)
	--				if cfgDatas then
	--					if actItem:IsLimited() then
	--						if not actItem:IsOutofDate() then
	--							remainTime = actItem:LeftTime()
	--							shopEndTimes[actShopId] = actItem.endTime
	--							if not nearestRemainTime or nearestRemainTime > remainTime then
	--								nearestRemainTime = remainTime
	--							end
	--							shopLs[#shopLs+1] = cfgDatas
	--						end
	--					else
	--						shopLs[#shopLs+1] = cfgDatas
	--					end
	--				end
	--			end
	--		end
	--	end
	--end
	self.nearestRemainTime = nearestRemainTime
	self.shopEndTimes = shopEndTimes

	table.sort(shopLs, function(a, b)
		return a.SortId < b.SortId
	end)
	self.shopLs = shopLs

	self.curSelectIdx = 1
end

function UIREShopCtr:RefreshCurShopData(forceRefresh)
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

function UIREShopCtr:GetNearestRemainTime()
	return self.nearestRemainTime
end

function UIREShopCtr:GeCurEndTime()
	if self.shopLs then
		local cfgData = self.shopLs[self.curSelectIdx]
		if cfgData then
			return self.shopEndTimes and self.shopEndTimes[cfgData.Id] or nil
		end
	end
	return nil
end

function UIREShopCtr:GetShopLs()
	return self.shopLs
end

function UIREShopCtr:GetShopByIdx(idx)
	return self.shopLs and self.shopLs[idx] or nil
end

function UIREShopCtr:GetCurSelectIdx()
	return self.curSelectIdx
end

function UIREShopCtr:SetCurSelectIdx(newIdx)
	if self.curSelectIdx == newIdx then
		return false
	end
	self.curSelectIdx = newIdx
	self:RefreshCurShopData(true)
	return true
end

function UIREShopCtr:GetCurShopCfgData()
	return self.curShopCfgData
end

function UIREShopCtr:GetCurShopData()
	return self.curShopData
end

function UIREShopCtr:GetRefreshCostInfo()
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

function UIREShopCtr:SendShopInfoReq()
	if not self.curShopData then
		return 398
	end
	if not ManagerContainer.DataMgr.ShopDataMgr:SendShopInfoReq(self.curShopData.shopId) then
		return 100007
	end
	return 0
end

function UIREShopCtr:SendRefreshShopReq()
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

function UIREShopCtr:SetCurGoodsData(goodsData)
	self.curGoodsData = goodsData
end

function UIREShopCtr:GetOwnResCountByItemId(cfgId)
	return CommonUtil.GetOwnResCountByItemId(cfgId)
end

function UIREShopCtr:SendShopBuyItemReq()
	if not self.curGoodsData then
		return 390
	end
	local price = self.curGoodsData.curPrice
	local goodsCfgData = self.curGoodsData:GetGoodsCfgData()
	local ownCount = self:GetOwnResCountByItemId(goodsCfgData.PayForType)
	if ownCount < price then
		return 391, goodsCfgData.PayForType
	end

	if not ManagerContainer.DataMgr.ShopDataMgr:SendShopBuyItemReq(self.curShopData.shopId, self.curGoodsData.id, 1) then
		return 100007
	end
	return 0
end

return UIREShopCtr

