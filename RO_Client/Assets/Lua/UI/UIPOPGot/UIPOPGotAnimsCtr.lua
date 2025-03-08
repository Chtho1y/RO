local UIPOPGotAnimsCtr = class("UIPOPGotAnimsCtr", require("UICtrBase"))

function UIPOPGotAnimsCtr:Init(view)
	self.view = view
end

function UIPOPGotAnimsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPOPGotAnimsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPOPGotAnimsCtr:GetData()
	return self.data
end

function UIPOPGotAnimsCtr:IsInSameTypeAnim(type)
	if self.view == nil then return false end
	return self.view:IsInSameTypeAnim(type)
end

function UIPOPGotAnimsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPOPGotAnimsCtr

