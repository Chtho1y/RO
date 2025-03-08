local UINoticeTipsCtr = class("UINoticeTipsCtr", require("UICtrBase"))

function UINoticeTipsCtr:Init(view)
	self.view = view
end

function UINoticeTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINoticeTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINoticeTipsCtr:GetData()
	return self.data
end

function UINoticeTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UINoticeTipsCtr

