local ClimbingTowerNpcData = class("ClimbingTowerNpcData")

function ClimbingTowerNpcData:ctor(cfg,level)
    self.npcId = cfg[1]
    self.npcPos = cfg[2]
    self.offset = nil
    self.npcLevel = level
    self.natureIcon = nil
    self.isBoss = false
    local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(self.npcId)
    if npcCfgData then
        self.npcImg = npcCfgData.Icon
        if npcCfgData.IconOffset~= nil and #npcCfgData.IconOffset then
            self.offset = Vector2(npcCfgData.IconOffset[1],npcCfgData.IconOffset[2])
        end
        self.isBoss = npcCfgData.NpcType == 2

        local natureCfg = ManagerContainer.CfgMgr:GetNatureDataById(npcCfgData.NatureId)
        if natureCfg ~= nil then
            self.natureIcon = natureCfg.Icon
        end
    else
        self.npcImg = nil
    end
    
end

function ClimbingTowerNpcData:GetNpcId()
    return self.npcId
end

function ClimbingTowerNpcData:GetNpcPos()
    return self.npcPos
end

function ClimbingTowerNpcData:GetNpcImg()
    return self.npcImg
end

function ClimbingTowerNpcData:GetNatureIcon()
    return self.natureIcon
end

return ClimbingTowerNpcData