--[[
    在多人玩家战斗的情况下，把自身封装成和其它玩家一样的结构，和Api，
    方便统一逻辑处理，省去在取数据或调用Api时的判断
]]

local SelfActorSystem = class("SelfActorSystem", require("CreateActorSystem"))
-- local LuaToCSData = require('LuaToCSData')

function SelfActorSystem:ctor()
    local heroActorData = ManagerContainer.LuaActorDataMgr:GetActorData(true,0)
    if heroActorData then
        self.heroActorData = ActorData.CloneActorData(heroActorData)
        local heroData = ManagerContainer.DataMgr.UserData:GetHeroData(1)
        if heroData then
            local skillData = heroData.skillData
            if skillData then
                local skillPrams = skillData:GetUsedSkillParams()
                skillPrams = CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, skillPrams)
                self.heroActorData:RefreshSkills(skillPrams)
            end
        end
    end


    local list = ManagerContainer.DataMgr.PartnerData:GetAllPartnerTeamDatas()
    self.fellewActorDatas = {}
    if list ~= nil then
        for _,v in pairs(list) do
            local actorData = ManagerContainer.LuaActorDataMgr:GetActorData(false,v.id)
            if actorData then
                actorData = ActorData.CloneActorData(actorData)
                local heroData = ManagerContainer.DataMgr.UserData:GetHeroData(v.uid)
                if heroData then
                    local skillData = heroData.skillData
                    if skillData then
                        local skillPrams = skillData:GetUsedSkillParams()
                        skillPrams = CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, skillPrams)
                        actorData:RefreshSkills(skillData:GetUsedSkillParams())
                    end
                end
                table.insert(self.fellewActorDatas, actorData)
            end
        end
    end

    tbChangePetId = {}
    -- local userData = ManagerContainer.DataMgr.UserData
    -- local roleParam = {
    --     uid = userData:GetId(),
    --     id = userData:GetUserRoleId(),
    --     jobId = userData:GetJobCfgId(),
    --     lv = userData:GetRoleLv(),
    --     role = false,
    --     mainRole = true,
    --     skills = userData:GetSkillData(1),
    --     buffs = userData:GetCardBuffs(1),
    --     fashion = userData:GetViewData(),
    --     petId = 1000,
    --     petBaseId = userData:GetId()
    -- }
    -- local heroActorData = ActorData.CreatePlayerActor(roleParam)
    -- local fashionParam = LuaToCSData.CreateFashionParamData(userData:GetUserRoleId(), userData:GetJobCfgId(), userData:GetViewData())
    -- self.userData = userData
    -- self.heroData = clone(userData:GetHeroData(1), true)
    -- self.fashionMap = ManagerContainer.DataMgr.FashionData:GetFashionMap()
    -- self:CalcHeroAttrs()
end

function SelfActorSystem:GetUserId()
    return ManagerContainer.DataMgr.UserData:GetUserId()
end

function SelfActorSystem:GetUserHeadIcon()
    return ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
end

function SelfActorSystem:GetUserNickname()
    return ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function SelfActorSystem:GetPlayerActorParam()
    if nil ~= self.PetBossActor then --有变身ID 返回变身ID
        return self.PetBossActor
    end
    return self.heroActorData
end

function SelfActorSystem:GetFellowActorParam()
    return self.fellewActorDatas
end

function SelfActorSystem:GetHeadFrameId()
    return ManagerContainer.DataMgr.UserData:GetHeadFrameId()
end

function SelfActorSystem:CalChangePetActorId()
    local PetBossIdRane = 100000
    return ManagerContainer.DataMgr.UserData:GetUserId()-- + PetBossIdRane
end

function SelfActorSystem:CreatePetBossActor(ChangePetId)
    if nil == self.tbChangePetId then
        self.tbChangePetId = {}
    end
    local ChangePetUId = self:CalChangePetActorId()
    self.PetBossActor = ManagerContainer.LuaActorDataMgr:CreatePetBossActor(ChangePetUId, ChangePetId,self.heroActorData.Level)
    self.PetBossActor.Level = self.heroActorData.Level
    self.PetBossActor.HeadIcon = self.heroActorData.HeadIcon
    self.PetBossActor.IsMainRole = true
    table.insert(self.tbChangePetId,self.PetBossActor.ID)
    return self.PetBossActor
end

function SelfActorSystem:RemoveAllPetBossActor()
    for k,v in pairs(tbChangePetId) do
        ManagerContainer.LuaActorDataMgr:DeletePetActorData(v)
    end
end

function SelfActorSystem:Dispose()
    self.RemoveAllPetBossActor()
end

return SelfActorSystem