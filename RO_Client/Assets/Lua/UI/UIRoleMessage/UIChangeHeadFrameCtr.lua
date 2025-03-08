local UIChangeHeadFrameCtr = class("UIChangeHeadFrameCtr", require("UICtrBase"))

function UIChangeHeadFrameCtr:Init(view)
	self.view = view
end

function UIChangeHeadFrameCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChangeHeadFrameCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChangeHeadFrameCtr:GetData()
	return self.data
end

function UIChangeHeadFrameCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIChangeHeadFrameCtr

