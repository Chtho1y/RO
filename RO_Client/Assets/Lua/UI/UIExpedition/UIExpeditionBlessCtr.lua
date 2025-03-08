local UIExpeditionBlessCtr = class("UIExpeditionBlessCtr", require("UICtrBase"))

function UIExpeditionBlessCtr:Init(view)
	self.view = view
end

function UIExpeditionBlessCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionBlessCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionBlessCtr:GetData()
	return self.data
end

function UIExpeditionBlessCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExpeditionBlessCtr

