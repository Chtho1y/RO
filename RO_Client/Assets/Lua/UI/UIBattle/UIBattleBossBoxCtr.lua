local UIBattleBossBoxCtr = class("UIBattleBossBoxCtr", require("UICtrBase"))

function UIBattleBossBoxCtr:Init(view)
	self.view = view
end

function UIBattleBossBoxCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleBossBoxCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleBossBoxCtr:GetData()
	return self.data
end

function UIBattleBossBoxCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleBossBoxCtr

