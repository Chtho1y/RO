local UIBattleReplayCtr = class("UIBattleReplayCtr", require("UICtrBase"))

function UIBattleReplayCtr:Init(view)
	self.view = view
	self.latestData = nil
	self.lowestData = nil
end

-- RecordIdx=1表示最近通关  =2表示最低战力通关
function UIBattleReplayCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	if self.data ~= nil then
		for i=1, #self.data do
			if self.data[i].record_idx == 1 then
				self.latestData = self.data[i]
			elseif self.data[i].record_idx == 2 then
				self.lowestData = self.data[i]
			end
		end
	end
end

function UIBattleReplayCtr:LatestData()
	return self.latestData
end

function UIBattleReplayCtr:LowestData()
	return self.lowestData
end

function UIBattleReplayCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleReplayCtr:GetData()
	return self.data
end

function UIBattleReplayCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleReplayCtr

