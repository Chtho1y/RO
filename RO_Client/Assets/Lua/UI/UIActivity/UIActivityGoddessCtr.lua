local UIActivityGoddessCtr = class("UIActivityGoddessCtr", require("UICtrBase"))

function UIActivityGoddessCtr:Init(view)
	self.view = view
end

function UIActivityGoddessCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityGoddessCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityGoddessCtr:GetData()
	return self.data
end

function UIActivityGoddessCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.activityData = nil
	self.lastSendReq = nil
end

function UIActivityGoddessCtr:InitData()
	local actId = self:GetActId()
	self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
end

function UIActivityGoddessCtr:GetActId()
	return self.data.actId
end

function UIActivityGoddessCtr:GetBg()
	return self.data.pageBg
end

function UIActivityGoddessCtr:GetActivityData()
	return self.activityData
end

function UIActivityGoddessCtr:SendGiveLikabilityReq(id, itemCfgId, lv)
	if not self.activityData then
		return 551
	end
	if self.lastSendReq and (ManagerContainer.LuaTimerMgr:GetTimeSecond() - self.lastSendReq) < 0.1 then
		return 0
	end
	local actId = self:GetActId()
	local cfgDatas = ManagerContainer.CfgMgr:GetActivityGoddessGiftCfgByActId(actId)
	if not cfgDatas then
		return 551
	end
	local cfgData = cfgDatas[id]
	if not cfgData or cfgData.Classitemid ~= itemCfgId then
		return 551
	end

	local curLoveLv = self.activityData:GetCurLoveLv()
	local loveCfgData = ManagerContainer.CfgMgr:GetActivityGoddessLoveCfgByLv(actId, curLoveLv)
	if not loveCfgData or not loveCfgData.LikeMax or loveCfgData.LikeMax <= 0 then
		return 'LikeLevelMaxTips'
	end
	local curLoveVal = self.activityData:GetCurLoveVal()
	if loveCfgData.LikeMax <= curLoveVal then
		return 'LikeLevelMaxTips'
	end

	local giveGift = cfgData.Classcostaddlike[lv]
	if not giveGift then
		return 551
	end
	local ownerNum = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	if ownerNum < giveGift[1] then
		return 'ItemNotEnoughDefault'
	end

	self.lastSendReq = ManagerContainer.LuaTimerMgr:GetTimeSecond()
	local actId = self:GetActId()
	ManagerContainer.DataMgr.ActsDataMgr:SendGiveLikabilityReq(actId, itemCfgId, lv)
	return 0
end


return UIActivityGoddessCtr

