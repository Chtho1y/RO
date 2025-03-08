local UIExpeditionBattleCtr = class("UIExpeditionBattleCtr", require("UICtrBase"))

function UIExpeditionBattleCtr:Init(view)
	self.view = view
end

function UIExpeditionBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionBattleCtr:GetData()
	return self.data
end

function UIExpeditionBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExpeditionBattleCtr

