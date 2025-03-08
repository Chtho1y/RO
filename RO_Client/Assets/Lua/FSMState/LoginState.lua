local LoginState = class("LoginState", require("StateBase"))

function LoginState:Enter(relogin)
    ManagerContainer.LoginMgr:Enter(relogin)
end

function LoginState:Update()
    ManagerContainer.LoginMgr:Update()
end

function LoginState:Exit()
    ManagerContainer.LoginMgr:Exit()
end

function LoginState:GetTask()
    return nil
end

return LoginState