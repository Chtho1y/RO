local UINotifyActivityTipsCtr = class("UINotifyActivityTipsCtr", require("UICtrBase"))

function UINotifyActivityTipsCtr:Init(view)
	self.view = view
end

function UINotifyActivityTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINotifyActivityTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINotifyActivityTipsCtr:GetData()
	return self.data
end

function UINotifyActivityTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UINotifyActivityTipsCtr

