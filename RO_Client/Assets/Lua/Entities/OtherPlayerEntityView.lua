local OtherPlayerEntityView = class("OtherPlayerEntityView", require("PlayerEntityView"))

function OtherPlayerEntityView:CollectPreloadAssets()
    local guildLobbyData = ManagerContainer.DataMgr.GuildLobbyData
    local playerData = guildLobbyData:GetPlayerData(self.uid)
    if playerData then
        self.roleViewSystem:RefreshData(Enum.RoleInEnvType.GuildLobby, playerData.roleCfgId, playerData.viewData)
    end
    OtherPlayerEntityView.super.CollectPreloadAssets(self)
end

function OtherPlayerEntityView:EnterWorld()
    local guildLobbyData = ManagerContainer.DataMgr.GuildLobbyData
    local playerData = guildLobbyData:GetPlayerData(self.uid)
    if playerData then
        self:CollectPreloadAssets()
        OtherPlayerEntityView.super.EnterWorld(self)
    else
        self.isInWorld = true
        self.isCreated = false
        self:CreateContainer()
    end
end

function OtherPlayerEntityView:RefreshGenerateView()
    OtherPlayerEntityView.super.RefreshGenerateView(self)
    local guildLobbyData = ManagerContainer.DataMgr.GuildLobbyData
    local playerData = guildLobbyData:GetPlayerData(self.uid)
    if not playerData then return end
    self.roleViewSystem:RefreshView(Enum.RoleInEnvType.GuildLobby, playerData.roleCfgId, playerData.viewData)
end

return OtherPlayerEntityView