local ActivitySpringItem = class("ActivitySpringItem",require("Activities/ActivityTypeItem"))

function ActivitySpringItem:ctor()
    self.redPointType = Enum.RPNotifyType.ActivitySpring
end

function ActivitySpringItem:HasRedPoint()
    for k,v in pairs (ManagerContainer.CfgMgr.WorldBossChangePlayCfg) do
        local ConsumeId = v.Consume[1][1]
        local ownerNum = CommonUtil.GetOwnResCountByItemId(ConsumeId)
        if ownerNum > 0 then       
            return true  
        end
    end
    return false
end

return ActivitySpringItem