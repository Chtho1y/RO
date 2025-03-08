local UISeasonIdolCtr = class("UISeasonIdolCtr", require("UICtrBase"))

function UISeasonIdolCtr:Init(view)
	self.view = view
end

function UISeasonIdolCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISeasonIdolCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISeasonIdolCtr:GetData()
	return self.data
end

function UISeasonIdolCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISeasonIdolCtr

