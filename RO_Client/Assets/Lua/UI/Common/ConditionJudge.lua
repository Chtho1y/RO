local ConditionJudge = {}

local JudgeFun = {}

function ConditionJudge:ConditionPassResult(conditionId)
    local conditionData = ManagerContainer.CfgMgr:GetCondDataById(conditionId)
    local condition = conditionData.Condition

    return self:ConditionPassResult1(condition)
end

function ConditionJudge:ConditionPassResult1(condition)
    if not condition then
        return false, 0, ''
    end
    local typeId = condition[1]
    if not typeId then
        return false, 0, ''
    end
    local fun = JudgeFun[typeId]
    if not fun then
        return false, 0, ''
    end
    return fun(condition)
end

JudgeFun[1] = function(condition)
    local val = condition[2]
    local content = I18N.SetLanguageValue("FunUnLock1", val)
    local baseLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
    return baseLv >= val, val, content
end

JudgeFun[11] = function(condition)
    local val = condition[2]
    local levelData = ManagerContainer.CfgMgr:GetLevelDataById(val)
    if not levelData then
        return false, val, ''
    end
    local content = I18N.SetLanguageValue("FunUnLock11", I18N.T(levelData.Name))
    local uniId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
    return uniId >= val, val, content
end

JudgeFun[37] = function(condition)
    local val = condition[2]
    val = val + 1
    local climbingData = ManagerContainer.CfgMgr:GetClimbingTowerCfgById(val)
    local content = I18N.SetLanguageValue("FunUnLock37", I18N.T(climbingData.Desc))
    local climbingTowerLv = ManagerContainer.DataMgr.TowerDataMgr:GetCurChallengeLevel()
    return climbingTowerLv >= val, val, content
end

JudgeFun[1000] = function(condition)
    local val = condition[2]
    local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
    local vipCfgData = ManagerContainer.CfgMgr:GetVipCfgById(val)
    if vipCfgData then
        local content = I18N.SetLanguageValue("FunUnLock1000", I18N.T(vipCfgData.Name))
        return vipLv >= val, val, content
    else
        return false, 0, ''
    end
end

JudgeFun[1001] = function(condition)
    local val = condition[2]
    if not Constant.OpenPay then
        if val == 0 then
            return false, val, ''
        else
            return true, val, ''
        end
    end
    return true, val, ''
end

JudgeFun[1002] = function(condition)
    local val = condition[2]
    if Constant.OpenPay then
        local curVal = ManagerContainer.PayMgr:GetTotalRecharge()
        return curVal >= val, val, ''
    end
    return false, val, ''
end

return ConditionJudge