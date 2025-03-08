local UIVoyageReformingCtr = class("UIVoyageReformingCtr", require("UICtrBase"))

function UIVoyageReformingCtr:Init(view)
	self.view = view
end

function UIVoyageReformingCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIVoyageReformingCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVoyageReformingCtr:GetData()
	return self.data
end

function UIVoyageReformingCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIVoyageReformingCtr

