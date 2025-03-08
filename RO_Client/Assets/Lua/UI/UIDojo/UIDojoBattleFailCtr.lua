local UIDojoBattleFailCtr = class("UIDojoBattleFailCtr", require("UICtrBase"))

function UIDojoBattleFailCtr:Init(view)
	self.view = view
end

function UIDojoBattleFailCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoBattleFailCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoBattleFailCtr:GetData()
	return self.data
end

function UIDojoBattleFailCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIDojoBattleFailCtr

