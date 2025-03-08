local KeepSakeBookData = class("CardHandBook", require("DataBase"))

function KeepSakeBookData:ctor()
    self.data = {}

    self.totalCount = 0
    self.normalCount = 0
    self.miniCount = 0
    self.mvpCount = 0
    self.data.keepSakeMaps = {}
    self.data.keepSakeMaterials = {}
end

function KeepSakeBookData:InitDatas(keepSakes, materials)
    self:RefreshDatas(keepSakes, materials)

    ManagerContainer.DataMgr.UserData:CalcKeepSakeAttrs()
    for i = 2, 6 do
        local data = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(i)
        if data and data.owned then
            local fellowData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(data.id,data.configId)
            ManagerContainer.DataMgr.PartnerData:CalcKeepSakeAttrs(fellowData, data, true)
        end
    end
end

function KeepSakeBookData:RefreshDatas(keepSakes, materials, isChange)
    local data = ProtocalDataNormal.ParseKeepSakeData(keepSakes)
    for _,v in pairs(data) do
        if not self.data.keepSakeMaps[v.keepSakeId] then
            self.totalCount = self.totalCount + 1
            local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(v.keepSakeId)
            if cfgData then
                if cfgData.CollectionLevel == 2 then
                    self.normalCount = self.normalCount + 1
                elseif cfgData.CollectionLevel == 3 then
                    self.miniCount = self.miniCount + 1
                elseif cfgData.CollectionLevel == 4 then
                    self.mvpCount = self.mvpCount + 1
                end
            end
        end
        local lastLv = self.data.keepSakeMaps[v.keepSakeId] or 0
        local isLvUp = lastLv < v.keepSakeLevel
        self.data.keepSakeMaps[v.keepSakeId] = v.keepSakeLevel
        if isLvUp and isChange then
            ManagerContainer.DataMgr.UserData:AddKeepSakeLvUpAttrs(v.keepSakeId, v.keepSakeLevel)
            ManagerContainer.DataMgr.PartnerData:AddKeepSakeLvUpAttrs(v.keepSakeId, v.keepSakeLevel)
        end
    end

    for _,v in pairs(materials) do
        self.data.keepSakeMaterials[v.key] = v.value
    end

    local rpState = false
    local list = ManagerContainer.CfgMgr:GetAllKeepSakeCfgDatas()
    for _,v in pairs(list) do
        local result = self:CanKeepSakeLvUp(v.Id)
        if result then
            rpState = true
            break
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.KeepSakeCollect, rpState)
end

function KeepSakeBookData:GetMaterialById(costId)
    return self.data.keepSakeMaterials[costId] or 0
end

function KeepSakeBookData:GetMaterialDatas()
    return self.data.keepSakeMaterials
end

function KeepSakeBookData:CanKeepSakeLvUp(id)
    local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(id)
    local lv = self.data.keepSakeMaps[id] or 0

    local cost = cfgData["MaterialLevel"..(lv + 1)]
    if not cost then
        return false
    end

    for _,v in pairs(cost) do
        local costId = v[1]
        local costNum = v[2]
        if costNum > self:GetMaterialById(costId) then
            return false
        end
    end

    return true
end

function KeepSakeBookData:IsKeepSakeMaxLv(id)
    local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(id)
    local lv = self.data.keepSakeMaps[id] or 0

    local cost = cfgData["MaterialLevel"..(lv + 1)]
    if not cost then
        return true
    end
    return false
end

function KeepSakeBookData:QueryKeepSakeHandBook()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ONLINE_GET_KEEP_SAKE_REQ, {})
end

function KeepSakeBookData:SendKeepSakeLevelUpReq(id)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_KEEP_SAKE_LEVEL_UP_REQ, {keep_sake_id = id})
end

function KeepSakeBookData:QueryKeepSakeRank(id)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_KEEP_SAKE_RANK_REQ, {keep_sake_id = id})
end

function KeepSakeBookData:GetKeepSakeHandBookQualityCountByType(type)
    if type == Enum.CollectQualityType.ALL then
        return self.totalCount
    elseif type == Enum.CollectQualityType.NORMAL then
        return self.normalCount
    elseif type == Enum.CollectQualityType.MINIBOSS then
        return self.miniCount
    elseif type == Enum.CollectQualityType.MVP then
        return self.mvpCount
    end
    return 0
end

function KeepSakeBookData:GetKeepSakeBookDataById(id)
    return self.data.keepSakeMaps[id]
end

function KeepSakeBookData:GetKeepSakeMaps()
    return self.data.keepSakeMaps
end

function KeepSakeBookData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ONLINE_GET_KEEP_SAKE_ACK, function(data)
        self:InitDatas(data.role_keep_sake.keep_sake, data.role_keep_sake.material)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KEEP_SAKE_CHANGE_NTF, function(data)
        self:RefreshDatas({data.keep_sake}, data.materials, true)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KEEP_SAKE_LEVEL_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.KEEPSAKE_LEVEL_UP_SUCCESS_NTF)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KEEP_SAKE_RANK_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            if data.player_info then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_HANDBOOK_RANK_REFRESH, data.player_info, data.achievement_time)
            end
        end
    end)
end

function KeepSakeBookData:Clear()
    self.data = {}

    self.totalCount = 0
    self.normalCount = 0
    self.miniCount = 0
    self.mvpCount = 0
    self.data.keepSakeMaps = {}
    self.data.keepSakeMaterials = {}
end

function KeepSakeBookData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function KeepSakeBookData:UnRegisterNetEvents()

end

return KeepSakeBookData