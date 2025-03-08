local UIStoryMgr = class("UIStoryMgr")

local storyPlayStatus = false
local curStoryData
local storyList = {}

function UIStoryMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UISTORY_CONDITION_TRIGGER, self, self.StoryConditionTrigger)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UISTORY_UI_START_OR_OVER, self, self.StoryUIStartOrOver)
end

function UIStoryMgr:StoryConditionTrigger(type, ...)
    local params = {...}
    local storyData
    local storyDatas = ManagerContainer.DataMgr.StoryData:GetStoryDatas()
    local condition = params[1]
    local storyId = params[2]
    if type == Enum.UIStoryCondType.FirstSceneEnter then
        local storyCfgData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
        if storyCfgData == nil then
            return
        end

        if storyCfgData.Condition ~= nil then
            if storyCfgData.Condition[2] == condition then
                storyData = storyCfgData
            end
        end

        local record = UIStoryMgr:CheckRecord(storyId)
        if record then
            return
        end
    else
        local storyCfgDatas = ManagerContainer.CfgMgr:GetAllStoryDatasByType(type)
        if storyCfgDatas ~= nil then
            for _,v in pairs(storyCfgDatas) do
                if v.Condition ~= nil then
                    if v.Condition[2] == condition then
                        storyData = v
                        local record = UIStoryMgr:CheckRecord(v.Id)
                        if record then
                            return
                        end
                    end
                end
            end
        end
    end
    if storyData == nil then
        return
    end
    self:StoryCheckData(storyData)

    if condition == storyData.Condition[2] then
        storyList[#storyList + 1] = storyData
        self:StartStory()
    end
end

function UIStoryMgr:MapStartStoryByStoryId(storyId)
    local storyData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
    if storyData == nil then
        LogError("hurui: "..tostring(storyId) .." storyId  isnt exist")
        return
    end
    self:StoryCheckData(storyData)

    storyData.isMap = true
    storyList[#storyList + 1] = storyData
    self:StartStory()
end

function UIStoryMgr:StartStoryByStoryId(storyId, skipCheckCache)
    local storyData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
    if storyData == nil then
        LogError("hurui: "..tostring(storyId) .." storyId  isnt exist")
        --LuaBattleBridge.CurStoryOver(storyId)
        return
    end
    local record = false
    if not skipCheckCache then
        record = UIStoryMgr:CheckRecord(storyId)
    end

    if not record then
        self:StoryCheckData(storyData)

        storyList[#storyList + 1] = storyData
        self:StartStory()
    end
end

function UIStoryMgr:GetNextStory(storyId)
    local storyData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
    local storyDatas = ManagerContainer.DataMgr.StoryData:GetStoryDatas()
    storyId = storyData.SelectionNext[storyDatas[storyId]]
    storyData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
    if storyData then
        if storyDatas[storyId] ~= nil then
            if storyData.SelectionNext == nil then
                if storyDatas[storyId] >= 0 then
                    return nil
                end
            else
                return self:GetNextStory(storyId)
            end
        else
            return storyData
        end
    end
    return nil
end

function UIStoryMgr:CheckRecord(storyId)
    local storyData
    local list = ManagerContainer.CfgMgr:GetSameStoryGroupDatasById(storyId)
    local storyDatas = ManagerContainer.DataMgr.StoryData:GetStoryDatas()

    if list == nil then
        if storyDatas[storyId] ~= nil then
            storyData = self:GetNextStory(storyId)
            if storyData == nil then
                --LogError("hurui: "..storyId .." story  is recorded")
                LuaBattleBridge.CurStoryOver(storyId)
                return true
            end
        end
    else
        for _,v in pairs(list) do
            if storyDatas[v.Id] ~= nil then
                storyData = self:GetNextStory(v.Id)
                if storyData == nil then
                    --LogError("hurui: "..storyId .." story  is recorded")
                    LuaBattleBridge.CurStoryOver(storyId)
                    return true
                end
            end
        end
    end

    return false
end

function UIStoryMgr:StoryCheckData(storyData)
    if storyData.Group ~= nil and storyData.DataCheck ~= nil then
        local list = ManagerContainer.CfgMgr:GetSameStoryGroupDatasById(storyData.Id)
        if list ~= nil then
            for k,v in pairs(list) do
                if ManagerContainer.DataMgr.StoryData:CheckDataConditions(v.DataCheck) then
                    storyData = v
                    break
                end
            end
        end
    end
end

function UIStoryMgr:StartStory()
    if storyPlayStatus then
        return
    end
    if #storyList == 0 then
        return
    end
    curStoryData = storyList[1]
    table.remove(storyList, 1)
    storyPlayStatus = true
    --LogError("open story  "..curStoryData.Id)
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIStory, curStoryData)
end

function UIStoryMgr:NeedNextStory()
    return #storyList > 0
end

function UIStoryMgr:ImmediateRecord(storyId, idx)
    local storyData = ManagerContainer.CfgMgr:GetStoryDataById(storyId)
    if storyData == nil then
        return
    end
    local default = storyData.SelectionTexts ~= nil and 1 or 0
    idx = idx or default
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ROLE_STORY_REQ, {story_id = {key = storyId, value = idx}})
end

function UIStoryMgr:StartNextStory(idx)
    if curStoryData == nil then return end

    if curStoryData.ProgramControl and not curStoryData.isMap then
        LuaBattleBridge.CurStoryOver(curStoryData.Id)
    end

    if curStoryData.NeedSave then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ROLE_STORY_REQ, {story_id = {key = curStoryData.Id, value = idx or 0}})
    end

    if curStoryData.SelectionNext ~= nil and idx ~= nil and idx > 0 then
        curStoryData = ManagerContainer.CfgMgr:GetStoryDataById(curStoryData.SelectionNext[idx])
        if curStoryData ~= nil then
            return curStoryData
        end
    end

    if #storyList == 0 then
        return
    end
    curStoryData = storyList[1]
    table.remove(storyList, 1)
    storyPlayStatus = true
    return curStoryData
end

function UIStoryMgr:StoryUIStartOrOver(status, idx)
    if curStoryData == nil then return end

    if curStoryData.HideUi then
        ManagerContainer.LuaUIMgr:StoryHideUIStatus(not status)
    end

    if not status then
        if curStoryData.ProgramControl and not curStoryData.isMap then
            LuaBattleBridge.CurStoryOver(curStoryData.Id)
        end

        if curStoryData.NeedSave then
            ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ROLE_STORY_REQ, {story_id = {key = curStoryData.Id, value = idx or 0}})
        end

        local storyId = curStoryData.Id
        storyPlayStatus = false
        curStoryData = nil
        --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.Story, storyId)

        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIStory)
    end
end

function UIStoryMgr:Dispose()
    storyPlayStatus = false
    curStoryData = nil

    storyList = {}

    ManagerContainer.LuaUIMgr:CloseInputMask()
end

function UIStoryMgr:Destroy()
    self:Dispose()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UISTORY_CONDITION_TRIGGER, self, self.StoryConditionTrigger)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UISTORY_UI_START_OR_OVER, self, self.StoryUIStartOrOver)

    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end

return UIStoryMgr