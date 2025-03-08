local UIIdolRankCtr = class("UIIdolRankCtr", require("UICtrBase"))

function UIIdolRankCtr:Init(view)
	self.view = view
end

function UIIdolRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIIdolRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIIdolRankCtr:GetData()
	return self.data
end

function UIIdolRankCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIIdolRankCtr

