local UINatureInfoCtr = class("UINatureInfoCtr", require("UICtrBase"))

function UINatureInfoCtr:Init(view)
	self.view = view
end

function UINatureInfoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINatureInfoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINatureInfoCtr:GetData()
	return self.data
end

function UINatureInfoCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UINatureInfoCtr

