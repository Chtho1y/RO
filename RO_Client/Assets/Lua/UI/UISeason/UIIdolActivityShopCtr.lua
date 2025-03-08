local UIIdolActivityShopCtr = class("UIIdolActivityShopCtr", require("UICtrBase"))

function UIIdolActivityShopCtr:Init(view)
	self.view = view
end

function UIIdolActivityShopCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIIdolActivityShopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIIdolActivityShopCtr:GetData()
	return self.data
end

function UIIdolActivityShopCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.shopType = nil
	self.shopSubType = nil
	self.idx = nil
end

function UIIdolActivityShopCtr:InitData()
    self.shopType = Enum.RuneShopType.IdolShop
end

function UIIdolActivityShopCtr:GetIdx()
	return self.idx
end

function UIIdolActivityShopCtr:GetCurShopType()
    return self.shopType, self.shopSubType
end

function UIIdolActivityShopCtr:RefreshCurShopData(forceRefresh)
	 ManagerContainer.DataMgr.RuneShopDataMgr:RefreshShopData(self.shopType, self.shopSubType, forceRefresh)
	self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
	if self.curShopData then
		if not self.curShopData:IsValidShow() then
			self.curShopData:RefreshShowGoodsDatas()
		end
		return true
	end
	return false
end

function UIIdolActivityShopCtr:GetGuildsmenRewords()
    return self.guildsmenRewords
end

function UIIdolActivityShopCtr:GetMvpRewords()
    return self.mvpRewords
end

function UIIdolActivityShopCtr:SendShopInfoReq()
	ManagerContainer.DataMgr.RuneShopDataMgr:SendShopInfoReq(self.shopType,nil)
end

function UIIdolActivityShopCtr:GetShowGoodsDatas()
    if not self.curShopData then
        self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
        if self.curShopData then
            if not self.curShopData:IsValidShow() then
                self.curShopData:RefreshShowGoodsDatas()
            end
        end
    end
	return self.curShopData and self.curShopData:GetShowGoodsDatas() or nil
end

function UIIdolActivityShopCtr:SendPay(goodsId)
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.shopType, self.shopSubType, goodsId)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

function UIIdolActivityShopCtr:SendRewardReq(rewardType)
	ManagerContainer.DataMgr.RankActivitiesMgr:SendRewardReq(self.type, rewardType)
end

return UIIdolActivityShopCtr