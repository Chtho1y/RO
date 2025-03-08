local GuildLobbyState = class("GuildLobbyState",require("StateBase"))
function GuildLobbyState:Enter()
    LuaBattleBridge.SetLuaGuildLobbyMgr(ManagerContainer.LuaGuildLobbyMgr)
    ManagerContainer.LuaGuildLobbyMgr:Enter()
end

function GuildLobbyState:Update()
    ManagerContainer.LuaGuildLobbyMgr:Update()
end

function GuildLobbyState:Exit()
    ManagerContainer.LuaGuildLobbyMgr:Exit()
end

function GuildLobbyState:GetTask()
    return nil
end

return GuildLobbyState