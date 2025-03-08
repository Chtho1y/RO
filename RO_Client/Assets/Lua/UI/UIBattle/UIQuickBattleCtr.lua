local UIQuickBattleCtr = class("UIQuickBattleCtr", require("UICtrBase"))

function UIQuickBattleCtr:Init(view)
	self.view = view
end

function UIQuickBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIQuickBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIQuickBattleCtr:GetData()
	return self.data
end

function UIQuickBattleCtr:LeftCnt()
	local maxCnt = ManagerContainer.LuaBattleMgr:MaxQuickBattleTimes()
	local usedCnt = ManagerContainer.LuaBattleMgr:UsedQuickBattleTimes()
	return  maxCnt - usedCnt 
end

function UIQuickBattleCtr:GetUseCondition()
	local leftCnt = self:LeftCnt()
	if leftCnt == 0 then
		return "已达上限", true
	end

	local nextTimes = ManagerContainer.LuaBattleMgr:UsedQuickBattleTimes() + 1
	local costCfg = ManagerContainer.CfgMgr:GetQuickBattleCost(nextTimes)
	if costCfg == nil or costCfg.Cost == 0 then
		return I18N.T("Free"), true
	end

	local enough = costCfg.Cost <= ManagerContainer.DataMgr.UserData:GetOwnDiamond()
	return tostring(costCfg.Cost), enough
end

function UIQuickBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIQuickBattleCtr

