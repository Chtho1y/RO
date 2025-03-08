local UIRuneShopGoldBuyTipsCtr = class("UIRuneShopGoldBuyTipsCtr", require("UICtrBase"))

function UIRuneShopGoldBuyTipsCtr:Init(view)
	self.view = view
end

function UIRuneShopGoldBuyTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRuneShopGoldBuyTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRuneShopGoldBuyTipsCtr:GetData()
	return self.data
end

function UIRuneShopGoldBuyTipsCtr:OnDispose()
	self.runeShopType = nil
	self.runeShopSubType = nil
	self.id = nil
	self.curGoodsData = nil

	self.data = nil
	self.view = nil
end

function UIRuneShopGoldBuyTipsCtr:InitData()
	if self.data then
		self.runeShopType = self.data[1]
		self.runeShopSubType = self.data[2]
		self.id = self.data[3]
	else
		self.runeShopType = Enum.RuneShopType.Gifts
		self.runeShopSubType = Enum.RuneShopSubType.Gold
		self.id = 1
	end
	
	self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.runeShopType, self.runeShopSubType)
	if self.curShopData then
		self.curGoodsData = self.curShopData:GetGoodsDataByIdx(self.id)
	else
		self.curGoodsData = nil
	end
end

function UIRuneShopGoldBuyTipsCtr:GetCurGoodsData()
	return self.curGoodsData
end

function UIRuneShopGoldBuyTipsCtr:SendPay()
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.runeShopType, self.runeShopSubType, self.id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

return UIRuneShopGoldBuyTipsCtr

