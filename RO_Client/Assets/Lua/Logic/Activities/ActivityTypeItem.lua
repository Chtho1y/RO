local ActivityTypeItem = class("ActivityTypeItem")

function ActivityTypeItem:ctor(updateTime)
    self.actId = 0
    self.type = 0
    self.name = nil
    self.order = 0
    self.desc = ""
    self.endTime = 0
    self.opened = false                   --活动是否开启
    self.bg = nil                            --活动的背景图片
    self.pageId = 0                         --对应的界面id
    self.entrance = 0                       --活动入口位置
    self.data = nil
    self.redPointType = 0

    self.updateTime = updateTime
end

function ActivityTypeItem:Init(cfg)
    self.actId = cfg.Id
    self.type = cfg.Type
    self.name = cfg.Name
    self.order = cfg.Order
    self.openCondition = cfg.OpenCondition
    self.desc = ""
    self.pageId = cfg.PageId                --对应的界面id
    self.entrances = cfg.Entrance            --活动入口位置
    self.bg = cfg.BG                        --活动的背景图片
    self.pageBg = cfg.ActivityBG
    self.needShow = cfg.NeedShow
    self.noPay = cfg.NoPay
    self.infoLangKey = cfg.RuleKey
end

function ActivityTypeItem:SetRPType(rpType)
    self.redPointType = rpType
end

function ActivityTypeItem:HasEntrance(pageId,btnName)
    if self.entrances == nil  then
        return false
    end

    for i = 1, #self.entrances do
        local entrance = self.entrances[i]
        if type(entrance) == "table" then
            if entrance[1] == pageId and entrance[2] == btnName then
                return true
            end
        else
            if entrance == pageId then
                return  true
            end
        end
    end
    return false
end

function ActivityTypeItem:SetBg(bg)
    -- self.bg = bg
end

function ActivityTypeItem:GetBg()
    return self.bg
end

function ActivityTypeItem:SetEndTime(endTime)
    if endTime == nil then
        self.endTime = 0
    else
        self.endTime = tonumber(tostring(endTime / 1000))
    end
end

function ActivityTypeItem:SetOpenState(unlock)
    self.opened = unlock
end

function ActivityTypeItem:SyncSrvData(serverData)
end

function ActivityTypeItem:SyncCurDayEndTime(curDayEndTime)
    return false
end

--是否为新活动
function ActivityTypeItem:IsNew()
end

--是否为限时活动
function ActivityTypeItem:IsLimited()
    return self.endTime ~= nil and self.endTime > 0
end

--限时活动剩余时长
function ActivityTypeItem:LeftTime()
    return self.endTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
end

--限时活动是否过时
function ActivityTypeItem:IsOutofDate()
    return self.endTime ~= nil and self.endTime > 0 and self.endTime < ManagerContainer.LuaTimerMgr:GetTimeSecond()
end

--获取活动数据
function ActivityTypeItem:GetActivityData()
    return self.data
end

function ActivityTypeItem:IsOpened()
    return self.opened
end

function ActivityTypeItem:NeedShow()
    return self.needShow
end

function ActivityTypeItem:NoPay()
    return self.noPay
end

function ActivityTypeItem:HasRedPoint()
    return false
end

--功能入口是否解锁
function ActivityTypeItem:IsUnlocked()
    if self.openCondition == nil then
        return true
    end 

    for i = 1, #self.openCondition do
        if not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(self.openCondition[i]) then
            return false
        end
    end

    return true
end

function ActivityTypeItem:PerMinuteCheckEndTime()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_ENVELOPE_REMAIN_TIME_REFRESH)
end

return ActivityTypeItem