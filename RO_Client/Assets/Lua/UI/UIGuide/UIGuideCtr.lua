local UIGuideCtr = class("UIGuideCtr", require("UICtrBase"))

function UIGuideCtr:Init(view)
	self.view = view
end

function UIGuideCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuideCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuideCtr:GetData()
	return self.data
end

function UIGuideCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGuideCtr

