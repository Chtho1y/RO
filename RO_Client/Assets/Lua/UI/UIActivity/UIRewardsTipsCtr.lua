local UIRewardsTipsCtr = class("UIRewardsTipsCtr", require("UICtrBase"))

function UIRewardsTipsCtr:Init(view)
	self.view = view
end

function UIRewardsTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRewardsTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRewardsTipsCtr:GetData()
	return self.data
end

function UIRewardsTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIRewardsTipsCtr

