local UIBattleStatisticsCtr = class("UIBattleStatisticsCtr", require("UICtrBase"))

function UIBattleStatisticsCtr:Init(view)
	self.view = view
end

function UIBattleStatisticsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.battleMode = self.data[1]
	self.battleSubMode = self.data[2]
end

function UIBattleStatisticsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleStatisticsCtr:GetData()
	return self.data
end

function UIBattleStatisticsCtr:GetBattleMode()
	return self.battleMode
end

function UIBattleStatisticsCtr:GetBattleSubMode()
	return self.battleSubMode
end

function UIBattleStatisticsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.battleMode = nil
	self.battleSubMode = nil
end

return UIBattleStatisticsCtr

