local UIEquipRefineTipsCtr = class("UIEquipRefineTipsCtr", require("UICtrBase"))

function UIEquipRefineTipsCtr:Init(view)
	self.view = view
end

function UIEquipRefineTipsCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIEquipRefineTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIEquipRefineTipsCtr:GetData()
	return self.data
end

-- 获得道具配置id
function UIEquipRefineTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UIEquipRefineTipsCtr:GetSlotIndex()
	return self.data.slotIndex
end

function UIEquipRefineTipsCtr:GetSlotType()
	return self.data.slotType
end

function UIEquipRefineTipsCtr:SendSlotRefineReq()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_SLOT_LEVEL_UP_REQ, {hero_id = self.data.slotIndex, sub_slot_index = self.data.slotType})
end

function UIEquipRefineTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIEquipRefineTipsCtr

