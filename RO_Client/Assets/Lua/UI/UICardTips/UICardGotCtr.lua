local UICardGotCtr = class("UICardGotCtr", require("UICtrBase"))

function UICardGotCtr:Init(view)
	self.view = view
end

function UICardGotCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UICardGotCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardGotCtr:GetData()
	return self.data
end

function UICardGotCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardGotCtr

