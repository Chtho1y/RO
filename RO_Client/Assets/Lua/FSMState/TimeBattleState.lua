local TimeBattleState = class("TimeBattleState",require("StateBase"))

function TimeBattleState:Enter(timeBattleMode)
    ManagerContainer.LuaTimeBattleMgr:Enter(timeBattleMode)
end

function TimeBattleState:Update()
end

function TimeBattleState:Exit()
    ManagerContainer.LuaTimeBattleMgr:Exit()
end

function TimeBattleState:GetTask()
    return nil
end

return TimeBattleState