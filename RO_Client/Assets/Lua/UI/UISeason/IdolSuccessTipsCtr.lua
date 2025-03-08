local IdolSuccessTipsCtr = class("IdolSuccessTipsCtr", require("UICtrBase"))

function IdolSuccessTipsCtr:Init(view)
	self.view = view
end

function IdolSuccessTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function IdolSuccessTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function IdolSuccessTipsCtr:GetData()
	return self.data
end

function IdolSuccessTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return IdolSuccessTipsCtr

