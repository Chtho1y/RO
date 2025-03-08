local OtherPlayerEntity = class("OtherPlayerEntity", require("PlayerEntity"))
local OtherPlayerEntityView = require("OtherPlayerEntityView")

function OtherPlayerEntity:ctor()
    self.targetPos = Vector3.New()
end

function OtherPlayerEntity:Dispose()
    self.targetPos = nil
    OtherPlayerEntity.super.Dispose(self)
end

function OtherPlayerEntity:EnterMap()
    self.view = OtherPlayerEntityView:new(self.uid, self.pos, self.rot)
    OtherPlayerEntity.super.EnterMap(self)
end

function OtherPlayerEntity:SynPosition(pos)
    if self.targetPos:Equals(pos) then
        return
    end
    self.targetPos:Set(pos.x, pos.y, pos.z)
    if self.pos:Equals(pos) then
        self:StopMove()
        return
    end
    local moveDir = self.targetPos - self.pos
    moveDir.y = 0
    local distance = moveDir.magnitude
    if distance <= 1e-5 then
        self.pos:Set(pos.x, pos.y, pos.z)
        self:StopMove()
        return
    end
    moveDir:SetNormalize()
    local moveSpeed = distance / self:GetSyncPosIntervalTime()
    local moveState = self:GetMoveStateBySpeed(moveSpeed)
    moveSpeed = self:GetMoveSpeed(moveState)
    self.moveState = moveState
    self.moveSpeed = moveSpeed
    self.moveDir = moveDir
    self.moveRot = Quaternion.LookRotation(moveDir)
end

function OtherPlayerEntity:Update(deltaTime)
    if self.moveState > 0 then
        if self.pos:Equals(self.targetPos) then
            self:StopMove()
        else
            self.pos = Vector3.MoveTowards( self.pos, self.targetPos, deltaTime * self.moveSpeed )
            self.rot = Quaternion.Slerp(self.rot, self.moveRot, self:GetTurnSpeed() * deltaTime)
        end
    end
    OtherPlayerEntity.super.Update(self, deltaTime)
end

return OtherPlayerEntity