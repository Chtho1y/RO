local LuaGuildLobbyMgr = class("LuaGuildLobbyMgr")
local EntityMgr = require("EntityMgr")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local State = {
    None = 1,
    EnterStart = 2,
    EnterLoading = 3,
    EnterEnd = 4,
    Exit = 5,
}

function LuaGuildLobbyMgr:ctor()
    self.curState = State.None
    self.entityMgr = EntityMgr:new()
    self:RegisterNetEvents()
end

function LuaGuildLobbyMgr:Destroy()
    self:UnRegisterNetEvents()
    self.curState = nil
    self.entityMgr:Dispose()
    self.entityMgr = nil
end

function LuaGuildLobbyMgr:RegisterNetEvents()
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_ENTER_MAP_ACK, self.OnEnterMapAck, self)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_ENTER_NTF, self.OnPlayerEnterMapNtf, self)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SYNC_PLAYERS_NTF, self.OnSyncPlayersPosNtf, self)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_LEAVE_NTF, self.OnPlayerLeaveMapNft, self)
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GM_SYNC_ALL_PLAYER_NTF, self.OnSyncAllPlayersNtf, self)
end

function LuaGuildLobbyMgr:UnRegisterNetEvents()
    -- ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_ENTER_MAP_ACK)
    -- ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_ENTER_NTF)
    -- ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SYNC_PLAYERS_NTF)
    -- ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_LEAVE_NTF)
    -- ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GM_SYNC_ALL_PLAYER_NTF)
end

function LuaGuildLobbyMgr:SendEnterReq()
    -- ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_ENTER_MAP_REQ,{})
end

function LuaGuildLobbyMgr:SendLeaveReq()
    local entityType = Enum.EntityType.MinePlayer
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local pos = self.entityMgr:GetPosition(entityType, uid)
    if pos then
        local endPos = {x = pos.x, y = pos.z, z = pos.y}
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_LEAVE_MAP_REQ, { pos = endPos })
    else
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_LEAVE_MAP_REQ,{})
    end
end

function LuaGuildLobbyMgr:SendMoveCmdReq(movePos)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_MOVE_REQ, {pos = {x = movePos.x,y = movePos.z,z = movePos.y}})
end


function LuaGuildLobbyMgr:OnEnterMapAck(data)
    LogError("[Wboy] SC_PLAYER_ENTER_MAP_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then return end
    local entityType = Enum.EntityType.MinePlayer
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local pos = data.pos and Vector3.New(data.pos.x, data.pos.z, data.pos.y) or Vector3.zero
    if not self.curState or self.curState == State.None then
        self.curState = State.EnterStart
        self.entityMgr:EnterMap(entityType, uid, pos)
        ManagerContainer.LuaGameMgr:EnterGuildLobby()
    elseif self.curState == State.Exit then
        LogError("[Wboy] not enter, because exiting")
    else
        self.entityMgr:EnterMap(entityType, uid, pos)
    end
end

function LuaGuildLobbyMgr:OnPlayerEnterMapNtf(data)
    LogError("[Wboy] SC_PLAYER_ENTER_NTF " .. Inspect(data))
    if not self:IsInGuildLobby() then
        return
    end
    local players = data.players
    for i = 1, #players do
        local player = players[i]
        local uid = player.uid
        local pos = player.pos
        local entityType = player.u_type
        pos = pos and Vector3.New(pos.x, pos.z, pos.y) or Vector3.zero
        local entity = self.entityMgr:EnterMap(entityType, uid, pos)
        if self.curState == State.EnterEnd then
            self.entityMgr:EnterWorld(entity)
        end
    end
end

function LuaGuildLobbyMgr:OnSyncPlayersPosNtf(data)
    LogError("[Wboy] SC_SYNC_PLAYERS_NTF " .. Inspect(data))
    if not self:IsInGuildLobby() then
        return
    end
    local players = data.players
    for i = 1, #players do
        local player = players[i]
        local uid = player.uid
        local pos = player.pos
        local entityType = player.u_type
        if pos then
            self.entityMgr:SynPosition(entityType, uid, Vector3.New(pos.x, pos.z, pos.y))
        end
    end
end

function LuaGuildLobbyMgr:OnPlayerLeaveMapNft(data)
    LogError("[Wboy] SC_PLAYER_LEAVE_NTF " .. Inspect(data))
    if not self:IsInGuildLobby() then
        return
    end
    local players = data.players
    for i = 1, #players do
        local player = players[i]
        local uid = player.uid
        local entityType = player.u_type
        self.entityMgr:ExitMap(entityType, uid)
    end
end

function LuaGuildLobbyMgr:OnSyncAllPlayersNtf()
    if not self:IsInGuildLobby() then
        return
    end
end

function LuaGuildLobbyMgr:IsInGuildLobby()
    return self.curState and self.curState ~= State.None and self.curState ~= State.Exit
end


function LuaGuildLobbyMgr:Enter()
    self:RegisterEvents()
    self.curState = State.EnterLoading
    self:_OnLoadProgress(0.2)
    -- 创建玩家GameObject容器
    self.playerContainer = UnityEngine.GameObject("PlayerContainer").transform
    -- 进入前需要预加载的资源
    self:_PreloadAssets()
end

function LuaGuildLobbyMgr:Update()
    local deltaTime = Time.deltaTime
    self.entityMgr:Update(deltaTime)
end

function LuaGuildLobbyMgr:Exit()
    self.curState = State.Exit
    self:SendLeaveReq()
    if self.loadSystem then
        self.loadSystem:Dispose()
        self.loadSystem = nil
    end
    self.entityMgr:RemoveAllEntity()
    self.playerContainer = nil
    self.mainCamera = nil
    self.cullingMask = nil
    self.curState = State.None
    self:UnRegisterEvents()
    ManagerContainer.DataMgr.GuildLobbyData:ClearPlayerData()
end

function LuaGuildLobbyMgr:_PreloadAssets()
    local loadSystem = self.loadSystem
    if loadSystem then
        loadSystem:Cancel()
        loadSystem:RemoveLoadAllAsset()
    else
        loadSystem = MultiTypeAssetLoadSystem:new()
        loadSystem:SetCompleteCB(self, self._PreloadAssetsComplete, self._LoadProgressChanged)
        self.loadSystem = loadSystem
    end
    loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, 'Assets/Content/Prefabs/Camera', 'DefaultCVC')
    -- 预加载主角
    local entityDic = self.entityMgr:GetEntitys(Enum.EntityType.MinePlayer)
    for uid, entity in pairs(entityDic) do
        entity:StatisticsPreloadAssets(loadSystem)
    end
    loadSystem:Begin()
end

function LuaGuildLobbyMgr:_LoadProgressChanged(progress)
    self:_OnLoadProgress(0.2 + 0.8 * progress)
end

function LuaGuildLobbyMgr:_PreloadAssetsComplete()
    local modelGo = ManagerContainer.ResMgr:GetGoFromPool("Assets/Content/Prefabs/Camera", "DefaultCVC")
    local defaultCVC = modelGo:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
    self.mainCamera = LuaBattleBridge.InitMainCamera()
    self.cullingMask = self.mainCamera.cullingMask
    -- 所有的实体对象进入游戏世界
    self.entityMgr:AllEntityEnterWorld()
    self.curState = State.EnterEnd
    self:_OnLoadComplete()
    -- 设置摄像机跟随
    local entityType = Enum.EntityType.MinePlayer
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    defaultCVC.Follow = self.entityMgr:GetTransform(entityType, uid)
    -- 打开UI界面
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildLobby)
end

function LuaGuildLobbyMgr:_OnLoadProgress(progress)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Progress, progress);
end

function LuaGuildLobbyMgr:_OnLoadComplete()
    LogWarning("LuaGuildLobbyMgr:_OnLoadComplete ")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Complete);
end


function LuaGuildLobbyMgr:GetPlayerContainer()
    return self.playerContainer
end

function LuaGuildLobbyMgr:GetMainCamera()
    return self.mainCamera
end

function LuaGuildLobbyMgr:GetEntityMgr()
    return self.entityMgr
end

function LuaGuildLobbyMgr:OnJoystickDrag(dir, state)
    local entityType = Enum.EntityType.MinePlayer
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local entity = self.entityMgr:GetEntity(entityType, uid)
    if entity then
        if entity.OnJoystickDrag then
            entity:OnJoystickDrag(dir, state)
        end
    end
end

function LuaGuildLobbyMgr:RegisterEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.ForceUpdateMineEntityView)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.GUILD_LOBBY_PLAYER_INFO_CHANGED, self, self.ForceUpdateOtherEntityView)
end

function LuaGuildLobbyMgr:UnRegisterEvents()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.ForceUpdateMineEntityView)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.GUILD_LOBBY_PLAYER_INFO_CHANGED, self, self.ForceUpdateOtherEntityView)
end


function LuaGuildLobbyMgr:ForceUpdateMineEntityView()
    local entityType = Enum.EntityType.MinePlayer
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    self.entityMgr:ForceRefreshGenerateView(entityType, uid)
end

function LuaGuildLobbyMgr:ForceUpdateOtherEntityView(uid)
    local entityType = Enum.EntityType.OtherPlayer
    self.entityMgr:ForceRefreshGenerateView(entityType, uid)
end

return LuaGuildLobbyMgr