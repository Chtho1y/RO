local UIStarSignTipsCtr = class("UIStarSignTipsCtr", require("UICtrBase"))

function UIStarSignTipsCtr:Init(view)
	self.view = view
end

function UIStarSignTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStarSignTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStarSignTipsCtr:GetData()
	return self.data
end

function UIStarSignTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIStarSignTipsCtr
