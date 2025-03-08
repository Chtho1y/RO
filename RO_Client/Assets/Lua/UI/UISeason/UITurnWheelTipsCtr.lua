local UITurnWheelTipsCtr = class("UITurnWheelTipsCtr", require("UICtrBase"))

function UITurnWheelTipsCtr:Init(view)
	self.view = view
end

function UITurnWheelTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UITurnWheelTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITurnWheelTipsCtr:GetData()
	return self.data
end

function UITurnWheelTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITurnWheelTipsCtr

