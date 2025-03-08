local UINewbieBattleCtr = class("UINewbieBattleCtr", require("UICtrBase"))

function UINewbieBattleCtr:Init(view)
	self.view = view
end

function UINewbieBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINewbieBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINewbieBattleCtr:GetData()
	return self.data
end

function UINewbieBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UINewbieBattleCtr

