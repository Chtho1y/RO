local UIChipProduceNoticeCtr = class("UIChipProduceNoticeCtr", require("UICtrBase"))

function UIChipProduceNoticeCtr:Init(view)
	self.view = view
end

function UIChipProduceNoticeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChipProduceNoticeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChipProduceNoticeCtr:GetData()
	return self.data
end

function UIChipProduceNoticeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIChipProduceNoticeCtr:SureDecompose()
	self.data[2](self.data[1])
end

function UIChipProduceNoticeCtr:CancelDecompose()
	self.data[3](self.data[1])
end

return UIChipProduceNoticeCtr

