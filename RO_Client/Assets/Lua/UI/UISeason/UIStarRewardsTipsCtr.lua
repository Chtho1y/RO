local UIStarRewardsTipsCtr = class("UIStarRewardsTipsCtr", require("UICtrBase"))

function UIStarRewardsTipsCtr:Init(view)
	self.view = view
end

function UIStarRewardsTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStarRewardsTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStarRewardsTipsCtr:GetData()
	return self.data
end

function UIStarRewardsTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIStarRewardsTipsCtr

