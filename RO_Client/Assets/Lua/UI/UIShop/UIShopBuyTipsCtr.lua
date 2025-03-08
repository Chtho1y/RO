local UIShopBuyTipsCtr = class("UIShopBuyTipsCtr", require("UICtrBase"))

function UIShopBuyTipsCtr:Init(view)
	self.view = view
end

function UIShopBuyTipsCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIShopBuyTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIShopBuyTipsCtr:GetData()
	return self.data
end

function UIShopBuyTipsCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.curShopData = nil
	self.curGoodsData = nil
	self.maxBuyNumOnce = nil
	self.buyNum = nil
end

function UIShopBuyTipsCtr:InitData()
	local shopId = self.data[1]
	local goodId = self.data[2]
	self.curShopData = ManagerContainer.DataMgr.ShopDataMgr:GetShopData(shopId)
	if self.curShopData then
		self.curGoodsData = self.curShopData:GetGoodsDataById(goodId)
	else
		self.curGoodsData = nil
	end
	self.maxBuyNumOnce = GlobalConfig.Instance:GetConfigIntValue(120)
	self:SetBuyNum(1)
end

function UIShopBuyTipsCtr:GetCurShopData()
	return self.curShopData
end


function UIShopBuyTipsCtr:GetCurGoodsData()
	return self.curGoodsData
end

function UIShopBuyTipsCtr:GetCurPrice()
	return self.curGoodsData.curPrice
end

function UIShopBuyTipsCtr:GetMaxBuyNumOnce()
	return self.maxBuyNumOnce
end

function UIShopBuyTipsCtr:GetBuyNum()
	return self.buyNum
end

function UIShopBuyTipsCtr:SetBuyNum(buyNum)
	if not self:IsValidData() then
		return false
	end
	local remainBuyNum = self.curGoodsData:GetRemainBuyNum()
	if remainBuyNum >= 0 then
		if buyNum > remainBuyNum then
			buyNum = remainBuyNum
		end
	end
	local price = self.curGoodsData.curPrice
	local goodsCfgData = self.curGoodsData:GetGoodsCfgData()
	local ownCount = self:GetOwnResCountByItemId(goodsCfgData.PayForType)
	remainBuyNum = Mathf.Floor(ownCount / price)
	if buyNum > remainBuyNum then
		buyNum = remainBuyNum
	end
	buyNum = Mathf.Clamp(buyNum, 1, self.maxBuyNumOnce)
	if self.buyNum == buyNum then
		return false
	end
	self.buyNum = buyNum
	return true
end

function UIShopBuyTipsCtr:ChangeDeltaBuyNum(deltaBuyNum)
	local buyNum = self.buyNum + deltaBuyNum
	return self:SetBuyNum(buyNum)
end


function UIShopBuyTipsCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UIShopBuyTipsCtr:IsValidData()
	return self.curShopData and self.curGoodsData
end


function UIShopBuyTipsCtr:SendShopBuyItemReq()
	if not self:IsValidData() then
		return 390
	end
	local price = self.curGoodsData.curPrice
	local goodsCfgData = self.curGoodsData:GetGoodsCfgData()
	local ownCount = self:GetOwnResCountByItemId(goodsCfgData.PayForType)
	if ownCount < (price * self.buyNum) then
		return 391, goodsCfgData.PayForType
	end

	if not ManagerContainer.DataMgr.ShopDataMgr:SendShopBuyItemReq(self.curShopData.shopId, self.curGoodsData.id, self.buyNum) then
		return 100007
	end
	return 0
end

return UIShopBuyTipsCtr

