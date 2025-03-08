local UIDojoBattleCtr = class("UIDojoBattleCtr", require("UICtrBase"))

function UIDojoBattleCtr:Init(view)
	self.view = view
end

function UIDojoBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoBattleCtr:GetData()
	return self.data
end

function UIDojoBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIDojoBattleCtr:GetBattleMode()
	if self.data and self.data[1] then
		return self.data[1]
	end
	return BattleMode.None
end

function UIDojoBattleCtr:GetBattleSubMode()
	if self.data and self.data[2] then
		return self.data[2]
	end
	return BattleSubMode.None
end

function UIDojoBattleCtr:GetMatchFighterName()
	if self.data and self.data[3] then
		return self.data[3]
	end
	return ''
end

function UIDojoBattleCtr:GetOurMembers()
	if self.data and self.data[4] then
		return self.data[4]
	end
	return {}
end

function UIDojoBattleCtr:GetEnemyMembers()
	if self.data and self.data[5] then
		return self.data[5]
	end
	return {}
end

function UIDojoBattleCtr:GetIsLeftTime()
	if self.data and self.data[6] then
		return self.data[6]
	end
	return false
end

function UIDojoBattleCtr:GetTotalTime()
	if self.data and self.data[7] then
		return self.data[7]
	end
	return 0
end

return UIDojoBattleCtr

