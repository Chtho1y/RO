local UISimpleWebCtr = class("UISimpleWebCtr", require("UICtrBase"))

function UISimpleWebCtr:Init(view)
	self.view = view
end

function UISimpleWebCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISimpleWebCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISimpleWebCtr:GetData()
	return self.data
end

function UISimpleWebCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISimpleWebCtr

