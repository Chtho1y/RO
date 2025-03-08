local UIActivitySignDailyCtr = class("UIActivitySignDailyCtr", require("UICtrBase"))

function UIActivitySignDailyCtr:Init(view)
	self.view = view
end

function UIActivitySignDailyCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivitySignDailyCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivitySignDailyCtr:GetData()
	return self.data
end
function UIActivitySignDailyCtr:GetActId()
  	return self.data and self.data.actId or 0
end

function UIActivitySignDailyCtr:RefreshShowDatas()
	local actId = self:GetActId()
	if not actId then
		return
	end
	if not self.actItem then
		self.actItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
		if not self.actItem then
			return
		end
	end
	self.canSignToday = self.actItem:GetCanSignToDay()
	self.curDay = self.actItem:GetSignDays()
	local showDatas = ManagerContainer.CfgMgr:GetActivitySignDataById(actId)
	self.showDatas = showDatas
	return self.showDatas
end

function UIActivitySignDailyCtr:GetRuleKey()
	return self.actItem and self.actItem.infoLangKey ~= '' and self.actItem.infoLangKey  or "not configuration"
end

function UIActivitySignDailyCtr:GetCanSignToday()
	return self.canSignToday
end

function UIActivitySignDailyCtr:GetSignDays()
	return self.curDay or 0
end

function UIActivitySignDailyCtr:GetShowDataLength()
	return self.showDatas and #self.showDatas or 0
end

function UIActivitySignDailyCtr:GetShowData(itemIndex)
	if not self.showDatas then
		return
	end

	return self.showDatas[itemIndex + 1]
end

function UIActivitySignDailyCtr:SendSignUp()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_SIGN_IN_REQ, {activity_id = self:GetActId()})
end

function UIActivitySignDailyCtr:OnDispose()
	self.showDatas = nil
	self.data = nil
	self.view = nil
end

return UIActivitySignDailyCtr
