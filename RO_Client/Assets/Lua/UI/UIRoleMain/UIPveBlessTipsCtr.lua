local UIPveBlessTipsCtr = class("UIPveBlessTipsCtr", require("UICtrBase"))

function UIPveBlessTipsCtr:Init(view)
	self.view = view
end

function UIPveBlessTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPveBlessTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPveBlessTipsCtr:GetData()
	return self.data
end

function UIPveBlessTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPveBlessTipsCtr

