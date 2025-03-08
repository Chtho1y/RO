local UIIdolMyFansTipsCtr = class("UIIdolMyFansTipsCtr", require("UICtrBase"))

function UIIdolMyFansTipsCtr:Init(view)
	self.view = view
end

function UIIdolMyFansTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIIdolMyFansTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIIdolMyFansTipsCtr:GetData()
	return self.data
end

function UIIdolMyFansTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIIdolMyFansTipsCtr

