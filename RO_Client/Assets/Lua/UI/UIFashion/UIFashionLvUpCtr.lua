local UIFashionLvUpCtr = class("UIFashionLvUpCtr", require("UICtrBase"))

function UIFashionLvUpCtr:Init(view)
	self.view = view
end

function UIFashionLvUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFashionLvUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionLvUpCtr:GetData()
	return self.data
end

function UIFashionLvUpCtr:GetFashionLogicData(cfgId)
	return ManagerContainer.DataMgr.FashionData:GetFashionById(cfgId)
end

function UIFashionLvUpCtr:GetFashionSuitLv(suitId)
	return ManagerContainer.DataMgr.FashionData:GetFashionSuitLvById(suitId)
end

function UIFashionLvUpCtr:GetJobTypeName(jobType)
	if not jobType then return "" end
	local colorStr = "<color=%s>%s</color>"
	local leaderColor = GlobalConfig.Instance:GetConfigStrValue(306)
	local name = string.format(colorStr, leaderColor, I18N.T("protagonist"))
	if jobType > 0 then
		--伙伴
		local name1, color = ManagerContainer.CfgMgr:GetPartnerCfgDataByJobType(jobType)
		name = string.format(colorStr, color, I18N.T(name1))
	end
	return name
end

function UIFashionLvUpCtr:SendFashionLvUp()
	local fashionId = self:GetData()
	ManagerContainer.DataMgr.FashionData:SendFashionLvUp(fashionId)
end

function UIFashionLvUpCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFashionLvUpCtr

