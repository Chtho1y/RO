local UIErrorTipsCtr = class("UIErrorTipsCtr", require("UICtrBase"))

function UIErrorTipsCtr:Init(view)
	self.view = view
end

function UIErrorTipsCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIErrorTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIErrorTipsCtr:GetData()
	return self.data
end

function UIErrorTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIErrorTipsCtr

