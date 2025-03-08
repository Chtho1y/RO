local UIRefineExtraPopCtr = class("UIRefineExtraPopCtr", require("UICtrBase"))

function UIRefineExtraPopCtr:Init(view)
	self.view = view
end

function UIRefineExtraPopCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIRefineExtraPopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRefineExtraPopCtr:GetData()
	return self.data
end

function UIRefineExtraPopCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIRefineExtraPopCtr

