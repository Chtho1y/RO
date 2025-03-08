local UIMinTipsCtr = class("UIMinTipsCtr", require("UICtrBase"))

function UIMinTipsCtr:Init(view)
	self.view = view
end

function UIMinTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.pos = data[1]
	self.tipsType = data[2]
	self.strKey = data[3]
	self.strParam = data[4]
	self.rewards = data[5]
end

function UIMinTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMinTipsCtr:GetData()
	return self.data
end

function UIMinTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIMinTipsCtr:GetTipsType()
	return self.tipsType
end

function UIMinTipsCtr:GetTipsData()
	return self.pos,self.strKey,self.strParam
end

function UIMinTipsCtr:GetRewardsData()
	return self.pos,self.rewards
end

return UIMinTipsCtr

