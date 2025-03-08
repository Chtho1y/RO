local UIExchangeCtr = class("UIExchangeCtr", require("UICtrBase"))

function UIExchangeCtr:Init(view)
	self.view = view
end

function UIExchangeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExchangeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExchangeCtr:GetData()
	return self.data
end

function UIExchangeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExchangeCtr

