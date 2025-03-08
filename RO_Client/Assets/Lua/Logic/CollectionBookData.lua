local CollectionBookData = class("CardHandBook", require("DataBase"))
local BitUtil = require("BitUtil")

function CollectionBookData:ctor()
    self.data = {}

    if not self.data.qualityCardDatas then
        self.data.qualityCardDatas = {}
    end
    if not self.data.handBookMaps then
        self.data.handBookMaps = {}
    end
    if not self.data.handBookQualityCounts then
        self.data.handBookQualityCounts = {}
    end
end

function CollectionBookData:InitDatas(data)
    self:RefreshDatas(data)
end

function CollectionBookData:RefreshDatas(data)
    for _,v in pairs(data) do
        if self.data.qualityCardDatas[v.card_quality] == nil then
            self.data.qualityCardDatas[v.card_quality] = {}
        end
        for _,v1 in pairs(v.card_book) do
            local data1 = ProtocalDataNormal.ParseCardHandBook(v1)
            self.data.handBookMaps[data1.cardId] = data1
            self.data.qualityCardDatas[v.card_quality][data1.cardId] = data1
        end
    end

    local rpState = false
    for k,v in pairs(self.data.qualityCardDatas) do
        local hasCount = 0
        local count = 0
        for _,v1 in pairs(v) do
            hasCount = hasCount + 1
            for i = 1,v1.cardLevel do
                local rewarded = BitUtil.RshiftNumBandOne(v1.rewardRec, i - 1) == 1
                if not rewarded then
                    count = count + 1
                    break
                end
            end
        end
        if not rpState and count > 0 then
            rpState = true
        end
        self.data.handBookQualityCounts[k] = hasCount
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardCollect, rpState)
end

function CollectionBookData:QueryCardHandBook(pageId)
    self.data.queryPageId = pageId
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_COLLECT_INFO_REQ, {})
end

function CollectionBookData:SendCardHandBookReward(id, lv)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_COLLECT_REWARD_REQ, {card_id = id, level = lv})
end

function CollectionBookData:QueryCardRank(id)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_COLLECTION_RANK_REQ, {card_id = id})
end

function CollectionBookData:GetCardHandBookQualityCountById(id)
    return self.data.handBookQualityCounts[id] or 0
end

function CollectionBookData:GetCollectionBookDataById(id)
    return self.data.handBookMaps[id]
end

function CollectionBookData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_COLLECT_INFO_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:InitDatas(data.card_collect)

            if self.data.queryPageId == Enum.UIPageName.UIMainCity1 then
                self.data.queryPageId = nil
                ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardHandBook, nil, Enum.UIPageName.UIMainCity1)
            end
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_COLLECT_CHANGE_NTF, function(data)
        self:RefreshDatas(data.card_collect)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_COLLECT_REWARD_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_HANDBOOK_REWARD_REFRESH, data.card_id)

            CommonUtil.ACKShowRewardList(data.reward_list)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_COLLECTION_RANK_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            if data.player_info then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_HANDBOOK_RANK_REFRESH, data.player_info, data.achievement_time)
            end
        end
    end)
end

function CollectionBookData:Clear()
    self.data = {}

    self.data.qualityCardDatas = {}
    self.data.handBookMaps = {}
    self.data.handBookQualityCounts = {}
end

function CollectionBookData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function CollectionBookData:UnRegisterNetEvents()

end

return CollectionBookData