local UIFashionTotalCtr = class("UIFashionTotalCtr", require("UICtrBase"))

function UIFashionTotalCtr:Init(view)
	self.view = view
end

function UIFashionTotalCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.title = self.data.title
	self.title1 = self.data.title1
	self.attrs = self.data.attrs
	self.attrs1 = self.data.attrs1
end

function UIFashionTotalCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionTotalCtr:GetData()
	return self.data
end

function UIFashionTotalCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFashionTotalCtr:GetTile()
	return self.title
end

function UIFashionTotalCtr:GetTile1()
	return self.title1
end

function UIFashionTotalCtr:GetAttrs()
	return self.attrs
end

function UIFashionTotalCtr:GetAttrs1()
	return self.attrs1
end

return UIFashionTotalCtr

