local UIPvpSuppressTipsCtr = class("UIPvpSuppressTipsCtr", require("UICtrBase"))

function UIPvpSuppressTipsCtr:Init(view)
	self.view = view
end

function UIPvpSuppressTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPvpSuppressTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPvpSuppressTipsCtr:GetData()
	return self.data
end

function UIPvpSuppressTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPvpSuppressTipsCtr

