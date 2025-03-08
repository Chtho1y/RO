local UIActivationCodeCtr = class("UIActivationCodeCtr", require("UICtrBase"))

function UIActivationCodeCtr:Init(view)
	self.view = view
end

function UIActivationCodeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivationCodeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivationCodeCtr:GetData()
	return self.data
end

function UIActivationCodeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIActivationCodeCtr

