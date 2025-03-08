local UIRewardsBuyTipsCtr = class("UIRewardsBuyTipsCtr", require("UICtrBase"))
local inspect = require "util.inspect"

function UIRewardsBuyTipsCtr:Init(view)
	self.view = view
end

function UIRewardsBuyTipsCtr:InitData()
	self.rewards = {}
	local runeShopBaseData = ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData()

	local cfg = runeShopBaseData:GetRewardsCurRoundCfg()
	self.expUp = cfg.MissonExpUp
	self.price = cfg.RMB

	local hasMissionExp
	local missionExp = runeShopBaseData:GetRewardsMissionExp()
	if missionExp then
		if missionExp > 0 then
			hasMissionExp = true
		end
	end
	if hasMissionExp then
		--战令icon
		self.rewards[1] = {cfgId = 35 , num =missionExp *(self.expUp -100)/100}
	end
	for i=1,runeShopBaseData:GetShowRewardsCurLv() do
		local tempdata = runeShopBaseData:GetGoodsDataByIdx(i)
		local hasId = false
		for j = 1, #self.rewards do
			if self.rewards[j].cfgId == tempdata.cfgData.CashReward[1][1] then
				self.rewards[j].num = self.rewards[j].num + tempdata.cfgData.CashReward[1][2]
				hasId = true
				break
			end
		end
		if not hasId then
			self.rewards[#self.rewards +1] = {cfgId = tempdata.cfgData.CashReward[1][1], num = tempdata.cfgData.CashReward[1][2]}
		end
	end
	--LogError("aaa"..tostring(#self.rewards).."bbb"..Inspect(self.rewards))
end

function UIRewardsBuyTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRewardsBuyTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRewardsBuyTipsCtr:GetData()
	return self.data
end

function UIRewardsBuyTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIRewardsBuyTipsCtr:GetCurGoodsData()
	return self.rewards
end

function UIRewardsBuyTipsCtr:GetGiftName()
	return string.formatbykey('HighReward')
end

function UIRewardsBuyTipsCtr:GetPrice()
	return self.price
end

function UIRewardsBuyTipsCtr:GetExpUp()
	local baseData = ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData()
	return tostring(ManagerContainer.CfgMgr:GetRuneShopExploreCfgByRound(ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData():GetShowRewardsRoundData()).MissonExpUp)..'%'
end 

function UIRewardsBuyTipsCtr:SendPay()
	local round = ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData():GetShowRewardsRoundData()
	local errorCode = ManagerContainer.PayMgr:AirShipPay(round)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

return UIRewardsBuyTipsCtr

