local UIHundredDojoSloganCtr = class("UIHundredDojoSloganCtr", require("UICtrBase"))

function UIHundredDojoSloganCtr:Init(view)
	self.view = view
end

function UIHundredDojoSloganCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoSloganCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoSloganCtr:GetData()
	return self.data
end

function UIHundredDojoSloganCtr:OnDispose()
	self.sloganLengthMax = nil
	self.changeSlogan = nil

	self.data = nil
	self.view = nil
end

function UIHundredDojoSloganCtr:InitData()
	self.sloganLengthMax = GlobalConfig.Instance:GetConfigIntValue(276)
	self.changeSlogan = self:GetCurSlogan()
end

function UIHundredDojoSloganCtr:GetSloganLengthMax()
	return self.sloganLengthMax
end

function UIHundredDojoSloganCtr:GetCurSlogan()
	return ManagerContainer.DataMgr.HundredDojoDataMgr:GetSlogan() or ''
end

function UIHundredDojoSloganCtr:GetChangeSlogan()
	return self.changeSlogan
end

function UIHundredDojoSloganCtr:SetChangeSlogan(slogan)
	self.changeSlogan = slogan
end

function UIHundredDojoSloganCtr:SendChangeSlogan()
	if not self.changeSlogan then
		self.changeSlogan = ''
	end
	if self:GetCurSlogan() == self.changeSlogan then
		return 1
	end
	local level = ManagerContainer.DataMgr.UserData:GetRoleLv()
	if not SDKMgr.Instance:CheckSpeech(level, ChannelType.HUNDRED_DOJO_SLOGAN, self.changeSlogan) then
		return 'ShieldTips01'
	end
	if not ManagerContainer.DataMgr.HundredDojoDataMgr:SendChangeSlogan(self.changeSlogan) then
		return 100007
	end
	return 0
end

return UIHundredDojoSloganCtr

