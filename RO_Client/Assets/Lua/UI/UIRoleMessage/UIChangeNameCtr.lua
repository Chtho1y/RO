local UIChangeNameCtr = class("UIChangeNameCtr", require("UICtrBase"))

function UIChangeNameCtr:Init(view)
	self.view = view
end

function UIChangeNameCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChangeNameCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChangeNameCtr:GetData()
	return self.data
end

function UIChangeNameCtr:OnDispose()
	self.data = nil
	self.view = nil
end


return UIChangeNameCtr

