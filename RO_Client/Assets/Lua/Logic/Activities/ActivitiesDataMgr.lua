local ActivitiesDataMgr = class("ActivitiesDataMgr",require("DataBase"))
local ActivityTypeItem = require('Activities/ActivityTypeItem')
local ActivityShopItem = require('Activities/ActivityShopItem')
local ActivityFortnightLoginItem = require("Activities/ActivityFortnightLoginItem")
local ActivityFortnightTaskItem = require("Activities/ActivityFortnightTaskItem")
local ActivityHundredItem = require("Activities/ActivityHundredItem")

local ActivityFirstRechargeItem = require("Activities/ActivityFirstRechargeItem")
local ActivityDailyComulativeRechargeItem = require("Activities/ActivityDailyComulativeRechargeItem")
local ActivityLimitRechargeItem = require("Activities/ActivityLimitRechargeItem")
local ActivityChipRewardItem = require("Activities/ActivityChipRewardItem")
local ActivityPetRewardItem = require("Activities/ActivityPetRewardItem")
local ActivityGoddessItem = require("Activities/ActivityGoddessItem")
local ActivitySpringItem = require("Activities/ActivitySpringItem")
local ActivityKingTaskItem = require("Activities/ActivityKingTaskItem")
local Activity61TrunWheelItem = require("Activities/Activity61TrunWheelItem")
local ActivitySignItem = require("Activities/ActivitySignItem")

function ActivitiesDataMgr:ctor()
    self.bInited = false
    self.actItemList = nil
    self.curDayEndTime = nil
    self.firstRechargeItem = nil
    self.limitRechargeItem = nil

    self.hdDropMap = nil
end

function ActivitiesDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_OPEN_LIST_NTF,self.OnActivitiesOpenListNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_CHANGE_NTF,self.OnActivitiesChangeNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_REWARD_ACK,self.OnActivitiesRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_STARTUP_NTF,self.OnActivitiesStartUpNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_SCORE_REWARD_ACK,self.OnGetBoxRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_FIRST_CHARGE_CHANGE_NTF,self.OnActivitiesFirstRechargeNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_FIRST_CHARGE_REWARD_ACK,self.OnActivitiesFirstRechargeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_DISCOUNTS_NTF,self.OnActivitiesLimitRechargeNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_COLLECTION_SERVER_DATA_ACK,self.OnActivitiesCollecttionAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_LIKABILITY_REWARD_ACK, self.OnActivitiesGoddessAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_EXCHANGE_ACK,self.OnPetRewardBack,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITY_SIGN_IN_ACK,self.OnActivitySignACK,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITIES_WORD_NOTICE_SET_ACK,self.OnActivitiesWordNoticeSetACK,self)
end

function ActivitiesDataMgr:Clear()
    self.bInited = false
    self.actItemList = nil
    self.curDayEndTime = nil
    self.firstRechargeItem = nil
    self.limitRechargeItem = nil
    self.activityRP = nil

    self.hdDropMap = nil
end

function ActivitiesDataMgr:OnActivitiesFirstRechargeNtf(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:RefreshFirstRechargeData(data, self.curDayEndTime)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_FirstRecharge_Change)
    self:RefreshRedPointState()
end

function ActivitiesDataMgr:OnActivitiesWordNoticeSetACK(data)
    if data.error == 0 then
        local actItem = self:GetActivityItemById(data.activity_id)
        if actItem then
            actItem:SetWordNotice(data.collect_id,data.no_notice)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CHIPREWARD_ISNOTICE_CHANHE, data.collect_id)
        end
    end
end

function ActivitiesDataMgr:OnActivitiesLimitRechargeNtf(data)
    if self.limitRechargeItem then
        self.limitRechargeItem:SyncSrvData(data.discount_data_list)
    end
end

function ActivitiesDataMgr:OnPetRewardBack(data)
    if data.error == 0 then
        local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(data.reward_idx)
        local rewards = {}
        for k, v in pairs(cfgData.Reward) do
            table.insert(rewards,{cfgId = v[1], num = v[2]})
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewards})
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EXCHANGEPET_NTF,data)
end

function ActivitiesDataMgr:OnActivitySignACK(data)
    if data.error == 0 then
        local actItem = self:GetActivityItemById(data.activity_id)
        if not actItem  then
            return
        end
        local signCfgData = ManagerContainer.CfgMgr:GetSignInCfg(data.sign_days)
        if not signCfgData then
            return
        end

        local rewardList = {}
        for _,v in pairs(data.reward_list) do
            rewardList[#rewardList + 1] = {key = v.key, value = v.value, vip = 0}
        end
        for _,v in pairs(data.ext_reward_list) do
            rewardList[#rewardList + 1] = {key = v.key, value = v.value, vip = signCfgData.VipLevel}
        end

        CommonUtil.ACKSpecialShowRewardList(rewardList)
        actItem:SyncSrvData({nil,nil,{next_sign_time = data.next_sign_time, sign_days = data.sign_days}})
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTIVITY_SIGN_SUCCESS,data)        --通知界面刷新
    end
end

function ActivitiesDataMgr:OnActivitiesGoddessAck(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if data.reward_item_list ~= nil then
        local rewardList = {}
        for i = 1, #data.reward_item_list do
            local _itemData = data.reward_item_list[i]
            rewardList[#rewardList+1] = {cfgId = _itemData.key, num = _itemData.value}
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
    end
end

function ActivitiesDataMgr:OnActivitiesCollecttionAck(data)
    local collectionItem = self:GetActivityItemById(data.activity_id)
    if collectionItem and data.error == Enum.NetErrorCode.ERROR_OK and data.activity_id == collectionItem.actId then
        collectionItem:RefreshCollectionGlobalData(data.data_list)
    end
end

function ActivitiesDataMgr:OnActivitiesFirstRechargeAck(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local itemList = data.reward_item_list
    if itemList then
        local itemLength = #itemList
        if itemLength > 0 then
            local addItemMap = {}
            local cfgId, addNum, item
            for i = 1, itemLength do
                item = itemList[i]
                cfgId = item.key
                addNum = item.value
                if addItemMap[cfgId] then
                    addItemMap[cfgId] = addItemMap[cfgId] + addNum
                else
                    addItemMap[cfgId] = addNum
                end
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addItemMap)
        end
    end
end

function ActivitiesDataMgr:OnActivitiesOpenListNtf(data)
    self:SetOpenActivityList(data.activity_list)
end

function ActivitiesDataMgr:OnActivitiesChangeNtf(data)
    self:RefreshActivitiesData(data.activity_data_list,data.cur_day_end_time)
    self:RefreshDayEndTime(data.cur_day_end_time)
    self:RefreshRedPointState()
end

function ActivitiesDataMgr:SendGiveLikabilityReq(activityId, itemCfgId, lv)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_LIKABILITY_REWARD_REQ, {activity_id = activityId, item_cfg_id = itemCfgId, likability_level = lv})
end

function ActivitiesDataMgr:SendGetFirstRechargeRewardReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_FIRST_CHARGE_REWARD_REQ)
end

--param: 根据活动的类型传递不同的参数
function ActivitiesDataMgr:SendGetActivityRewardReq(activityId,param, rewardNum)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_REWARD_REQ, {activity_id = activityId,param = param, reward_num = rewardNum or 0})
end

--全局数据
function ActivitiesDataMgr:SendGetGlobalCollectionServerData(activityId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_COLLECTION_SERVER_DATA_REQ, {activity_id = activityId})
end

function ActivitiesDataMgr:OnActivitiesRewardAck(data)
    --LogError("add by raul get reward "..Inspect(data))
    if data.error == 0 then
        if data.reward_item_list ~= nil then
            local rewardList = {};
            for i = 1, #data.reward_item_list do
                local _itemData = data.reward_item_list[i];
                rewardList[#rewardList+1] = {cfgId = _itemData.key, num = _itemData.value}
            end
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})

            if data.activity_id == Enum.ActivityType.ACTIVITY_TYPE_DAILY_CUMULATIVE_RECHARGE then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Daily_Comulative_Refresh)
            --elseif data.activity_id == Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD then
            --    CommonUtil.ACKShowRewardList(data.reward_item_list)
            --    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTIVITY_TYPE_FESTIVAL_REWARD)
            end
        end
    end
end

function ActivitiesDataMgr:SendGetBoxRewardReq(activityId,boxId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_SCORE_REWARD_REQ, {activity_id = activityId,box_idx = boxId})
end

function ActivitiesDataMgr:OnGetBoxRewardAck(data)
    if data.error == 0 then
        if data.reward_item_list ~= nil then
            local rewardList = {};
            for i = 1, #data.reward_item_list do
                local _itemData = data.reward_item_list[i];
                rewardList[#rewardList+1] = {cfgId = _itemData.key, num = _itemData.value}
            end
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
        end
    end
end

function ActivitiesDataMgr:OnActivitiesStartUpNtf(data)
    -- LogHRWarning("OnActivitiesStartUpNtf")
    self:InitData()
    self:SetOpenActivityList(data.open_activity_list)
    self:RefreshActivitiesData(data.activity_data_list,data.cur_day_end_time)
    self:RefreshFirstRechargeData(data, data.cur_day_end_time)
    self:RefreshDayEndTime(data.cur_day_end_time)
    self:RefreshRedPointState()
    self:RefreshLimitRechargeData(data.unlock_charge_list)
end

function ActivitiesDataMgr:SetOpenActivityList(activityList)
    if activityList == nil then
        return
    end

    local actIds = {}
    for i = 1, #activityList do
        local activityItem = self:GetActivityItemById(activityList[i].id)
        if activityItem ~= nil then
            if not activityItem:IsOpened() then
                actIds[#actIds+1] = activityList[i].id
            end
            activityItem:SetOpenState(true)
            activityItem:SetEndTime(activityList[i].end_time)
            activityItem:SetBg(activityList[i].bg)
        end
    end

    --LogError("add by raul SetOpenActivityList"..Inspect(activityList))
    if #actIds > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Open_Activity_Refresh, actIds)
    end
end

function ActivitiesDataMgr:RefreshActivitiesData(activityDataList,curDayEndTime)
    if activityDataList ~= nil then
        for i = 1, #activityDataList do
            local activityData = activityDataList[i]
            local actItem = self:GetActivityItemById(activityData.activities_id)
            if actItem ~= nil then
                if activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_14_Days_LOGIN then
                    actItem:SyncSrvData({activityData.cur_day,activityData.login_reward_list})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_14_Days_Task then
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.fortnight_days})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_DAILY_CUMULATIVE_RECHARGE then
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.reward_state})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD  then
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.collection_list})
                    --add by raul  collection_list--?
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_KING_TASK then
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.king_task,activityData.fighting_target})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_PET_REWARD then
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.exchange_list})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_61_Days then                    
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.wheel_data})
                elseif activityData.activities_type == Enum.ActivityType.ACTIVITY_TYPE_SIGN then                    
                    actItem:SyncSrvData({activityData.cur_day,curDayEndTime,activityData.sign_data})
                else
                    actItem:SyncSrvData(activityData, curDayEndTime)
                end
            end
        end

        for i = 1, #activityDataList do
            local activityData = activityDataList[i]
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Data_Change,activityData.activities_id)
        end
    end
end

--- 有些活动对当前时间敏感,但是服务器的活动数据不会变化，则由客户端自己判定
function ActivitiesDataMgr:RefreshDayEndTime(curDayEndTime)
    if self.curDayEndTime and self.curDayEndTime ~= curDayEndTime then
        for i = 1, #self.actItemList do
            local actItem = self.actItemList[i]
            if actItem then
                if actItem:SyncCurDayEndTime(curDayEndTime) then
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Data_Change, actItem.actId)
                end
            end
        end
        if self.firstRechargeItem then
            if self.firstRechargeItem:SyncCurDayEndTime(curDayEndTime) then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_FirstRecharge_Change)
            end
        end
    end
    self.curDayEndTime = curDayEndTime
end

function ActivitiesDataMgr:RefreshRedPointState(type)
    if not self.activityRP then
        self.activityRP = {}
    end
    for i = 1, #self.actItemList do
        if type and type == self.actItemList[i].type then
            local rpState = (not self.actItemList[i]:IsOutofDate()) and self.actItemList[i]:HasRedPoint()
            local oldId = self.activityRP[self.actItemList[i].redPointType]
            if rpState then
                self.activityRP[self.actItemList[i].redPointType] = self.actItemList[i].actId
            else
                self.activityRP[self.actItemList[i].redPointType] = oldId == self.actItemList[i].actId and 0 or oldId
            end
            return
        else
            local rpState = (not self.actItemList[i]:IsOutofDate()) and self.actItemList[i]:HasRedPoint()
            local oldId = self.activityRP[self.actItemList[i].redPointType]
            if rpState then
                self.activityRP[self.actItemList[i].redPointType] = self.actItemList[i].actId
            else
                self.activityRP[self.actItemList[i].redPointType] = oldId == self.actItemList[i].actId and 0 or oldId
            end
        end
    end
    if self.activityRP then
        for k,v in pairs(self.activityRP) do
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, k, v > 0)
        end
    end

    if self.firstRechargeItem then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, self.firstRechargeItem.redPointType, self.firstRechargeItem:HasRedPoint())
    end
end

function ActivitiesDataMgr:RefreshLimitRechargeData(data)
    if self.limitRechargeItem == nil then
        self.limitRechargeItem = ActivityLimitRechargeItem:new()
    end

    self.limitRechargeItem:SyncSrvData(data, true)
end

function ActivitiesDataMgr:GetLimitRechargeItem()
    return self.limitRechargeItem
end

function ActivitiesDataMgr:RefreshFirstRechargeData(data, curDayEndTime)
    if not self.firstRechargeItem then
        self.firstRechargeItem = ActivityFirstRechargeItem:new()
    end
    self.firstRechargeItem:SyncSrvData(data, curDayEndTime)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_FirstRecharge_Change)
end

function ActivitiesDataMgr:InitData()
    if self.bInited then
        return
    end

    self.actItemList = {}
    self.hdDropMap = {}
    local cfgList = ManagerContainer.CfgMgr:GetActivities()
    if cfgList ~= nil then
        for k,v in pairs(cfgList) do
            local actItem = self:CreateActItem(v)
            self.actItemList[#self.actItemList+1] = actItem

            if v.HdDrop then
                for _,v1 in pairs(v.HdDrop) do
                    self.hdDropMap[v1] = v.Id
                end
            end
        end
    end
    --LogError("add by raul :ActivitiesDataMgr:InitData---cfgList"..Inspect(cfgList))
    self.bInited = true
    self:SortActItems()
    --LogError("add by raul:ActivitiesDataMgrInitData---sorted self.actItemList"..Inspect(self.actItemList))
end

function ActivitiesDataMgr:TestData()
    local loginActivity = self:GetActivityItemByType(Enum.ActivityType.ACTIVITY_TYPE_14_Days_LOGIN)
    if loginActivity ~= nil then
        loginActivity:SetOpenState(true)
        loginActivity:SyncSrvData({3,0})
    end

    local taskActivity = self:GetActivityItemByType(Enum.ActivityType.ACTIVITY_TYPE_14_Days_Task)
    if taskActivity ~= nil then
        taskActivity:SetOpenState(true)
        taskActivity:SyncSrvData({3,0,nil})
    end
end

function ActivitiesDataMgr:CreateActItem(cfg)
    local item = nil
    if cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_14_Days_LOGIN then
        item = ActivityFortnightLoginItem:new(cfg.Id)
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_14_Days_Task then
        item = ActivityFortnightTaskItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_HUNDRED_Task then
        item = ActivityHundredItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_DAILY_CUMULATIVE_RECHARGE then
        item = ActivityDailyComulativeRechargeItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD then
        item = ActivityChipRewardItem:new(cfg.Id)
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_PET_REWARD then
        item = ActivityPetRewardItem:new(cfg.Id)       
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_SHOP then
        item = ActivityShopItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_CASH_SHOP then
        item = ActivityShopItem:new(true)
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_GOD_DESS then
        item = ActivityGoddessItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_SPRING_BATTLE then
        item = ActivitySpringItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_KING_TASK then
        item = ActivityKingTaskItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_61_Days then
        item = Activity61TrunWheelItem:new()
    elseif cfg.Type == Enum.ActivityType.ACTIVITY_TYPE_SIGN then
        item = ActivitySignItem:new()
    else
        item = ActivityTypeItem:new()
    end

    if item~= nil then
        item:Init(cfg)
    end
    return item
end

function ActivitiesDataMgr:SortActItems()
    if self.actItemList == nil or #self.actItemList < 2 then
        return
    end

    table.sort(
        self.actItemList,
        function(a, b)
            return a.order < b.order
        end
    )
end

function ActivitiesDataMgr:GetActivityItemsByPageId(pageId)
    if self.actItemList == nil then
        return nil
    end

    self:RefreshRedPointState()

    local items = {}
    for i = 1, #self.actItemList do
        local item = self.actItemList[i]
        if item:HasEntrance(pageId) and item:NeedShow() and item:IsUnlocked() and item:IsOpened() and not item:IsOutofDate() then
            if Constant.OpenPay then
                items[#items+1] = item
            else
                if not item:NoPay() then
                    items[#items+1] = item
                end
            end
        end
    end

    return items
end

function ActivitiesDataMgr:GetActivityItemByType(type)
    if self.actItemList == nil then
        return nil
    end

    for i = 1, #self.actItemList do
        local item = self.actItemList[i]
        if item.type == type then
            return item
        end
    end

    return nil
end

function ActivitiesDataMgr:GetActivityItemById(id)
    if self.actItemList == nil then
        return nil
    end

    for i = 1, #self.actItemList do
        local item = self.actItemList[i]
        if item.actId == id then
            return item
        end
    end

    return nil
end

function ActivitiesDataMgr:GetActivityItemByIdAndType(id,type)
    if self.actItemList == nil then
        return nil
    end

    for i = 1, #self.actItemList do
        local item = self.actItemList[i]
        if item.actId == id  and item.type == type then
            return item
        end
    end

    return nil
end

function ActivitiesDataMgr:GetFirstRechargeItem()
    return self.firstRechargeItem
end

function ActivitiesDataMgr:IsInActivityDrop(cfgId)
    local needActId = self.hdDropMap and self.hdDropMap[cfgId] or 0
    local actItem = self:GetActivityItemById(needActId)
    return actItem and not actItem:IsOutofDate() and actItem:IsOpened()
end

function ActivitiesDataMgr:IsActivityItemAndUnderway(cfgId)
    if self.hdDropMap then
        local needActId = self.hdDropMap[cfgId]
        if needActId then
            local actItem = self:GetActivityItemById(needActId)
            return true, actItem and not actItem:IsOutofDate() and actItem:IsOpened()
        end
    end
    return false, false
end

function ActivitiesDataMgr:UpdateActsEndTime()
    if not self.actItemList then
        return
    end

    for _,v in pairs(self.actItemList) do
        if v.updateTime then
            v:PerMinuteCheckEndTime()
        end
    end
end

return ActivitiesDataMgr