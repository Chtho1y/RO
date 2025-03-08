local UIWishPOPGotCtr = class("UIWishPOPGotCtr", require("UICtrBase"))

function UIWishPOPGotCtr:Init(view)
	self.view = view
end

function UIWishPOPGotCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIWishPOPGotCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWishPOPGotCtr:GetData()
	return self.data
end

function UIWishPOPGotCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIWishPOPGotCtr

