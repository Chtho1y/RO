local UIExpeditionRankCtr = class("UIExpeditionRankCtr", require("UICtrBase"))

function UIExpeditionRankCtr:Init(view)
	self.view = view
end

function UIExpeditionRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionRankCtr:GetData()
	return self.data
end

function UIExpeditionRankCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExpeditionRankCtr

