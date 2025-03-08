local UIFilterCtr = class("UIFilterCtr", require("UICtrBase"))

function UIFilterCtr:Init(view)
	self.view = view
end

function UIFilterCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFilterCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFilterCtr:GetData()
	return self.data
end

function UIFilterCtr:GetUIId()
	return self.data.uiId
end

function UIFilterCtr:GetEnter()
	return self.data.enter
end

function UIFilterCtr:GetFilterData()
	return self.data.filterData
end

function UIFilterCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFilterCtr

