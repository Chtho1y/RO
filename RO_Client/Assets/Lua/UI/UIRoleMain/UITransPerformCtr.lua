local UITransPerformCtr = class("UITransPerformCtr", require("UICtrBase"))

function UITransPerformCtr:Init(view)
	self.view = view
end

function UITransPerformCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UITransPerformCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITransPerformCtr:GetData()
	return self.data
end

function UITransPerformCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITransPerformCtr

