local BagData = class("BagData", require("DataBase"))
local petStampRPItems

function BagData:ctor()
    self.data = {}
end

function BagData:InitBagData(data)
    local items = {}
    local itemsCfgs = {}
    local bagCount = 0
    local cfgMgr = ManagerContainer.CfgMgr
    for i = 1, #data.item_list do
        local itemData = data.item_list[i]
        if itemData and itemData.num > 0 then
            local item = self:ProtocalDataToItemData(itemData)
            local cfgId = item.cfgId
            local itemCfgData = cfgMgr:GetItemById(cfgId)
            if not itemCfgData then
                LogError("[Wboy] .. ".. tostring(cfgId) .. " 道具ID不存在")
            else
                items[item.id] = item
                if itemsCfgs[cfgId] then
                    itemsCfgs[cfgId].num = itemsCfgs[cfgId].num + item.num
                else
                    itemsCfgs[cfgId] = {cfgId = cfgId, num = item.num}
                end
            end
        end
    end
    bagCount = data.bag_count

    self.data.items = items
    self.data.itemCfgMap = itemsCfgs
    self.data.bagCount = bagCount

    local needRP = false
    for k,v in pairs(items) do
        local cfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
        local result = self:RefreshItemRPState(v, cfgData)
        if result then
            needRP = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.BagItem, needRP)
end

function BagData:StartLimitTimeItemDelete()
    if self.timerId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.timerId)
        self.timerId = nil
    end
    self.timerId = ManagerContainer.LuaTimerMgr:AddTimer(10000, -1, self, self.LimitTimeItemDelete, nil)
end

function BagData:LimitTimeItemDelete()
    local nextItemCfgId,nextItemId
    local minTime, minIdx = 0,0

    for k,v in pairs(self.data.items) do
        if minTime == 0 and v.timeStamp > 0 then
            minTime = v.timeStamp
        end
        if v.timeStamp > 0 and v.timeStamp <= minTime then
            minTime = v.timeStamp
            minIdx = k
            nextItemCfgId = v.cfgId
            nextItemId = v.id
        end
    end

    if minIdx == 0 or nextItemCfgId == nil or nextItemId == nil then
        return
    end

    local cfgData = ManagerContainer.CfgMgr:GetItemById(nextItemCfgId)
    if cfgData and cfgData.ItemTime == 7 then
        return
    end

    local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if curTime < minTime then
        return
    end

    self.data.items[minIdx] = nil
    self.data.itemCfgMap[nextItemCfgId] = nil

    ManagerContainer.DataMgr.BagData:DelAllTimeLimitItems({nextItemId})
end

function BagData:GetItemById(id)
    return self.data.items[id]
end

function BagData:GetItemDataByCfgId(cfgId)
    for _,v in pairs(self.data.items) do
        if v. cfgId == cfgId then
            return v
        end
    end
    return nil
end

function BagData:SendWishBoxReq(data)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_WISH_BOX_USE_REQ, {
        item_id = data.id,
        select_item = data.cfgId,
    })
end

function BagData:GetItemByCfgId(cfgId)
    return self.data.itemCfgMap[cfgId]
end

function BagData:GetItemCountByCfgId(cfgId)
    local data = self.data.itemCfgMap[cfgId]
    if data ~= nil then
        return data.num
    end
    return 0
end

function BagData:GetAllItemDatas()
    local list = {}
    local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    for k,v in pairs(self.data.items) do
        if v.timeStamp > 0 then
            if curTime > v.timeStamp then
                local cfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
                if cfgData and cfgData.ItemTime ~= 7 then
                    list[#list + 1] = v.id
                    self.data.items[k] = nil
                    self.data.itemCfgMap[v.cfgId] = nil
                end
            end
        end
    end
    if #list > 0 then
        self:DelAllTimeLimitItems(list)
    end
    return self.data.items
end

function BagData:DelAllTimeLimitItems(list)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DEL_ITEM_REQ, {item_id_list = list})
end

function BagData:RefreshData(item_list, ignore)
    -- 是否为新增道具， 默认为新增
    local cfgMgr = ManagerContainer.CfgMgr
    ignore = ignore and ignore or false
    local items = self.data.items
    local itemCfgs = self.data.itemCfgMap
    local addItemMap = {}
    local changedIds = {}
    for _,itemData in ipairs(item_list) do
        local id = itemData.id
        local num = itemData.num
        local cfgId = itemData.config_id or id

        local itemCfgData = cfgMgr:GetItemById(cfgId)
        if not itemCfgData then
            LogError("[Wboy] .. ".. cfgId .. " 道具ID不存在")
        else
            local item = items[id]
            local itemCfg = itemCfgs[cfgId]
            local lastNum = item and item.num or 0
            if num <= 0 then
                -- 删除道具
                items[id] = nil
                if itemCfg then
                    itemCfg.num = itemCfg.num - lastNum
                    if itemCfg.num <= 0 then
                        itemCfgs[cfgId] = nil
                    end
                end
                changedIds[cfgId] = 0
            else
                -- 更新道具数量
                local newItem = self:ProtocalDataToItemData(itemData)
                items[id] = newItem
                local addNum = newItem.num - lastNum
                if itemCfg then
                    itemCfg.num = itemCfg.num + addNum
                else
                    itemCfg = {cfgId = cfgId, num = newItem.num}
                    itemCfgs[cfgId] = itemCfg
                end
                changedIds[cfgId] = itemCfg.num

                -- 当前增加的道具
                if addNum > 0 then
                    self:NewItemRefreshRP(cfgId, itemCfgData)
                    if addItemMap[cfgId] then
                        addItemMap[cfgId] = addItemMap[cfgId] + addNum
                    else
                        addItemMap[cfgId] = addNum
                    end
                end
            end
        end
    end

    local needRP = false
    for k,v in pairs(items) do
        local cfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
        local result = self:RefreshItemRPState(v, cfgData)
        if result then
            needRP = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.BagItem, needRP)

    if not CommonUtil.TableIsEmpty(addItemMap) then
        ManagerContainer.DataMgr.SummonDataMgr:CalcRedPoint()
    end

    if not ignore then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addItemMap)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ITEM_CHANGE, changedIds)

    ManagerContainer.RedPointMgr.HeroRPCtr:PartnerItemChangeRPNotify()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_UI_REDPOINT_CHANGE)
end

function BagData:NewItemRefreshRP(cfgId, itemCfgData)
    if not petStampRPItems then
        local val = GlobalConfig.Instance:GetConfigStrValue(321)
        if val ~= "" and val ~= nil then
            petStampRPItems = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end
    if cfgId == Enum.ItemIds.Recruit then
        ManagerContainer.RedPointMgr.HeroRPCtr:PartnerRecruitNotify()
    elseif cfgId == Enum.ItemIds.QiyueItem then
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
    elseif itemCfgData.ItemTime == Enum.ActivitiesItemType.HolidayCollectionWord then
        ManagerContainer.DataMgr.ActsDataMgr:RefreshRedPointState(Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD)
    elseif CommonUtil.EleInTable(tostring(cfgId), petStampRPItems) then
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()
    end
end

function BagData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ITEM_CHANGE_NTF, function(data)
        self:RefreshData(data.item_list, data.ignore)
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_UPDATE_WISH_SLOT_NTF, function(data)
        self:RefreshWishSlotData(data)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DEL_ITEM_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            local list = {}
            for _,v in pairs(data.del_cfg_id_list) do
                if not CommonUtil.EleInTable(v, list) then
                    local cfgData = ManagerContainer.CfgMgr:GetItemById(v)
                    list[#list + 1] = I18N.T(cfgData.Name)
                end
            end

            self:NoticeDelTimeLimitItems(list)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DEL_ITEM_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            local list = {}
            for _,v in pairs(data.del_cfg_id_list) do
                if not CommonUtil.EleInTable(v, list) then
                    local cfgData = ManagerContainer.CfgMgr:GetItemById(v)
                    list[#list + 1] = I18N.T(cfgData.Name)
                end
            end

            self:NoticeDelTimeLimitItems(list)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_WISH_UNLOCK_SLOT_ACK, function(data)  --解锁请求
        if data.error == 0 then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("WishunlockTips1")
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WISHBOX_SLOT_CHANGE)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_WISH_SLOT_REQ_ACK, function(data) --加速领奖返回
        if data.error == 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WISHBOX_SLOT_CHANGE)
            local rewards = {}
            if data.award_item then
                table.insert(rewards,{cfgId = data.award_item.key,num = data.award_item.value,lucky = false})
            end
            if data.lucky_item then
                table.insert(rewards,{cfgId = data.lucky_item.key,num = data.lucky_item.value,lucky = true})
            end
            if #rewards > 0 then
                ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWishPOPGot,rewards)
            end
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_WISH_BOX_USE_ACK, function(data)
        if data.error == 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WISHBOX_SLOT_SHOWANIMATION,data.index)
        end
    end)
end

function BagData:RefreshWishSlotData(data)
    local wishSlot = data.slots
    if wishSlot and #wishSlot > 0 then
        if not self.wishSlotData  then
            self.wishSlotData = {}
            local wishSlotNum = GlobalConfig.Instance:GetConfigIntValue(348)
            for i = 1, wishSlotNum do
                table.insert(self.wishSlotData, {end_time = 0,isOpen = false})
            end
        end
        for i = 1, #wishSlot do
            self.wishSlotData[i] = wishSlot[i]
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WISHBOX_SLOT_CHANGE)
        local items = self.data.items
        local wishRP = self:GetWishRedPointState()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.WishSlotItem, wishRP)
    end
end

function BagData:SendWishSlotUnlockReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_WISH_UNLOCK_SLOT_REQ)
end

function BagData:SendWishAccelerateReq(idx)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_WISH_SLOT_REQ,{index = idx})
end

function BagData:GetWishSlotData()
    if not self.wishSlotData then
        self.wishSlotData = {}
        local wishSlotNum = GlobalConfig.Instance:GetConfigIntValue(348)
        for i = 1, wishSlotNum do
            table.insert(self.wishSlotData, {end_time = 0,isOpen = false})
        end
    end
    return self.wishSlotData
end

function BagData:GetWishRedPointState()
    if self.wishSlotData then
        for i = 1, #self.wishSlotData do
            local slotData = self.wishSlotData[i]
            if slotData.isOpen and slotData.item ~= nil and slotData.end_time == 0 then
                return true
            end
        end
    end
    return false
end

function BagData:NoticeDelTimeLimitItems(list)
    local datas = {}
    for _,v in pairs(list) do
        local data = {}
        data.type = Enum.ChatSystemType.TimeLimitDel
        data.nick_name = v
        data.send_time = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
        datas[#datas + 1] = data
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.SetLanguageValue("CompetitionTip2", v))
    end

    ManagerContainer.DataMgr.ChatData:AddNewSystemData(datas)
end

function BagData:Clear()
    if self.timerId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.timerId)
        self.timerId = nil
    end
    self.wishSlotData = nil
    self.data = {}
end

function BagData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function BagData:UnRegisterNetEvents()

end

function BagData:ProtocalDataToItemData(protocalData)
    local itemData      = {}
    itemData.id         = protocalData.id
    itemData.cfgId      = protocalData.config_id
    itemData.num        = protocalData.num
    itemData.timeStamp  = protocalData.time_stamp
    itemData.redpointState = false
    return itemData
end

function BagData:RefreshItemRPState(itemData, cfgData)
    local unLockLv = cfgData.NeedLevel
    local curLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
    if curLv < unLockLv then
        return
    end

    if cfgData.ResType == Enum.ItemType.Gift then
        local costId = cfgData.Costitem and cfgData.Costitem[1][1] or 0
        local costCount = cfgData.Costitem and cfgData.Costitem[1][2] or 0
        if costId == 0 then
            itemData.redpointState = itemData.num > 0 and cfgData.NeedRP
        else
            --考虑是否需要钥匙打开礼包
            local ownedCost = CommonUtil.GetOwnResCountByItemId(costId)
            itemData.redpointState = itemData.num > 0 and ownedCost >= costCount and cfgData.NeedRP
        end
    elseif cfgData.ResType == Enum.ItemType.HeadFrame then
        itemData.redpointState = cfgData.NeedRP
    elseif cfgData.ResType == Enum.ItemType.Compose then
        local costId = cfgData.Costitem and cfgData.Costitem[1][1] or 0
        local costCount = cfgData.Costitem and cfgData.Costitem[1][2] or 0
        if costId == 0 then
            itemData.redpointState = false
        else
            if costId ~= itemData.cfgId then
                itemData.redpointState = false
            else
                itemData.redpointState = itemData.num >= costCount and cfgData.NeedRP
            end
        end
    elseif cfgData.ResType == Enum.ItemType.OptionalGift then
        itemData.redpointState = cfgData.NeedRP
	end
    return itemData.redpointState
end

return BagData