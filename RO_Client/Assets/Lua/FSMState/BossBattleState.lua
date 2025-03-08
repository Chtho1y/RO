local BossBattleState = class("BossBattleState",require("StateBase"))

function BossBattleState:Enter(bossMode)
    ManagerContainer.LuaBossBattleMgr:Enter(bossMode)
end

function BossBattleState:Update()
end

function BossBattleState:Exit()
    ManagerContainer.LuaBossBattleMgr:Exit()
end

function BossBattleState:GetTask()
    return nil
end

return BossBattleState