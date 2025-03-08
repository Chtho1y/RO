local PlayerEntity = class("PlayerEntity", require("Entity"))

local SyncPosIntervalTime = 0.3
local SyncStayPosIntervalTime = 2

function PlayerEntity:ctor(uid, pos, rot)
    self.moveState = 0
    self.moveSpeed = 0
    self.moveDir = Vector3.New()
    self.moveRot = Quaternion.identity
end

function PlayerEntity:Dispose()
    self.moveState = nil
    self.moveSpeed = nil
    self.moveDir = nil
    self.moveRot = nil
    PlayerEntity.super.Dispose(self)
end

function PlayerEntity:Update(deltaTime)
    self.view:SetPosition(self.pos)
    self.view:SetRotation(self.rot)
    self.view:SetMoveState(self.moveState)
end

function PlayerEntity:StopMove()
    self.moveState = 0
    self.moveSpeed = 0
    self.moveDir:Set(0, 0, 0)
    self.moveRot:SetIdentity()
end

function PlayerEntity:GetMoveSpeed(moveState)
    if moveState == 1 then
        return Constant.GuildLobby_WalkSpeed
    elseif moveState == 2 then
        return Constant.GuildLobby_RunSpeed
    else
        return 0
    end
end

function PlayerEntity:GetMoveStateBySpeed(moveSpeed)
    if moveSpeed <= 0 then
        return 0
    elseif moveSpeed <= Constant.GuildLobby_WalkSpeed then
        return 1
    else
        return 2
    end
end

function PlayerEntity:GetTurnSpeed()
    return Constant.GuildLobby_TurnSpeed
end

function PlayerEntity:GetSyncPosIntervalTime()
    return SyncPosIntervalTime
end

function PlayerEntity:GetSyncStayPosIntervalTime()
    return SyncStayPosIntervalTime
end

function PlayerEntity:ForceRefreshGenerateView()
    self.view:ForceRefreshGenerateView()
end

return PlayerEntity