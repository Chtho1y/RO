local UIEvilCtr = class("UIEvilCtr", require("UICtrBase"))
local evilData = ManagerContainer.DataMgr.EvilData

function UIEvilCtr:Init(view)
	self.view = view
end

function UIEvilCtr:SetData(data)
	evilData:SendEvilRefreshReq(false)
	self:InitQualityData()
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIEvilCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIEvilCtr:GetData()
	return self.data
end

function UIEvilCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIEvilCtr:InitQualityData()
	local val = GlobalConfig.Instance:GetConfigStrValue(236)
	if val ~= nil and val ~= "" then
		self.qualityBGList = string.split(val,";")
	end
end

function UIEvilCtr:GetMaxEvilExp()
	return evilData.maxEvilExp
end

function UIEvilCtr:GetCurrentEvilExp()
	return ManagerContainer.DataMgr.UserData:GetEvilExp()
end

function UIEvilCtr:GetSlotData()
	return evilData.slots
end

function UIEvilCtr:GetSlotDataByIdx(idx)
	return evilData.slots[idx]
end

function UIEvilCtr:GetEvilLevel()
	return evilData.curEvilLevel
end

function UIEvilCtr:GetMaxLevel()
	return evilData.maxEvilLevel
end

function UIEvilCtr:NextLevelChallengedCount()
	return evilData.nextEvilLevelCnt - evilData.challengedCount
end


function UIEvilCtr:SendChallengeBoss(slotIdx)
	evilData:SendEvilChallengeReq(slotIdx)
end

function UIEvilCtr:GetUsedRefreshCnt()
	return evilData.maxFreeRefreshTimes - evilData.leftFreeCnt
end

function UIEvilCtr:LeftFreeCnt()
	return evilData.leftFreeCnt
end


function UIEvilCtr:GetMaxRefreshTimes()
	return evilData.maxFreeRefreshTimes
end

function UIEvilCtr:IsFreeForever()
	return evilData.isFreeLimit
end

function UIEvilCtr:GetCost()
	return evilData.costEvilExp
end

function UIEvilCtr:RefreshCost()
	return evilData.refreshCostGold
end

function UIEvilCtr:RefreshReq()
	evilData:SendEvilRefreshReq(true)
end

function UIEvilCtr:GetQualityColor(quality)
	if quality == 1 then
		return {0.7568628,0.9450981,0.8235295}
	elseif quality == 2 then
		return {0.7607843,0.9137255,1}
	elseif quality == 3 then
		return {0.9333333,0.8235294,1}
	elseif quality == 4 then
		return {1,0.8588235,0.6509804}
	end
	return {0.7568628,0.9450981,0.8235295}
end

function UIEvilCtr:GetQuialityBg(quality)
	if self.qualityBGList == nil then
		return nil
	end

	return self.qualityBGList[quality]
end

return UIEvilCtr

