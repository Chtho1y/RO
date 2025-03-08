local UISettingsCtr = class("UISettingsCtr", require("UICtrBase"))

function UISettingsCtr:Init(view)
	self.view = view
end

function UISettingsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISettingsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISettingsCtr:GetData()
	return self.data
end

function UISettingsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.headPortraits = nil
end

return UISettingsCtr

