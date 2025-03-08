local UIForceGuideCtr = class("UIForceGuideCtr", require("UICtrBase"))

function UIForceGuideCtr:Init(view)
	self.view = view
end

function UIForceGuideCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIForceGuideCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIForceGuideCtr:GetData()
	return self.data
end

function UIForceGuideCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIForceGuideCtr

