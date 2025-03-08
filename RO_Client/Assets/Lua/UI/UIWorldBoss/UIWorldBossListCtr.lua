local UIWorldBossListCtr = class("UIWorldBossListCtr", require("UICtrBase"))

-- 24 * 60 * 60 * 1000
local OneDay = 86400000
-- 60 * 60 * 1000
local OneHour = 3600000
-- 60 * 1000
local OneMinute = 60000


function UIWorldBossListCtr:Init(view)
	self.view = view
end

function UIWorldBossListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIWorldBossListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWorldBossListCtr:GetData()
	return self.data
end

function UIWorldBossListCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.worldBossList = nil
	self.nextUpdateTimes = nil
	self:ClearWorldBossList()
end

function UIWorldBossListCtr:InitData()
	self:RefreshWorldBossList()
	self:RefreshCurLevel()
	self:RefreshMaxCount()
end

function UIWorldBossListCtr:ClearWorldBossList()
	ManagerContainer.DataMgr.WorldBossData:ClearWorldBossList()
end

function UIWorldBossListCtr:RefreshWorldBossList()
	self.worldBossList = ManagerContainer.DataMgr.WorldBossData:GetWorldBossList()
	self:RefreshNextUpdateTimes()
end

function UIWorldBossListCtr:GetWorldBossList()
	return self.worldBossList
end

function UIWorldBossListCtr:GetWorldBossByItemIndex(itemIndex)
	return self.worldBossList and self.worldBossList[itemIndex + 1] or nil
end

function UIWorldBossListCtr:RefreshCurLevel()
	self.curLevelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
end

function UIWorldBossListCtr:GetCurLevelId()
	return self.curLevelId
end

function UIWorldBossListCtr:GetChallengeCount()
	return ManagerContainer.DataMgr.WorldBossData:GetWorldBossCount()
end

function UIWorldBossListCtr:RefreshNextUpdateTimes()
	if not self.worldBossList then return end
	local num = #self.worldBossList
	if num <= 0 then return end
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	for i = 1, num do
		self:RefreshNextUpdateTime(self.worldBossList[i], i, curTime)
	end
end

function UIWorldBossListCtr:RefreshNextUpdateTime(worldBossData, idx, curTime)
	local nextUpdateTime = 0
	local remainTime = 0
	if worldBossData then
		if int64.__lt(0, worldBossData.expireTime) then
			remainTime = (worldBossData.expireTime - curTime)
			nextUpdateTime = self:CalcNextUpdateTime(remainTime, curTime)
		elseif int64.__lt(0, worldBossData.nextTime) then
			remainTime = (worldBossData.nextTime - curTime)
			nextUpdateTime = self:CalcNextUpdateTime(remainTime, curTime)
		end
	end
	self:SetNextUpdateTime(idx, nextUpdateTime)
	-- return remainTime
end

function UIWorldBossListCtr:CalcNextUpdateTime(remainTime, curTime)
	if int64.__le(OneDay, remainTime) then
		local validTime = remainTime % OneHour
		if int64.equals(validTime, 0) then validTime = OneHour end
		return curTime + validTime
	elseif int64.__le(OneHour, remainTime) then
		local validTime = remainTime % OneMinute
		if int64.equals(validTime, 0) then validTime = OneMinute end
		return curTime + validTime
	elseif int64.__le(0, remainTime) then
		local validTime = remainTime % 1000
		if int64.equals(validTime, 0) then validTime = 1000 end
		return curTime + validTime
	else
		return 0
	end
end

function UIWorldBossListCtr:GetNextUpdateTime(itemIndex)
	if not self.nextUpdateTimes then return nil end
	return self.nextUpdateTimes[itemIndex]
end

function UIWorldBossListCtr:SetNextUpdateTime(itemIndex, time)
	if not self.nextUpdateTimes then
		self.nextUpdateTimes = {}
	end
	self.nextUpdateTimes[itemIndex] = time
end

function UIWorldBossListCtr:RefreshMaxCount()
	local maxCount = GlobalConfig.Instance:GetConfigIntValue(154)
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	if vipCfg and vipCfg.WorldBossCount and vipCfg.WorldBossCount >= 1 then
		maxCount = maxCount + vipCfg.WorldBossCount
	end
	self.maxCount = maxCount
end

function UIWorldBossListCtr:GetMaxCount()
	return self.maxCount
end



--- 获得世界boss列表
---@return integer 0:发送成功；1:客户端限制发送
function UIWorldBossListCtr:SendRefreshBossListReq()
	
	return ManagerContainer.DataMgr.WorldBossData:SendWorldBossListRequest()
end

function UIWorldBossListCtr:SendChallengeBossReq(bossId, bossSummonIdx)
	ManagerContainer.DataMgr.WorldBossData:SendChallengeBossRequest(bossId, bossSummonIdx)
end

return UIWorldBossListCtr

