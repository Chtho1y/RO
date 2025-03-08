local UIBattleResultCtr = class("UIBattleResultCtr", require("UICtrBase"))

function UIBattleResultCtr:Init(view)
	self.view = view
end

function UIBattleResultCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleResultCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleResultCtr:GetData()
	return self.data
end

function UIBattleResultCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIBattleResultCtr:GetWinNum()
	return self.data and self.data[1] or 0
end

function UIBattleResultCtr:GetScores()
	return self.data and self.data[2] or nil
end

function UIBattleResultCtr:GetRewards()
	return self.data and self.data[3] or nil
end

function UIBattleResultCtr:GetLangKey()
	return self.data and self.data[4] or nil
end

function UIBattleResultCtr:HandleCallback()
	if self.data then
		local cb = self.data[5]
		local ownerCb = self.data[6]
		if cb then
			if ownerCb then
				cb(ownerCb)
			else
				cb()
			end
		end
	end
end

return UIBattleResultCtr

