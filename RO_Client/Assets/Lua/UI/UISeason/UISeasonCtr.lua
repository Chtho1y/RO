local UISeasonCtr = class("UISeasonCtr", require("UICtrBase"))

function UISeasonCtr:Init(view)
	self.view = view
end

function UISeasonCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISeasonCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISeasonCtr:GetData()
	return self.data
end

function UISeasonCtr:GetCurStageAndNextTime()
	return ManagerContainer.DataMgr.CompetitionData:GetCurStageAndNextTime()
end

function UISeasonCtr:GetCurCompetitionId()
	return ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionId()
end

function UISeasonCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISeasonCtr

