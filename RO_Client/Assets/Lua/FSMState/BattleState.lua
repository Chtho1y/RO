local BattleState = class("BattleState", require("StateBase"))
function BattleState:Enter()
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIStartLoading) == false then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMain)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle)
    end
    ManagerContainer.LuaBattleMgr:Enter()
end

function BattleState:Update()

end

function BattleState:Exit()
    ManagerContainer.LuaBattleMgr:Exit()
end

function BattleState:GetTask()
    return nil
end


return BattleState