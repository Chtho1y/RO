local UISignCtr = class("UISignCtr", require("UICtrBase"))

function UISignCtr:Init(view)
	self.view = view
end

function UISignCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISignCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISignCtr:GetData()
	return self.data
end

function UISignCtr:OnDispose()
	self.data = nil
	self.view = nil
end
return UISignCtr

