local UIFashionGotCtr = class("UIFashionGotCtr", require("UICtrBase"))

function UIFashionGotCtr:Init(view)
	self.view = view
end

function UIFashionGotCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFashionGotCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionGotCtr:GetData()
	return self.data
end

function UIFashionGotCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFashionGotCtr:GetCfgId()
	return self.data[1].cfgId
end

function UIFashionGotCtr:GetFashionLogicData(cfgId)
	return ManagerContainer.DataMgr.FashionData:GetFashionById(cfgId)
end

function UIFashionGotCtr:GetJobTypeName(jobType)
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

function UIFashionGotCtr:SendEquip()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(self:GetCfgId())
	local viewData = ManagerContainer.DataMgr.UserData:GetViewData()
	local fashionLocation = fashionCfgData.FashionLocation
	local curFahsionCfgId = viewData.fashionData[fashionLocation]
	if curFahsionCfgId then
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_DOWN_REQ, { fashion_cfg_id = {curFahsionCfgId} })
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_UP_REQ, { fashion_cfg_id = {self:GetCfgId()} })
end

return UIFashionGotCtr

