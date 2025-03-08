local UIBagCardListTipsCtr = class("UIBagCardListTipsCtr", require("UICtrBase"))

function UIBagCardListTipsCtr:Init(view)
	self.view = view
end

function UIBagCardListTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBagCardListTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBagCardListTipsCtr:GetData()
	return self.data
end

function UIBagCardListTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UIBagCardListTipsCtr:GetSlotIndex()
	return self.data.slotIndex
end

function UIBagCardListTipsCtr:GetSlotType()
	return self.data.slotType
end

function UIBagCardListTipsCtr:GetCardSlotIndex()
	return self.data.cardSlotIndex
end

function UIBagCardListTipsCtr:GetCardList()
	return self.data.cardList
end

function UIBagCardListTipsCtr:GetCardId()
	return self.data.cardId
end

function UIBagCardListTipsCtr:SendInsertCard(cardSlotIndex)
	local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(self:GetSlotIndex()))
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_MOUNT_REQ, {hero_id = self:GetSlotIndex(), sub_slot_index = self:GetSlotType(), card_slot_index = cardSlotIndex, card_id = self:GetCfgId()})
end

function UIBagCardListTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBagCardListTipsCtr

