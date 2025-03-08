local UIHundredDojoRewardCtr = class("UIHundredDojoRewardCtr", require("UICtrBase"))

function UIHundredDojoRewardCtr:Init(view)
	self.view = view
end

function UIHundredDojoRewardCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoRewardCtr:GetData()
	return self.data
end

function UIHundredDojoRewardCtr:OnDispose()
	self.rewards = nil
	self.rewardTime = nil
	self.currencys = nil
	self.items = nil
	self.data = nil
	self.view = nil
end

function UIHundredDojoRewardCtr:InitData()
	local rewardMaxTime = GlobalConfig.Instance:GetConfigIntValue(255) * 3600
	local rewardInterval = GlobalConfig.Instance:GetConfigIntValue(252)
	if rewardInterval <= 0 then rewardInterval = 1 end
	local rewardRate = 60 / rewardInterval
	local baseRewardStr = GlobalConfig.Instance:GetConfigStrValue(301)
	local baseRewards = CommonUtil.DeserializeGlobalStrToNumberTable(baseRewardStr)

	local areaData = ManagerContainer.DataMgr.HundredDojoDataMgr:GetSelfAreaData()
	if areaData and areaData:IsOccupy() then
		local cfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaData.id)
		if cfgData and cfgData.ShowRewardList then
			for i = 1, 3 do
				local rewards = cfgData.ShowRewardList[i]
				if not rewards then
					break
				end
				if baseRewards[i] then
					if baseRewards[i][1] == rewards[1] then
						baseRewards[i][2] = baseRewards[i][2] + rewards[2]
					else
						LogError('[wboy] Hundred Dojo base reward cfg and seat reward cfg is not same !!!')
						break
					end
				else
					baseRewards[i] = rewards
				end
			end
		end
	end
	self.rewardRate = rewardRate
	self.rewards = baseRewards


	local rewardTime = 0
	if self.data then
		if self.data[1] then
			rewardTime = self.data[1] * rewardInterval
		end
	end
	if rewardMaxTime < rewardTime then
		rewardTime = rewardMaxTime
	end
	self.rewardTime = rewardTime

	local currencys = {}
	local items = {}
	if self.data then
		local getRewards = self.data[2]
		if getRewards then
			for i = 1, #getRewards do
				local getReward = getRewards[i]
				if getReward.key < 100 then
					currencys[getReward.key] = getReward.value
				else
					items[#items + 1] = {cfgId = getReward.key, num = getReward.value}
				end
			end
		end
	end

	if #items > 0 then
		table.sort(items, function (a, b)
			local _aCfg = ManagerContainer.CfgMgr:GetItemById(a.cfgId)
			local _bCfg = ManagerContainer.CfgMgr:GetItemById(b.cfgId)
			if _aCfg ~= nil and _bCfg == nil then
				return true;
			elseif _aCfg == nil and _bCfg ~= nil then
				return false;
			elseif _aCfg ~= nil and _bCfg ~= nil then
				local _aQuality = _aCfg.Quality
				local _bQuality = _bCfg.Quality
				if _aQuality ~= nil and _bQuality == nil then
					return true;
				elseif _aQuality == nil and _bQuality ~= nil then
					return false;
				elseif _aQuality ~= nil and _bQuality ~= nil then
					if _aQuality ~= _bQuality then
						return _aQuality > _bQuality
					else
						return a.cfgId < b.cfgId
					end
				else
					return a.cfgId < b.cfgId
				end
			else
				return a.cfgId < b.cfgId
			end
		end)
	end

	self.currencys = currencys
	self.items = items
end

function UIHundredDojoRewardCtr:GetRewardRate()
	return self.rewardRate
end

function UIHundredDojoRewardCtr:GetRewards()
	return self.rewards
end

function UIHundredDojoRewardCtr:GetRewardTime()
	return self.rewardTime
end

function UIHundredDojoRewardCtr:GetCurrencys()
	return self.currencys
end

function UIHundredDojoRewardCtr:GetItems()
	return self.items
end

return UIHundredDojoRewardCtr

