local UIBattleRewardCtr = class("UIBattleRewardCtr", require("UICtrBase"))

function UIBattleRewardCtr:Init(view)
	self.view = view
end

function UIBattleRewardCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleRewardCtr:GetData()
	return self.data
end

function UIBattleRewardCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleRewardCtr

