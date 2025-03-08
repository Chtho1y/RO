local UICardListTipsCtr = class("UICardListTipsCtr", require("UICtrBase"))

local oldSlot
function UICardListTipsCtr:Init(view)
	self.view = view
end

function UICardListTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UICardListTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardListTipsCtr:GetData()
	return self.data
end

-- 获得道具配置id
function UICardListTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UICardListTipsCtr:GetHeroId()
	return self.data.equipTipsData[1].id
end

function UICardListTipsCtr:GetSlotIndex()
	return self.data.equipTipsData[1].slotIndex
end

function UICardListTipsCtr:GetSlotType()
	return self.data.equipTipsData[1].slotType
end

function UICardListTipsCtr:GetCardSlotIndex()
	return self.data.idx
end

function UICardListTipsCtr:GetHeroJobType()
	local id = self.data.equipTipsData[1].id
	local jobType
	if id == 1 then
		local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
		jobType = jobData.JobType
	else
		local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		jobType = cfgData.JobType
	end
	return jobType
end

function UICardListTipsCtr:SendInsertCard(cfgId)
	local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(self:GetSlotIndex()))
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_MOUNT_REQ, {hero_id = self:GetSlotIndex(), sub_slot_index = self:GetSlotType(), card_slot_index = self:GetCardSlotIndex(), card_id = cfgId})
end

function UICardListTipsCtr:SendRemoveCard()
	local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(self:GetSlotIndex()))
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_DOWN_REQ, {hero_id = self:GetSlotIndex(), sub_slot_index = self:GetSlotType(), card_slot_index = self:GetCardSlotIndex()})
end

function UICardListTipsCtr:OnDispose()
	self.data = nil
	self.view = nil

	oldSlot = nil
end

return UICardListTipsCtr

