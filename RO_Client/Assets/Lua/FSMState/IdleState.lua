local IdleState = class("IdleState", require("StateBase"))

function IdleState:Enter()
end

function IdleState:Update()
end

function IdleState:Exit()
end

function IdleState:GetTask()
    return nil
end


return IdleState