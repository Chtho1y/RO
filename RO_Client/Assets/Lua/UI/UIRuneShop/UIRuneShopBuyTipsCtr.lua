local UIRuneShopBuyTipsCtr = class("UIRuneShopBuyTipsCtr", require("UICtrBase"))

function UIRuneShopBuyTipsCtr:Init(view)
	self.view = view
end

function UIRuneShopBuyTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRuneShopBuyTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRuneShopBuyTipsCtr:GetData()
	return self.data
end

function UIRuneShopBuyTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.runeShopType = nil
	self.runeShopSubType = nil
	self.id = nil
	self.curShopData = nil
	self.curGoodsData = nil
	self.giftName = nil
	self.isLimitNum = nil
	self.remainNum = nil
	self.price = nil
	self.rewards = nil
end

function UIRuneShopBuyTipsCtr:InitData()
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
	if self.curGoodsData then
		local cfgData = self.curGoodsData:GetCfgData()
		if self.runeShopType == Enum.RuneShopType.MonthCard then
			self.giftName = cfgData.Name
			self.isLimitNum = false
			self.remainNum = 0
			self.price = self.curGoodsData:GetPrice()
			self.rewards = nil
		elseif self.runeShopType == Enum.RuneShopType.Gifts then
			local remainNum = self.curGoodsData:GetRemainBuyNum()
			self.giftName = cfgData.Name
			self.isLimitNum = (remainNum >= 0)
			self.remainNum = remainNum
			self.price = self.curGoodsData:GetPrice()
			self.rewards = {}
			local rewards = cfgData.Reward
			if rewards then
				local reward
				for i = 1, #rewards do
					reward = rewards[i]
					self.rewards[i] = {cfgId = reward[1], num = reward[2]}
				end
			end
		elseif self.runeShopType == Enum.RuneShopType.LimitTime then
			local remainNum = self.curGoodsData:GetRemainBuyNum()
			self.giftName = cfgData.Name
			self.isLimitNum = (remainNum >= 0)
			self.remainNum = remainNum
			self.price = self.curGoodsData:GetPrice()
			self.rewards = {}
			local rewards = cfgData.BuyReward
			if rewards then
				local reward
				for i = 1, #rewards do
					reward = rewards[i]
					self.rewards[i] = {cfgId = reward[1], num = reward[2]}
				end
			end
		else
			self.giftName = ''
			self.isLimitNum = false
			self.remainNum = 0
			self.price = 0
			self.rewards = nil
		end
	else
		self.giftName = ''
		self.isLimitNum = false
		self.remainNum = 0
		self.price = 0
		self.rewards = nil
	end
end

function UIRuneShopBuyTipsCtr:GetGiftName()
	return self.giftName
end

function UIRuneShopBuyTipsCtr:IsLimitNum()
	return self.isLimitNum
end

function UIRuneShopBuyTipsCtr:GetRemainNum()
	return self.remainNum
end

function UIRuneShopBuyTipsCtr:GetPrice()
	return self.price
end

function UIRuneShopBuyTipsCtr:GetCurGoodsData()
	return self.curGoodsData
end

function UIRuneShopBuyTipsCtr:GetShopType()
	return self.runeShopType
end

function UIRuneShopBuyTipsCtr:GetRewards()
	return self.rewards or {}
end

function UIRuneShopBuyTipsCtr:SendPay()
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.runeShopType, self.runeShopSubType, self.id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

return UIRuneShopBuyTipsCtr

