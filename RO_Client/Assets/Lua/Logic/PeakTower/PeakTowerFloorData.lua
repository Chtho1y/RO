local PeakTowerFloorData = class("PeakTowerFloorData")
local CreateActorSystem = require("CreateActorSystem")

function PeakTowerFloorData:ctor(data)
    local fightInfo = data[1]
    local validEndTime = data[2]
    
    self:RefreshData(fightInfo, validEndTime)
end

function PeakTowerFloorData:RefreshData(fightInfo, validEndTime)
    self.floorIdx = fightInfo.idx
    self.fightInfo = fightInfo.fight_info

    if not self.actorSystem then
        self.actorSystem = CreateActorSystem:new()
    else
        self.actorSystem:Dispose()
    end
    self.actorSystem:ParseFightRoleInfo(fightInfo.fight_info)

    self.rewardState = fightInfo.reward_state

    if validEndTime then
        self.validEndTime = validEndTime
    end
end

function PeakTowerFloorData:GetRoleInfo()
    return self.actorSystem.userData
end

function PeakTowerFloorData:GetRoleHeroData()
    return self.actorSystem.heroData
end

function PeakTowerFloorData:GetRoleRewardState()
    return self.rewardState
end

function PeakTowerFloorData:GetFightInfo()
    return self.fightInfo
end

return PeakTowerFloorData