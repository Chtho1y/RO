local UIParterGotCtr = class("UIParterGotCtr", require("UICtrBase"))

function UIParterGotCtr:Init(view)
	self.view = view
end

function UIParterGotCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIParterGotCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIParterGotCtr:GetData()
	return self.data
end

function UIParterGotCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIParterGotCtr

