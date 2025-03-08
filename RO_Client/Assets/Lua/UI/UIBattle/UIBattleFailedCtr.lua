local UIBattleFailedCtr = class("UIBattleFailedCtr", require("UICtrBase"))

function UIBattleFailedCtr:Init(view)
	self.view = view
end

function UIBattleFailedCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleFailedCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleFailedCtr:GetData()
	return self.data
end

function UIBattleFailedCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleFailedCtr

