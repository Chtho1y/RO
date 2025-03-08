local UIDojoBattleWinCtr = class("UIDojoBattleWinCtr", require("UICtrBase"))

function UIDojoBattleWinCtr:Init(view)
	self.view = view
end

function UIDojoBattleWinCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoBattleWinCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoBattleWinCtr:GetData()
	return self.data
end

function UIDojoBattleWinCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIDojoBattleWinCtr

