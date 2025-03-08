local UIWaitingCtr = class("UIWaitingCtr", require("UICtrBase"))

function UIWaitingCtr:Init(view)
	self.view = view
end

function UIWaitingCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIWaitingCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWaitingCtr:GetData()
	return self.data
end

function UIWaitingCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIWaitingCtr

