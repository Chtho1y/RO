local UIBattleBossTipsCtr = class("UIBattleBossTipsCtr", require("UICtrBase"))

function UIBattleBossTipsCtr:Init(view)
	self.view = view
end

function UIBattleBossTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleBossTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleBossTipsCtr:GetData()
	return self.data
end

function UIBattleBossTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleBossTipsCtr

