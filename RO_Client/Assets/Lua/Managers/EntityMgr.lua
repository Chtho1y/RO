local EntityMgr = class("EntityMgr")
local MinePlayerEntity = require("MinePlayerEntity")
local OtherPlayerEntity = require("OtherPlayerEntity")

function EntityMgr:ctor()
    self.entityMap = {}
end

function EntityMgr:Dispose()
    self:RemoveAllEntity()
    self.entityMap = nil
end

function EntityMgr:CreateEntity(entityType, uid, pos)
    local entity = self:GetEntity(entityType, uid)
    if entity then
        entity:SynPosition(pos)
        return entity
    end
    if entityType == Enum.EntityType.MinePlayer then
        entity = MinePlayerEntity:new(uid, pos, Quaternion.identity)
    elseif entityType == Enum.EntityType.OtherPlayer then
        entity = OtherPlayerEntity:new(uid, pos, Quaternion.identity)
    else
        LogError("[Wboy] unkonw EntityType : " .. tostring(entityType) .. " uid : " .. tostring(uid))
    end
    if entity then
        if not self.entityMap then self.entityMap = {} end
        local entityDic = self.entityMap[entityType]
        if not entityDic then
            entityDic = {}
            self.entityMap[entityType] = entityDic
        end
        entityDic[uid] = entity
        entity:EnterMap()
    end
    return entity
end

function EntityMgr:HasEntity(entityType, uid)
    if not self.entityMap then return false end
    local entityDic = self.entityMap[entityType]
    if not entityDic then return false end
    local entity = entityDic[uid]
    if not entity then return false end
    return true
end

function EntityMgr:GetEntity(entityType, uid)
    if not self.entityMap then return nil end
    local entityDic = self.entityMap[entityType]
    if not entityDic then return nil end
    return entityDic[uid]
end

function EntityMgr:GetEntitys(entityType)
    if not self.entityMap then return nil end
    local entityDic = self.entityMap[entityType]
    return entityDic
end

function EntityMgr:RemoveEntity(entityType, uid)
    if not self.entityMap then return end
    local entityDic = self.entityMap[entityType]
    if not entityDic then return end
    local entity = entityDic[uid]
    if not entity then return end
    entity:Dispose()
    entityDic[uid] = nil
end

function EntityMgr:RemoveAllEntity()
    if self.entityMap then
        for entityType, entityDic in pairs(self.entityMap) do
            if entityDic then
                for uid, entity in pairs(entityDic) do
                    if entity then
                        entity:Dispose()
                        entityDic[uid] = nil
                    end
                end
            end
        end
    end
    self.entityMap = {}
end

function EntityMgr:EnterMap(entityType, uid, pos)
    return self:CreateEntity(entityType, uid, pos)
end

function EntityMgr:ExitMap(entityType, uid)
    self:RemoveEntity(entityType, uid)
end

function EntityMgr:EnterWorld(entity)
    if not entity then return end
    entity:EnterWorld()
end

function EntityMgr:ExitWorld(entity)
    if not entity then return end
    entity:ExitWorld()
end

function EntityMgr:AllEntityEnterWorld()
    if self.entityMap then
        for entityType, entityDic in pairs(self.entityMap) do
            if entityDic then
                for uid, entity in pairs(entityDic) do
                    if entity then
                        entity:EnterWorld()
                    end
                end
            end
        end
    end
end

function EntityMgr:AllEntityExitWorld()
    if self.entityMap then
        for entityType, entityDic in pairs(self.entityMap) do
            if entityDic then
                for uid, entity in pairs(entityDic) do
                    if entity then
                        entity:ExitWorld()
                    end
                end
            end
        end
    end
end

function EntityMgr:Update(deltaTime)
    if self.entityMap then
        for entityType, entityDic in pairs(self.entityMap) do
            if entityDic then
                for uid, entity in pairs(entityDic) do
                    if entity then
                        entity:Update(deltaTime)
                    end
                end
            end
        end
    end
end

function EntityMgr:SynPosition(entityType, uid, pos)
    local entity = self:GetEntity(entityType, uid)
    if entity then
        entity:SynPosition(pos)
    end
end

function EntityMgr:GetPosition(entityType, uid)
    local entity = self:GetEntity(entityType, uid)
    if entity then
        return entity:GetPosition()
    end
    return nil
end

function EntityMgr:GetTransform(entityType, uid)
    local entity = self:GetEntity(entityType, uid)
    if entity and entity.view then
        return entity.view:GetTransform()
    end
    return nil
end

function EntityMgr:ForceRefreshGenerateView(entityType, uid)
    local entity = self:GetEntity(entityType, uid)
    if entity then
        entity:ForceRefreshGenerateView()
    end
end

return EntityMgr