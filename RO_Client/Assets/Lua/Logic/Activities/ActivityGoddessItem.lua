local ActivityGoddessItem = class("ActivityGoddessItem",require("Activities/ActivityTypeItem"))

function ActivityGoddessItem:ctor()
    self.redPointType = Enum.RPNotifyType.ActivityGoddess
    self.lv = 0
    self.val = 0
end

function ActivityGoddessItem:SyncSrvData(serverData)
    if not serverData then return end
    local data = serverData.likability_data
    if not data then return end
    self.lv = data.level
    self.val = data.param
end

function ActivityGoddessItem:GetCurLoveLv()
    return self.lv
end

function ActivityGoddessItem:GetCurLoveVal()
    return self.val
end

function ActivityGoddessItem:HasRedPoint()
    if self:IsOutofDate() then
        return false
    end
    local cfgDatas = ManagerContainer.CfgMgr:GetActivityGoddessGiftCfgByActId(self.actId)
    if cfgDatas then
        for _, cfgData in pairs(cfgDatas) do
            local classcostaddlikes = cfgData.Classcostaddlike
            if classcostaddlikes then
                local ownerNum = CommonUtil.GetOwnResCountByItemId(cfgData.Classitemid)
                if ownerNum > 0 then
                    for i = 1, #classcostaddlikes do
                        local classcostaddlike = classcostaddlikes[i]
                        if classcostaddlike and classcostaddlike[1] then
                            if ownerNum >= classcostaddlike[1] then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

return ActivityGoddessItem