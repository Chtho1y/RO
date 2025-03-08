local UIGetNowPopCtr = class("UIGetNowPopCtr", require("UICtrBase"))

function UIGetNowPopCtr:Init(view)
	self.view = view
end

function UIGetNowPopCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGetNowPopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGetNowPopCtr:GetData()
	return self.data
end

function UIGetNowPopCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGetNowPopCtr

