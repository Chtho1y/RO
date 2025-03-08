local PartnerData = class("PartnerData", require("DataBase"))
local SkillData = require("SkillData")

local baseAttrs

local needNtfTeamBattle = true
local attrDirty = false

local lastTeamPetAttrs = {}

local lastTeamEquipAttrs = {}
local lastTeamCardAttrs = {}
local lastTeamAdvenceLvs = {}
local lastTeamStrengthLvs = {}
local lastTeamPointAttrs = {}
local lastTeamBaseAttrs = {}
local lastTeamFashionAttrs = {}
local lastTeamKeepSakeAttrs = {}

local lastTeamSkillAttrs = {}

local lastTotalAttrs = {}

local battlePartnerChanged = false
local partnerChangeTimer

local AttrFilterList
function PartnerData:ctor()
    self.data = {}
end

local function SortPartnerId(a, b)
    if a.id > 0 and b.id > 0 then
        return a.post < b.post
    else
        if a.id == b.id then
            return a.post < b.post
        else
            return a.id > b.id
        end
    end
end

function PartnerData:InitPartnerData(partnerData)
    local baseAttr = SInt.Convert(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_base_attr_id))
    baseAttrs = {[Enum.HeroAttrType.STR] = baseAttr, [Enum.HeroAttrType.AGI] = baseAttr, [Enum.HeroAttrType.INT] = baseAttr,
                 [Enum.HeroAttrType.DEX] = baseAttr, [Enum.HeroAttrType.VIT] = baseAttr, [Enum.HeroAttrType.LUK] = baseAttr}

    if self.data.partnerData == nil then
        self.data.partnerData = {}
    end

    if self.data.partnerData.heroDatas == nil then
        self.data.partnerData.heroDatas = {}
    end

    self:RefreshPartnerDatas(partnerData.hero_data, true)
end

function PartnerData:RefreshPartnerDatas(heroData, isInit)
    local addPartnerIds = {}
    local addPartnerMap = {}
    local newBattleStatus = false
    local needRpRefreshIds = {}
    local changePetIds = {}
    local allPartnerDatas = ManagerContainer.CfgMgr:GetOriPartnerDatas()
    local list = {}

    for _,v in pairs(self.data.partnerData.heroDatas) do
        if not v.owned then
            v.id = 0
        end
    end

    if allPartnerDatas ~= nil then
        for _,v in pairs(allPartnerDatas) do
            local data = self:GetPartnerDataByOriId(v.ParterId)
            local isNew = false
            if data == nil then
                data = {}
                data.owned = false
                data.isBattle = false
            end
            data.changeBattle = false
            for _,v1 in pairs(heroData) do
                local oriPartnerCfgId = ManagerContainer.CfgMgr:GetOriPartnerDataByAdvenceId(v1.config_id)
                if v.ParterId == oriPartnerCfgId.ParterId then
                    if data.isBattle ~= v1.is_battle then
                        newBattleStatus = true
                        data.changeBattle = true
                        attrDirty = true
                    end
                    if not data.owned then
                        isNew = true
                        data.owned          = true
                        attrDirty = true
                    end

                    if data.battlePetId ~= v1.battle_pet_id then
                        changePetIds[#changePetIds + 1] = v1.id
                        attrDirty = true
                    end

                    local addAdvenceLv = v1.advance_level > (data.advanceLevel or 0)
                    local addStrengthLv = v1.strength_level > (data.strengthLevel or 0)
                    if isInit then
                        addAdvenceLv = false
                        addStrengthLv = false
                    end
                    local isTransfer = data.configId ~= v1.config_id
                    self:InitOwnedHeroData(data, v1)

                    --转职刷新数据
                    if not isNew and data.owned then
                        if isTransfer then
                            if not LuaBattleBridge.ActorInFighting(data.id) then
                                ManagerContainer.LuaActorDataMgr:RefreshFellowActorData(data.id, data.configId)
                            end

                            data.isTransferred = true

                            lastTeamPointAttrs[data.id] = nil
                            lastTeamBaseAttrs[data.id] = nil
                            self:RefreshAddPointAttr(data.id)
                            attrDirty = true

                            lastTeamSkillAttrs[data.id] = nil
                            lastTeamEquipAttrs[data.id] = nil
                            lastTeamCardAttrs[data.id] = nil
                            lastTeamPetAttrs[data.id] = nil
                            lastTeamAdvenceLvs[data.id] = 0
                            lastTeamStrengthLvs[data.id] = 0
                            lastTeamFashionAttrs[data.id] = nil
                        end

                        --进阶刷新数据
                        ManagerContainer.LuaActorDataMgr:SetPartnerStep(data.id,data.configId, data.advanceLevel)

                        --重新计算属性
                        self:InitPartnerAttr(data, addAdvenceLv, addStrengthLv)
                        if addAdvenceLv or addStrengthLv then
                            attrDirty = true
                        end
                    end

                    if isInit then
                        self:InitPartnerAttr(data, addAdvenceLv, addStrengthLv)
                    end

                    if isNew then
                        self:RefreshAddPointAttr(v1.id)
                        addPartnerMap[v.ParterId] = v1.id
                        addPartnerIds[#addPartnerIds + 1] = v1.id
                        attrDirty = true
                    end

                    if not CommonUtil.EleInTable(v1.id, needRpRefreshIds) then
                        needRpRefreshIds[#needRpRefreshIds + 1] = v1.id
                    end
                end
            end
            if not data.owned then
                self:InitUnownedHeroData(data, v)
                data.owned = false
            end
            data.post = v.PostId
            data.jobType = v.JobType

            list[#list + 1] = data
        end
    end
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            local oriPartnerCfg = ManagerContainer.CfgMgr:GetOriPartnerDataByAdvenceId(v.configId)
            for k,v1 in pairs(list) do
                local oriPartnerCfg1 = ManagerContainer.CfgMgr:GetOriPartnerDataByAdvenceId(v1.configId)
                if oriPartnerCfg1.ParterId == oriPartnerCfg.ParterId then
                    list[k] = v
                    if v1.id > 0 then
                        list[k].isBattle = v1.isBattle
                        if v1.changeBattle then
                            ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleSkillEquipRPById(v1.id)
                        end
                    end
                end
            end
        end
    end
    table.sort(list, SortPartnerId)
    self:RefreshPartnerID(list)
    return addPartnerMap, newBattleStatus, needRpRefreshIds,changePetIds
end

function PartnerData:RefreshPartnerID(list)
    for i = 1, #list do
        if list[i].id == 0 then
            list[i].id = i + 1
            list[i].slot.hero_id = list[i].id
        end
        self.data.partnerData.heroDatas[list[i].id] = list[i]
    end
end

function PartnerData:InitUnownedHeroData(data, heroData)
    data.id             = 0
    data.configId       = heroData.ParterId
    data.fightPower     = SInt.Convert(heroData.InitFightPower or 0)
    data.avatar         = 0
    data.isBattle       = false
    data.baseLevel      = 1
    data.advanceLevel   = 0
    data.strengthLevel  = 0
    data.attrs          = CommonUtil.TableClone(baseAttrs)

    data.slot           = {hero_id = data.id, slot_list = {}}

    data.treasureFree   = 1
    data.battlePetId    = 0
    data.skillEquipSlot = {heroId = data.id, slot_list = {}}
    --宠物契约
    data.petQiyueData = ProtocalDataNormal.ParsePetQiyueData(data.petQiyueData, heroData.pet_qiyue_data) 
    self:UpdateHeroExtGoShowData(data)
end

function PartnerData:InitOwnedHeroData(data, heroData)
    --LogHRWarning(Inspect(heroData))
    data.id             = heroData.id
    data.configId       = heroData.config_id
    data.fightPower     = SInt.Convert(heroData.fight_power or 0)
    data.avatar         = heroData.avatar
    data.isBattle       = heroData.is_battle
    data.baseLevel      = heroData.base_level
    data.advanceLevel   = heroData.advance_level or 0
    data.strengthLevel  = heroData.strength_level or 0

    data.attrs          = CommonUtil.TableClone(baseAttrs)

    data.slot           = heroData.slot
    if #data.slot.slot_list == 0 then
        for i = 1, 6 do
            data.slot.slot_list[i] = {}
            data.slot.slot_list[i].level = 0
            data.slot.slot_list[i].equip_id = 0
            data.slot.slot_list[i].card_id_list = {}
        end
    end

    data.attrList        = heroData.attr_list
    for _,v in pairs(data.attrList) do
        v.value = SInt.Convert(v.value)
    end
    data.attrPoint      = SInt.Convert(heroData.attr_point)
    data.qualityList   = {}
    if heroData.quality_list and #heroData.quality_list > 0 then
        for k, v in pairs(heroData.quality_list) do
            data.qualityList[v.key] = v.value
        end
    end

    data.battlePetId    = heroData.battle_pet_id

    self:InitPartnerSkill(data, heroData.skill)

    data.treasureFree   = 1

    data.skillEquipSlot = ProtocalDataNormal.ParseSkillEquipSlotData(data.skillEquipSlot, heroData.skill_equip_slot) 
    --宠物契约
    data.petQiyueData = ProtocalDataNormal.ParsePetQiyueData(data.petQiyueData, heroData.pet_qiyue_data) 
    LogHRWarning("refresh partner heroData    "..Inspect(heroData.pet_qiyue_data).."     "..Inspect(data.petQiyueData))
    self:UpdateHeroExtGoShowData(data)
    return data
end

function PartnerData:ChangePartnerData(data)
    local newData = self:GetPartnerDataById(data.config_id)
    if newData == nil then
        newData = {}
        newData.isBattle = false
        newData.owned = false
    end

    local lastBattleStatue = newData.isBattle
    local lastOwnStatue = newData.owned

    newData.id             = data.id
    newData.configId       = data.config_id
    --newData.fightPower     = data.fight_power or 0
    newData.avatar         = data.avatar
    newData.isBattle       = data.is_battle
    newData.baseLevel      = data.base_level
    newData.advanceLevel   = data.advance_level
    newData.strengthLevel  = data.strength_level or 0
    newData.slot           = data.slot
    -- newData.skillData      = data.skill
    self:InitPartnerSkill(newData, data.skill)

    if newData.attrs == nil then
        newData.attrs          = CommonUtil.TableClone(baseAttrs)
    end

    newData.owned = true
    newData.treasureFree   = 1

    ManagerContainer.LuaActorDataMgr:SetPartnerStep(newData.id,newData.configId, newData.advanceLevel)
    self:InitPartnerAttr(newData)
    self.data.partnerData.heroDatas[newData.id] = newData
    -- self:SetHeroSkills(newData)

    return lastBattleStatue ~= newData.isBattle, not lastOwnStatue and newData.owned, newData
end

--function PartnerData:RefreshPartnerTransfer(id)
--    for k,v in pairs(self.data.partnerData.heroDatas) do
--        if v.id == id then
--            if not LuaBattleBridge.ActorInFighting(id) then
--                ManagerContainer.LuaActorDataMgr:RefreshFellowActorData(id,v.configId)
--            end
--
--            v.isTransferred = true
--
--            lastTeamPointAttrs[id] = nil
--            lastTeamBaseAttrs[id] = nil
--            self:RefreshAddPointAttr(id)
--            attrDirty = true
--
--            lastTeamSkillAttrs[id] = nil
--            lastTeamEquipAttrs[id] = nil
--            lastTeamCardAttrs[id] = nil
--            lastTeamPetAttrs[id] = nil
--            lastTeamAdvenceLvs[id] = 0
--            lastTeamStrengthLvs[id] = 0
--            self:InitPartnerAttrById(v.id, v.advanceLevel, v.strengthLevel)
--        end
--    end
--end

function PartnerData:RefreshPartnerTreasureState(heroId, isFree)
    local heroData = self:GetPartnerDataByUniqueId(heroId)
    heroData.treasureFree = isFree and 1 or 0
end

function PartnerData:GetAdvenceAttrs(data, attrId, addAdvenceLv)
    local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
    if data.advanceLevel == 0 then
        return 0
    end

    local num = 0
    if addAdvenceLv then
        local adds = CommonUtil.DeserializeCfgItemList(stepData["Attribute"..data.advanceLevel])
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
    else
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
    end

    return num
end

function PartnerData:InitPartnerPointAttr()
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            self:RefreshAddPointAttr(v.id)
        end
    end
end

function PartnerData:RefreshAddPointAttr(id)
    if lastTeamPointAttrs[id] == nil then lastTeamPointAttrs[id] = {} end
    if lastTeamBaseAttrs[id] == nil then lastTeamBaseAttrs[id] = {} end

    local partnerData = self:GetPartnerDataByUniqueId(id)
    if partnerData == nil then return end

    local heroData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(id,partnerData.configId)
    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.LUK then
            local delta = self:GetPointAttr(id, v)
            if lastTeamPointAttrs[id] ~= nil and lastTeamPointAttrs[id][v] ~= nil then
                -- delta = self:GetPointAttr(v) - lastPointAttrs[v]
                delta = SDataUtil.Sub(self:GetPointAttr(id, v), lastTeamPointAttrs[id][v])
            end

            heroData:SetBaseFirstAttr(v, SDataUtil.Add(heroData:GetBaseFirstAttr(v),delta))
            lastTeamPointAttrs[id][v] = self:GetPointAttr(id, v)
            lastTeamBaseAttrs[id][v] = heroData:GetBaseFirstAttr(v)
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        partnerData.attrs[v] = heroData:GetFinalAttr(v)
    end
end

function PartnerData:GetAllPartnerSlots()
    local slots = {}
    for k,v in pairs(self.data.partnerData.heroDatas) do
        local slot = v.slot
        if slot ~= nil then
            slots[slot.hero_id] = slot
        end
    end
    return slots
end

function PartnerData:GetStrengthAttrs(data, attrId, addStrengthLv)
    local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
    if data.strengthLevel == 0 then
        return 0
    end
    local num = 0
    if addStrengthLv then
        local adds = CommonUtil.DeserializeCfgItemList(stepData["BreachAttribute"..data.strengthLevel])
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
    else
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
    end

    return num
end

function PartnerData:CalcAdvenceAttrs(fellowData, data, needRefresh, addAdvenceLv)
    for _,v in pairs(Enum.HeroAttrType) do
        local advencAttr = self:GetAdvenceAttrs(data, v, addAdvenceLv)
        if data.advanceLevel == lastTeamAdvenceLvs[data.id] then
            advencAttr = 0
        end
        if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.RealHurt then
            -- fellowData:SetAdditionalAttr(v, fellowData:GetAdditionalAttr(v) + advencAttr)
            fellowData:SetAdditionalAttr(v, SDataUtil.Add(fellowData:GetAdditionalAttr(v), advencAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            -- fellowData:SetAdditionalAttrPercent(v, fellowData:GetAdditionalAttrPercent(v) + advencAttr)
            fellowData:SetAdditionalAttrPercent(v, SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v), advencAttr))
        end
    end

    lastTeamAdvenceLvs[data.id] = data.advanceLevel

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:CalcStrengthAttrs(fellowData, data, needRefresh, addStrengthLv)
    for _,v in pairs(Enum.HeroAttrType) do
        local strengthAttr = self:GetStrengthAttrs(data, v, addStrengthLv)
        if data.strengthLevel == lastTeamStrengthLvs[data.id] then
            strengthAttr = 0
        end
        if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.RealHurt then
            -- fellowData:SetAdditionalAttr(v, fellowData:GetAdditionalAttr(v) + strengthAttr)
            fellowData:SetAdditionalAttr(v, SDataUtil.Add(fellowData:GetAdditionalAttr(v), strengthAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            -- fellowData:SetAdditionalAttrPercent(v, fellowData:GetAdditionalAttrPercent(v) + strengthAttr)
            fellowData:SetAdditionalAttrPercent(v, SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v), strengthAttr))
        end
    end

    lastTeamStrengthLvs[data.id] = data.strengthLevel

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:CalcEquipAttrs(fellowData, data, needRefresh)
    if data.slot ~= nil then
        local equipTotalAttrs = ManagerContainer.DataMgr.UserData:GetSlotsEquipAttr(data.slot.slot_list)

        for _,v in pairs(Enum.HeroAttrType) do
            if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.MaxSp then
                fellowData:SetAdditionalAttr(v, SDataUtil.Add(fellowData:GetAdditionalAttr(v),equipTotalAttrs[v] - (lastTeamEquipAttrs[data.id] == nil and 0 or lastTeamEquipAttrs[data.id][v])))
            elseif v >= Enum.HeroAttrType.STR_Percent then
                fellowData:SetAdditionalAttrPercent(v, SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v), equipTotalAttrs[v] - (lastTeamEquipAttrs[data.id] == nil and 0 or lastTeamEquipAttrs[data.id][v])))
            end
        end

        lastTeamEquipAttrs[data.id] = equipTotalAttrs
    else
        for _,v in pairs(Enum.HeroAttrType) do
            if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.MaxSp then
                fellowData:SetAdditionalAttr(v, fellowData:GetAdditionalAttr(v))
            elseif v >= Enum.HeroAttrType.STR_Percent then
                fellowData:SetAdditionalAttrPercent(v, fellowData:GetAdditionalAttrPercent(v))
            end
        end
    end

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:CalcCardAttrs(fellowData, data, needRefresh)
    if data.slot ~= nil then
        --ManagerContainer.DataMgr.CardData:RefreshEquipedCardSuitData(data.id)
        local cardTotalAttrs = ManagerContainer.DataMgr.UserData:GetSlotsCardAttr(data.slot.slot_list)
        local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(data.id)
        if state then
            local lv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(data.id)
            if lv > 0 then
                local suitCfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(lv)
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
                    local val = SDataUtil.Add(fellowData:GetAdditionalAttr(v), cardTotalAttrs[v] - (lastTeamCardAttrs[data.id] == nil and 0 or lastTeamCardAttrs[data.id][v]))
                    fellowData:SetAdditionalAttr(v, val)
                else
                    local val = SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v), cardTotalAttrs[v] - (lastTeamCardAttrs[data.id] == nil and 0 or lastTeamCardAttrs[data.id][v]))
                    fellowData:SetAdditionalAttrPercent(v, val)
                end
            end
        end

        lastTeamCardAttrs[data.id] = cardTotalAttrs
    end

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:CalcAllPartnerFashionAttrs()
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            self:CalcPartnerFashionAttrsById(v.id)
        end
    end
end

function PartnerData:CalcPartnerFashionAttrsById(id)
    local data = self:GetPartnerDataByUniqueId(id)
    local fellowData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(data.id,data.configId)
    if data and fellowData then
        self:CalcFashionAttrs(fellowData, data, true)
    end
end

function PartnerData:CalcFashionAttrs(fellowData, data, needRefresh)
    local partnerCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    if not partnerCfgData then return end

    if not lastTeamFashionAttrs[data.id] then
        lastTeamFashionAttrs[data.id] = {}
    end
    local jobType = partnerCfgData.JobType
    local fashionTotalAttrs = ManagerContainer.DataMgr.FashionData:GetFashionAllAttrsByJobType(jobType)

    if not fashionTotalAttrs then return end

    local changeNum = 0
    for _,v in pairs(Enum.HeroAttrType) do
        if fashionTotalAttrs[v] ~= nil then
            if v < Enum.HeroAttrType.STR_Percent then
                changeNum = (fashionTotalAttrs[v] - ((lastTeamFashionAttrs[data.id] == nil or not lastTeamFashionAttrs[data.id][v]) and 0 or lastTeamFashionAttrs[data.id][v]))
                if changeNum ~= 0 then
                    -- local val =  heroData:GetAdditionalAttr(v) + changeNum;
                    local val = SDataUtil.Add(fellowData:GetAdditionalAttr(v), changeNum)
                    fellowData:SetAdditionalAttr(v, val)
                end
            else
                changeNum = (fashionTotalAttrs[v] - ((lastTeamFashionAttrs[data.id] == nil or not lastTeamFashionAttrs[data.id][v]) and 0 or lastTeamFashionAttrs[data.id][v]))
                if changeNum ~= 0 then
                    -- local val =  heroData:GetAdditionalAttrPercent(v) + changeNum * 0.0001
                    local val = SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v), changeNum * 0.0001)
                    fellowData:SetAdditionalAttrPercent(v, val)
                end
            end
        end
    end

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
    lastTeamFashionAttrs[data.id] = clone(fashionTotalAttrs)
end

function PartnerData:CalcPetAttrsById(id)
    local data = self:GetPartnerDataByUniqueId(id)
    local fellowData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(data.id,data.configId)
    if data and fellowData then
        self:CalcPetAttrs(fellowData, data, true)
    end
end

function PartnerData:CalcPetAttrs(fellowData, data, needRefresh)
    if not AttrFilterList then
        local val = GlobalConfig.Instance:GetConfigStrValue(230)
        if val ~= "" and val ~= nil then
            AttrFilterList = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end

    if not lastTeamPetAttrs[data.id] then
        lastTeamPetAttrs[data.id] = {}
    end
    local petId = data.battlePetId
    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)

    local multiply = 0
    if petData then
        local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
        multiply = petCfgData.ConversionRate*0.0001
    end
    local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(petId)

    for _,v in pairs(Enum.HeroAttrType) do
        if not CommonUtil.EleInTable(tostring(v), AttrFilterList) then
            local petAttr = petActorData and SDataUtil.Multiply(petActorData:GetFinalAttr(v), multiply) or 0
            if v <= Enum.HeroAttrType.RealHurt then
                local eAttr = fellowData:GetAdditionalAttr(v)
                local lastAttr = lastTeamPetAttrs[data.id][v] or 0
                fellowData:SetAdditionalAttr(v, SDataUtil.Sub(SDataUtil.Add(eAttr,petAttr),lastAttr))
            elseif v >= Enum.HeroAttrType.STR_Percent then
                local eAttrPercent = fellowData:GetAdditionalAttrPercent(v)
                local lastAttr = lastTeamPetAttrs[data.id][v] or 0
                fellowData:SetAdditionalAttrPercent(v, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,petAttr),lastAttr))
            end

            lastTeamPetAttrs[data.id][v] = petAttr
        end
    end

    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:CalcSkillAttrs(fellowData, data, needRefresh)
    local skillTotalAttrs = data.skillData and data.skillData:GetUnlockSkillAttrs() or {}
    local lastSkillAttrs = lastTeamSkillAttrs[data.id]
    local attrValue = nil
    local changeNum = nil
    local isChanged = false
    for _,v in pairs(Enum.HeroAttrType) do
        attrValue = skillTotalAttrs[v]
        if not attrValue then attrValue = 0 end
        changeNum = attrValue - ((lastSkillAttrs == nil or not lastSkillAttrs[v]) and 0 or lastSkillAttrs[v])
        if changeNum ~= 0 then
            if v < Enum.HeroAttrType.STR_Percent then
                -- local val =  fellowData:GetAdditionalAttr(v) + changeNum
                local val = SDataUtil.Add(fellowData:GetAdditionalAttr(v),changeNum)
                fellowData:SetAdditionalAttr(v, val)
            else
                -- local val =  fellowData:GetAdditionalAttrPercent(v) + changeNum
                local val = SDataUtil.Add(fellowData:GetAdditionalAttrPercent(v),changeNum)
                fellowData:SetAdditionalAttrPercent(v, val)
            end
            isChanged = true
        end
    end
    if needRefresh then
        for _,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
    lastTeamSkillAttrs[data.id] = skillTotalAttrs
    if isChanged then
        attrDirty = true
    end
    return isChanged
end

function PartnerData:CalcKeepSakeAttrs(fellowData, data, needRefresh)
    local keepsakeMaps = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeMaps()
    local partnerCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId)
    local addAttrs = {}
    for k,v in pairs(keepsakeMaps) do
        local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(k)
        if cfgData and CommonUtil.EleInTable(partnerCfgData.JobType, cfgData.Job) then
            local attrs = cfgData["AddAttrLevel"..v]
            if attrs then
                for i = 1,#attrs do
                    local attrId = attrs[i][1]
                    local val1 = attrs[i][2]
                    if not addAttrs[attrId] then
                        addAttrs[attrId] = 0
                    end
                    addAttrs[attrId] = addAttrs[attrId] + (attrId > 21 and val1*0.0001 or val1)
                end
            end
        end
    end
    if not lastTeamKeepSakeAttrs[data.id] then
        lastTeamKeepSakeAttrs[data.id] = {}
    end
    for k,v in pairs(addAttrs) do
        if k <= Enum.HeroAttrType.RealHurt then
            local eAttr = fellowData:GetAdditionalAttr(k)
            local lastAttr = (lastTeamKeepSakeAttrs == nil and 0 or (lastTeamKeepSakeAttrs[data.id][k] or 0))
            fellowData:SetAdditionalAttr(k,  SDataUtil.Sub(SDataUtil.Add(eAttr,v),lastAttr))
        elseif k >= Enum.HeroAttrType.STR_Percent then
            local eAttrPercent = fellowData:GetAdditionalAttrPercent(k)
            local lastAttr = (lastTeamKeepSakeAttrs == nil and 0 or (lastTeamKeepSakeAttrs[data.id][k] or 0))
            fellowData:SetAdditionalAttrPercent(k, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,v),lastAttr))
        end
    end
    lastTeamKeepSakeAttrs[data.id] = addAttrs

    if needRefresh then
        for k,v in pairs(Enum.HeroAttrType) do
            data.attrs[v] = fellowData:GetFinalAttr(v)
        end
    end
end

function PartnerData:AddKeepSakeLvUpAttrs(keepsakeId, lv)
    if not lv then return end
    local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(keepsakeId)
    local addAttrs = {}
    if cfgData then
        local attrs = cfgData["AddAttrLevel"..lv]
        if attrs then
            for i = 1,#attrs do
                local attrId = attrs[i][1]
                local val1 = attrs[i][2]
                if not addAttrs[attrId] then
                    addAttrs[attrId] = 0
                end
                addAttrs[attrId] = addAttrs[attrId] + (attrId > 21 and val1*0.0001 or val1)
            end
        end
        if lv > 1 then
            attrs = cfgData["AddAttrLevel"..(lv - 1)]
            if attrs then
                for i = 1,#attrs do
                    local attrId = attrs[i][1]
                    local val1 = attrs[i][2]
                    if not addAttrs[attrId] then
                        addAttrs[attrId] = 0
                    end
                    addAttrs[attrId] = addAttrs[attrId] - (attrId > 21 and val1*0.0001 or val1)
                end
            end
        end
    else
        return
    end

    for i = 2, 6 do
        local fellowData = self:GetPartnerDataByUniqueId(i)
        if fellowData and fellowData.owned then
            local fellowActorData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(fellowData.id,fellowData.configId)
            local partnerCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(fellowData.configId)
            if CommonUtil.EleInTable(partnerCfgData.JobType, cfgData.Job) then
                for k,v in pairs(addAttrs) do
                    if k <= Enum.HeroAttrType.RealHurt then
                        local eAttr = fellowActorData:GetAdditionalAttr(k)
                        lastTeamKeepSakeAttrs[i][k] = (lastTeamKeepSakeAttrs[i][k] or 0) + v
                        fellowActorData:SetAdditionalAttr(k,  SDataUtil.Add(eAttr,v))
                    elseif k >= Enum.HeroAttrType.STR_Percent then
                        local eAttrPercent = fellowActorData:GetAdditionalAttrPercent(k)
                        lastTeamKeepSakeAttrs[i][k] = (lastTeamKeepSakeAttrs[i][k] or 0) + v
                        fellowActorData:SetAdditionalAttrPercent(k, SDataUtil.Add(eAttrPercent,v))
                    end
                end

                for k,v in pairs(addAttrs) do
                    fellowData.attrs[k] = fellowActorData:GetFinalAttr(k)
                end
            end
        end
    end
end

function PartnerData:InitPartnerAttrById(id, addAdvenceLv, addStrengthLv)
    local data = self:GetPartnerDataByUniqueId(id)
    self:InitPartnerAttr(data, addAdvenceLv, addStrengthLv)
end

function PartnerData:InitPartnerAttr(data, addAdvenceLv, addStrengthLv)
    local fellowData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(data.id,data.configId)
    fellowData.Level = data.baseLevel
    fellowData.StrengthLevel = data.strengthLevel

    lastTotalAttrs[data.id] = CommonUtil.TableClone(data.attrs)
    self:CalcSkillAttrs(fellowData, data, false)
    self:CalcAdvenceAttrs(fellowData, data, false, addAdvenceLv)
    self:CalcStrengthAttrs(fellowData, data, false, addStrengthLv)
    self:CalcEquipAttrs(fellowData, data, false)
    self:CalcCardAttrs(fellowData, data, false)
    self:CalcFashionAttrs(fellowData, data, false)
    self:CalcPetAttrs(fellowData, data, false)
    self:CalcKeepSakeAttrs(fellowData, data, true)
	ManagerContainer.LuaActorAttributeMgr:SyncServerActorData(fellowData)
end

function PartnerData:InitPartnerSkill(data, skill)
    local skillData = data.skillData
    if not skillData then
        skillData = SkillData:new()
        data.skillData = skillData
    end
    skillData:InitData(skill)
end

function PartnerData:SaveLastTotalAttr()
    for _,v in pairs(self.data.partnerData.heroDatas) do
        lastTotalAttrs[v.id] = CommonUtil.TableClone(v.attrs)
    end   
end

function PartnerData:GetLastTotalAttrs(id)
    return lastTotalAttrs[id]
end

function PartnerData:GetPartnerDataBySlotIndex(id)
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            return v
        end
    end
    return nil
end

function PartnerData:InitPartnerAttrFromBattle()
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            self:InitPartnerAttr(v)
        end

        --LogError(Inspect(v))
    end
end

function PartnerData:InitPartnerAttrById(id)
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            self:InitPartnerAttr(v)
            return
        end
    end
end

function PartnerData:GetPartnerDatas()
    if self.data then
        if self.data.partnerData then
            return self.data.partnerData.heroDatas
        end
    end
    return nil
end

function PartnerData:SortPartnerData()
    local partnerDatas = self:GetPartnerDatas()
	local sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		sortedPartnerDatas[#sortedPartnerDatas + 1] = v
	end
	table.sort(sortedPartnerDatas, function (a, b)
		if a.owned and b.owned then
			return a.post < b.post
		else
			if a.owned and not b.owned then
				return true
			elseif not a.owned and b.owned then
				return false
			else
				return a.post < b.post
			end
		end
    end)
    return sortedPartnerDatas
end

function PartnerData:GetOwnedPartnerCount()
    local count = 0
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            count = count + 1
        end
    end
    return count
end

function PartnerData:GetBattlePartnerDatas(userAttrsChanged, ignore)
    if not userAttrsChanged and not ignore then
        if not attrDirty then return nil end
    end

    local list = {}
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.isBattle and v.owned then
            local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(v.id)
            local petId = v.battlePetId
            local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)

            local count = ManagerContainer.LuaActorDataMgr:GetFellowActorDataCountByUid(v.id)
            v.isTransferred = count > 1
            
            local data = {
                uid = v.id,
                id = v.configId,
                lv = v.baseLevel,
                advanceLevel = v.advanceLevel,
                -- skills = self:GetHeroUsedSkill(v),
                skills = v.skillData:GetUsedSkills(),
                buffs = ManagerContainer.DataMgr.UserData:GetCardBuffs(index),
                role = false,
                mainRole = false,
                isTransferred = v.isTransferred or false,

                petId = petId > 0 and petId + Enum.ActorUidField.Pet or 0,
                petBaseId = petData and petData.cfgId or 0,
            }
            list[#list + 1] = data

            --神器技能替换
            CommonUtil.ReplaceBattleSkillBySkillEquip(v, data.skills)

            lastTeamAdvenceLvs[v.id] = v.advanceLevel
            lastTeamStrengthLvs[v.id] = v.strengthLevel
            --lastTeamEquipAttrs[v.id] = lastTeamEquipAttrs[v.id]
            --lastTeamCardAttrs[v.id] = lastTeamCardAttrs[v.id]

            v.isTransferred = false
        end
    end

    attrDirty = false
    return list
end

function PartnerData:GetAllPartnerTeamDatas()
    local list = {}
    for _, v in pairs(self.data.partnerData.heroDatas) do
        if v.owned then
            local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(v.id)
            list[#list + 1] =
            {
                uid = v.id,
                id = v.configId,
                lv = v.baseLevel,
                advanceLevel = v.advanceLevel,
                skills = v.skillData:GetUsedSkills(),
                -- skills = self:GetHeroUsedSkill(v),
                buffs = ManagerContainer.DataMgr.UserData:GetCardBuffs(index)
            }
        end
    end
    return list
end

function PartnerData:GetPartnerDataById(id)
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.configId == id then
            return v
        end
    end
    return nil
end

function PartnerData:GetPartnerDataByOriId(id)
    for _,v in pairs(self.data.partnerData.heroDatas) do
        local oriPartnerCfgId = ManagerContainer.CfgMgr:GetOriPartnerDataByAdvenceId(v.configId)
        if oriPartnerCfgId.ParterId == id then
            return v
        end
    end
    return nil
end

function PartnerData:GetPartnerDataByUniqueId(id)
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            return v
        end
    end
    return nil
end

--出战角色获取
function PartnerData:GetPartnersDataByInBattle()
    local tbBattlePartner = {}
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.isBattle and v.owned then
            table.insert(tbBattlePartner,v)
        end
    end
    return tbBattlePartner
end

function PartnerData:PartnerDataChangeLv(id, lv)
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            v.baseLevel = lv
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerLvUpNotify(v.id)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_LV_CHANGED, id)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_TRAIN_ATTRS)
            return
        end
    end
end

function PartnerData:PartnerDataChangeAdvencLv(id, lv)
    for _,v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            v.advanceLevel = lv
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerLvUpNotify(v.id)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ADVENCE_SUCCESS)
            return
        end
    end
end

function PartnerData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_HERO_INFO_NTF, function(data)
        local addParterMap, battleStatus, needRpRefreshIds, changePetIds = self:RefreshPartnerDatas(data.hero_data)

        if #needRpRefreshIds > 0 then
            for _,v in pairs(needRpRefreshIds) do
                ManagerContainer.RedPointMgr.HeroRPCtr:PartnerRedPointNotifyById(v)
            end
            ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardRP()
        end
        if battleStatus then
            battlePartnerChanged = true
        end
        if next(addParterMap) ~= nil then
            for k,v in pairs(addParterMap) do
                local id = v
                local heroData = self:GetPartnerDataByUniqueId(id)
                self:InitPartnerAttr(heroData)
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_PARTER_ADD, addParterMap)
        end

        if battlePartnerChanged and partnerChangeTimer == nil then
            partnerChangeTimer = ManagerContainer.LuaTimerMgr:AddTimer(100, 1, self, self.SetTeamData, nil)
        end

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_LIST_CHANGE_NOTICE)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_UI_REDPOINT_CHANGE)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_RP_REFRESH)
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_LEVEL_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:PartnerDataChangeLv(data.hero_id, data.hero_level)
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(data.hero_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_ADVANCE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:PartnerDataChangeAdvencLv(data.hero_id, data.advance_level)
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(data.hero_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_BATTLE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_BATTLE_REQ_SUCCESS)
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_STRENGTH_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerStrengthNotify(data.hero_id)
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(data.hero_id)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_STRENGTH_SUCCESS)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_ACTIVE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_ACTIVE_SUCCESS, data.hero_id)
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerRecruitNotify()
        end
    end)
end

function PartnerData:SetTeamData()
    if not ManagerContainer.LuaUIMgr:IsInRoleUI() then
        ManagerContainer.LuaBattleMgr:SetTeamData()
    end
    partnerChangeTimer = nil
    battlePartnerChanged = false
end

function PartnerData:Clear()
    if partnerChangeTimer ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(partnerChangeTimer)
        partnerChangeTimer = nil
    end

    if self.data.partnerData and self.data.partnerData.heroDatas then
        for _,v in pairs(self.data.partnerData.heroDatas) do
            ManagerContainer.LuaActorDataMgr:DeleteActorDataById(v.id)
        end
    end

    needNtfTeamBattle = true
    attrDirty = false

    lastTeamPetAttrs = {}
    lastTeamEquipAttrs = {}
    lastTeamCardAttrs = {}
    lastTeamAdvenceLvs = {}
    lastTeamStrengthLvs = {}
    lastTeamPointAttrs = {}
    lastTeamBaseAttrs = {}
    lastTeamSkillAttrs = {}
    lastTotalAttrs = {}

    self.data = {}
end

function PartnerData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function PartnerData:UnRegisterNetEvents()
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("SC_ROLE_HERO_INFO_NTF")
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("SC_HERO_LEVEL_UP_ACK")
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("SC_HERO_ADVANCE_ACK")
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("CS_HERO_BATTLE_ACK")
end

-- function PartnerData:SetHeroSkills(hero)
--     local dirty = false

--     if hero.skills == nil then
--         hero.skills = {}
--     end

--     local parternCfg = ManagerContainer.CfgMgr:GetPartnerDataById(hero.configId)
--     if parternCfg == nil then
--         return
--     end

--     local paternStepCfg = ManagerContainer.CfgMgr:GetParterProgressById(hero.configId)
--     if paternStepCfg == nil then
--         return
--     end

--     local openSkill = paternStepCfg.OpenSkill
--     local initialSkillId = parternCfg.InitialSkill

--     if initialSkillId > 0 then
--         local lv,maxLv,nextPTLv = self:GetSkillLvInfo(paternStepCfg,hero.baseLevel,1)
--         local skill = self:GetHeroSkillById(hero.skills,initialSkillId)
--         if skill == nil then
--             skill =  SkillItem:new(initialSkillId,lv,true,0);
--             skill.maxLevel = maxLv
--             hero.skills[#hero.skills+1] = skill
--         else
--             if skill.level ~= lv then
--                 dirty = true
--             end
            
--             skill:SetLevel(lv)
--             skill.maxLevel = maxLv
--         end
--         skill.nextLevelPartenrLv = nextPTLv
--     end

--     for i = 1, #openSkill do
--         local skillId = openSkill[i]
--         if skillId~= nil and skillId > 0 then
--             local lv,maxLv,nextPTLv = self:GetSkillLvInfo(paternStepCfg,hero.baseLevel,i+1)
--             local skill = self:GetHeroSkillById(hero.skills,skillId)
--             local unlock = hero.advanceLevel >= i;
--             if skill == nil then
--                 skill =  SkillItem:new(skillId,lv,unlock,0);
--                 skill.maxLevel = maxLv
--                 hero.skills[#hero.skills+1] = skill
--             else
--                 skill:SetLevel(lv)
--                 skill.maxLevel = maxLv
--             end
--             skill.nextLevelPartenrLv = nextPTLv
--             if unlock then
--                 skill:Unlock()
--             else
--                 skill.unlockCondition = i
--             end
--         end
--     end

--     if dirty then
--         ManagerContainer.LuaBattleMgr:UpdateTeamSkills()
--     end
--     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_PARTENR_SKILL_REFRESH,hero.configId)
-- end

-- function PartnerData:GetHeroSkillById(skillList,skillId)
--     if skillList == nil then
--         return nil
--     end

--     for idx =1,#skillList do
--         local skill = skillList[idx]
--         if skill.skillId == skillId then
--             return skill
--         end
--     end
--     return nil
-- end

function PartnerData:GetHeroUsedSkill(hero)
    if hero == nil or hero.skills == nil then
        return nil
    end

    local usedSkills = {}
    for i =1, #hero.skills do
        local skill = hero.skills[i]
        if skill.isUnlocked then
            usedSkills[#usedSkills+1] = {skillId = skill.skillId, lv = skill.level}
        end
    end
    return usedSkills
end

function PartnerData:GetSkillLvInfo(paternStepCfg,heroLv,skillIdx)
    if paternStepCfg == nil then
        return 1,1
    end

    if skillIdx > #paternStepCfg.SkillUp then
        return 1,1
    end

    local temp = paternStepCfg.SkillUp[skillIdx]
    if temp == nil then
        return 1,1
    end

    local lv = 1
    local maxLv = 1 + #temp
    local nextPTLv = heroLv
    for i = 1, #temp do
        if heroLv >= temp[i] then
            lv = lv + 1
        else
            nextPTLv = temp[i]
            break
        end
    end
    return lv, maxLv,nextPTLv
end

function PartnerData:GetHeroLv(id)
    local partnerData = self:GetPartnerDataByUniqueId(id)
    return partnerData and partnerData.baseLevel or 0
end

function PartnerData:GetHeroQuality(id)
    local partnerData = self:GetPartnerDataByUniqueId(id)
    return partnerData and partnerData.strengthLevel or 0
end

function PartnerData:GetHeroIsBattle(id)
    local partnerData = self:GetPartnerDataByUniqueId(id)
    return partnerData and partnerData.isBattle or false
end

function PartnerData:GetHeroCfgId(id)
    local partnerData = self:GetPartnerDataByUniqueId(id)
    return partnerData and partnerData.configId or 0
end

function PartnerData:GeSkillData(id)
    local partnerData = self:GetPartnerDataByUniqueId(id)
    return partnerData and partnerData.skillData or nil
end

function PartnerData:OnJobSkillDataChanged(id)
    local data = self:GetPartnerDataByUniqueId(id)
    if not data then return false end
    if not data.owned then return false end
    local fellowData = ManagerContainer.LuaActorDataMgr:GetFellowActorData(data.id,data.configId)
    fellowData.Level = data.baseLevel
    return self:CalcSkillAttrs(fellowData, data, true)
end

function PartnerData:GetLastBaseAttrs(id)
    return lastTeamBaseAttrs[id]
end

function PartnerData:GetRoleDataAttrPoints(id)
    for k,v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id then
            return v.attrPoint
        end
    end
    return 0
end

function PartnerData:GetPointAttr(id, type)
    for k,v in pairs(self.data.partnerData.heroDatas) do
        if v.id == id and v.owned then
            for _,v1 in pairs(v.attrList) do
                if v1.key == type then
                    return v1.value
                end
            end
        end
    end
    return 0
end

function PartnerData:UpdateHeroExtGoShowData(heroData)
    CommonUtil.UpdateHeroExtGoShowData(heroData)
end

return PartnerData