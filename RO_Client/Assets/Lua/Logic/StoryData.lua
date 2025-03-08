local StoryData = class("StoryData", require("DataBase"))

function StoryData:ctor()
    self.data = {}
    self.data.storyDatas = {}
end

function StoryData:InitStoryData(storyDatas)
    if #storyDatas == 0 then return end

    for _,v in pairs(storyDatas) do
        local id = Mathf.Round(v * 0.01)
        local val = v % 100
        self.data.storyDatas[id] = val
    end
end

function StoryData:RefreshStoryData(storyKV)
    if storyKV == nil then return end

    self.data.storyDatas[storyKV.key] = storyKV.value
end

function StoryData:GetStoryDatas()
    return self.data.storyDatas
end

function StoryData:CheckDataConditions(data)
    local conditionResult = true
    for k,v in pairs(data) do
        local id = v[1]
        local num = v[2]
        if self.data.storyDatas[id] == nil then
            local storyCfgData = ManagerContainer.CfgMgr:GetStoryDataById(id)
            if #storyCfgData.SelectionTexts > 0 then
                self.data.storyDatas[id] = 1
            else
                self.data.storyDatas[id] = 0
            end
        end
        if self.data.storyDatas[id] ~= num then
            conditionResult = false
        end
    end
    return conditionResult
end

function StoryData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_STORY_NTF, function(data)
        self:InitStoryChapterData(data)
        self:InitStoryData(data.Story)
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_STORY_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshStoryData(data.story_id)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_NEW_MAP_CARTOON_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshStoryChapterData(data)
        end
        -- 避免流程卡住，则需要不管是否存储成功，都算完成
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STORY_DATA_CHANGED)
    end)
end

function StoryData:Clear()
    self.data = {}
    self.data.storyDatas = {}
end

function StoryData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function StoryData:UnRegisterNetEvents()

end


function StoryData:InitStoryChapterData(data)
    local changed = false
    local storyChapterData = self.data.storyChapterData
    if not storyChapterData then
        storyChapterData = {}
        self.data.storyChapterData = storyChapterData
    end
    if data then
        local mapCart = data.map_cart
        if mapCart then
            local id = mapCart.key
            local state = mapCart.value
            if id ~= nil and state ~= nil then
                storyChapterData.id = id
                storyChapterData.state = state
                changed = true
            end
        end
    end
    return changed
end

function StoryData:RefreshStoryChapterData(data)
    if not data then return false end
    return self:InitStoryChapterData(data)
end

function StoryData:GetStateStoryChapterId(id)
    if not id then return Enum.StoryChapterState.NotStart end
    local storyChapterData = self.data.storyChapterData
    if not storyChapterData then return Enum.StoryChapterState.NotStart end
    if storyChapterData.id == nil then return Enum.StoryChapterState.NotStart end
    if id > storyChapterData.id then return Enum.StoryChapterState.NotStart end
    if id == storyChapterData.id then
        if storyChapterData.state < 1 then
            return Enum.StoryChapterState.NotStart
        elseif storyChapterData.state == 1 then
            return Enum.StoryChapterState.Start
        end
    end
    return Enum.StoryChapterState.End
end







return StoryData