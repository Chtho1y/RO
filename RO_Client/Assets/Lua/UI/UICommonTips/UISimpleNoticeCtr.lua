local UISimpleNoticeCtr = class("UISimpleNoticeCtr", require("UICtrBase"))

function UISimpleNoticeCtr:Init(view)
	self.view = view
end

function UISimpleNoticeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISimpleNoticeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISimpleNoticeCtr:GetData()
	return self.data
end

function UISimpleNoticeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UISimpleNoticeCtr:GetTitle()
	return self.data and self.data[1] or nil
end

function UISimpleNoticeCtr:GetContent()
	return self.data and self.data[2] or nil
end

return UISimpleNoticeCtr

