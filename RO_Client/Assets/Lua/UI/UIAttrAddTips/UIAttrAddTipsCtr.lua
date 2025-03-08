local UIAttrAddTipsCtr = class("UIAttrAddTipsCtr", require("UICtrBase"))

function UIAttrAddTipsCtr:Init(view)
	self.view = view
end

function UIAttrAddTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UIAttrAddTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIAttrAddTipsCtr:GetData()
	return self.data
end

function UIAttrAddTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIAttrAddTipsCtr

