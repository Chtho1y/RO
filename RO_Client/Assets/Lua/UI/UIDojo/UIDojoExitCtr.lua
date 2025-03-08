local UIDojoExitCtr = class("UIDojoExitCtr", require("UICtrBase"))

function UIDojoExitCtr:Init(view)
	self.view = view
end

function UIDojoExitCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoExitCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoExitCtr:GetData()
	return self.data
end

function UIDojoExitCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIDojoExitCtr

