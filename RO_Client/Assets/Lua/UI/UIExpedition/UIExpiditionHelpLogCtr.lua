local UIExpiditionHelpLogCtr = class("UIExpiditionHelpLogCtr", require("UICtrBase"))

function UIExpiditionHelpLogCtr:Init(view)
	self.view = view
end

function UIExpiditionHelpLogCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpiditionHelpLogCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpiditionHelpLogCtr:GetData()
	return self.data
end

function UIExpiditionHelpLogCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIExpiditionHelpLogCtr

