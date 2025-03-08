local DojoState = class("DojoState",require("StateBase"))

function DojoState:Enter(mode)
    ManagerContainer.LuaDojoMgr:Enter(mode)
end

function DojoState:Update()
end

function DojoState:Exit()
    ManagerContainer.LuaDojoMgr:Exit()
end

function DojoState:GetTask()
    return nil
end

return DojoState