local UICardEquipListCtr = class("UICardEquipListCtr", require("UICtrBase"))

local curSlotIndex
function UICardEquipListCtr:Init(view)
	self.view = view
end

function UICardEquipListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICardEquipListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardEquipListCtr:GetData()
	return self.data
end

function UICardEquipListCtr:GetSlotIndex()
	return curSlotIndex
end

function UICardEquipListCtr:SetSlotIndex(idx)
	curSlotIndex = idx
end

function UICardEquipListCtr:SendInsertCard(slotIndex, slotType, cardSlotIndex, cfgId)
	curSlotIndex = slotIndex
	local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex))
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_MOUNT_REQ, {hero_id = slotIndex, sub_slot_index = slotType, card_slot_index = cardSlotIndex, card_id = cfgId})
end

function UICardEquipListCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardEquipListCtr

