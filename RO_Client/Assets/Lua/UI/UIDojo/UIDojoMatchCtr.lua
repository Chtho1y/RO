local UIDojoMatchCtr = class("UIDojoMatchCtr", require("UICtrBase"))

function UIDojoMatchCtr:Init(view)
	self.view = view
	self.ourMembers = nil
end

function UIDojoMatchCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoMatchCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoMatchCtr:GetData()
	return self.data
end

function UIDojoMatchCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIDojoMatchCtr

