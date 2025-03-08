local UIExchangeCodeCtr = class("UIExchangeCodeCtr", require("UICtrBase"))

function UIExchangeCodeCtr:Init(view)
	self.view = view
end

function UIExchangeCodeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExchangeCodeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExchangeCodeCtr:GetData()
	return self.data
end

function UIExchangeCodeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExchangeCodeCtr

