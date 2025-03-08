local UICustomerServiceTipsCtr = class("UICustomerServiceTipsCtr", require("UICtrBase"))

function UICustomerServiceTipsCtr:Init(view)
	self.view = view
end

function UICustomerServiceTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICustomerServiceTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICustomerServiceTipsCtr:GetData()
	return self.data
end

function UICustomerServiceTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICustomerServiceTipsCtr

