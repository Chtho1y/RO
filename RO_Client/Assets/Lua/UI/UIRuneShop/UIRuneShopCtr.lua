local UIRuneShopCtr = class("UIRuneShopCtr", require("UICtrBase"))

function UIRuneShopCtr:Init(view)
	self.view = view
end

---@param data table|nil {[1] = Enum.RuneShopType, [2] = Enum.RuneShopSubType}, 默认值为｛Enum.RuneShopType.MonthCard, Enum.RuneShopSubType.Daily｝
function UIRuneShopCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
end

function UIRuneShopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRuneShopCtr:GetData()
	return self.data
end

function UIRuneShopCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.shopType = nil
	self.shopSubType = nil
end

function UIRuneShopCtr:InitData()
	local shopType = nil
	local shopSubType = nil
	if self.data then
		shopType = self.data[1]
		shopSubType = self.data[2]
		if  self.data[4] then
			self:RefreshCurRewardsData()
			return
		end
		if shopType == Enum.RuneShopType.Gifts then
			if shopSubType ~= Enum.RuneShopSubType.Week
				and shopSubType ~= Enum.RuneShopSubType.Month
				and shopSubType ~= Enum.RuneShopSubType.Gold then
				shopSubType = Enum.RuneShopType.Daily
			end
		elseif shopType == Enum.RuneShopType.LimitTime then
			shopSubType = nil
		elseif shopType == Enum.RuneShopType.Rewards then
			shopSubType = nil
		else
			shopType = Enum.RuneShopType.MonthCard
			shopSubType = nil
		end
	else
		shopType = Enum.RuneShopType.MonthCard
		shopSubType = nil
	end

	self.shopType = shopType
	self.shopSubType = shopSubType
	self:RefreshCurShopData(true)
end

function UIRuneShopCtr:RefreshCurShopData(forceRefresh)
	self.isAirShip = false
	ManagerContainer.DataMgr.RuneShopDataMgr:RefreshShopData(self.shopType, self.shopSubType, forceRefresh)
	self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
	if self.curShopData then
		if not self.curShopData:IsValidShow() then
			self.curShopData:RefreshShowGoodsDatas()
		end
	end
end

function  UIRuneShopCtr:RefreshCurRewardsData()
	self.isAirShip = true
	ManagerContainer.DataMgr.RuneShopDataMgr:RefreshRewardData()
	self.curRewardsData = ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData()
end

function UIRuneShopCtr:GetShopType()
	return self.shopType
end

function UIRuneShopCtr:ChangeShopType(shopType)
	if self.shopType == shopType then
		return false
	end
	self.shopType = shopType
	if shopType == Enum.RuneShopType.Gifts then
		self.shopSubType = Enum.RuneShopSubType.Daily
	else
		self.shopSubType = nil
	end
	if self.shopType then
		self:RefreshCurShopData(true)
	else
		self:RefreshCurRewardsData()
	end
	
	return true
end

function UIRuneShopCtr:GetShopSubType()
	return self.shopSubType
end

function UIRuneShopCtr:ChangeShopSubType(shopSubType)
	if self.shopSubType == shopSubType then
		return false
	end
	self.shopSubType = shopSubType
	self:RefreshCurShopData(true)
	return true
end

function UIRuneShopCtr:GetCurVipLv()
	return ManagerContainer.DataMgr.UserData:GetVipLv()
end

function UIRuneShopCtr:GetOwnResCountByItemId(cfgId)
	return CommonUtil.GetOwnResCountByItemId(cfgId)
end

function UIRuneShopCtr:GetShowGoodsDatas()
	return self.curShopData and self.curShopData:GetShowGoodsDatas() or nil
end

function UIRuneShopCtr:GetRemainTime()
	return self.curShopData and self.curShopData:RefreshRemainTime() or nil
end

function UIRuneShopCtr:GetRewardsRemainTime()
	return self.curRewardsData and self.curRewardsData:RefreshRewaradsRemainTime() or nil
end

function UIRuneShopCtr:GetShowGoodsDataByIdx(idx)
	if self.curShopData then
		local showGoodsDatas = self.curShopData:GetShowGoodsDatas()
		if showGoodsDatas then
			return showGoodsDatas[idx]
		end
	end
	return nil
end

function UIRuneShopCtr:GetShowRewardsDataByIdx(idx)
	
	return self.curRewardsData and self.curRewardsData:GetGoodsDataByIdx(idx) or nil
end

--战令悬赏数据
function UIRuneShopCtr:GetShowRewardsData()
	return self.curRewardsData:GetShowRewardsData()
end

function UIRuneShopCtr:GetRewardsBaseData()
	return ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData() --self.curRewardsData
end



function UIRuneShopCtr:GetShowReardsNearMinCashReward(min)
	return self.curRewardsData and self.curRewardsData:GetShowReardsNearMinCashReward(min) or nil
end

function UIRuneShopCtr:GetShowReardsNearMaxCashReward(max)
	return self.curRewardsData and self.curRewardsData:GetShowReardsNearMaxCashReward(max) or nil
end


function UIRuneShopCtr:SendPay(goodsId)
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.shopType, self.shopSubType, goodsId)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

return UIRuneShopCtr

