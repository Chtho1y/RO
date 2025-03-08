local UITipsCtr = class("UITipsCtr", require("UICtrBase"))
local ConditionJudge = require("Common/ConditionJudge")

function UITipsCtr:Init(view)
	self.view = view
end

function UITipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UITipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITipsCtr:GetData()
	return self.data
end

function UITipsCtr:GetCfgId()
	return self.data.cfgId
end

function UITipsCtr:SendDecomposeMsg()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_PAPER_DECOMPOSE_REQ, {paper_cfg_id = self:GetCfgId()})
end

function UITipsCtr:CanEquipCard()
	local cardData = ManagerContainer.CfgMgr:GetCardDataById(self:GetCfgId())
	local slotType = cardData.CardLocation
	local slotsRoot = ManagerContainer.DataMgr.UserData:GetAllSlotInfos()
	for _,v in pairs(slotsRoot) do
		if #v.slot_list > 0 then
			local slot = v.slot_list[slotType]
			if slot.equip_id > 0 then
				for j = 1, Constant.CARD_SLOT_LIMIT do
					local id = slot.card_id_list[j] or 0
					local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(slotType * 100 + j)
					if condition ~= nil then
						local result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition[1])
						if result then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function UITipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITipsCtr

