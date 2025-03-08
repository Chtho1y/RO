local TitleData = class("TitleData", require("DataBase"))

function TitleData:ctor()
    self.AllTitleDatas = {}
    self.TypeList = {}
    self.redPoint = {}
    self.currWearerId = 0
    self:Init()
end
function TitleData:Init()
    local DesignationCfg = ManagerContainer.CfgMgr:GetDesignationCfg()
    self.AllTitleDatas = {}
    for k, v in pairs(DesignationCfg) do
        if v.Type > 0 then
            if not self.AllTitleDatas[v.Type] then
                self.AllTitleDatas[v.Type] = {}
                self.redPoint[v.Type] = false
                table.insert(self.TypeList,v.Type)
            end
            local data = {head_id = k}
            self.AllTitleDatas[v.Type][k] = self:InitTitleData(data)
        end
    end
    table.sort(self.TypeList,function(a,b)
        return a < b
    end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.TitleRedPoint, self:GetRedPointResult())
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.None, self:GetRedPointResult())
end

function TitleData:JudgeTotal(_type, _total)
    if _type == Enum.TaskType.Level_Battle_Count then   --同关
        return 1;
    else
        return _total;
    end
end
function TitleData:GetTitleDataByType(type)
    return self.AllTitleDatas[type]
end

function TitleData:GetTitleDataByTypeAndId(type,id)
    return self.AllTitleDatas[type] and self.AllTitleDatas[type][id]
end

function TitleData:GetAllActiveTitleListAttrs()
    local list = {}
    for _, value in pairs(self.AllTitleDatas) do
        for k, v in pairs(value) do
            if v.state >= 3 then
                local titleCfgData = ManagerContainer.CfgMgr:GetDesignationCfgById(v.titleId)
                local attrs = titleCfgData.Attribute
                if attrs and #attrs > 0 then
                    for i = 1, #attrs do
                        if not list[attrs[i][1]] then
                            list[attrs[i][1]] = 0
                        end
                        list[attrs[i][1]] = list[attrs[i][1]] + attrs[i][2]
                    end
                end
            end
        end
    end
    return list
end

function TitleData:GetAllActiveTitleList()
    local list = {}
    for _, value in pairs(self.AllTitleDatas) do
        for k, v in pairs(value) do
            if v.state >= 3 then
                table.insert(list,v)
            end
        end
    end
    table.sort(list,function(a, b)
        local titleCfgDataA = ManagerContainer.CfgMgr:GetDesignationCfgById(a.titleId)
        local titleCfgDataB = ManagerContainer.CfgMgr:GetDesignationCfgById(b.titleId)
        if titleCfgDataA.Type == titleCfgDataB.Type then
            return titleCfgDataA.Sort > titleCfgDataB.Sort
        else
            return titleCfgDataA.Type > titleCfgDataB.Type
        end
    end)
    return list
end

function TitleData:GetRedPointResult()
    local isshowRed = false
    for i = 1, #self.redPoint do
        self.redPoint[i] = false
    end
    for _, value in pairs(self.AllTitleDatas) do
        for k, v in pairs(value) do
            if v.state == 2 then
                isshowRed = true
                self.redPoint[_] = true 
            end
        end
    end
    return isshowRed
end

function TitleData:GetTitleTypeList()
    return self.TypeList
end
function TitleData:GetTitleRedPointList()
    return self.redPoint
end

function TitleData:GetCurrWearerTitleId()
    return self.currWearerId
end

function TitleData:InitData(data)
    if not data or not self.AllTitleDatas then
        return
    end
    local headList = data.head
    local changeData = {}
    if headList and #headList > 0 then
        for i = 1, #headList do
            local id = headList[i].head_id
            local titleData = ManagerContainer.CfgMgr:GetDesignationCfgById(id)
            if titleData then
                if not self.AllTitleDatas[titleData.Type] then
                    self.AllTitleDatas[titleData.Type] = {}
                end
                changeData[id] = self:InitTitleData(headList[i])
                self.AllTitleDatas[titleData.Type][id] = changeData[id]
                if self.currWearerId == id and self.AllTitleDatas[titleData.Type][id].state ~= 3 then
                    self.currWearerId = 0
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_WEARER_DISBOARD_NOTICE)
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_ACTIVE_REDPOINT_NOTICE)
                end
                if self.AllTitleDatas[titleData.Type][id].state == 3 then
                    self.currWearerId = id
                end
                if self.AllTitleDatas[titleData.Type][id].state == 2 then
                    self.redPoint[titleData.Type] = true
                end
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_TITLE_CHANGE,changeData)
    local isShowRedPoint = self:GetRedPointResult()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.TitleRedPoint, isShowRedPoint)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.None, isShowRedPoint)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_ACTIVE_REDPOINT_NOTICE)
end

function TitleData:InitTitleData(data)
    if not data then
        return
    end
    local temp = {}
    temp.titleId = data.head_id
    temp.state   = data.state and data.state + 1 or 1
    temp.endTime = data.end_time or 0
    if data.task_data and data.task_data.progress and #data.task_data.progress > 0 then
        temp.currCount = data.task_data.progress[1].value
    else
        temp.currCount = 0
    end
    local titleCfgData = ManagerContainer.CfgMgr:GetDesignationCfgById(data.head_id)
    local total = 0
    if titleCfgData and  titleCfgData.TaskCondition and  titleCfgData.TaskCondition then
        local _conditions = titleCfgData.TaskCondition[1]
        total = self:JudgeTotal(_conditions[1], _conditions[#_conditions])
    end
    temp.totalCount = total
    return temp
end

function TitleData:RegisterNetEvents()
    --称号数据请求返回
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HEAD_OPERATE_ACK,self.RefreshTitleDataByAck,self)
    --称号状态更新
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HEAD_UPDATE_NTF,self.RefreshTitleDataByNtf,self)
end

function TitleData:RefreshTitleDataByAck(data)
    if data.error == 0 then
        local type = data.operateType
        if type == 1 then --激活操作
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ActivateSucess")
        elseif type == 2 then --佩戴操作
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("WearSucess")
            self.currWearerId = data.headId
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_WEARER_DISBOARD_NOTICE)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_ACTIVE_REDPOINT_NOTICE)
        elseif type == 3 then --卸下操作
            self.currWearerId = 0
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_WEARER_DISBOARD_NOTICE)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TITLE_ACTIVE_REDPOINT_NOTICE)
        end
    end
end

function TitleData:Clear()

end

function TitleData:RefreshTitleDataByNtf(data)
    self:InitData(data)
end

function TitleData:Destroy()
    self.AllTitleDatas = nil
    self.TypeList = nil
    self.redPoint = nil
    self.currWearerId = nil
    self:UnRegisterNetEvents()
end

function TitleData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_HEAD_OPERATE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_HEAD_UPDATE_NTF)
end

return TitleData