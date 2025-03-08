local UIStorySkipCtr = class("UIStorySkipCtr", require("UICtrBase"))

function UIStorySkipCtr:Init(view)
	self.view = view
end

function UIStorySkipCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStorySkipCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStorySkipCtr:GetData()
	return self.data
end

function UIStorySkipCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIStorySkipCtr

