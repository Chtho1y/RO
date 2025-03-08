local CreatePetActorSystem = class("CreatePetActorSystem")
local LuaToCSData = require("LuaToCSData")

function CreatePetActorSystem:ctor()

end

function CreatePetActorSystem:CreatePetActorData(id, baseId, level, skillList)
    local skillParams = System.Array.CreateInstance(Enum.TypeInfo.SkillParam, #skillList)
    for i = 1, #skillList do
        local data = {skillId = skillList[i].cfgId, lv = skillList[i].level, rate = skillList[i].rate}
        local skill = LuaToCSData.CreateSkillParamData(data)
        skillParams[i - 1] = skill
    end
    local actorData = ManagerContainer.LuaActorDataMgr:CreatePet(id, baseId, level, skillParams)
    --获取服务器同步属性
    --ManagerContainer.LuaActorAttributeMgr:SyncServerActorData(actorData)
    return actorData
end

function CreatePetActorSystem:CreateSkillParamDatas(skillList)
    local skillParams = System.Array.CreateInstance(Enum.TypeInfo.SkillParam, #skillList)
    for i = 1, #skillList do
        local data = {skillId = skillList[i].cfgId, lv = skillList[i].level, rate = skillList[i].rate}
        local skill = LuaToCSData.CreateSkillParamData(data)
        skillParams[i - 1] = skill
    end
    return skillParams
end

function CreatePetActorSystem:Dispose()

end
return CreatePetActorSystem