local UIFightPowerTipsCtr = class("UIFightPowerTipsCtr", require("UICtrBase"))

function UIFightPowerTipsCtr:Init(view)
	self.view = view
end

function UIFightPowerTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFightPowerTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFightPowerTipsCtr:GetData()
	return self.data
end

function UIFightPowerTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFightPowerTipsCtr

