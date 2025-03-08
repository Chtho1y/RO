local MinePlayerEntity = class("MinePlayerEntity", require("PlayerEntity"))
local MinePlayerEntityView = require("MinePlayerEntityView")

function MinePlayerEntity:ctor()
    self.intervalTime = nil
    self.stayIntervalTime = nil
end

function MinePlayerEntity:Dispose()
    self.intervalTime = nil
    self.stayIntervalTime = nil
    MinePlayerEntity.super.Dispose(self)
end

function MinePlayerEntity:EnterMap()
    self.view = MinePlayerEntityView:new(self.uid, self.pos, self.rot)
    self:SetForceCheckTrigger()
    MinePlayerEntity.super.EnterMap(self)
end

function MinePlayerEntity:OnJoystickDrag(dir, state)
    if state <= 0 then
        self:StopMove()
        return
    end
    self.moveDir:Set(dir.x, 0, dir.y)
    self.moveState = state
    self.moveSpeed = self:GetMoveSpeed(state)
    self.moveRot = Quaternion.LookRotation(self.moveDir)
end

function MinePlayerEntity:Update(deltaTime)
    if self.moveState > 0 then
        local newPos = LuaBattleBridge.GetCanMovePoint(self.pos, self.moveDir, self.moveSpeed * deltaTime)
        local needSend = (not self.pos:Equals(newPos))
        self.pos = newPos
        self.rot = Quaternion.Slerp(self.rot, self.moveRot, self:GetTurnSpeed() * deltaTime)

        if needSend then
            self.isForceCheckTrigger = true
        end

        if self.intervalTime == nil and needSend then
            self.intervalTime = self:GetSyncPosIntervalTime()
        end

        if self.intervalTime ~= nil then
            self.intervalTime = self.intervalTime - deltaTime
            if self.intervalTime <=0 then
                ManagerContainer.LuaGuildLobbyMgr:SendMoveCmdReq(self.pos)
                self.intervalTime = self:GetSyncPosIntervalTime() + self.intervalTime
                if not needSend then
                    self.intervalTime = nil
                    self.stayIntervalTime = nil
                end
            end
        end
    else
        if self.intervalTime ~= nil then
            self.intervalTime = self.intervalTime - deltaTime
            if self.intervalTime <= 0 then
                ManagerContainer.LuaGuildLobbyMgr:SendMoveCmdReq(self.pos)
                self.intervalTime = nil
                self.stayIntervalTime = nil
            end
        else
            if self.stayIntervalTime == nil then
                self.stayIntervalTime = self:GetSyncStayPosIntervalTime()
            end
            self.stayIntervalTime = self.stayIntervalTime - deltaTime
            if self.stayIntervalTime <= 0 then
                ManagerContainer.LuaGuildLobbyMgr:SendMoveCmdReq(self.pos)
                self.stayIntervalTime = self:GetSyncStayPosIntervalTime() + self.stayIntervalTime
            end
        end
    end

    if self.isForceCheckTrigger then
        self:CheckTrigger()
    end
    MinePlayerEntity.super.Update(self, deltaTime)
end

-- 检测是否到了npc的事件触发区域内
function MinePlayerEntity:CheckTrigger()
end

function MinePlayerEntity:SetForceCheckTrigger()
    self.isForceCheckTrigger = true
end

return MinePlayerEntity