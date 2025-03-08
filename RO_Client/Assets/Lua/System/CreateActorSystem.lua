local CreateActorSystem = class("CreateActorSystem")
local LuaToCSData = require("LuaToCSData")
local ProtocalDataNormal = require("ProtocalDataNormal")

local AttrFilterList
function CreateActorSystem:ctor()
    tbChangePetId = {}
end

function CreateActorSystem:CreateAllPetActorDatas(battle_pet_list)
    if self.heroData then
        self:CreatePetActorDatas(self.heroData.battlePetId, battle_pet_list)
    end

    if self.fellewDatas then
        for k,v in pairs(self.fellewDatas) do
            self:CreatePetActorDatas(v.battlePetId, battle_pet_list)
        end
    end

    if self.petActorDatas then
        for k,v in pairs(self.petActorDatas) do
            local petData = self.petDatas[k]
            if petData then
                local heroId = petData.heroId
                if heroId > 0 then
                    if heroId == 1 then
                        if self.heroActorData then
                            self.heroActorData:SetPet(v)
                        end
                    else
                        if self.fellewActorDatas and self.fellewActorDatas[heroId] then
                            self.fellewActorDatas[heroId]:SetPet(v)
                        end
                    end
                    self:SetSvrCalAttrs(v,petData)
                end
            end
        end
    end
end

function CreateActorSystem:UpdatePetExtGoShowData(petData)
    if not petData or petData.heroId == 0 then return end

    local heroData = self:GetHeroDataById(petData.heroId)
    CommonUtil.UpdatePetExtGoShowData(petData, heroData)
end

function CreateActorSystem:CreatePetActorDatas(id, battlePetList)
    if self.petDatas == nil then
        self.petDatas = {}
    end
    if self.petActorDatas == nil then
        self.petActorDatas = {}
    end

    if id == 0 or not battlePetList then return end

    for _,v in pairs(battlePetList) do
        if id == v.id then
            local petData = ProtocalDataNormal.ParsePetData(v)
            if petData then
                self.petDatas[v.id] = petData
            end
            self:UpdatePetExtGoShowData(petData)
            local actorParam = LuaToCSData.CreatePetActorParamData(petData)
            local actorData = ActorData.CreatePetActor(actorParam)
            if actorData then
                self.petActorDatas[v.id] = actorData
                actorData:SetStep(petData.advanceLevel)
                self:AddPetAdvenceAttrs(petData.cfgId, petData.advanceLevel, actorData)
            end
            return
        end
    end
end

function CreateActorSystem:AddPetAdvenceAttrs(cfgId, advLv, actorData)
    local cfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(cfgId)
    if not cfgData then
        return
    end
    if not actorData then
        return
    end

    for i = 1, advLv do
        local attrs = cfgData["Attribute"..i]
        if not attrs then
            return
        end
        for _,v in pairs(attrs) do
            local key = v[1]
            local val = v[2]
            if key <= Enum.HeroAttrType.RealHurt then
                local eAttr = actorData:GetAdditionalAttr(key)
                actorData:SetAdditionalAttr(key, SDataUtil.Add(eAttr,val))
            elseif key >= Enum.HeroAttrType.STR_Percent then
                local eAttr = actorData:GetAdditionalAttrPercent(key)
                actorData:SetAdditionalAttrPercent(key, SDataUtil.Add(eAttr,val * 0.0001))
            end
        end
    end
end

function CreateActorSystem:GetUserId()
    return self.userData.uid
end

function CreateActorSystem:GetUserHeadIcon()
    return self.userData.headPortraitName
end

function CreateActorSystem:GetUserNickname()
    return self.userData.nickName
end

function CreateActorSystem:GetPlayerActorParam()
    if nil ~= self.PetBossActor then --有变身ID 返回变身ID
        return self.PetBossActor
    end
    return self.heroActorData
end

function CreateActorSystem:GetFellowActorParam()
    return self.fellewActorDatas
end

function CreateActorSystem:GetPetActorDataByUid(uid)
    return self.petActorDatas and self.petActorDatas[uid] or nil
end

--- 创建主角ActorParam
function CreateActorSystem:CreatePlayerActorData()
    if not self.heroData then return nil end
    local actorParam = LuaToCSData.CreateActorParamData(self.heroData, self.heroData.skillData, self.heroData.buffs, self.userData, self.userData.viewData)
    local actorData = ActorData.CreatePlayerActor(actorParam)
    return actorData
end

---创建伙伴ActorParam
function CreateActorSystem:CreateFellowActorData()
    local fellowActorDatas = {}
    for k,v in pairs(self.fellewDatas) do
        local actorParam = LuaToCSData.CreateActorParamData(v, v.skillData, v.buffs)
        fellowActorDatas[k] = ActorData.CreateFellowActor(actorParam)
    end
    return fellowActorDatas
end

--根据data数据找寻Actordata
function CreateActorSystem:FindFellowActorDataByData(fellewDatas)
    for k,v in pairs(self.fellewActorDatas) do
        if fellewDatas.id == v.ID then
            return self.fellewActorDatas[k]
        end
    end
    return nil    
end

function CreateActorSystem:CreateRobotFightInfo(userData)
    local heroDatas = {}
    local robotCfg = ManagerContainer.CfgMgr:GetRobotDataByCfgId(userData.uid)
    if not robotCfg then 
        userData.inited = false
        return heroDatas
    end

    userData.nickName = robotCfg.RobotName
    userData.headPortraitId = robotCfg.RobotHeadPortrait
    userData.configId = robotCfg.RobotAvatar
    userData.arenaLevelId = robotCfg.ArenaLevelId
    userData.level = robotCfg.RobotLevel
    userData.avatar = robotCfg.RobotAvatar

    userData.roleCfgId  = CommonUtil.JobIdToRoleId(userData.configId, userData.gender)

    local power = math.random(robotCfg.FightPower[1], robotCfg.FightPower[2])
    userData.fightPower = power

    userData.inited = true

    --heroDatas[1] = ProtocalDataNormal.ParseRobotHeroData(1, userData.configId, robotCfg, true, true)
    for i = 1, 4 do
        heroDatas[i] = ProtocalDataNormal.ParseRobotHeroData(i, robotCfg.PartnerId[i - 1], robotCfg)
    end
    return heroDatas
end

function CreateActorSystem:CalcHeroAttrs()
    if self.heroData == nil then return end

    --需先清空 原有属性
    self.heroActorData:ResetBaseFirstAttr()
    self.heroActorData:ResetAdditionalAttr()
    self.heroActorData:ResetAdditionalAttrPercent()

    self:CalcHeroAddPointAttr()
    self:CalcEquipAttrs(self.heroActorData, self.heroData)
    if not self.userData.isRobot and self.fashionMap then   --不是机器人并且有时装信息
        self:CalcFashionAttrs(self.heroActorData, self.heroData)
    end
    self:CalcCardAttrs(self.heroActorData, self.heroData)
    self:CalcSkillAttrs(self.heroActorData, self.heroData)
    self:CalcPetAttrs(self.heroActorData, self.heroData)

    self:SetSvrCalAttrs(self.heroActorData,self.heroData)

end


function CreateActorSystem:CalcFellewAttrs()
    for k,v in pairs(self.fellewActorDatas) do
        --需先清空 原有属性
        v:ResetBaseFirstAttr()
        v:ResetAdditionalAttr()
        v:ResetAdditionalAttrPercent()

        self:SetSvrCalAttrs(v,self.fellewDatas[k])
        self:CalcFellewAddPointAttr(v, self.fellewDatas[k])
        self:CalcAdvenceAttrs(v, self.fellewDatas[k])
        self:CalcStrengthAttrs(v, self.fellewDatas[k])
        self:CalcEquipAttrs(v, self.fellewDatas[k])
        self:CalcCardAttrs(v, self.fellewDatas[k])
        self:CalcSkillAttrs(v, self.fellewDatas[k])
        self:CalcPetAttrs(v, self.fellewDatas[k])
    end
end

function CreateActorSystem:CalcHeroAddPointAttr()
    local actorData = self.heroActorData
    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.LUK then
            local delta = self:GetPointAttr(v)
            actorData:SetBaseFirstAttr(v, SDataUtil.Add(actorData:GetBaseFirstAttr(v),delta))
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        self.heroData.attrs[v] = actorData:GetAttr(v)
    end
end

function CreateActorSystem:CalcFellewAddPointAttr(actorData, heroData)
    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.LUK then
            local delta = self:GetFellowPointAttr(heroData, v)
            actorData:SetBaseFirstAttr(v, SDataUtil.Add(actorData:GetBaseFirstAttr(v),delta))
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroData.attrs[v] = actorData:GetAttr(v)
    end
end

function CreateActorSystem:GetPointAttr(type)
    for _,v in pairs(self.heroData.attrList) do
        if v.key == type then
            return v.value
        end
    end
    return 0
end

function CreateActorSystem:GetFellowPointAttr(herodata, type)
    if herodata.attrList then
        for _,v in pairs(herodata.attrList) do
            if  v.key == type then
                return v.value
            end
        end
    end
    return 0
end

function CreateActorSystem:CalcEquipAttrs(actorData, heroData)
    local slots = heroData.slot.slot_list
    local equipTotalAttrs = self:GetSlotsEquipAttr(slots)
    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.RealHurt then
            -- actorData:SetAdditionalAttr(v, actorData:GetAdditionalAttr(v) + equipTotalAttrs[v])
            actorData:SetAdditionalAttr(v, SDataUtil.Add(actorData:GetAdditionalAttr(v), equipTotalAttrs[v]))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            -- actorData:SetAdditionalAttrPercent(v, actorData:GetAdditionalAttrPercent(v) + equipTotalAttrs[v])
            actorData:SetAdditionalAttrPercent(v, SDataUtil.Add(actorData:GetAdditionalAttrPercent(v), equipTotalAttrs[v]))
        end
    end
end

function CreateActorSystem:GetSlotsEquipAttr(slots)
    if slots == nil then return nil end

    local baseAttrs = {}
    for _,v in pairs(Enum.HeroAttrType) do
        baseAttrs[v] = 0
    end

    local suitIds = {}
    local suitCounts = {}
    local refineSuitLv = CommonUtil.GetMinRefineLevel(slots)
    for i = 1,#slots do
        if slots[i].equip_id > 0 then
            local suitNum = CommonUtil.GetSuitNum(slots, i)
            local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(slots[i].equip_id)
            local refineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(slots[i].level)
            for k,v in pairs(Enum.HeroAttrType) do
                if equipCfgData[k] and equipCfgData[k] ~= 0 then
                    if v < Enum.HeroAttrType.STR_Percent then
                        local refineAdd = equipCfgData[k]*(refineData ~= nil and ((refineData.Result + 100)*0.01) or 1)
                        baseAttrs[Enum.HeroAttrType[k]] = baseAttrs[Enum.HeroAttrType[k]] + refineAdd
                    end
                end
                if refineSuitLv > 0 then
                    for j = refineSuitLv, 1, -1 do
                        local data = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(j)
                        local refineEff = data["Suit"]
                        if refineEff ~= nil and #refineEff > 0 and refineEff[1] == Enum.HeroAttrType[k] then
                            if v >= Enum.HeroAttrType.STR_Percent then
                                baseAttrs[Enum.HeroAttrType[k]] = baseAttrs[Enum.HeroAttrType[k]] + refineEff[1]
                            end
                        end
                    end
                end
            end

            if equipCfgData.Suit > 0 and not CommonUtil.EleInTable(equipCfgData.Suit, suitIds) then
                suitIds[#suitIds + 1] = equipCfgData.Suit
                suitCounts[equipCfgData.Suit] = math.floor(suitNum/2)
            end
        end
    end

    for i = 1,#suitIds do
        local suitCfgData = ManagerContainer.CfgMgr:GetEquipSuitById(suitIds[i])
        for j = 1, suitCounts[suitIds[i]] do
            if suitCfgData["Suit"..j] ~= nil then
                for k, v in pairs(suitCfgData["Suit"..j]) do
                    if type(v) == "table" then
                        if baseAttrs[v[1]] == nil then
                            baseAttrs[v[1]] = v[2]
                        else
                            baseAttrs[v[1]] = baseAttrs[v[1]] + v[2]
                        end
                    else
                        if baseAttrs[suitCfgData["Suit"..j][1]] == nil then
                            baseAttrs[suitCfgData["Suit"..j][1]] = suitCfgData["Suit"..j][2]
                        else
                            baseAttrs[suitCfgData["Suit"..j][1]] = baseAttrs[suitCfgData["Suit"..j][1]] + suitCfgData["Suit"..j][2]
                        end
                        break
                    end
                end
            end
        end
    end

    for k, v in pairs(Enum.HeroAttrType) do
        if v >= Enum.HeroAttrType.STR_Percent then
            baseAttrs[v] = baseAttrs[v]*0.0001
        end
    end

    for k, v in pairs(Enum.HeroAttrType) do
        if v < Enum.HeroAttrType.STR_Percent then
            baseAttrs[v] = baseAttrs[v]*(1 + baseAttrs[v + 30])
        end
    end

    for k, v in pairs(Enum.HeroAttrType) do
        if v >= Enum.HeroAttrType.STR_Percent then
            baseAttrs[v] = 0
        end
    end

    return baseAttrs
end

function CreateActorSystem:CalcCardAttrs(actorData, heroData)
    local slots = heroData.slot.slot_list
    local cardTotalAttrs = self:GetSlotsCardAttr(slots)
    local cardData = self:RefreshEquipedCardSuitData(heroData.id)
    if cardData and cardData[4] then
        if cardData[1] > 0 then
            local suitCfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(cardData[1])
            if suitCfgData then
                for i = 1, #suitCfgData.Suit1 do
                    local attr = suitCfgData.Suit1[i]
                    if attr then
                        local attrId = attr[1]
                        local attrNum = attr[2]*0.0001
                        local mapAttrData = ManagerContainer.CfgMgr:GetFightCfgByAttrId(attrId)

                        local newAttrId = mapAttrData.Mapping > 0 and mapAttrData.Mapping or attrId
                        if not cardTotalAttrs[newAttrId] then
                            cardTotalAttrs[newAttrId] = 0
                        end
                        if mapAttrData.Mapping > 0 then
                            cardTotalAttrs[newAttrId] = cardTotalAttrs[newAttrId] *(1 + attrNum)
                        else
                            cardTotalAttrs[newAttrId] = cardTotalAttrs[newAttrId] + attrNum
                        end
                    end
                end
            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        if cardTotalAttrs[v] ~= nil then
            if v < Enum.HeroAttrType.STR_Percent then
                -- local val =  actorData:GetAdditionalAttr(v) + cardTotalAttrs[v];
                local val = SDataUtil.Add(actorData:GetAdditionalAttr(v), cardTotalAttrs[v])
                actorData:SetAdditionalAttr(v, val)
            else
                -- local val =  actorData:GetAdditionalAttrPercent(v) + cardTotalAttrs[v];
                local val = SDataUtil.Add(actorData:GetAdditionalAttrPercent(v), cardTotalAttrs[v])
                actorData:SetAdditionalAttrPercent(v, val)
            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroData.attrs[v] = actorData:GetFinalAttr(v)
    end
end

function CreateActorSystem:GetSlotsCardAttr(slots)
    if slots == nil then return nil end

    local baseAttrs = {}
    for _,v in pairs(Enum.HeroAttrType) do
        baseAttrs[v] = 0
    end

    for i = 1,#slots do
        local cardList = slots[i].card_id_list
        for _,v in pairs(cardList) do
            if v > 0 then
                local cardData = ManagerContainer.CfgMgr:GetCardDataById(v)
                for _,v1 in pairs(CommonUtil.DeserializeCfgItemList(cardData.Attribute1)) do
                    if v1[1] < Enum.HeroAttrType.STR_Percent then
                        baseAttrs[v1[1]] = baseAttrs[v1[1]] + v1[2]
                    else
                        baseAttrs[v1[1]] = baseAttrs[v1[1]] + v1[2]*0.0001
                    end
                end
            end
        end
    end

    return baseAttrs
end

function CreateActorSystem:GetAllAttrs()
    return self.heroData.attrs
end

function CreateActorSystem:GetAllFinalAttr()
    local attrs = {}
    for _,v in pairs(Enum.HeroAttrType) do       
        attrs[v] = self.heroActorData:GetFinalAttr(v)
    end    
    return attrs
end

function CreateActorSystem:CalcSkillAttrs(actorData, heroData)
    local skillTotalAttrs = heroData.skillData:GetUnlockSkillAttrs()

    for _,v in pairs(Enum.HeroAttrType) do
        if skillTotalAttrs[v] ~= nil then
            if v < Enum.HeroAttrType.STR_Percent then
                -- local val =  actorData:GetAdditionalAttr(v) + skillTotalAttrs[v];
                local val = SDataUtil.Add(actorData:GetAdditionalAttr(v), skillTotalAttrs[v])
                actorData:SetAdditionalAttr(v, val)
            else
                -- local val =  actorData:GetAdditionalAttrPercent(v) + skillTotalAttrs[v];
                local val =  SDataUtil.Add(actorData:GetAdditionalAttrPercent(v), skillTotalAttrs[v])
                actorData:SetAdditionalAttrPercent(v, val)
            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroData.attrs[v] = actorData:GetFinalAttr(v)
    end
end


function CreateActorSystem:SetSvrCalAttrs(actorData, heroData)
    actorData:ResetServerSecondAttr()
    if nil ~= heroData.battle_attr_list then
        --LogError("acId".. tostring(actorData.ID) .. "set svr "..Inspect(heroData.battle_attr_list))
        for k,v in pairs(heroData.battle_attr_list) do     
            actorData:SetServerSecondAttr(v.key,v.value)
        end
    end
end

function CreateActorSystem:CalcPetAttrs(actorData, heroData)
    if not AttrFilterList then
        local val = GlobalConfig.Instance:GetConfigStrValue(230)
        if val ~= "" and val ~= nil then
            AttrFilterList = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end

    local petId = heroData.battlePetId
    --保存的ID 没有加 宠物区域  + Enum.ActorUidField.Pet（需后续查看战斗ID）
    local petActorData = self:GetPetActorDataByUid(petId)
    if petActorData == nil then
        return
    end
    local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petActorData.BaseId)

    local multiply = petCfgData.ConversionRate*0.0001

    for _,v in pairs(Enum.HeroAttrType) do
        if not CommonUtil.EleInTable(tostring(v), AttrFilterList) then
            local petAttr = petActorData and SDataUtil.Multiply(petActorData:GetFinalAttr(v), multiply) or 0
            if v <= Enum.HeroAttrType.RealHurt then
                local eAttr = actorData:GetAdditionalAttr(v)
                actorData:SetAdditionalAttr(v, SDataUtil.Add(eAttr,petAttr))
            elseif v >= Enum.HeroAttrType.STR_Percent then
                local eAttrPercent = actorData:GetAdditionalAttrPercent(v)
                actorData:SetAdditionalAttrPercent(v, SDataUtil.Add(eAttrPercent,petAttr))
            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroData.attrs[v] = actorData:GetFinalAttr(v)
    end
end

function CreateActorSystem:InitFashionData(data)
    if not data then return; end
    local fashion_list = data.fashion_list
    local fashionMap = {}
    local cfgMgr = ManagerContainer.CfgMgr
    local cfgId, fashionData
    if fashion_list then
        for i = 1, #fashion_list do
            cfgId = fashion_list[i]
            local fashionCfgData = cfgMgr:GetFashionById(cfgId)
            if not fashionCfgData then
                LogError("[Wboy] .. ".. cfgId .. " 时装ID不存在")
            else
                fashionData = { cfgId = cfgId, isNew = false }
                fashionMap[cfgId] = fashionData
            end
        end
    end
    self.fashionMap = fashionMap
end


function CreateActorSystem:CalcFashionAttrs(_heroActorData)
    --local heroData = _heroActorData
    --local heroLogicData = self:GetHeroData()
    --local fashionMap = self.fashionMap
    --local fashionTotalAttrs = CommonUtil.GetFashionAttrMap(fashionMap)
    --local changeNum = 0
    --for _,v in pairs(Enum.HeroAttrType) do
    --    if fashionTotalAttrs[v] ~= nil then
    --        if v < Enum.HeroAttrType.STR_Percent then
    --            changeNum = fashionTotalAttrs[v]
    --            if changeNum ~= 0 then
    --                -- local val =  heroData:GetAdditionalAttr(v) + changeNum;
    --                local val =  SDataUtil.Add(heroData:GetAdditionalAttr(v),changeNum)
    --                heroData:SetAdditionalAttr(v, val)
    --            end
    --        else
    --            changeNum = fashionTotalAttrs[v]
    --            if changeNum ~= 0 then
    --                -- local val =  heroData:GetAdditionalAttrPercent(v) + changeNum * 0.0001
    --                local val =  SDataUtil.Add(heroData:GetAdditionalAttrPercent(v),changeNum * 0.0001)
    --                heroData:SetAdditionalAttrPercent(v, val)
    --            end
    --        end
    --    end
    --end
    --
    --for _,v in pairs(Enum.HeroAttrType) do
    --    heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    --end
end

function CreateActorSystem:CalcAdvenceAttrs(actorData, heroData)
    for _,v in pairs(Enum.HeroAttrType) do
        local advencAttr = self:GetAdvenceAttrs(heroData, v)
        if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.RealHurt then
            -- actorData:SetAdditionalAttr(v, actorData:GetAdditionalAttr(v) + advencAttr)
            actorData:SetAdditionalAttr(v, SDataUtil.Add(actorData:GetAdditionalAttr(v), advencAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            -- actorData:SetAdditionalAttrPercent(v, actorData:GetAdditionalAttrPercent(v) + advencAttr)
            actorData:SetAdditionalAttrPercent(v, SDataUtil.Add(actorData:GetAdditionalAttrPercent(v), advencAttr))
        end
    end
end

function CreateActorSystem:GetAdvenceAttrs(data, attrId)
    local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
    if data.advanceLevel == 0 then
        return 0
    end

    local num = 0
    for i = 1,data.advanceLevel do
        local adds = CommonUtil.DeserializeCfgItemList(stepData["Attribute"..i])
        if adds ~= nil then
            for k,v in pairs(adds) do
                if v[1] == attrId then
                    if v[1] < Enum.HeroAttrType.STR_Percent then
                        num = num + v[2]
                    else
                        num = num + v[2]*0.0001
                    end
                end
            end
        end
    end

    return num
end

function CreateActorSystem:CalcStrengthAttrs(actorData, heroData)
    for _,v in pairs(Enum.HeroAttrType) do
        local strengthAttr = self:GetStrengthAttrs(heroData, v)
        if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.RealHurt then
            -- actorData:SetAdditionalAttr(v, actorData:GetAdditionalAttr(v) + strengthAttr)
            actorData:SetAdditionalAttr(v, SDataUtil.Add(actorData:GetAdditionalAttr(v), strengthAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            -- actorData:SetAdditionalAttrPercent(v, actorData:GetAdditionalAttrPercent(v) + strengthAttr)
            actorData:SetAdditionalAttrPercent(v, SDataUtil.Add(actorData:GetAdditionalAttrPercent(v), strengthAttr))
        end
    end
end

function CreateActorSystem:GetStrengthAttrs(data, attrId)
    local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
    if data.strengthLevel == 0 then
        return 0
    end
    local num = 0
    for i = 1,data.strengthLevel do
        local adds = CommonUtil.DeserializeCfgItemList(stepData["BreachAttribute"..i])
        if adds ~= nil then
            for k,v in pairs(adds) do
                if v[1] == attrId then
                    if v[1] < Enum.HeroAttrType.STR_Percent then
                        num = num + v[2]
                    else
                        num = num + v[2]*0.0001
                    end
                end
            end
        end
    end

    return num
end

function CreateActorSystem:GetRoleLv()
    return self.heroData.baseLevel
end

function CreateActorSystem:GetJobCfgId()
    return self.heroData.configId;
end

function CreateActorSystem:GetHeroData()
    return self.heroData
end

function CreateActorSystem:GetId()
    return self.heroData.id
end

function CreateActorSystem:GetSkillData(heroId)
    local skillData = nil
    if heroId == 1 then
        skillData = self.heroData.skillData
    else
        skillData = self.fellewDatas[heroId].skillData
    end
    return skillData
end

function CreateActorSystem:GetCurSlotInfos(id)
    self:GetAllSlotInfos()
    local slot = self.allSlots[id]
    if slot == nil then
        return nil
    end
    return slot.slot_list
end

function CreateActorSystem:GetAllSlotInfos()
    local heroSlot = self.heroData.slot
    if not self.allSlots then self.allSlots = {}; end
    self.allSlots[heroSlot.hero_id] = heroSlot
    local slots = self:GetAllPartnerSlots()
    for k,v in pairs(slots) do
        self.allSlots[k] = v
    end
    return self.allSlots
end

function CreateActorSystem:GetAllPartnerSlots()
    local slots = {}
    for k,v in pairs(self.fellewDatas) do
        local slot = v.slot
        if slot ~= nil then
            slots[slot.hero_id] = slot
        end
    end
    return slots
end

function CreateActorSystem:GetUserRoleId()
    return self.userData.roleCfgId
end

function CreateActorSystem:GetViewData()
    return self.userData.viewData
end

function CreateActorSystem:GetMainRoleData()
    return self.heroData
end

function CreateActorSystem:GetHeadFrameId()
    return self.userData.headFrame or -1;
end

function CreateActorSystem:GetPartnerDatas()
    return self.fellewDatas
end

function CreateActorSystem:GetHeroDataAttr(id)
    return SDataUtil.InvConvert(self.heroData.attrs[id] or 0)  
end

function CreateActorSystem:GetUserHeadPortraitId()
    return self.userData.headPortraitId
end

function CreateActorSystem:GetGuildName()
    return self.guildName
end

function CreateActorSystem:GetTotalFightPower()
    return self.userData.fightPower
end

--技能压制等级
function CreateActorSystem:GetSkillPvPVal()
    return self.userData.repress_skill_pvp_val
end

--- 解析 FightRoleInfo网络数据
---@field fightRoleInfo table
function CreateActorSystem:ParseFightRoleInfo(fightRoleInfo)
    self.userData = {}
    self.userData.isRobot   = fightRoleInfo.is_robot
    self.userData.jobLevel = fightRoleInfo.job_level
    self.userData.gender = fightRoleInfo.gender
    self.userData.repress_skill_pvp_val = fightRoleInfo.repress_skill_pvp_val
    self.userData = ProtocalDataNormal.ParsePlayerBriefInfo(fightRoleInfo.brief_info, self.userData)
    self.userData.viewData = ProtocalDataNormal.FashionDataToViewData(fightRoleInfo.fashion_data)
    self.userData.inited = true
    if fightRoleInfo.is_robot then
        local heroDatas = self:CreateRobotFightInfo(self.userData)
        self.userData.attrList       = {}
        self.fellewDatas = {}
        for i = 1, #heroDatas do
            local id = heroDatas[i].id
            --if id == 1 then
            --    self.heroData = heroDatas[i]
            --else
                self.fellewDatas[id] = heroDatas[i]
            --end
        end
        if self.heroData ~= nil then
            local actorParam = LuaToCSData.CreateActorParamData(self.heroData, self.heroData.skillData, self.heroData.buffs, self.userData, self.userData.viewData)
            self.heroActorData = ActorData.CreatePlayerActor(actorParam)
        end
    else
        if fightRoleInfo.hero_data_list then
            self.fellewDatas = {}
            for i = 1, #fightRoleInfo.hero_data_list do
                local id = fightRoleInfo.hero_data_list[i].id
                if id == 1 then
                    self.heroData = ProtocalDataNormal.ParseHeroData(fightRoleInfo.hero_data_list[i], self.userData, false, true)
                    CommonUtil.UpdateHeroExtGoShowData(self.heroData)
                else
                    self.fellewDatas[id] = ProtocalDataNormal.ParseHeroData(fightRoleInfo.hero_data_list[i])
                    CommonUtil.UpdateHeroExtGoShowData(self.fellewDatas[id])
                end
            end
        end
        if self.heroData ~= nil then
            self.heroActorData = self:CreatePlayerActorData()
            self.heroActorData.Name = self.userData.nickName
            self.heroActorData.HeadFrameId = self.userData.headFrame
        end
    end

    self.fellewActorDatas = self:CreateFellowActorData()

    self:CreateAllPetActorDatas(fightRoleInfo.battle_pet_list)
    --要变身的ID
    self.userData.change_play_id = fightRoleInfo.change_play_id
    self:CreateChangePetActor()

    self:CalcHeroAttrs()
    self:CalcFellewAttrs()
end
--创建变身后的宠物ACTORdata
function CreateActorSystem:CreateChangePetActor()
    if nil ~= self.userData.change_play_id  then
        
    end


    if self.heroData then
        self:CreatePetActorDatas(self.heroData.battlePetId, battle_pet_list)
    end

    if self.fellewDatas then
        for k,v in pairs(self.fellewDatas) do
            self:CreatePetActorDatas(v.battlePetId, battle_pet_list)
        end
    end

    if self.petActorDatas then
        for k,v in pairs(self.petActorDatas) do
            local petData = self.petDatas[k]
            if petData then
                local heroId = petData.heroId
                if heroId > 0 then
                    if heroId == 1 then
                        if self.heroActorData then
                            self.heroActorData:SetPet(v)
                        end
                    else
                        if self.fellewActorDatas and self.fellewActorDatas[heroId] then
                            self.fellewActorDatas[heroId]:SetPet(v)
                        end
                    end
                    self:SetSvrCalAttrs(v,petData)
                end
            end
        end
    end
end

--用于查询其他玩家信息
function CreateActorSystem:ParseOtherRoleInfo(viewRoleInfo)
    self.userData = {}
    -- self.userData.attrList = viewRoleInfo.attr_list

    self.userData.attrList = {}
    for _,v in pairs(viewRoleInfo.attr_list) do
        local attr = {key=v.key,value=SInt.Convert(v.value)}
        self.userData.attrList[#self.userData.attrList] = attr
    end

    self.userData = ProtocalDataNormal.ParsePlayerBriefInfo(viewRoleInfo.brief, self.userData)
    self.userData.viewData = ProtocalDataNormal.FashionDataToViewData(viewRoleInfo.fashion_data)
    self.userData.fashion = viewRoleInfo.fashion
    self.userData.danScore = viewRoleInfo.danScore
    self.userData.paramList = viewRoleInfo.param_list

    self.fellewDatas = {}
    if viewRoleInfo.hero then
        for i = 1, #viewRoleInfo.hero.hero_data do
            local _heroData = viewRoleInfo.hero.hero_data[i]
            local id = _heroData.id
            self.fellewDatas[id] = ProtocalDataNormal.ParseHeroData(_heroData)
            CommonUtil.UpdateHeroExtGoShowData(self.fellewDatas[id])
        end
    end
    self.heroData = ProtocalDataNormal.ParseHeroData(viewRoleInfo.role_hero, self.userData, false, true)
    CommonUtil.UpdateHeroExtGoShowData(self.heroData)
    if self.heroData ~= nil then
        self.heroActorData = self:CreatePlayerActorData()
    end

    self.fellewActorDatas = self:CreateFellowActorData()

    self:CreateAllPetActorDatas(viewRoleInfo.pet_list)

    self:InitFashionData(self.userData.fashion)
    self:CalcHeroAttrs()
    self:CalcFellewAttrs()

    self.guildName = viewRoleInfo.guild_name
end

function CreateActorSystem:GetHeroPetDataByHeroId(id)
    if id == 1 then
        return self.petDatas[self.heroData.battlePetId]
    else
        return self.petDatas[self.fellewDatas[id].battlePetId]
    end
end

function CreateActorSystem:GetHeroPetActorDataById(id)
    return self.petActorDatas[id]
end

function CreateActorSystem:GetHeroDataById(id)
    if id == 1 then
        return self.heroData
    else
        return self.fellewDatas[id]
    end
end

function CreateActorSystem:GetCardSuitLvById(id)
    if id == 1 then
        return self.heroData.petFightPower
    else
        return self.fellewDatas[id].petFightPower
    end
end

function CreateActorSystem:RefreshEquipedCardSuitData(id)
    local slot
    if id == 1 then
        slot = self.heroData.slot
    else
        slot = self.fellewDatas[id].slot
    end

    local equipedCards = {}
    for _,v in pairs(slot.slot_list) do
        local cardList = v.card_id_list
        for _,v1 in pairs(cardList) do
            if v1 and v1 > 0 then
                equipedCards[#equipedCards + 1] = v1
            end
        end
    end

    local cloneEquips
    local suitData = {}
    local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
    for i = #allCfgDatas, 1, -1 do
        local cfgData = allCfgDatas[i]
        local enoughCount = {}
        local count = {}

        cloneEquips = clone(equipedCards)
        for j = #cfgData.TriggerConditions, 1, -1 do
            local condition = cfgData.TriggerConditions[j]
            local type = condition[1]
            local lv = condition[2]
            local num = condition[3]
            enoughCount[j] = num
            if not count[j] then
                count[j] = 0
            end

            for m = #cloneEquips, 1, -1 do
                local cfgId = cloneEquips[m]
                local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
                if cardCfgData and cardCfgData.CardType >= type and cardCfgData.CardLevel >= lv then
                    count[j] = count[j] + 1
                    table.remove(cloneEquips, m)
                    if count[j] >= enoughCount[j] then
                        break
                    end
                end
            end
            count[j] = math.min(count[j], enoughCount[j])
            suitData = {cfgData.Id, count, enoughCount, false}
        end

        local result = true
        for j = 1,#count do
            if count[j] < enoughCount[j] then
                result = false
                break
            end
        end
        if result then
            suitData[4] = true
            break
        end
    end

    return suitData, slot
end

function CreateActorSystem:GetHeroPetFightPowerByHeroId(id)
    if id == 1 then
        return self.heroData.petFightPower
    else
        return self.fellewDatas[id].petFightPower
    end
end

function CreateActorSystem:GetHeroSkillEquipDataByHeroId(id)
    if id == 1 then
        local skillEquipSlot = self.heroData.skillEquipSlot
		local skillEquipData = skillEquipSlot.slotList[1]
        return skillEquipData
    else
        local skillEquipSlot = self.fellewDatas[id].skillEquipSlot
		local skillEquipData = skillEquipSlot.slotList[1]
        return skillEquipData
    end
end

----变身宠物
function CreateActorSystem:CalChangePetActorId()
    local PetBossIdRane = 100000
    return ManagerContainer.DataMgr.UserData:GetUserId()-- + PetBossIdRane
end

function CreateActorSystem:CreatePetBossActor(ChangePetId)
    if nil == self.tbChangePetId then
        self.tbChangePetId = {}
    end
    local ChangePetUId = self:CalChangePetActorId()
    self.PetBossActor = ManagerContainer.LuaActorDataMgr:CreatePetBossActor(ChangePetUId, ChangePetId,self.heroActorData.Level)
    self.PetBossActor.Level = self.heroActorData.Level
    self.PetBossActor.HeadIcon = self.heroActorData.HeadIcon
    table.insert(self.tbChangePetId,self.PetBossActor.ID)
    return self.PetBossActor
end

function CreateActorSystem:RemoveAllPetBossActor()
    for k,v in pairs(tbChangePetId) do
        ManagerContainer.LuaActorDataMgr:DeletePetActorData(v)
    end
end


function CreateActorSystem:Dispose()
    self.RemoveAllPetBossActor()
    self.userData = nil
    self.heroData = nil
    self.fellewDatas = nil
    self.petDatas = nil

    self.heroActorData = nil
    self.fellewActorDatas = nil
    self.fashionMap = nil
    self.petActorDatas = nil
    self.guildName = nil
end
return CreateActorSystem