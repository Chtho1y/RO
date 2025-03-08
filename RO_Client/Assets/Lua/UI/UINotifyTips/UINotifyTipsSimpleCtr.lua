local UINotifyTipsSimpleCtr = class("UINotifyTipsSimpleCtr", require("UICtrBase"))

function UINotifyTipsSimpleCtr:Init(view)
	self.view = view
end

function UINotifyTipsSimpleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return false end
	if self.data then
		if self.data[1] == data[1] or self.data[2] == data[2] then
			return false
		end
	end
	self.data = data
	return true
end

function UINotifyTipsSimpleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINotifyTipsSimpleCtr:GetData()
	return self.data
end

function UINotifyTipsSimpleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UINotifyTipsSimpleCtr:GetTitleAndContent()
	if self.data then
		return self.data[1], self.data[2]
	end
	return nil, nil
end

return UINotifyTipsSimpleCtr

