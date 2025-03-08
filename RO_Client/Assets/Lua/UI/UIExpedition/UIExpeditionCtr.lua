local UIExpeditionCtr = class("UIExpeditionCtr", require("UICtrBase"))

function UIExpeditionCtr:Init(view)
	self.view = view
end

function UIExpeditionCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionCtr:GetData()
	return self.data
end

function UIExpeditionCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExpeditionCtr

