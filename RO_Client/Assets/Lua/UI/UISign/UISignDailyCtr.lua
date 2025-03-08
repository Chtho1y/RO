local UISignDailyCtr = class("UISignDailyCtr", require("UICtrBase"))

function UISignDailyCtr:Init(view)
	self.view = view
end

function UISignDailyCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISignDailyCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISignDailyCtr:GetData()
	return self.data
end

function UISignDailyCtr:RefreshShowDatas()
	self.canSignToday = ManagerContainer.DataMgr.SignData:CanTodaySign()
	local curDay = ManagerContainer.DataMgr.SignData:GetCurSignedDay()
	local startDay = math.floor(curDay/30)*30 + 1
	local maxSignDay = ManagerContainer.CfgMgr:GetMaxSignDay()
	if curDay == maxSignDay then
			startDay = startDay - 30
	end
	self.showDatas = {}
	for i = startDay, startDay + 29 do
			local signCfgData = ManagerContainer.CfgMgr:GetSignInCfg(i)
			if signCfgData then
					self.showDatas[#self.showDatas + 1] = signCfgData
			end
	end
	return self.showDatas
end

function UISignDailyCtr:GetCanSignToday()
	return self.canSignToday
end

function UISignDailyCtr:GetShowDataLength()
	return self.showDatas and #self.showDatas or 0
end

function UISignDailyCtr:GetShowData(itemIndex)
	if not self.showDatas then
		return
	end

	return self.showDatas[itemIndex + 1]
end

function UISignDailyCtr:SendSignUp()
 	ManagerContainer.DataMgr.SignData:SendSignUpReq()
end

function UISignDailyCtr:OnDispose()
	self.showDatas = nil

	self.data = nil
	self.view = nil
end

return UISignDailyCtr

