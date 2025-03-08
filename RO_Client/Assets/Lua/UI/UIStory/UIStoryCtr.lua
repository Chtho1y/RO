local UIStoryCtr = class("UIStoryCtr", require("UICtrBase"))

function UIStoryCtr:Init(view)
	self.view = view
end

function UIStoryCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStoryCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStoryCtr:GetData()
	return self.data
end

function UIStoryCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIStoryCtr

