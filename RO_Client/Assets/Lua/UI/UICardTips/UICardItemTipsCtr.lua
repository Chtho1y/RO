local UICardItemTipsCtr = class("UICardItemTipsCtr", require("UICtrBase"))

function UICardItemTipsCtr:Init(view)
	self.view = view
end

function UICardItemTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICardItemTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardItemTipsCtr:GetData()
	return self.data
end

function UICardItemTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardItemTipsCtr

