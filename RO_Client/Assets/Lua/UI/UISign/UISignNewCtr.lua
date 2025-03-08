local UISignNewCtr = class("UISignNewCtr", require("UICtrBase"))

function UISignNewCtr:Init(view)
	self.view = view
end

function UISignNewCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISignNewCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISignNewCtr:GetData()
	return self.data
end

function UISignNewCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISignNewCtr

