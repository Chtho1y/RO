local CardData = class("CardData", require("DataBase"))

function CardData:ctor()
    self.data = {}
    self.cardSuitMap = {}
end

local function SortRule(a, b)
    if a.CardType == b.CardType then
        return a.cfgId < b.cfgId
    else
        return a.CardType > b.CardType
    end
end

function CardData:InitCardData(data)
    local cardMap = {}
    local cardTypes = {}
    local cfgMgr = ManagerContainer.CfgMgr
    if data and data.card_list then
        for i = 1, #data.card_list do
            local cardData = data.card_list[i]
            if cardData and cardData.num > 0 then
                local card, type = self:ProtocalDataToCardData(cardData)
                local itemCfgData = cfgMgr:GetItemById(card.cfgId)
                if not itemCfgData then
                    LogError("[Wboy] ".. tostring(card.cfgId) .. " 道具ID不存在")
                else
                    cardMap[card.cfgId] = card

                    if cardTypes[type] == nil then
                        cardTypes[type] = {}
                    end
                    cardTypes[type][#cardTypes[type] + 1] = card
                end
            end
        end
    end
    self.data.cardMap = cardMap
    self.data.cardTypes = cardTypes
    for _,v in pairs(self.data.cardTypes) do
        CommonUtil.ArraySortSelections(v, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")
        --table.sort(v, SortRule)
    end
    for i = 1, 6 do
        self:RefreshEquipedCardSuitData(i)
    end
    ManagerContainer.RedPointMgr.HeroRPCtr:InitCardSlotState(data.card_slot_list)
end

function CardData:RefreshEquipedCardSuitData(id)
    if not self.cardSuitMap[id] then
        self.cardSuitMap[id] = {0,{}, {}, false, 0}
    else
        if not self:GetCardSuitStateById(id) then
            self.cardSuitMap[id][5] = self.cardSuitMap[id][1] - 1
        else
            self.cardSuitMap[id][5] = self.cardSuitMap[id][1]
        end
    end
    local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
    if not slot then
        return
    end
    local equipedCards = {}
    for _,v in pairs(slot.slot_list) do
        local cardList = v.card_id_list
        for _,v1 in pairs(cardList) do
            if v1 and v1 > 0 then
                equipedCards[#equipedCards + 1] = v1
            end
        end
    end

    local cloneEquips
    local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
    for i = #allCfgDatas, 1, -1 do
        local cfgData = allCfgDatas[i]
        local enoughCount = {}
        local count = {}

        cloneEquips = clone(equipedCards)
        for j = #cfgData.TriggerConditions, 1, -1 do
            local condition = cfgData.TriggerConditions[j]
            local type = condition[1]
            local lv = condition[2]
            local num = condition[3]
            enoughCount[j] = num
            count[j] = 0

            for m = #cloneEquips, 1, -1 do
                local cfgId = cloneEquips[m]
                local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
                if cardCfgData and cardCfgData.CardType >= type and cardCfgData.CardLevel >= lv then
                    count[j] = count[j] + 1
                    table.remove(cloneEquips, m)
                    if count[j] >= enoughCount[j] then
                        break
                    end
                end
            end
            count[j] = math.min(count[j], enoughCount[j])
            self.cardSuitMap[id] = {cfgData.Id, count, enoughCount, false, self.cardSuitMap[id][5]}
        end

        local result = true

        for j = 1,#count do
            if count[j] < enoughCount[j] then
                result = false
                break
            end
        end
        if result then
            self.cardSuitMap[id][4] = true
            return
        end
    end
end

function CardData:RefreshAllEquipedCardSuitData()
    if self.cardSuitMap then
        for key, value in pairs(self.cardSuitMap) do
            self:RefreshEquipedCardSuitData(key)
        end
    end
end

function CardData:GetCardSuitLvById(id)
    return self.cardSuitMap[id] and self.cardSuitMap[id][1] or 0
end

function CardData:GetCardSuitLastLvById(id)
    return self.cardSuitMap[id] and self.cardSuitMap[id][5] or 0
end

function CardData:GetCardSuitCountById(id)
    return self.cardSuitMap[id] and self.cardSuitMap[id][2] or 0, self.cardSuitMap[id] and self.cardSuitMap[id][3] or 0
end

function CardData:GetCardSuitStateById(id)
    return self.cardSuitMap[id] and self.cardSuitMap[id][4] or false
end

function CardData:GetAllCardDataMap()
    return self.data.cardMap
end

function CardData:GetCardById(id)
    return self.data.cardMap[id]
end
function CardData:GetCardCountById(id)
    return self.data.cardMap[id] and self.data.cardMap[id].num or 0
end

function CardData:GetAllCardDatasByType(type)
    return self.data.cardTypes[type]
end

function CardData:RefreshCardDatas(card_list)
    if card_list == nil then return nil end
    -- 是否为新增道具， 默认为新增
    local addCards = {}
    local cardMap = self.data.cardMap
    local cardTypes = self.data.cardTypes
    local isNeedSort = {false,false,false,false,false,false}
    local cfgMgr = ManagerContainer.CfgMgr
    for _,item in ipairs(card_list) do
        local cfgId = item.config_id
        local itemCfgData = cfgMgr:GetItemById(cfgId)
        if not itemCfgData then
            LogError("[Wboy] ".. cfgId .. " 道具ID不存在")
        else
            local num = item.num
            local card = cardMap[cfgId]
            if num <= 0 then
                -- 删除装备
                if card then
                    cardMap[cfgId] = nil

                    for i = 1, 6 do
                        local cardList = cardTypes[i]
                        if cardList ~= nil then
                            for i,v in ipairs(cardList) do
                                if v.cfgId == card.cfgId then
                                    table.remove(cardList, i)
                                end
                            end
                        end
                    end
                end
            else
                -- 更新装备
                local lastnum = card and card.num or 0
                if card then
                    card.num = num
                else
                    local type = 1
                    card, type = self:ProtocalDataToCardData(item)
                    cardMap[cfgId] = card

                    if cardTypes[type] == nil then
                        cardTypes[type] = {}
                    end
                    cardTypes[type][#cardTypes[type] + 1] = card
                    isNeedSort[type] = true
                end

                local addNum = num - lastnum
                if addNum > 0 then
                    if addCards[cfgId] then
                        addCards[cfgId] = addCards[cfgId] + addNum
                    else
                        addCards[cfgId] = addNum
                    end
                end
            end
        end
    end
    for _,v in pairs(self.data.cardTypes) do
        CommonUtil.ArraySortSelections(v, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")
        --table.sort(v, SortRule)
    end

    return addCards
end

function CardData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_STARTUP_INFO_CARD_NTF, function(data)
        self:InitCardData(data.role_card_info)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_CHANGE_NTF, function(data)
        local addCards = self:RefreshCardDatas(data.card_list)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_CHANGE)

        ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardRP()

        if data.ignore then

        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addCards)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_MOUNT_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshAllEquipedCardSuitData()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_LIST_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_CARD_SUIT)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_DOWN_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshAllEquipedCardSuitData()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_LIST_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_CARD_SUIT)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_COMPOSE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GET_ONE_BIG_CARD_AFTER_RECREATE, data.new_card_id)
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_RECREATE_REFRESH, data.new_card_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_DECOMPOSE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_RECREATE_REFRESH)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_UP_GRADE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GET_ONE_BIG_CARD_AFTER_COMPOSE, data.config_ids[1])
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_RECREATE_REFRESH)

            CommonUtil.ACKShowRewardList(data.config_ids);
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_EQUIP_ALL_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
            ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardSlotRP(data.hero_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_EQUIP_DOWN_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_UP_GRADE_ALL_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_LEVEL_EXCHANGE_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_TRANS_REFRESH,{leftId = data.source_card_id ,rightId = data.target_card_id})
        end
    end)
end
function CardData:SendMvpCardTransReq(leftId,rightId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_LEVEL_EXCHANGE_REQ,{source_card_id = leftId,target_card_id = rightId})
end

function CardData:Clear()
    self.data = {}
    self.cardSuitMap = {}
end

function CardData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function CardData:UnRegisterNetEvents()

end

function CardData:ProtocalDataToCardData(protocalData)
    local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(protocalData.config_id)
    local cardData      = {}
    cardData.cfgId      = protocalData.config_id
    cardData.num        = protocalData.num
    cardData.timeStamp  = protocalData.time_stamp
    cardData.CardType   = cardCfgData.CardType
    cardData.CardLevel   = cardCfgData.CardLevel
    cardData.FightPower = cardCfgData.FightPower
    cardData.Profession = cardCfgData.Profession
    cardData.Attribute2 = cardCfgData.Attribute2
    cardData.CardLocation = cardCfgData.CardLocation

    return cardData, cardCfgData.CardLocation
end

function CardData:CanCurCardUp(cfgId, needNum, remainRes, equiped)
    local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
    local nextLevelCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId + 100)
    if not nextLevelCfgData then
        return false, 3
    end
    local cardLogicData = ManagerContainer.DataMgr.CardData:GetCardById(cfgId)
    if cardCfgData == nil then
        return false, 3
    end

    local totalNum = 0
    if cardLogicData ~= nil then
        totalNum = cardLogicData.num
    end

    local cost = cardCfgData.UpCost * needNum
    if cardCfgData.ToCardId > 0 and cost <= remainRes then
        remainRes = remainRes - cost
        local num = needNum * 3
        if equiped then
            num = num - 1
        end

        if totalNum >= num then
            return true, remainRes, cardCfgData.CardType >= 3
        else
            local num1 = num - totalNum
            if cardCfgData.FromCardId > 0 then
                return self:CanCurCardUp(cardCfgData.FromCardId, num1, remainRes)
            else
                return false, 2
            end
        end
    else
        return false, 1
    end
end

return CardData