local ForceGuideMgr = class("ForceGuideMgr")

local needGuide = true
function ForceGuideMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_FORCE_GUIDE_TRIGGER, self, self.ForceGuideTrigger)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_PAGE_IN_END_NTF, self, self.UIPageInEnd)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_PAGE_OUT_END_NTF, self, self.UIPageOutEnd)

    --k groupId , v {ids = {id,id,id}, records = {true, false, false}}
    self.forceGuideTasks = {}
    self.forceGuideState = false
    self.curGroupId = nil
    self.curGuideIdx = nil
    self.curGuideId = nil
end

function ForceGuideMgr:InitForceGuideData()
    local cfgDatas = ManagerContainer.CfgMgr:GetForceGuideDatas()
    for i = 1, #cfgDatas do
        local data = cfgDatas[i]
        if self.forceGuideGroups[data.Group] == nil then
            self.forceGuideGroups[data.Group] = {}
            self.forceGuideGroups[data.Group].ids = {}
            self.forceGuideGroups[data.Group].records = {}
        end
        self.forceGuideGroups[data.Group].ids[#self.forceGuideGroups[data.Group].ids + 1] = data.Id
        self.forceGuideGroups[data.Group].records[#self.forceGuideGroups[data.Group].records + 1] = false
    end
end

function ForceGuideMgr:InitMgrData()
    self.forceGuideGroups = {}
    self:Reset()
    self:InitForceGuideData()
end

function ForceGuideMgr:InitDataRecords(data)
    for k,v in pairs(data) do
        local id = v
        local cfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(id)
        if self.forceGuideGroups[cfgData.Group] then
            local result, idx = CommonUtil.EleInTable(id, self.forceGuideGroups[cfgData.Group].ids)
            if idx then
                self.forceGuideGroups[cfgData.Group].records[idx] = true
            end
        end
    end
end

function ForceGuideMgr:LoggedinCheckForceGuide()
    if not ManagerContainer.FSMMgr:IsBattleState() then
        return false
    end
    local datas = ManagerContainer.DataMgr.ForceGuideData:GetForceGuideDatas()

    local maxK = 1
    local maxV = 0
    if datas then
        for k,v in pairs(datas) do
            if k > maxK then
                maxK = k
                maxV = v
            end
        end
    end

    local data = self.forceGuideGroups[maxK]
    if data == nil then
        return false
    end

    local dontGuide = data.records[#data.records]
    if dontGuide == false and not ManagerContainer.StoryMgr:IsStorying() and not ManagerContainer.StoryMgr:HasPreStoryChapter() then
        for k,v in pairs(data.records) do
            data.records[k] = false
        end
        self:AddForceGuideDontCheck(maxK)
    end
    return not dontGuide
end

function ForceGuideMgr:ForceGuideTrigger(type, param, needCheck)
    local forceGuideGroup = 0
    if type == Enum.ForceGuideTriggerEnum.BattleWin then
        local curLevel = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
        local levelData = ManagerContainer.CfgMgr:GetLevelDataById(curLevel)
        if levelData == nil then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
            return
        end

        forceGuideGroup = levelData.ForceGuideGroup

    elseif type == Enum.ForceGuideTriggerEnum.Story then
        local newFuncData = ManagerContainer.CfgMgr:GetStoryDataById(param)
        if newFuncData == nil then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
            return
        end

        forceGuideGroup = newFuncData.ForceGuideGroup
    elseif type == Enum.ForceGuideTriggerEnum.FuncOpen then
        local storyData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(param)
        if storyData == nil then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
            return
        end

        forceGuideGroup = storyData.ForceGuideGroup
    elseif type == Enum.ForceGuideTriggerEnum.FGGroupId then
        forceGuideGroup = tonumber(param)
    end

    --self.delayTimer = FrameTimer.New(function()
    if forceGuideGroup > 0 then
        if needCheck == nil or needCheck == true then
            self:AddForceGuideNeedCheck(forceGuideGroup)
        elseif needCheck == false then
            self:AddForceGuideDontCheck(forceGuideGroup)
        end
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
    end
    --end, 1)
    --self.delayTimer:Start()
end

function ForceGuideMgr:AddForceGuideNeedCheck(groupId)
    if not needGuide then return end

    if self:CheckRecord(groupId) then
        self:AddForceGuide(groupId)
        self:StartForceGuideTask(true)
    end
end

function ForceGuideMgr:AddForceGuideDontCheck(groupId)
    if not needGuide then return end

    self:AddForceGuide(groupId)
    self:StartForceGuideTask(false)
end

function ForceGuideMgr:CheckRecord(groupId)
    local datas = ManagerContainer.DataMgr.ForceGuideData:GetForceGuideDatas()
    local maxK = 0
    for k,v in pairs(datas) do
        if k > maxK then
            maxK = k
        end
    end
    if groupId < maxK then
        return false
    elseif groupId == maxK then
        local groupDatas = ManagerContainer.CfgMgr:GetForceGuideGroupDatasById(groupId)
        for k1,v1 in pairs(groupDatas) do
            if datas[maxK] < v1.Id then
                return true
            end
        end
    else
        return true
    end
end

function ForceGuideMgr:AddForceGuide(groupId)
    if self.forceGuideGroups[groupId] == nil then
        LogHRWarning(groupId.." isnt exist in ForceGuideCfg")
        return
    end

    if self.forceGuideGroups[groupId].ids == nil or self.forceGuideGroups[groupId].records == nil then
        LogHRWarning(groupId.." data error")
        return
    end

    if not CommonUtil.EleInTable(groupId, self.forceGuideTasks) then
        self.forceGuideTasks[#self.forceGuideTasks + 1] = groupId
    end
end

function ForceGuideMgr:StartForceGuideTask(needCheck)
    if self.forceGuideState then return end
    if #self.forceGuideTasks == 0 then return end

    self.needCheck = needCheck
    self.curGroupId = self.forceGuideTasks[1]
    self.curGuideIdx = 0
    for i = 1, #self.forceGuideGroups[self.curGroupId].records do
        local v = self.forceGuideGroups[self.curGroupId].records[i]
        if (self.needCheck and not v) or not self.needCheck then
            self.curGuideIdx = i
            self.curGuideId = self.forceGuideGroups[self.curGroupId].ids[self.curGuideIdx]
            self.forceGuideState = true

            self:ForceGuideSDKReport(self.curGroupId, 0)
            --多步引导 引导第一步 首次就保存
            if #self.forceGuideGroups[self.curGroupId].records > 1 then
                if not ManagerContainer.DataMgr.ForceGuideData:GetForceGuideRecordByGroupId(self.curGroupId, self.curGuideId) then
                    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPULSORY_GUIDANCE_REQ, {story_id = self.curGroupId, status = self.curGuideId})
                end
            end
            ManagerContainer.LuaUIMgr:OpenInputMask(Enum.UISibling[Enum.UIType.Story] - 1)
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle)
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForceGuide, self.curGuideId)
            return
        end
    end
end

function ForceGuideMgr:StartNextForceGuideTask(id)
    if id == Enum.UIPageName.UIErrorTips then return end
    if self.forceGuideState then return end
    if #self.forceGuideTasks == 0 then return end
    if not self.curGuideIdx then return end

    self.curGroupId = self.forceGuideTasks[1]
    for i = 1, #self.forceGuideGroups[self.curGroupId].records do
        local v = self.forceGuideGroups[self.curGroupId].records[i]
        if i > self.curGuideIdx and ((self.needCheck and not v) or not self.needCheck) then
            self.curGuideIdx = i
            self.curGuideId = self.forceGuideGroups[self.curGroupId].ids[self.curGuideIdx]

            local cfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(self.curGuideId)
            if cfgData == nil then
                --LogHRWarning(id .." forceGuide over error")
                self:ForceGuideOver(true)
                return
            end

            if cfgData.UIId == id or ManagerContainer.LuaUIMgr:GetPage(cfgData.UIId) then
                self.forceGuideState = true
                --ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForceGuide, self.curGuideId)
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_DISPLAY, self.curGuideId)
            end
            return
        end
    end
end

function ForceGuideMgr:GetCurGuideUIId()
    local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(self.curGuideId)
    if cfgData == nil then
        --LogHRWarning(id .." forceGuide over error")
        self:ForceGuideOver(true)
        return
    end

    return cfgData.UIId
end

function ForceGuideMgr:GetCurGuideId()
    return self.curGuideId
end

function ForceGuideMgr:CurForceGuideOver()
    self.forceGuideState = false

    if self.curGroupId == nil or self.curGuideId == nil then
        --LogHRWarning(" forceGuide over error")
        self:ForceGuideOver(true)
        return false
    end

    local cfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(self.curGuideId)
    if cfgData == nil then
        --LogHRWarning(" forceGuide over error")
        return false
    end

    if not ManagerContainer.DataMgr.ForceGuideData:GetForceGuideRecordByGroupId(self.curGroupId, self.curGuideId) then
        ManagerContainer.DataMgr.ForceGuideData:RefreshForceGuideData(self.curGroupId, self.curGuideId)
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPULSORY_GUIDANCE_REQ, {story_id = self.curGroupId, status = self.curGuideId})
    end
    self.forceGuideGroups[self.curGroupId].records[self.curGuideIdx] = true
    if self.curGuideIdx == #self.forceGuideGroups[self.curGroupId].records then
        table.remove(self.forceGuideTasks, 1)
        if #self.forceGuideTasks == 0 then
            LogHRWarning(self.curGroupId .."  group forceGuide over")
            self:ForceGuideOver()
            return false
        end
    end

    return true
end

function ForceGuideMgr:NeedManualOpenInEnd()
    if self.curGuideIdx then
        if self.curGuideIdx < #self.forceGuideGroups[self.curGroupId].records then
            local id = self.forceGuideGroups[self.curGroupId].ids[self.curGuideIdx]
            local nextId = self.forceGuideGroups[self.curGroupId].ids[self.curGuideIdx + 1]
            local curCfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(id)
            local nextCfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(nextId)
            local curUIId = curCfgData.UIId
            local nextUIId = nextCfgData.UIId
            local curUIData = ManagerContainer.CfgMgr:GetUIData(curUIId)
            local nextUIData = ManagerContainer.CfgMgr:GetUIData(nextUIId)
            if not curUIData or not nextUIData then
                return false
            end
            if curCfgData.UIId == nextCfgData.UIId then
                return true
            end
            if curUIData.type > 2 and nextUIData.type == 0 then
                return true
            end
            return false
        end
    end
    return false
end

function ForceGuideMgr:SetHasMaskOpenCompeleted(result)
    self.hasMaskOpenCompeleted = result
end

function ForceGuideMgr:MaskOpenAnimCompeleted()
    if not self.hasMaskOpenCompeleted then
        if self.forceGuideState then
            --当前强制引导节点结束
            self:CurForceGuideOver()

            if ManagerContainer.ForceGuideMgr:NeedManualOpenInEnd() then
                local id = self.forceGuideGroups[self.curGroupId].ids[self.curGuideIdx]
                local curCfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(id)
                self:UIPageInEnd(curCfgData.UIId)
            end
        end
    else
        self.hasMaskOpenCompeleted = false
    end
end

function ForceGuideMgr:UIPageInEnd(id)
    if not self.forceGuideState then
        --继续同个组内的下一个强制引导节点
        self.delayTimer1 = FrameTimer.New(function()
            self:StartNextForceGuideTask(id)
        end, 1)
        self.delayTimer1:Start()
    end
end

function ForceGuideMgr:UIPageOutEnd(id)

end

function ForceGuideMgr:ForceGuideOver(isError)
    if self.curGuideId == nil then
        self:Reset()
        ManagerContainer.LuaUIMgr:CloseInputMask()
        return
    end
    if isError then
        LogHRWarning(self.curGroupId .."  forceGuide end error")
        self:ForceGuideSDKReport(self.curGroupId, -1)
        local endId = self.forceGuideGroups[self.curGroupId].ids[#self.forceGuideGroups[self.curGroupId].ids]
        if not ManagerContainer.DataMgr.ForceGuideData:GetForceGuideRecordByGroupId(self.curGroupId, endId) then
            ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPULSORY_GUIDANCE_REQ, {story_id = self.curGroupId, status = endId})
        end
    end
    table.remove(self.forceGuideTasks, 1)

    self:ForceGuideSDKReport(self.curGroupId, 1)
    self:Reset()
    ManagerContainer.LuaUIMgr:CloseInputMask()
    ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIForceGuide)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
end

function ForceGuideMgr:ForceOver()
    self:Reset()
    ManagerContainer.LuaUIMgr:CloseInputMask()
end

function ForceGuideMgr:GuideBossBattle()
    if not ManagerContainer.FSMMgr:IsBattleState() then
        return false
    end
    local datas = ManagerContainer.DataMgr.ForceGuideData:GetForceGuideDatas()

    local maxK = 0
    local maxV = 0
    for k,v in pairs(datas) do
        if k > maxK then
            maxK = k
            maxV = v
        end
    end

    if maxK > 0 then
        return false
    end

    self:AddForceGuideDontCheck(1)
    return true
end

function ForceGuideMgr:Reset()
    self.forceGuideState = false
    self.curGroupId = nil
    self.curGuideIdx = nil
    self.curGuideId = nil
    self.needCheck = nil

    if self.delayTimer1 then
        self.delayTimer1:Stop()
    end
    self.delayTimer1 = nil
end

function ForceGuideMgr:Dispose()
    if self.delayTimer then
        self.delayTimer:Stop()
    end
    self.delayTimer = nil

    self.forceGuideGroups = {}
    self:Reset()

    ManagerContainer.LuaUIMgr:CloseInputMask()
end

function ForceGuideMgr:Destroy()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_FORCE_GUIDE_TRIGGER, self, self.ForceGuideTrigger)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_PAGE_IN_END_NTF, self, self.UIPageOutEnd)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_PAGE_OUT_END_NTF, self, self.UIPageOutEnd)

    self:Dispose()
    self.forceGuideTasks = nil
end

function ForceGuideMgr:ForceGuideSDKReport(groupId, state)
    ManagerContainer.DataMgr.UserData:SyncRoleDataToSDK()
    local tutorialId = tostring(groupId)
    local tutorialName = tostring(groupId)
    local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    local lv = ManagerContainer.DataMgr.UserData:GetRoleLv()
    if state ~= 0 then
        local delta = curTime - (self.beginTime or 0)
        SDKMgr.Instance:ReportTutorial(tutorialId, tutorialName, 0, 0, 0, lv, delta, state)
    else
        self.beginTime = curTime
        local beginTimeStamp = int64.new(tostring(curTime * 1000))
        SDKMgr.Instance:ReportTutorial(tutorialId, tutorialName, 0, 0, beginTimeStamp, lv, 0, state)
    end
end

return ForceGuideMgr