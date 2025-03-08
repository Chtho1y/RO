local PetAttrData = class("PetAttrData")
local CreatePetActorSystem = require("CreatePetActorSystem")

function PetAttrData:ctor()
    self.data = {}

    --self:InitData(pets)
    if not self.data.petDatas then
        self.data.petDatas = {}
    end
    if not self.data.petDatasMap then
        self.data.petDatasMap = {}
    end
end

function PetAttrData:InitData(petList)
    if not petList then return end

    for _,v in pairs(petList) do
        if not self.data.petDatasMap[v.id] then
            local data = ProtocalDataNormal.ParsePetData(v)
            self.data.petDatas[#self.data.petDatas + 1] = data
            self.data.petDatasMap[data.id] = data

            if data.isBattle then
                self:GetPetActorData(data.id)
                self:RefreshHeroPetState(0, data.heroId, data.id)
            end
            self:UpdatePetExtGoShowData(data)
            -- self:RefreshPetStampSuit(data)
            -- self:CalcPetStampAttrs(data)

            -- data.oldSlots = clone(data.slots)
            -- data.oldStampSuit = clone(data.stampSuit)
        else
            --local data = ProtocalDataNormal.ParsePetData(v)
            --data.totalFightPower = ManagerContainer.DataMgr.PetDataMgr:GetTotalFightPower(v.id)
            --self.data.petDatasMap[v.id] = data
            --self:RefreshPetStampSuit(data)
            --self:RefreshPetDataList(data)
            --if data.isBattle then
            --    self:GetPetActorData(data.id)
            --    self:RefreshHeroPetState(0, data.heroId, data.id)
            --end
        end
        self:CalcBaseFightPower(self.data.petDatasMap[v.id])
    end

    CommonUtil.ArraySortSelections(self.data.petDatas, Enum.TableSortRule.Down, "isBattle", "quality", "advanceLevel", "level", "cfgId")
end

function PetAttrData:InitPetDetailDatas(petInfoList)
    for _,v in pairs(petInfoList) do
        local data = self.data.petDatasMap[v.id]
        if data then
            data = ProtocalDataNormal.ParsePetData(v, data)
            data.is_queried = true

            if data.isBattle then
                self:GetPetActorData(data.id)
                self:RefreshHeroPetState(0, data.heroId, data.id)
            end

            self:RefreshPetStampSuit(data)
            self:CalcPetStampAttrs(data)

            data.oldSlots = clone(data.slots)
            data.oldStampSuit = clone(data.stampSuit)
            self:CalcBaseFightPower(self.data.petDatasMap[v.id])
            self:UpdatePetExtGoShowData(data)
        end
    end

end

function PetAttrData:RefreshData(changeList, delList)
    if not self.data.petDatas then
        self.data.petDatas = {}
    end
    if not self.data.petDatasMap then
        self.data.petDatasMap = {}
    end

    local addOrDelTrigger = false
    local slotChanged = false
    if changeList then
        for _,v in pairs(changeList) do
            local data = self.data.petDatasMap[v.id]
            if data then
                local levelChanged = data.level ~= v.level
                data.level = v.level

                local advenceChanged = data.advanceLevel ~= v.advance_level
                data.advanceLevel = v.advance_level

                if data.heroId ~= v.hero_id then
                    ManagerContainer.DataMgr.PetDataMgr:RecalcBattlePetRelationAttr(false, v.id)
                    if data.heroId > 0 then
                        self:RefreshHeroAttr(data.heroId)
                    end
                    if v.hero_id > 0 then
                        ManagerContainer.DataMgr.PetDataMgr:RecalcBattlePetRelationAttr(true, v.id)
                        --self:RefreshHeroAttr(v.hero_id)
                    end

                    self:RefreshHeroPetState(data.heroId, v.hero_id, v.id)
                end
                if data.heroId ~= v.hero_id then
                    slotChanged = true
                end
                data.heroId = v.hero_id
                data.isBattle = data.heroId > 0

                local skillUp = false
                data.totalSkillUpCount = 0
                for k1,v1 in pairs(data.skillList) do
                    if v1.level ~= v.skill_list[k1].level then
                        skillUp = true
                    end
                    v1.level = v.skill_list[k1].level
                    v1.rate = v.skill_list[k1].rate

                    data.totalSkillUpCount = data.totalSkillUpCount + (v1.level - 1)
                end

                if levelChanged then
                    local actorData = self:GetPetActorData(v.id)
                    actorData.Level = data.level
                end
                if advenceChanged then
                    local actorData = self:GetPetActorData(v.id)
                    actorData:SetStep(data.advanceLevel)
                    self:CalcPetAdvenceAttr(true, data.id, data.cfgId, data.advanceLevel)
                end
                if skillUp then
                    local actorData = self:GetPetActorData(v.id)
                    local skillParam = CreatePetActorSystem:CreateSkillParamDatas(data.skillList)
                    actorData:RefreshSkills(skillParam)
                end

                local slotsChanged1 = false
                data.oldSlots = clone(data.slots)
                data.oldStampSuit = clone(data.stampSuit)
                for _,v1 in pairs(v.slot_equip_list) do
                    if not data.slots[v1.idx] then
                        data.slots[v1.idx] = {}
                        data.slots[v1.idx].idx = v1.idx
                    end
                    if not slotsChanged1 then
                        local slotData = data.slots[v1.idx]
                        local stampId = slotData.stampId
                        local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(stampId)
                        slotsChanged1 = stampData and (slotData.stampId ~= v1.equip_id or stampData.oldLv ~= stampData.lv) or v1.equip_id > 0
                        if not slotChanged and slotsChanged1 then
                            slotChanged = slotsChanged1
                        end
                    end
                    data.slots[v1.idx].stampId = v1.equip_id
                    data.slots[v1.idx].stoneIdList = v1.stone_id_list
                end

                if slotsChanged1 then
                    self:RefreshPetStampSuit(data)
                end

                if levelChanged or advenceChanged or slotsChanged1 then
                    self:RefreshMasterAttr(v.id)
                end

                data.qiyueHeroId = v.qiyue_hero_id
            else
                data = ProtocalDataNormal.ParsePetData(v)
                self.data.petDatas[#self.data.petDatas + 1] = data
                self.data.petDatasMap[data.id] = data
                self:RefreshPetStampSuit(data)

                addOrDelTrigger = true
            end
            self:UpdatePetExtGoShowData(data)
            self:CalcBaseFightPower(data)
        end
    end

    if delList then
        addOrDelTrigger = true
        for i = #self.data.petDatas, 1, -1 do
            local data = self.data.petDatas[i]
            if CommonUtil.EleInTable(data.id, delList) then
                table.remove(self.data.petDatas, i)
                self.data.petDatasMap[data.id] = nil

                ManagerContainer.LuaActorDataMgr:DeletePetActorData(data.id)
            end
        end

        ManagerContainer.DataMgr.PetDataMgr:DeleteMySupportPets(delList)
    end

    CommonUtil.ArraySortSelections(self.data.petDatas, Enum.TableSortRule.Down, "isBattle", "advanceLevel", "level", "quality", "cfgId")

    if addOrDelTrigger then
        ManagerContainer.DataMgr.PetDataMgr:RefreshRelationRPStates()
    end
    return slotChanged
end

function PetAttrData:RefreshPetDataList(data)
    for i = 1,#self.data.petDatas do
        if data.id == self.data.petDatas[i].id then
            self.data.petDatas[i] = data
            return
        end
    end
end

function PetAttrData:CalcBaseFightPower(petData)
    local curLv = petData.level
    local curData = ManagerContainer.CfgMgr:GetPetExpCfgDataById(curLv)
    local lvFightPower = curData["Capacity"..petData.quality]

    local curAdvanceLv = petData.advanceLevel
    local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)
    local advanceFightPower = 0
    for i = 1,curAdvanceLv do
        advanceFightPower = advanceFightPower + petProgressCfgData.AddFight[i]
    end

    petData.baseFightPower = math.floor((lvFightPower + advanceFightPower)/10)
end

function PetAttrData:ShowAdvanceFightPower()
    local petData = self.controller:GetCurPetData()
    local lastAdvanceLv = petData.advanceLevel - 1
    local curAdvanceLv = petData.advanceLevel

    local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)
    local lastFightPower = lastAdvanceLv > 0 and petProgressCfgData.AddFight[lastAdvanceLv] or 0
    local curFightPower = petProgressCfgData.AddFight[curAdvanceLv]

    local data = {startNum = lastFightPower, endNum = curFightPower}
    ManagerContainer.LuaUIMgr:FightPowerAddNotice(data)
end

function PetAttrData:GetPetDataById(id)
    return self.data.petDatasMap and self.data.petDatasMap[id] or nil
end
function PetAttrData:GetPetCountById(id)
    local count = 0
    for k, v in pairs(self.data.petDatasMap) do
        if v.cfgId == id then
            count = count + 1
        end
    end
    return count
end

function PetAttrData:GetPetDataByIdAndLv(id,lv,skillLv)
    local list = {}
    for k, v in pairs(self.data.petDatasMap) do
        if v.cfgId == id and v.level >= lv and self:GetSkillLv(v.skillList) >= skillLv and not v.isBattle then
            list[#list + 1] = v
        end
    end
    CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "isSupport","isRelevant","quality", "advanceLevel", "level", "cfgId")
    return list
end

function PetAttrData:GetPetDataByQulityAndLv(quality,lv,skillLv)
    local list = {}
    for k, v in pairs(self.data.petDatasMap) do
        if v.quality == quality and v.level >= lv and self:GetSkillLv(v.skillList) >= skillLv and not v.isBattle then
            list[#list + 1] = v
        end
    end
    CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "isSupport","isRelevant","quality", "advanceLevel", "level", "cfgId")
    return list
end

function PetAttrData:GetPetCountByIdAndLv(id,lv,skillLv)
    local count = 0
    for k, v in pairs(self.data.petDatasMap) do
        if v.cfgId == id and v.level >= lv and self:GetSkillLv(v.skillList) >= skillLv and not v.isBattle then
            count = count + 1
        end
    end
    return count
end

function PetAttrData:GetPetCountByQulityAndLv(quality,lv,skillLv)
    local count = 0
    for k, v in pairs(self.data.petDatasMap) do
        if v.quality == quality and v.level >= lv and self:GetSkillLv(v.skillList) >= skillLv and not v.isBattle then
            count = count + 1
        end
    end
    return count
end

function PetAttrData:GetSkillLv(skillList)
    local count = 0
    if skillList and #skillList > 0 then
        for i = 1, #skillList do
            count = count + skillList[i].level
        end
    end
    return count
end

function PetAttrData:GetNextSortId(id, isAdd)
    for i = 1,#self.data.petDatas do
        local data = self.data.petDatas[i]
        if data.id == id then
            if isAdd then
                if self.data.petDatas[i + 1] then
                    return self.data.petDatas[i + 1].id
                else
                    return self.data.petDatas[1].id
                end
            else
                if self.data.petDatas[i - 1] then
                    return self.data.petDatas[i - 1].id
                else
                    return self.data.petDatas[#self.data.petDatas].id
                end
            end
            break
        end
    end
    return id
end

function PetAttrData:GetPetActorData(id)
    local data = self.data.petDatasMap[id]
    if not data then return end

    local uniqueId = id + Enum.ActorUidField.Pet
    local actorData = ManagerContainer.LuaActorDataMgr:GetPetDataById(uniqueId)
    if not actorData then
        actorData = CreatePetActorSystem:CreatePetActorData(uniqueId, data.cfgId, data.level, data.skillList)
        actorData:SetStep(data.advanceLevel)
        self:CalcPetAdvenceAttr(false, data.id, data.cfgId, data.advanceLevel)
    end
    return actorData
end

function PetAttrData:GetPetDatas()
    return self.data.petDatas
end

function PetAttrData:SendPetLvUp(id)
    local data = self.data.petDatasMap[id]
    if not data then return end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_LEVEL_UP_REQ, {pet_id = data.id})
end

function PetAttrData:SendPetAdvence(id, costList)
    local data = self.data.petDatasMap[id]
    if not data then return end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_ADVANCE_REQ, {pet_id = data.id, pet_list = costList})
end

function PetAttrData:GetSomePetMaxAdvLvByCfgId(cfgId)
    local advLv = 0
    local petId = 0
    for _,v in pairs(self.data.petDatas) do
        if v.cfgId == cfgId and v.advanceLevel >= advLv then
            advLv = v.advanceLevel
            petId = v.id
        end
    end
    return advLv, petId
end

function PetAttrData:SendPetSkillUp(id, matId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_SKILL_LEVEL_UP_REQ, {pet_id = id, cost_pet_id = matId})
end

function PetAttrData:SendPetBattle(map)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_BATTLE_REQ, {battle_list = map})
end

function PetAttrData:CalcPetAdvenceAttr(isAdd, id, cfgId, advLv)
    if isAdd then
        self:AddAdvenceAttrs(id, cfgId, advLv)
    else
        for i = 1, advLv do
            self:AddAdvenceAttrs(id, cfgId, i)
        end
    end
end

function PetAttrData:AddAdvenceAttrs(id, cfgId, advLv)
    local cfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(cfgId)
    local attrs = cfgData["Attribute"..advLv]
    if not attrs then
        return
    end

    local actorData = self:GetPetActorData(id)
    if not actorData then
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

function PetAttrData:RefreshMasterAttr(id)
    local petData = self:GetPetDataById(id)
    if petData.heroId == 1 then
        ManagerContainer.DataMgr.UserData:CalcPetAttrs()
    elseif petData.heroId > 1 then
        ManagerContainer.DataMgr.PartnerData:CalcPetAttrsById(petData.heroId)
    end
end

function PetAttrData:RefreshHeroPetState(downHeroId, onHeroId, petId)
    if downHeroId > 0 then
        local downHeroData = CommonUtil.GetHeroActorDataByUid(downHeroId)
        if downHeroData then
            downHeroData:SetPet(nil)
        end
    end
    if onHeroId > 0 then
        local onHeroData = CommonUtil.GetHeroActorDataByUid(onHeroId)
        local petData = self:GetPetActorData(petId)
        if onHeroData and petData then
            onHeroData:SetPet(petData)
        end
    end
end

function PetAttrData:RefreshHeroAttr(heroId)
    if heroId == 1 then
        ManagerContainer.DataMgr.UserData:CalcPetAttrs()
    elseif heroId > 1 then
        ManagerContainer.DataMgr.PartnerData:CalcPetAttrsById(heroId)
    end
end

function PetAttrData:RefreshPetStampSuit(petData)
    if not petData then return end

    local slots = petData.slots
    local qualityCount = {0,0,0,0,0}
    local slotQualityList = {}
    local curQuality = 0
    for _,v in pairs(slots) do
        local stampId = v.stampId
        local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(stampId)
        if stampData then
            local quality = stampData.cfgData.Quality
            slotQualityList[v.idx] = quality
            for i = 1, #qualityCount do
                if i <= quality then
                    qualityCount[i] = qualityCount[i] + 1
                end
            end
        end
    end

    for i = 1, #qualityCount do
        local suitCfgData = ManagerContainer.CfgMgr:GetPetEquipSuitCfgDataByQuality(i)
        if suitCfgData then
            if qualityCount[i] >= suitCfgData.Amount[1][2] then
                curQuality = i
            end
        end
    end

    local curSuitCount = curQuality > 0 and qualityCount[curQuality] or qualityCount[1]
    local nextSuitCount = curQuality > 0 and (curQuality >= 6 and 0 or qualityCount[curQuality + 1]) or qualityCount[2]
    petData.stampSuit = {curQuality, curSuitCount, nextSuitCount, slotQualityList}
end

--宠物印记修改 属性
local lastAttrs, newAttrs
function PetAttrData:CalcPetStampAttrs(petData)
    if not petData then return end

    lastAttrs, newAttrs = {}, {}
    local actorData = self:GetPetActorData(petData.id)
    for k,v in pairs(Enum.HeroAttrType) do
        lastAttrs[v] = SDataUtil.InvConvertDouble(actorData:GetFinalAttr(v))
    end

    --减去原来的
    self:CalcPetStampAttrs1(petData, true)
    --加上现在的
    self:CalcPetStampAttrs1(petData, false)

    for k,v in pairs(Enum.HeroAttrType) do
        newAttrs[v] = SDataUtil.InvConvertDouble(actorData:GetFinalAttr(v))
    end

    ManagerContainer.LuaUIMgr:AttrNoticeDisplay1({lastAttrs, newAttrs})
end

function PetAttrData:CalcPetStampAttrs1(petData, isMinus)
    if isMinus then
        if not petData.oldSlots or not petData.oldStampSuit then return end

        local attrs = self:CalcPetStampAttrs2(petData.oldSlots, petData.oldStampSuit, true)
        local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(petData.id)
        if not petActorData then return end

        for k,v in pairs(attrs) do
            if k <= Enum.HeroAttrType.RealHurt then
                local eAttr = petActorData:GetAdditionalAttr(k)
                local value = SDataUtil.InvConvertDouble(SDataUtil.Sub(eAttr,v))
                if value < 0 then
                    value = 0
                end
                petActorData:SetAdditionalAttr(k, value)
            elseif k >= Enum.HeroAttrType.STR_Percent then
                local eAttr = petActorData:GetAdditionalAttrPercent(k)
                local value = SDataUtil.InvConvertDouble(SDataUtil.Sub(eAttr,v))
                if value < 0 then
                    value = 0
                end
                petActorData:SetAdditionalAttrPercent(k, value)
            end
        end
    else
        if not petData.slots or not petData.stampSuit then return end

        local attrs = self:CalcPetStampAttrs2(petData.slots, petData.stampSuit)
        local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(petData.id)
        if not petActorData then return end

        for k,v in pairs(attrs) do
            if k <= Enum.HeroAttrType.RealHurt then
                local eAttr = petActorData:GetAdditionalAttr(k)
                local value = SDataUtil.InvConvertDouble(SDataUtil.Add(eAttr,v))
                petActorData:SetAdditionalAttr(k, value)
            elseif k >= Enum.HeroAttrType.STR_Percent then
                local eAttr = petActorData:GetAdditionalAttrPercent(k)
                local value = SDataUtil.InvConvertDouble(SDataUtil.Add(eAttr,v))
                petActorData:SetAdditionalAttrPercent(k, value)
            end
        end
    end
end

function PetAttrData:CalcPetStampAttrs2(slots, stampSuit, isOld)
    local stampAttrs = {}
    for _,v in pairs(slots) do
        local stampId = v.stampId
        local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(stampId)
        if stampData then
            local lv = isOld and stampData.oldLv or stampData.lv
            local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(lv, stampData.cfgId)
            for _,v1 in pairs(lvCfgData.Nature) do
                local key = v1[1]
                local val = v1[2]
                if not stampAttrs[key] then
                    stampAttrs[key] = 0
                end
                stampAttrs[key] = stampAttrs[key] + val
            end
        end
    end

    local suitLv = stampSuit[1]
    if suitLv > 0 then
        local suitCfgData = ManagerContainer.CfgMgr:GetPetEquipSuitCfgDataByQuality(suitLv)
        for _,v1 in pairs(suitCfgData.Suit) do
            local key = v1[1]
            local val = v1[2]
            if not stampAttrs[key] then
                stampAttrs[key] = 0
            end
            if key < Enum.HeroAttrType.STR_Percent then
                stampAttrs[key] = stampAttrs[key] + val
            else
                stampAttrs[key] = stampAttrs[key] + val*0.0001
            end
        end
    end
    return stampAttrs
end

function PetAttrData:RefreshPetStampAttrs(id)
    local petData = self:GetPetDataById(id)
    if petData then
        self:RefreshPetStampSuit(petData)
        self:RefreshMasterAttr(id)
    end
end

function PetAttrData:GetAllBattlePetDatas()
    local list = {}
    for _,v in pairs(self.data.petDatas) do
        if v.isBattle then
            list[#list + 1] = v
        end
    end
    return list
end

function PetAttrData:UpdatePetExtGoShowData(petData)
    if not petData or petData.heroId == 0 then return end

    local heroData = CommonUtil.GetHeroLogicDataByUid(petData.heroId)
    CommonUtil.UpdatePetExtGoShowData(petData, heroData)
end

function PetAttrData:UpdatePetExtGoShowData1(heroData)
    if not heroData or heroData.battlePetId == 0 then return end

    local petData = self:GetPetDataById(heroData.battlePetId)
    CommonUtil.UpdatePetExtGoShowData(petData, heroData)
end

function PetAttrData:RegisterNetEvents()

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_LEVEL_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_LVUP_REFRESH_NTF)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_ADVANCE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_ADVENCE_REFRESH_NTF)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_SKILL_LEVEL_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_SKILLUP_SUCCESS_NTF, data.skill_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_BATTLE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_BATTLE_SUCCESS_NTF, true)
        elseif data.error == Enum.NetErrorCode.ERROR_PET_BATTLE_REPEATED then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_BATTLE_SUCCESS_NTF, false)
        end
        ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
    end)
end

function PetAttrData:Clear()
    self.data = {}
    if not self.data.petDatas then
        self.data.petDatas = {}
    end
    if not self.data.petDatasMap then
        self.data.petDatasMap = {}
    end
end

function PetAttrData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function PetAttrData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_LEVEL_UP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_ADVANCE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_SKILL_LEVEL_UP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_BATTLE_ACK)
end

return PetAttrData