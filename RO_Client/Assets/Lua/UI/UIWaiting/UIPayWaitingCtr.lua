local UIPayWaitingCtr = class("UIPayWaitingCtr", require("UICtrBase"))

function UIPayWaitingCtr:Init(view)
	self.view = view
end

function UIPayWaitingCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPayWaitingCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPayWaitingCtr:GetData()
	return self.data
end

function UIPayWaitingCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPayWaitingCtr

