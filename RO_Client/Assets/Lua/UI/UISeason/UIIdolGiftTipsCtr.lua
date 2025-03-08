local UIIdolGiftTipsCtr = class("UIIdolGiftTipsCtr", require("UICtrBase"))

function UIIdolGiftTipsCtr:Init(view)
	self.view = view
end

function UIIdolGiftTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIIdolGiftTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIIdolGiftTipsCtr:GetData()
	return self.data
end

function UIIdolGiftTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIIdolGiftTipsCtr

