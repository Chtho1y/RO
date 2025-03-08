local UIFashionWashCtr = class("UIFashionWashCtr", require("UICtrBase"))

function UIFashionWashCtr:Init(view)
	self.view = view
end

function UIFashionWashCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFashionWashCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionWashCtr:GetData()
	return self.data
end

function UIFashionWashCtr:GetJobTypeName(jobType)
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

function UIFashionWashCtr:SendFashionWash(state)
	local fashionId = self:GetData()
	ManagerContainer.DataMgr.FashionData:SendFashionWash(fashionId, state)
end

function UIFashionWashCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFashionWashCtr

