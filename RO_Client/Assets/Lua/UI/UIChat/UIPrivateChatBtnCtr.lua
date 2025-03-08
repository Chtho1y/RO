local UIPrivateChatBtnCtr = class("UIPrivateChatBtnCtr", require("UICtrBase"))

function UIPrivateChatBtnCtr:Init(view)
	self.view = view
end

function UIPrivateChatBtnCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPrivateChatBtnCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPrivateChatBtnCtr:GetData()
	return self.data
end

function UIPrivateChatBtnCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPrivateChatBtnCtr

