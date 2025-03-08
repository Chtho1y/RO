local UICardTipsCtr = class("UICardTipsCtr", require("UICtrBase"))

function UICardTipsCtr:Init(view)
	self.view = view
end

function UICardTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UICardTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardTipsCtr:GetData()
	return self.data
end

-- 获得道具配置id
function UICardTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UICardTipsCtr:GetSlotIndex()
	return self.data.slotIndex
end

function UICardTipsCtr:GetSlotType()
	return self.data.slotType
end

function UICardTipsCtr:GetCardSlotIndex()
	return self.data.cardSlotIndex
end

function UICardTipsCtr:SendOneKeyRemoveCard()
	--local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(self:GetSlotIndex()))
	--ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_DOWN_REQ, {hero_id = self:GetSlotIndex(), sub_slot_index = self:GetSlotType(), card_slot_index = 0})
end

function UICardTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardTipsCtr

