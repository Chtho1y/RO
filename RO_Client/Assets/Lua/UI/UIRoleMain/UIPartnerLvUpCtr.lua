local UIPartnerLvUpCtr = class("UIPartnerLvUpCtr", require("UICtrBase"))

local canAdvence = false
local isLeader = false

function UIPartnerLvUpCtr:Init(view)
	self.view = view
end

function UIPartnerLvUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	isLeader = data == 1
end

function UIPartnerLvUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPartnerLvUpCtr:GetData()
	return self.data
end

function UIPartnerLvUpCtr:GetHeroLogicId()
	local logicData = self:GetHeroLogicData()
	return logicData.id
end

function UIPartnerLvUpCtr:PartnerLvUpReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_LEVEL_UP_REQ, {hero_id = id})
end

function UIPartnerLvUpCtr:PartnerAdvenceLvUpReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_ADVANCE_REQ, {hero_id = id})
end

function UIPartnerLvUpCtr:GetHeroLogicData()
	if isLeader then
		return ManagerContainer.DataMgr.UserData:GetHeroData()
	else
		return ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	end
end

function UIPartnerLvUpCtr:GetPartnerCurMaxLv()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
	if stepData == nil then
		canAdvence = false
		return logicData.baseLevel
	end
	local advenceMaxLv = logicData.advanceLevel < #stepData.AddLv and stepData.AddLv[logicData.advanceLevel + 1] or stepData.AddLv[#stepData.AddLv]

	local curMaxLv = logicData.strengthLevel == 0 and advenceMaxLv or (advenceMaxLv + stepData.BreachAddLv[logicData.strengthLevel])

	canAdvence = advenceMaxLv <= logicData.baseLevel and (logicData.advanceLevel + 1) < #stepData.AddLv

	if #stepData.AddLv <= (logicData.advanceLevel + 1) then
		advenceMaxLv = nil
	end
	return curMaxLv, advenceMaxLv
end

function UIPartnerLvUpCtr:CanAdvence()
	return canAdvence
end

function UIPartnerLvUpCtr:GetPartnerNextMaxLv()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
	return stepData.AddLv[logicData.advanceLevel + 2]
end

function UIPartnerLvUpCtr:GetPartmerLastMaxLv()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)	
	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
	if logicData.advanceLevel - 1 == 0 then
		return logicData.strengthLevel == 0 and stepData.AddLv[1] or (stepData.AddLv[1] + stepData.BreachAddLv[logicData.strengthLevel])
	end

	local advenceMaxLv = logicData.advanceLevel < #stepData.AddLv and stepData.AddLv[logicData.advanceLevel] or stepData.AddLv[#stepData.AddLv]

	local maxLv = logicData.strengthLevel == 0 and advenceMaxLv or (advenceMaxLv + stepData.BreachAddLv[logicData.strengthLevel])

	return maxLv
end

function UIPartnerLvUpCtr:GetHeroStepData()
	local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	return ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
end

function UIPartnerLvUpCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPartnerLvUpCtr

