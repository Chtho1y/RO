local TreasureData = class("TreasureData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")

local maxMessageCount = 10

function TreasureData:ctor()
    self.data = {}
end

function TreasureData:InitTreasureData(data)
    self.data.boxList = {}
    for k,v in pairs(data.battle_box.box_list) do
        local boxData = ProtocalDataNormal.ParseBattleBoxData(v)
        local dif = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(boxData.coolTime)
        if dif <= 0 and #boxData.heroCoolList > 0 then
            boxData.boxId = 0
        end
        self.data.boxList[v.id] = boxData
        if boxData.boxId > 0 then
            ManagerContainer.DataMgr.UserData:RefreshHeroesTreasureState(boxData.heroCoolList, false)
        end
    end

    self.data.messageList = data.box_message_list
end

function TreasureData:GetBoxList()
    return self.data.boxList
end

function TreasureData:GetBoxListByIdx(idx)
    return self.data.boxList[idx]
end

function TreasureData:GetMessageList()
    return self.data.messageList
end

function TreasureData:RefreshTreasureData(data)
    for _,v in pairs(data.box_list) do
        local oldData = self.data.boxList[v.id]
        self.data.boxList[v.id] = ProtocalDataNormal.ParseBattleBoxData(v)
        local state = self:IsCurSlotBoxOver(v.id)
        if oldData ~= nil then
            local heroList = #oldData.heroCoolList > 0 and oldData.heroCoolList or self.data.boxList[v.id].heroCoolList
            ManagerContainer.DataMgr.UserData:RefreshHeroesTreasureState(heroList, state ~= Enum.SlotBoxState.Opened)
        end
    end
end

function TreasureData:NewSlotResultData(data)
    self.data.curSlotData = ProtocalDataNormal.ParseBattleBoxData(data.slot_data)
end

function TreasureData:GetSlotBoxCount()
    local count = 0
    for _,v in pairs(self.data.boxList) do
        local state = self:IsCurSlotBoxOver(v.id)
        if state ~= Enum.SlotBoxState.None then
            count = count + 1
        end
    end
    return count
end

function TreasureData:GetMinBoxSlotIdx()
    for _,v in pairs(self.data.boxList) do
        local state = self:IsCurSlotBoxOver(v.id)
        if state == Enum.SlotBoxState.None then
            return v.id
        end
    end
    return 1
end

function TreasureData:ResetBoxInfo(idx)
    local data = self.data.boxList[idx]
    data.boxId = 0
    ManagerContainer.DataMgr.UserData:RefreshHeroesTreasureState(data.heroCoolList, true)
end

function TreasureData:CheckAllBoxInfo()
    for _,v in pairs(self.data.boxList) do
        local state = self:IsCurSlotBoxOver(v.id)
        if state == Enum.SlotBoxState.None and v.state then
            self:ResetBoxInfo(v.id)
        end
    end
end

function TreasureData:IsCurSlotBoxOver(index)
    local slotBoxData = ManagerContainer.DataMgr.TreasureData:GetBoxListByIdx(index)
    if slotBoxData == nil then
        return Enum.SlotBoxState.None
    end

    if slotBoxData.boxId == 0 then
        return Enum.SlotBoxState.None
    end

    if not slotBoxData.state then
        return Enum.SlotBoxState.NoOpen
    end

    local dif = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(slotBoxData.coolTime)
    if dif > 0 then
        return Enum.SlotBoxState.Opened
    end

    return Enum.SlotBoxState.None
end

function TreasureData:GetCurSlotData()
    return self.data.curSlotData
end

function TreasureData:InsertNewMessages(message_list)
    local count = #message_list
    local newCount = #self.data.messageList + count
    if newCount >= maxMessageCount then
        local delta = newCount - maxMessageCount
        for i = 1,delta do
            table.remove(self.data.messageList, 1)
        end
    end

    for _,v in pairs(message_list) do
        table.insert(self.data.messageList, v)
    end
end

function TreasureData:RegisterNetEvents()
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_REWARD_ACK, function(data)
    --     if data.error == Enum.NetErrorCode.ERROR_OK then
    --         self:NewSlotResultData(data)
    --     end
    --     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.START_TREASURE_SLOT, data.error)
    -- end)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_MESSAGE_NTF, function(data)
    --     self:InsertNewMessages(data.message_list)
    --     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.NEW_TREASURE_MESSAGE, data.message_list)
    -- end)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_CHANGE_NTF, function(data)
    --     self:RefreshTreasureData(data)
    -- end)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_REWARD_OPEN_ACK, function(data)
    --     if data.error == Enum.NetErrorCode.ERROR_OK then
    --         ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BOX_TREASURE_OPEN_SUCCESS)
    --     end
    -- end)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_REWARD_RECOVER_ACK, function(data)
    --     if data.error == Enum.NetErrorCode.ERROR_OK then
    --         local addItemMap = CommonUtil.ParseKeyValue2Map(data.item_list)
    --         ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addItemMap)
    --         ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BOX_TREASURE_OPEN_SUCCESS)
    --     end
    -- end)

    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOX_RESET_ACK, function(data)
    --     if data.error == Enum.NetErrorCode.ERROR_OK then
    --         ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BOX_TREASURE_OPEN_SUCCESS)
    --     end
    -- end)
end

function TreasureData:Clear()
    self.data = {}
end

function TreasureData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function TreasureData:UnRegisterNetEvents()

end

return TreasureData