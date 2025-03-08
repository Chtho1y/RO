local StoryMgr = class("StoryMgr")
local ExecuteSequenceData = require('ExecuteSequenceData')

local isStorying
local curStoryChapterId
local executeSequenceData = nil

function StoryMgr:ctor()
    isStorying = false
end

function StoryMgr:Destroy()
    isStorying = nil
    curStoryChapterId = nil
    executeSequenceData = nil
end

function StoryMgr:IsStorying()
    return isStorying
end

function StoryMgr:HasPreStoryChapter()
    local storyChapterId = ManagerContainer.LuaGameMgr:GetCurStoryId()
    if not storyChapterId then
        return false
    end
    local storyChapterCfgData = ManagerContainer.CfgMgr:GetStoryChapterById(storyChapterId)
    if not storyChapterCfgData then return false end
    local state = ManagerContainer.DataMgr.StoryData:GetStateStoryChapterId(storyChapterId)
    if state == Enum.StoryChapterState.End then
        return false
    end
    return true
end

function StoryMgr:StartStoryChapterById(storyChapterId)
    if isStorying then return false end
    if not storyChapterId then return end
    local state = ManagerContainer.DataMgr.StoryData:GetStateStoryChapterId(storyChapterId)
    if state == Enum.StoryChapterState.End then
        return false
    end
    local storyChapterCfgData = ManagerContainer.CfgMgr:GetStoryChapterById(storyChapterId)
    if not storyChapterCfgData then return false end
    isStorying = true
    curStoryChapterId = storyChapterId
    -- 根据配置生成执行队列
    local luaUIMgr = ManagerContainer.LuaUIMgr
    local uiStoryMgr = ManagerContainer.UIStoryMgr
    executeSequenceData = ExecuteSequenceData:new()

    executeSequenceData:AppendFrameInterval(1)
    executeSequenceData:AppendFunc(true, self, self._StartStoryChapter)
    if state == Enum.StoryChapterState.NotStart then
        -- 发送服务器故事章节开始, 并开始剧情引导
        executeSequenceData:AppendFrameInterval(1)
        executeSequenceData:AppendFunc(true, self, self._SendStoryChapterState, curStoryChapterId, Enum.StoryChapterState.Start)
    end
    executeSequenceData:AppendFrameInterval(1)
    executeSequenceData:AppendFunc(false, uiStoryMgr, uiStoryMgr.MapStartStoryByStoryId, storyChapterCfgData.DlgId)
    executeSequenceData:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
    executeSequenceData:AppendFrameInterval(1)
    executeSequenceData:AppendFunc(false, self, self._CheckUIBattle)
    executeSequenceData:AppendFunc(false, luaUIMgr, luaUIMgr.Open, Enum.UIPageName.UIBigMap, {enterType = Enum.BigMapEnterType.DropPoint})
    if storyChapterCfgData.CanSkip then
        executeSequenceData:AppendUIListener(Enum.UIPageName.UIBigMap, UIEventNames.UI_PAGE_IN_END_NTF)
        executeSequenceData:AppendFrameInterval(1)
        executeSequenceData:AppendFunc(false, luaUIMgr, luaUIMgr.Open, Enum.UIPageName.UIStorySkip)
    end
    executeSequenceData:AppendUIListener(Enum.UIPageName.UIBigMap, UIEventNames.UI_CLOSE_COMPELETED)
    executeSequenceData:AppendFrameInterval(1)
    executeSequenceData:AppendFunc(false, self, self._EndBigMapStoryChapter)
    executeSequenceData:AppendUIListener(Enum.UIPageName.UIBigMap, UIEventNames.UI_PAGE_OUT_END_NTF)
    executeSequenceData:AppendFrameInterval(1)
    executeSequenceData:AppendFunc(false, luaUIMgr, luaUIMgr.Open, Enum.UIPageName.UIChapter, curStoryChapterId)
    executeSequenceData:AppendUIListener(Enum.UIPageName.UIChapter, UIEventNames.UI_PAGE_OUT_END_NTF)
    executeSequenceData:AppendFrameInterval(1)
    if state ~= Enum.StoryChapterState.End then
        executeSequenceData:AppendFunc(false, self, self._SendStoryChapterState, curStoryChapterId, Enum.StoryChapterState.End)
    end
    executeSequenceData:AppendFunc(true, self, self._EndStoryChapter)
    executeSequenceData:AppendFunc(true, self, self._StartForceGuide, storyChapterCfgData.ForceGuide)
    ManagerContainer.ExecuteSequenceMgr:Execute(executeSequenceData)
    return true
end

function StoryMgr:SkipCurStoryChapter()
    if not isStorying then return end
    if not curStoryChapterId then return end
    local state = ManagerContainer.DataMgr.StoryData:GetStateStoryChapterId(curStoryChapterId)
    if state == Enum.StoryChapterState.End then
        return
    end
    if not executeSequenceData then return end
    local step = executeSequenceData:FindUIListener(Enum.UIPageName.UIBigMap, UIEventNames.UI_CLOSE_COMPELETED)
    ManagerContainer.ExecuteSequenceMgr:SkipToStep(executeSequenceData, step)
    local uibase = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIBigMap)
    if uibase then
        local luaTable = uibase.MLuaTable
        if luaTable then
            luaTable:UIClose()
        end
    end
end

function StoryMgr:ExpectedStopCurStoryChapter()
    if executeSequenceData then
        executeSequenceData:ClearDatas()
        ManagerContainer.ExecuteSequenceMgr:Exit(executeSequenceData)
    end
    if not isStorying then return end
    isStorying = false
    curStoryChapterId = nil
    executeSequenceData = nil
    ManagerContainer.LuaUIMgr:CloseInputMask()
end

function StoryMgr:_EndBigMapStoryChapter()
    local luaUIMgr = ManagerContainer.LuaUIMgr
    luaUIMgr:ClosePage(Enum.UIPageName.UIStorySkip)
    ManagerContainer.UIStoryMgr:Dispose()
    ManagerContainer.LuaGameMgr:StopStory(Enum.StoryType.EnterNewMap)
    luaUIMgr:ClosePage(Enum.UIPageName.UIStory)
end

function StoryMgr:_StartStoryChapter()
    local luaUIMgr = ManagerContainer.LuaUIMgr
    luaUIMgr:OpenInputMask(Enum.UISibling[Enum.UIType.Story] - 1)
    luaUIMgr:ClosePageByMUIType(Enum.UIType.TotalWin)
    luaUIMgr:ClosePageByMUIType(Enum.UIType.Tips)
    luaUIMgr:ClosePageByMUIType(Enum.UIType.Normal)
end

function StoryMgr:_EndStoryChapter()
    isStorying = false
    curStoryChapterId = nil
    executeSequenceData = nil
    local luaUIMgr = ManagerContainer.LuaUIMgr
    luaUIMgr:ClosePage(Enum.UIPageName.UIBigMap)
    luaUIMgr:ClosePage(Enum.UIPageName.UIStorySkip)
    luaUIMgr:ClosePage(Enum.UIPageName.UIStory)
    luaUIMgr:CloseInputMask()
    ManagerContainer.UIStoryMgr:Dispose()
    ManagerContainer.LuaGameMgr:StopStory(Enum.StoryType.EnterNewMap)
    if not luaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
        luaUIMgr:Open(Enum.UIPageName.UIBattle)
    end
end

function StoryMgr:_SendStoryChapterState(storyChapterId, state)
    local data = {}
    data.map_cart = {key = storyChapterId, value = state}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_NEW_MAP_CARTOON_REQ, data)
end

function StoryMgr:_CheckUIBattle()
    local luaUIMgr = ManagerContainer.LuaUIMgr
    if not luaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
        luaUIMgr:Open(Enum.UIPageName.UIBattle)
        if executeSequenceData then
            executeSequenceData:InsertNextUIListener(Enum.UIPageName.UIBattle, UIEventNames.UI_PAGE_IN_END_NTF)
        end
    end
end

function StoryMgr:_StartForceGuide(forceGuideId)
    if not forceGuideId or forceGuideId <= 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER)
        return
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.FGGroupId, forceGuideId, false)
end


function StoryMgr:StartStorySection(storySection, pos)
    local storySectionData = ManagerContainer.CfgMgr:GetStorySectionById(storySection)
    local hasNext = false
    if storySectionData then
        local storySectionType = storySectionData.Type
        if storySectionType == Enum.StorySectionEventType.UnlockFunc then
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                local data = ExecuteSequenceData:new()
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
                data:AppendFunc(true, self, self._ExecuteFuncLock)
                data:AppendFunc(true, self, self._ExecuteFuncLockView)
                ManagerContainer.ExecuteSequenceMgr:Execute(data)
                hasNext = true
            end
        elseif storySectionType == Enum.StorySectionEventType.UnlockHangBox then
            local data = ExecuteSequenceData:new()
            data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIPopGotSingle, {id=storySection, startPos=pos})
            data:AppendUIListener(Enum.UIPageName.UIPopGotSingle, UIEventNames.UI_PAGE_OUT_END_NTF)
            data:AppendFunc(true, self, self._ExecuteFuncLock)
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
            end
            data:AppendFunc(true, self, self._ExecuteFuncLockView)
            ManagerContainer.ExecuteSequenceMgr:Execute(data)
            hasNext = true
        elseif storySectionType == Enum.StorySectionEventType.GotItem then
            local data = ExecuteSequenceData:new()
            data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIPopGotSingle, {id=storySection, startPos=pos})
            data:AppendUIListener(Enum.UIPageName.UIPopGotSingle, UIEventNames.UI_PAGE_OUT_END_NTF)
            data:AppendFunc(true, self, self._ExecuteFuncLock)
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
            end
            data:AppendFunc(true, self, self._ExecuteFuncLockView)
            ManagerContainer.ExecuteSequenceMgr:Execute(data)
            hasNext = true
        elseif storySectionType == Enum.StorySectionEventType.PlayAnim then
            local data = ExecuteSequenceData:new()
            if storySectionData.Content then
                local videoPath = storySectionData.Content[1]
                data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIStoryPlayVideo, videoPath)
                data:AppendUIListener(Enum.UIPageName.UIStoryPlayVideo, UIEventNames.UI_PAGE_OUT_END_NTF)
            end
            data:AppendFunc(true, self, self._ExecuteFuncLock)
            data:AppendFunc(true, self, self._ExecuteFuncLockView)
            ManagerContainer.ExecuteSequenceMgr:Execute(data)
        elseif storySectionType == Enum.StorySectionEventType.GuardBoss then
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                local data = ExecuteSequenceData:new()
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
                data:AppendFunc(true, self, self._ExecuteFuncLock)
                data:AppendFunc(true, self, self._ExecuteFuncLockView)
                ManagerContainer.ExecuteSequenceMgr:Execute(data)
                hasNext = true
            end
        elseif storySectionType == Enum.StorySectionEventType.UnlockTask then
            local data = ExecuteSequenceData:new()
            data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIPopGotSingle, {id=storySection, startPos=pos})
            data:AppendUIListener(Enum.UIPageName.UIPopGotSingle, UIEventNames.UI_PAGE_OUT_END_NTF)
            data:AppendFunc(true, self, self._ExecuteFuncLock)
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
            end
            data:AppendFunc(true, self, self._ExecuteFuncLockView)
            ManagerContainer.ExecuteSequenceMgr:Execute(data)
            hasNext = true
        else
            -- 变态需求，避免程序疯狂修改，让策划自己玩去
            if storySectionData.TriggerDlgId and storySectionData.TriggerDlgId > 0 then
                local data = ExecuteSequenceData:new()
                data:AppendFunc(false, ManagerContainer.UIStoryMgr, ManagerContainer.UIStoryMgr.MapStartStoryByStoryId, storySectionData.TriggerDlgId)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
                data:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
                data:AppendFunc(true, self, self._ExecuteFuncLock)
                data:AppendFunc(true, self, self._ExecuteFuncLockView)
                ManagerContainer.ExecuteSequenceMgr:Execute(data)
                hasNext = true
            end
        end
    end
    if not hasNext then
        self:_ExecuteFuncLock()
        self:_ExecuteFuncLockView()
    end
    return hasNext
end

function StoryMgr:_ExecuteFuncLock()
    if ManagerContainer.UIFuncUnlockMgr:NeedOpenFuncCurLevelStart(ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FUNCLOCK_OPEN_NTF)
    end
end

function StoryMgr:_ExecuteFuncLockView()
    local levelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
    local newFuncs, _ = ManagerContainer.UIFuncUnlockMgr:GetNewFuncAndNearFuncByLevelId(levelId)
    if newFuncs[1] ~= nil then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_FUNC_OPEN_NTF)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.BattleWin)
    end
end

return StoryMgr