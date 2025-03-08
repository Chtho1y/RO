local UICardProduceNoticeCtr = class("UICardProduceNoticeCtr", require("UICtrBase"))

function UICardProduceNoticeCtr:Init(view)
	self.view = view
end

function UICardProduceNoticeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UICardProduceNoticeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardProduceNoticeCtr:GetData()
	return self.data
end

function UICardProduceNoticeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardProduceNoticeCtr

