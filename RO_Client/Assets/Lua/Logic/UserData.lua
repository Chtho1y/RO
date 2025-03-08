local UserData = class("UserData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")
local LuaToCSData = require("LuaToCSData")
local SkillData = require("SkillData")
local petStampRPItems

local baseAttrs
local lastEquipAttrs
local lastCardAttrs
local lastFashionAttrs
local lastTeamEquipAttrs
local lastTeamCardAttrs
local lastPointAttrs
local lastBaseAttrs
local lastSkillAttrs
local lastPetAttrs
local lastHeadFrameAttrs
local lastKeepSakeAttrs

local lastTotalAttrs

local attrsChanged = false

local AttrFilterList
function UserData:ctor()
    self.data = {}
    self.initedOver = false
end

function UserData:InitRoleBaseData(roleBase)
    local baseAttr = SInt.Convert(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_base_attr_id))
    baseAttrs = {[Enum.HeroAttrType.STR] = baseAttr, [Enum.HeroAttrType.AGI] = baseAttr, [Enum.HeroAttrType.INT] = baseAttr,
                 [Enum.HeroAttrType.DEX] = baseAttr, [Enum.HeroAttrType.VIT] = baseAttr, [Enum.HeroAttrType.LUK] = baseAttr}
    local oldUid
    if self.data.roleBase == nil then
        self.data.roleBase = {}
    else
        oldUid = self.data.roleBase.uid
    end
    self.data.roleBase.uid              = roleBase.id
    self.data.roleBase.nickname         = roleBase.nick_name
    self.data.roleBase.desc             = roleBase.desc
    --self.data.roleBase.headPortraitId   = roleBase.head_id
    self.data.roleBase.coin             = roleBase.coin
    self.data.roleBase.diamond          = roleBase.rmb
    self.data.roleBase.sex              = roleBase.sex
    self.data.roleBase.country          = roleBase.country
    self.data.roleBase.guideId          = roleBase.guide_id
    self.data.roleBase.vipLv            = roleBase.vip_level
    self.data.roleBase.questionReward   = roleBase.question_reward
	self.data.roleBase.RepressSkillPvpVal   = roleBase.repress_skill_pvp_val

    --LogError(tostring(self.data.roleBase.uid))
    ManagerContainer.DataMgr.HeadFrameDataMgr:InitData(roleBase.head_Info)
    self:InitRoleRes(roleBase.res_list)
    self:InitAdditionalRoleData(roleBase.role_data)
    self:InitViewData(roleBase.fashion_data)
    if oldUid ~= self.data.roleBase.uid then
        ManagerContainer.DataMgr.ForceGuideData:InitForceGuideData(roleBase.cguide)
    end
end

function UserData:InitRoleRes(resList)
    local resMap = {}
    local res = nil
    for i = 1, #resList do
        res = resList[i]
        resMap[res.key] = res.value
    end
    self.data.roleBase.resMap = resMap
    for k,v in pairs(self.data.roleBase.resMap) do
        self:NewResRefreshRP(k)
    end
end

function UserData:NewResRefreshRP(cfgId)
    if not petStampRPItems then
        local val = GlobalConfig.Instance:GetConfigStrValue(321)
        if val ~= "" and val ~= nil then
            petStampRPItems = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end
    if CommonUtil.EleInTable(tostring(cfgId), petStampRPItems) then
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()
    end
end

function UserData:GetUserId()
    if self.data.roleBase == nil then
        return 0
    end

    return self.data.roleBase.uid
end

function UserData:GetOriUserNickname()
    return self.data.roleBase.nickname
end

function UserData:GetQuestionRewardState()
    return self.data.roleBase.questionReward > 0
end

function UserData:GetUserNickname()
    local nickName = self.data.roleBase.nickname
    return CommonUtil.GetVaildNickName(nickName)
end

function UserData:GetGuideId()
    if self.data.roleBase == nil then
        return 0
    end
    return  self.data.roleBase.guideId
end

function UserData:GetUserHeadIcon()
    local actor = ManagerContainer.LuaActorDataMgr:GetActorData(true,0)
    if actor ~= nil then
        return actor.HeadIcon
    end
    return nil
end

--- 获得性别 Enum.SexType
---@return integer
function UserData:GetSex()
    return self.data.roleBase.sex
end

function UserData:GetUserRoleId()
    return self.data.roleBase and self.data.roleBase.roleCfgId or 0
end

function UserData:GetRoleDataAttrPoints()
    return self.data.roleBase.roleData.heroData.attrPoint
end

--- 获得玩家其他资源列表(不放背包的资源)
--- itemCfg的id
function UserData:GetResById(id)
    return self.data.roleBase.resMap[id] or 0 
end

function UserData:GetHeroExp()
    return self.data.roleBase.roleData.heroExp
end

function UserData:GetJobCfgId()
    return self.data.roleBase.roleData.heroData.configId
end

function UserData:GetJobLv()
    return self.data.roleBase.roleData.jobLevel
end

function UserData:GetRoleExp()
    return self.data.roleBase.roleData.baseExp
end

function UserData:GetRoleLv()
    return  self.data.roleBase.roleData.heroData.baseLevel
end

function UserData:GetCruise()
    return self.data.roleBase.roleData.cruise
end

function UserData:GetMaxCruise()
    return self.data.roleBase.roleData.max_cruise
end

function UserData:GetOwnCoin()
    return self.data.roleBase.coin
end

function UserData:GetOwnDiamond()
    return  self.data.roleBase.diamond
end

function UserData:GetEvilExp()
    return self:GetResById(Enum.ItemType.EvilExp) or 0
end

function UserData:GetSkillResetCount()
    return self.data.roleBase.roleData.skillResetCount or -1
end

function UserData:GetHeadFrameId()
    return self.data.roleBase.roleData.headFrameId or -1;
end

--设置正在使用的头像框的id
function UserData:SetHeadFrameId(_id)
    local _newId = _id or 0;
    self.data.roleBase.roleData.headFrameId = _newId;

    local actor = ManagerContainer.LuaActorDataMgr:GetActorData(true,0)
    if actor ~= nil then
        actor.HeadFrameId = self.data.roleBase.roleData.headFrameId
    end

    local frameData = ManagerContainer.DataMgr.HeadFrameDataMgr:GetHeadFrameById(_newId)
    if frameData ~= nil then
        frameData:SetFrameState(Enum.HeadFrameState.Using)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Used_New_HeadFrame,frameData.icon)
    end
end

--获取不同的货币，包括银币，钻石，将来还有可能有各种积分
function UserData:GetMoneyBuType(_type)
    if _type == Enum.ItemType.Coin then	--银币
        return self:GetOwnCoin() or 0, I18N.T("Silver"), ManagerContainer.CfgMgr:GetItemById(Enum.ItemType.Coin).Icon;
    elseif _type == Enum.ItemType.Diamond then 	--钻石
        return self:GetOwnDiamond() or 0, I18N.T("GoldCoin"), ManagerContainer.CfgMgr:GetItemById(Enum.ItemType.Diamond).Icon;
    elseif _type == Enum.ItemType.HeroSpirit then --英灵币
        return self:GetResById(Enum.ItemType.HeroSpirit) or 0, I18N.T("ValhallaCoin"), ManagerContainer.CfgMgr:GetItemById(Enum.ItemType.HeroSpirit).Icon;
    else
        error("暂时没有记录这种类型，请确认" .. tostring(_type));
        return 0;
    end
end

function UserData:GetJobExp()
    return self.data.roleBase.roleData.jobExp
end

function UserData:GetJobPoint()
    return self.data.roleBase.jobPoint
end

function UserData:GetJobType()
    return self.data.roleBase.roleData.jobType
end

function UserData:GetJobBranch()
    return self.data.roleBase.roleData.jobBranch
end

function UserData:GetJobStage()
    return self.data.roleBase.roleData.jobStage
end

function UserData:GetJobMaxLevel()
    return self.data.roleBase.roleData.maxJoBLevel
end

function UserData:GetJobIcon()
    return self.data.roleBase.roleData.jobIcon
end

function UserData:GetHeroDataAttr(id)
    return SDataUtil.InvConvert(self.data.roleBase.roleData.heroData.attrs[id] or 0)  
end

function UserData:GetAllAttrs()
    return self.data.roleBase.roleData.heroData.attrs
end

function UserData:GetId()
    return self.data.roleBase.roleData.heroData.id
end

function UserData:GetVipExp()
    return self:GetResById(Enum.ItemType.VipExp)
end

function UserData:GetVipLv()
    return self.data.roleBase.vipLv
end

--- 角色显示用数据，包含创建角色和装备的时装数据
function UserData:GetViewData()
    return self.data.roleBase.viewData
end

function UserData:InitAdditionalRoleData(roleData)
    if self.data.roleBase.roleData == nil then
        self.data.roleBase.roleData = {}
    end

    --self.data.roleBase.roleData.attrList        = roleData.attr_list
    --for _,v in pairs(self.data.roleBase.roleData.attrList) do
    --    v.value = SInt.Convert(v.value)
    --end

    self.data.roleBase.roleData.baseExp        = roleData.base_exp
    --self.data.roleBase.roleData.baseLevel      = roleData.base_level
    --self.data.roleBase.roleData.attrPoint      = SInt.Convert(roleData.attr_point)
    self.data.roleBase.roleData.jobLevel       = roleData.job_level
    self.data.roleBase.roleData.jobExp         = roleData.job_exp
    self.data.roleBase.roleData.jobPoint       = roleData.job_point
    self.data.roleBase.roleData.heroExp        = roleData.hero_exp
    self.data.roleBase.roleData.maxFightPower     = SInt.Convert(roleData.fight_power)

    self.data.roleBase.roleData.lastLogoutTime     = roleData.last_login_time

    --self.data.roleBase.roleData.skillData      = roleData.skill_data
    --self.data.roleBase.roleData.slot           = roleData.slot
    self.data.roleBase.roleData.cruise         = roleData.cruise
    self.data.roleBase.roleData.max_cruise     = roleData.max_cruise
    self.data.roleBase.roleData.skillResetCount = roleData.skill_reset_count

    self:InitHeadPortrait(roleData.head_id)
    self:InitHeroData(roleData.hero_data)
    self:SetHeadFrameId(roleData.head_frame_id)
end

function UserData:InitHeadPortrait(headId)
    self.data.roleBase.roleData.headPortraitId   = headId
    local headPortraitCfgData = ManagerContainer.CfgMgr:GetHeadPortraitDataById(self.data.roleBase.roleData.headPortraitId)
    self.data.roleBase.roleData.headPortraitName = (headPortraitCfgData and headPortraitCfgData.HeadPortraitPic or '')
end

function UserData:InitHeroData(heroData)
    --LogHRWarning(Inspect(heroData))
    if self.data.roleBase.roleData.heroData == nil then
        self.data.roleBase.roleData.heroData = {}
    end
    local heroData1 = self.data.roleBase.roleData.heroData
    heroData1.id             = heroData.id
    heroData1.configId       = heroData.config_id
    heroData1.avatar         = heroData.avatar
    heroData1.isBattle       = heroData.is_battle
    heroData1.baseLevel      = heroData.base_level
    heroData1.slot           = heroData.slot

    if heroData1.attrs == nil then
        heroData1.attrs          = CommonUtil.TableClone(baseAttrs)
    end
    self.data.roleBase.roleCfgId = CommonUtil.JobIdToRoleId(heroData1.configId, self.data.roleBase.sex)

    heroData1.isMainRole     = true
    heroData1.isRole         = true

    heroData1.strengthLevel  = 100

    if heroData1.treasureFree == nil then
        heroData1.treasureFree   = 1
    end

    heroData1.attrList        = heroData.attr_list
    for _,v in pairs(heroData1.attrList) do
        v.value = SInt.Convert(v.value)
    end
    heroData1.attrPoint      = SInt.Convert(heroData.attr_point)
    heroData1.qualityList    ={}
    if heroData.quality_list and #heroData.quality_list > 0 then
        for k, v in pairs(heroData.quality_list) do
            heroData1.qualityList[v.key] = v.value
        end
    end

    heroData1.battlePetId    = heroData.battle_pet_id

    --神器
    heroData1.skillEquipSlot = ProtocalDataNormal.ParseSkillEquipSlotData(heroData1.skillEquipSlot, heroData.skill_equip_slot) 

    --宠物契约
    heroData1.petQiyueData = ProtocalDataNormal.ParsePetQiyueData(heroData1.petQiyueData, heroData.pet_qiyue_data) 
    
    -- ManagerContainer.DataMgr.SkillsData:InitSkillsData(heroData.skill)
    self:InitSkillData(heroData.skill)
    self:InitJobData(heroData.config_id)

    self:UpdateHeroExtGoShowData(heroData1)
end

function UserData:InitSkillData(skill)
    local skillData = self.data.roleBase.roleData.heroData.skillData
    if not skillData then
        skillData = SkillData:new()
        self.data.roleBase.roleData.heroData.skillData = skillData
    end
    skillData:InitData(skill)
end

function UserData:InitJobData(jobId)
    local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(jobId);
    if self.data.roleBase.roleData.jobType ~= jobCfg.JobType or self.data.roleBase.roleData.jobStage ~= jobCfg.JobStage then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.USER_HEADPROTRAIT_CHANGED)
    end
    
    self.data.roleBase.roleData.jobName = I18N.T(jobCfg.JobName)
    self.data.roleBase.roleData.jobType = jobCfg.JobType
    self.data.roleBase.roleData.jobBranch = jobCfg.JobBranch
    self.data.roleBase.roleData.jobStage = jobCfg.JobStage
    self.data.roleBase.roleData.jobIcon = jobCfg.JobIcon
    self.data.roleBase.roleData.maxJoBLevel = jobCfg.MaxJobLv
end

function UserData:RefreshAddPointAttr()
    if lastPointAttrs == nil then lastPointAttrs = {} end
    if lastBaseAttrs == nil then lastBaseAttrs = {} end

    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.LUK then
            local delta = self:GetPointAttr(v)
            if lastPointAttrs ~= nil and lastPointAttrs[v] ~= nil then
                -- delta = self:GetPointAttr(v) - lastPointAttrs[v]
                delta = SDataUtil.Sub(self:GetPointAttr(v), lastPointAttrs[v])
            end

            heroData:SetBaseFirstAttr(v, SDataUtil.Add(heroData:GetBaseFirstAttr(v),delta))
            lastPointAttrs[v] = self:GetPointAttr(v)
            lastBaseAttrs[v] = heroData:GetBaseFirstAttr(v)
        end
    end

    local heroLogicData = self:GetHeroData()
    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
end

function UserData:GetLastBaseAttrs()
    return lastBaseAttrs
end

function UserData:InitViewData(viewData)
    self.data.roleBase.viewData = ProtocalDataNormal.FashionDataToViewData(viewData)
end

function UserData:UpdateHeroExtGoShowData(heroData)
    CommonUtil.UpdateHeroExtGoShowData(heroData)
end

--- 更新穿上的时装
function UserData:UpdateFashionUpData(fashionUpData)
    self.data.roleBase.viewData.fashionData = ProtocalDataNormal.FashionUpDataToData(fashionUpData)
    self:InitHeroAttrFromBattle()
    self:SyncFashionToActorData()
    AvatarRTMgr.Instance:RemoveActor(1)
end

function UserData:GetPlayerActorParam()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    return heroData;
end

function UserData:SyncFashionToActorData()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    if self.data.roleBase.viewData == nil or heroData == nil  then
        return
    end

    local fashionParam = LuaToCSData.CreateFashionParamData(self.data.roleBase.roleCfgId, self.data.roleBase.roleData.heroData.configId, self.data.roleBase.viewData)
    heroData:SetFashionData(fashionParam)
end

function UserData:GetHeroData(heroId)
    if not heroId or self:IsLeaderHero(heroId) then
        return self.data.roleBase.roleData.heroData
    else
        return ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(heroId)
    end
end

function UserData:GetMainRoleData()
    return self.data.roleBase.roleData.heroData
end

function UserData:GetAllSlotInfos()
    local allSlots = {}
    local heroSlot = self.data.roleBase.roleData.heroData.slot
    allSlots[heroSlot.hero_id] = heroSlot
    local slots = ManagerContainer.DataMgr.PartnerData:GetAllPartnerSlots()
    for k,v in pairs(slots) do
        allSlots[k] = v
    end
    return allSlots
end

function UserData:GetSlotInfoById(id)
    if id == 1 then
        local heroSlot = self.data.roleBase.roleData.heroData.slot
        return heroSlot
    else
        local partnerData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
        if not partnerData then
            return nil
        end
        return partnerData.slot
    end
end

function UserData:GetCurSlotInfos(id)
    --self:GetAllSlotInfos()
    local slot = self:GetSlotInfoById(id)
    if slot == nil then
        return nil
    end
    return slot.slot_list
end

function UserData:GetSlotIndexByHeroId(id)
    return id
end

function UserData:GetSlotInfosByHeroId(id)
    local slot = self:GetSlotInfoById(id)
    if slot then
        return slot.slot_list
    end
    return nil
end

function UserData:GetSlotBySlotIndex(slotIndex)
    return self:GetSlotInfoById(slotIndex)
end

function UserData:GetPointAttr(type)
    for _,v in pairs(self.data.roleBase.roleData.heroData.attrList) do
        if v.key == type then
            return v.value
        end
    end
    return 0
end

function UserData:CalcEquipAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local slots = self:GetCurSlotInfos(1)
    local heroLogicData = self:GetHeroData()
    local equipTotalAttrs = self:GetSlotsEquipAttr(slots)

    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.RealHurt then
            local eAttr = heroData:GetAdditionalAttr(v)
            local lastAttr = (lastEquipAttrs == nil and 0 or lastEquipAttrs[v])
            heroData:SetAdditionalAttr(v,  SDataUtil.Sub(SDataUtil.Add(eAttr,equipTotalAttrs[v]),lastAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            local eAttrPercent = heroData:GetAdditionalAttrPercent(v)
            local lastAttr = (lastEquipAttrs == nil and 0 or lastEquipAttrs[v])
            heroData:SetAdditionalAttrPercent(v, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,equipTotalAttrs[v]),lastAttr))
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end

    --if lastTeamEquipAttrs ~= nil then
    --    for k,v in pairs(lastTeamEquipAttrs) do
    --        if v ~= equipTotalAttrs[k] then
    --            attrsChanged = true
    --            break
    --        end
    --    end
    --end

    lastEquipAttrs = equipTotalAttrs
end

function UserData:CalcCardAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local slots = self:GetCurSlotInfos(1)
    local heroLogicData = self:GetHeroData()

    --ManagerContainer.DataMgr.CardData:RefreshEquipedCardSuitData(1)
    local cardTotalAttrs = self:GetSlotsCardAttr(slots)
    local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(1)
    if state then
        local lv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(1)
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
                local eAttr = heroData:GetAdditionalAttr(v)
                local cardAttr = (cardTotalAttrs[v] - (lastCardAttrs == nil and 0 or lastCardAttrs[v]))
                local val = SDataUtil.Add(eAttr,cardAttr);
                heroData:SetAdditionalAttr(v, val)
            else
                local eAttrPercent = heroData:GetAdditionalAttrPercent(v)
                local cardAttr = cardTotalAttrs[v] - (lastCardAttrs == nil and 0 or lastCardAttrs[v])
                local val = SDataUtil.Add(eAttrPercent,cardAttr);
                heroData:SetAdditionalAttrPercent(v, val)

            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
    --
    --if lastTeamCardAttrs ~= nil then
    --    if not attrsChanged then
    --        for k,v in pairs(lastTeamCardAttrs) do
    --            if v ~= cardTotalAttrs[k] then
    --                attrsChanged = true
    --                break
    --            end
    --        end
    --    end
    --end

    lastCardAttrs = cardTotalAttrs
end

function UserData:CalcFashionAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local heroLogicData = self:GetHeroData()
    --local fashionMap = ManagerContainer.DataMgr.FashionData:GetFashionMap()
	--local fashionTotalAttrs = CommonUtil.GetFashionAttrMap(fashionMap)
    local fashionTotalAttrs = ManagerContainer.DataMgr.FashionData:GetFashionAllAttrsByJobType(0)
    local fashionSuitAttrs = ManagerContainer.DataMgr.FashionData:GetFashionSuitAttrs()

    local totalAttrs = {}
    if fashionTotalAttrs then
        for k,v in pairs(fashionTotalAttrs) do
            if not totalAttrs[k] then
                totalAttrs[k] = 0
            end
            totalAttrs[k] = totalAttrs[k] + v
        end
    end
    if fashionSuitAttrs then
        for k,v in pairs(fashionSuitAttrs) do
            if not totalAttrs[k] then
                totalAttrs[k] = 0
            end
            totalAttrs[k] = totalAttrs[k] + v
        end
    end

    local changeNum = 0
    for _,v in pairs(Enum.HeroAttrType) do
        if totalAttrs[v] ~= nil then
            if v < Enum.HeroAttrType.STR_Percent then
                changeNum = (totalAttrs[v] - ((lastFashionAttrs == nil or not lastFashionAttrs[v]) and 0 or lastFashionAttrs[v]))
                if changeNum ~= 0 then
                    -- local val =  heroData:GetAdditionalAttr(v) + changeNum;
                    local val = SDataUtil.Add(heroData:GetAdditionalAttr(v), changeNum)
                    heroData:SetAdditionalAttr(v, val)
                    attrsChanged = true
                end
            else
                changeNum = (totalAttrs[v] - ((lastFashionAttrs == nil or not lastFashionAttrs[v]) and 0 or lastFashionAttrs[v]))
                if changeNum ~= 0 then
                    -- local val =  heroData:GetAdditionalAttrPercent(v) + changeNum * 0.0001
                    local val = SDataUtil.Add(heroData:GetAdditionalAttrPercent(v), changeNum * 0.0001)
                    heroData:SetAdditionalAttrPercent(v, val)
                    attrsChanged = true
                end
            end
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
    lastFashionAttrs = totalAttrs
end

function UserData:CalcSkillAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local heroLogicData = self:GetHeroData()
    local skillData = self:GetSkillData(self:GetId())
    local skillTotalAttrs = skillData and skillData:GetUnlockSkillAttrs() or {}
    local attrValue = nil
    local changeNum = nil
    local isChanged = false
    for _,v in pairs(Enum.HeroAttrType) do
        attrValue = skillTotalAttrs[v]
        if not attrValue then attrValue = 0 end
        changeNum = attrValue - ((lastSkillAttrs == nil or not lastSkillAttrs[v]) and 0 or lastSkillAttrs[v])
        if changeNum ~= 0 then
            if v < Enum.HeroAttrType.STR_Percent then
                -- local val =  heroData:GetAdditionalAttr(v) + changeNum
                local val = SDataUtil.Add(heroData:GetAdditionalAttr(v), changeNum)
                heroData:SetAdditionalAttr(v, val)
            else
                -- local val =  heroData:GetAdditionalAttrPercent(v) + changeNum * 0.0001
                local val = SDataUtil.Add(heroData:GetAdditionalAttrPercent(v), changeNum * 0.0001)
                heroData:SetAdditionalAttrPercent(v, val)
            end
            isChanged = true
        end
    end
    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
    lastSkillAttrs = skillTotalAttrs
    if isChanged then
        attrsChanged = true
    end
    return isChanged
end

function UserData:CalcPetAttrs()
    if not AttrFilterList then
        local val = GlobalConfig.Instance:GetConfigStrValue(230)
        if val ~= "" and val ~= nil then
            AttrFilterList = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end

    if not lastPetAttrs then
        lastPetAttrs = {}
    end

    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local heroLogicData = self:GetHeroData()
    local petId = heroLogicData.battlePetId
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
                local eAttr = heroData:GetAdditionalAttr(v)
                local lastAttr = lastPetAttrs[v] or 0
                heroData:SetAdditionalAttr(v,  SDataUtil.Sub(SDataUtil.Add(eAttr,petAttr),lastAttr))
            elseif v >= Enum.HeroAttrType.STR_Percent then
                local eAttrPercent = heroData:GetAdditionalAttrPercent(v)
                local lastAttr = lastPetAttrs[v] or 0
                heroData:SetAdditionalAttrPercent(v, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,petAttr),lastAttr))
            end

            lastPetAttrs[v] = petAttr
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
end

function UserData:CalcHeadFrameAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local heroLogicData = self:GetHeroData()
    local headFrameAttrs = ManagerContainer.DataMgr.HeadFrameDataMgr:CalcAttrs()

    for _,v in pairs(Enum.HeroAttrType) do
        if v <= Enum.HeroAttrType.RealHurt then
            local eAttr = heroData:GetAdditionalAttr(v)
            local lastAttr = (lastHeadFrameAttrs == nil and 0 or lastHeadFrameAttrs[v])
            heroData:SetAdditionalAttr(v,  SDataUtil.Sub(SDataUtil.Add(eAttr,headFrameAttrs[v]),lastAttr))
        elseif v >= Enum.HeroAttrType.STR_Percent then
            local eAttrPercent = heroData:GetAdditionalAttrPercent(v)
            local lastAttr = (lastHeadFrameAttrs == nil and 0 or lastHeadFrameAttrs[v])
            heroData:SetAdditionalAttrPercent(v, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,headFrameAttrs[v]),lastAttr))
        end
    end

    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end

    lastHeadFrameAttrs = headFrameAttrs
end

function UserData:CalcKeepSakeAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local keepsakeMaps = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeMaps()
    local heroLogicData = self:GetHeroData()
    local addAttrs = {}
    for k,v in pairs(keepsakeMaps) do
        local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(k)
        if cfgData and CommonUtil.EleInTable(0, cfgData.Job) then
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

    for k,v in pairs(addAttrs) do
        if k <= Enum.HeroAttrType.RealHurt then
            local eAttr = heroData:GetAdditionalAttr(k)
            local lastAttr = (lastKeepSakeAttrs == nil and 0 or (lastKeepSakeAttrs[k] or 0))
            heroData:SetAdditionalAttr(k,  SDataUtil.Sub(SDataUtil.Add(eAttr,v),lastAttr))
        elseif k >= Enum.HeroAttrType.STR_Percent then
            local eAttrPercent = heroData:GetAdditionalAttrPercent(k)
            local lastAttr = (lastKeepSakeAttrs == nil and 0 or (lastKeepSakeAttrs[k] or 0))
            heroData:SetAdditionalAttrPercent(k, SDataUtil.Sub(SDataUtil.Add(eAttrPercent,v),lastAttr))
        end
    end

    for k,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end

    lastKeepSakeAttrs = addAttrs
end

function UserData:AddKeepSakeLvUpAttrs(keepsakeId, lv)
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    if not lv then return end

    local heroLogicData = self:GetHeroData()
    local addAttrs = {}
    local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(keepsakeId)
    if cfgData and CommonUtil.EleInTable(0, cfgData.Job) then
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
    end

    for k,v in pairs(addAttrs) do
        if k <= Enum.HeroAttrType.RealHurt then
            local eAttr = heroData:GetAdditionalAttr(k)
            lastKeepSakeAttrs[k] = (lastKeepSakeAttrs[k] or 0) + v
            heroData:SetAdditionalAttr(k,  SDataUtil.Add(eAttr,v))
        elseif k >= Enum.HeroAttrType.STR_Percent then
            local eAttrPercent = heroData:GetAdditionalAttrPercent(k)
            lastKeepSakeAttrs[k] = (lastKeepSakeAttrs[k] or 0) + v
            heroData:SetAdditionalAttrPercent(k, SDataUtil.Add(eAttrPercent,v))
        end
    end

    for k,v in pairs(addAttrs) do
        heroLogicData.attrs[k] = heroData:GetFinalAttr(k)
    end
end

function UserData:InitHeroAttrFromBattle()
    attrsChanged = false

    lastTotalAttrs = CommonUtil.TableClone(self.data.roleBase.roleData.heroData.attrs)
    self:CalcEquipAttrs()
    self:CalcCardAttrs()
    self:CalcFashionAttrs()
    self:CalcSkillAttrs()
    self:CalcPetAttrs()
    self:CalcHeadFrameAttrs()
    self:CalcKeepSakeAttrs()
    --  LogError(Inspect(self:GetHeroData()))
end

function UserData:GetNewActorAttrs()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    local heroLogicData = self:GetHeroData()
    for _,v in pairs(Enum.HeroAttrType) do
        heroLogicData.attrs[v] = heroData:GetFinalAttr(v)
    end
end

function UserData:SaveLastTotalAttr()
    lastTotalAttrs = CommonUtil.TableClone(self.data.roleBase.roleData.heroData.attrs)
end

function UserData:GetLastTotalAtttrs()
    return lastTotalAttrs
end


function UserData:RefreshSlotData(data)
    --self:GetAllSlotInfos()

    local function IsSlotEquipChanged(oldSlotList, newSlotList)
        if oldSlotList and newSlotList then
            for i = 1, 6 do
                local oldCards = oldSlotList[i]
                local newCards = newSlotList[i]
                if not oldCards then
                    oldCards = {}
                    oldCards.card_id_list = {}
                end
                if oldCards and newCards then
                    if oldCards.equip_id ~= newCards.equip_id then
                        return true
                    end
                    for j = 1, 4 do
                        if oldCards.card_id_list[j] ~= newCards.card_id_list[j] then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    local isIn = false
    local heroData = CommonUtil.GetHeroLogicDataByUid(data.hero_id)
    if heroData.slot then
        isIn = true
        local changed = IsSlotEquipChanged(heroData.slot.slot_list, data.slot_list)
        heroData.slot = data
        if changed then
            ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardRP()
        end
        return
    end
    if not isIn then
        heroData.slot = data
    end
end

function UserData:IsHeroSlot(hero_id)
    return hero_id == 1
end

function UserData:RefreshHeroesTreasureState(heroIds, isFree)
    for _,v in pairs(heroIds) do
        if v == 1 then
            local heroData = self:GetHeroData()
            heroData.treasureFree = isFree and 1 or 0
        else
            ManagerContainer.DataMgr.PartnerData:RefreshPartnerTreasureState(v, isFree)
        end
    end
end

function UserData:RefreshHeroCurMaxExp()
    local curRoleLv = self:GetRoleLv()
    local baseExpData = ManagerContainer.CfgMgr:GetRoleExpData(curRoleLv)
    self.data.roleBase.roleData.baseCurMaxExp = baseExpData.Name

    local curJobLv = self:GetJobLv()
    local curMaxJobExp = ManagerContainer.CfgMgr:GetCurMaxJobExpByLvAndStep(curJobLv, self:GetJobStage())
    self.data.roleBase.roleData.jobCurMaxExp = curMaxJobExp
end

function UserData:GetHeroCurBaseMaxExp()
    return self.data.roleBase.roleData.baseCurMaxExp
end

function UserData:GetHeroCurJobMaxExp()
    return self.data.roleBase.roleData.jobCurMaxExp
end

function UserData:InitRoleFightPower(data, _getHeroData)
    self.data.roleBase.roleData.totalFightPower = SInt.Convert(data.total_fightpower or 0)
    for _,v in pairs(data.slot_fightpower) do
        if v ~= nil then
            local heroData;
            if _getHeroData then    --查看别的玩家的时候不能用自己本身的数据，这里是传过来的查找函数，不用这个就传nil
                heroData = _getHeroData(v.hero_id);
            else
                heroData = CommonUtil.GetHeroLogicDataByUid(v.hero_id)
            end
            heroData.fightPower = SInt.Convert(v.hero_fight_power or 0)
            heroData.petFightPower = SInt.Convert(v.pet_fight_power or 0)
            self:AddAsideFighterSvrPower(v.hero_id,false,v.hero_fight_power)
            self:AddAsideFighterSvrPower(heroData.battlePetId,true,v.pet_fight_power)
            --LogError("InitRoleFightPower"..tostring(heroData.fightPower).." v.hero_id "..tostring(v.hero_id)  )
        end
    end
    self.petRelationFightPower = data.pet_bond_fightpower or 0
end

function UserData:GetPetRelationTotalFightPower()
    return self.petRelationFightPower
end

function UserData:GetTotalFightPower()
    return SInt.InvConvert(self.data.roleBase.roleData.totalFightPower or 0)
end

function UserData:GetMaxTotalFightPower()
    return  SDataUtil.InvConvert(self.data.roleBase.roleData.maxFightPower or 0)
end

function UserData:GetSlotFightPower(id)
    local heroData = CommonUtil.GetHeroLogicDataByUid(id)
    if heroData == nil then return 0 end    
    local totalPower = SDataUtil.InvConvert(heroData.fightPower or 0)
                        + SDataUtil.InvConvert(heroData.petFightPower or 0)
    return totalPower
end

function UserData:SyncActorBaseLevel()
    local heroData = ManagerContainer.LuaActorDataMgr:GetHeroActorData(self:GetUserRoleId())
    heroData:SetLevel(self.data.roleBase.roleData.heroData.baseLevel)
end

function UserData:GetCreateTime()
    return self.createRoleTime
end

function UserData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BASE_LEVEL_UP_NTF, function(data)
        -- 目前所有的角色信息变化都能在，SC_ROLE_BASE_INFO_NTF中获得，所以这里暂不处理
        -- self.data.roleBase.roleData.baseLevel = data.new_level
        -- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_ROLE_LV)
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ADD_QUALITY_POINT_ACK,function (data)
        if data.error == 0 then
            local userName
            local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(data.hero_id)
            if data.hero_id == 1 then
                userName = ManagerContainer.DataMgr.UserData:GetUserNickname()
            else
                local _partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(herodata.configId)
                userName = string.formatbykey(_partnerData.Name)
            end
            local itemdata = ManagerContainer.CfgMgr:GetItemById(data.item_id)
            if itemdata then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('UseFruit',userName,itemdata['Name'])
            end
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_ATTR_ADD_SUCCESS)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRUIT_USE_SUCC,{data.hero_id,herodata})
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_STARTUP_INFO_NTF, function(data)
        -- LogError("start"..Inspect(data))
        --由于该协议会发送多次，所以需要判断数据是否为空===========================================很重要
        Constant.OpenPay = (data.func_disable == nil or not data.func_disable)
        self.createRoleTime = data.create_time
        self.serverStartTime = data.service_start_time
        ManagerContainer.LuaTimerMgr:SyncServerTime(data.server_time)

        if data.role_base then
            self:InitRoleBaseData(data.role_base)      
        end
        if data.role_hero then  
            ManagerContainer.LuaActorAttributeMgr:SetAllData(data.role_hero.battle_attr_list)--新号 属性
            ManagerContainer.DataMgr.PartnerData:InitPartnerData(data.role_hero)
            self:GetAllSlotInfos()
        end

        if data.role_base then
            --同步在线奖励时间
            ManagerContainer.LuaBattleMgr:SyncOnlineTime(data.role_base)
            self:RefreshHeroCurMaxExp()

            ManagerContainer.PayMgr:InitRechargeData(data.role_base)
        end

        if data.role_bag then
            ManagerContainer.DataMgr.BagData:InitBagData(data.role_bag)
        end
        if data.role_wish_box then
            ManagerContainer.DataMgr.BagData:RefreshWishSlotData(data.role_wish_box)
        end

        if data.role_battle then
            ManagerContainer.LuaBattleMgr:SetBattleData(data.role_battle,true)
            if data.role_battle.evil_info then
                ManagerContainer.DataMgr.EvilData:SetEvilData(data.role_battle.evil_info)
            end
            if data.role_battle.expedition_info then
                ManagerContainer.DataMgr.ExpeditionDataMgr:SetData(data.role_battle.expedition_info)
            end
        end
        
        if data.role_fashion then
            ManagerContainer.DataMgr.FashionData:InitFashionData(data.role_fashion)
        end
     
        if data.role_task then
            ManagerContainer.DataMgr.TaskDataNew:InitRoleTask(data.role_task)
        end
        
        if data.role_competition then
            ManagerContainer.DataMgr.CompetitionData:InitCurCompetitionData(data.role_competition)
            ManagerContainer.DataMgr.ChatData:Init()
        end
        
        if data.role_tower then
            ManagerContainer.DataMgr.TowerDataMgr:InitClimbingTowerInfo(data.role_tower)
        end
     
        if data.role_skill_equip then
            ManagerContainer.DataMgr.SkillEquipData:InitData(data.role_skill_equip)
            ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HEAD_DATA_REQ)
        end

        if data.role_map then
            ManagerContainer.DataMgr.WorldBossData:ChangeWorldBossCount(data.role_map.world_boss_count)
        end
        if data.role_draw then
            ManagerContainer.DataMgr.SummonDataMgr:InitSummonMap(data.role_draw)
        end

        if data.role_daochang100 then
            ManagerContainer.DataMgr.HundredDojoDataMgr:InitData(data.role_daochang100)
            ManagerContainer.DataMgr.TrunWheelDataMgr:OnDataChangeNtf(data.role_daochang100)
        end

        if data.role_cross then
            ManagerContainer.DataMgr.VoyageDataMgr:RefreshSelfVoyageData(data.role_cross.yuanhangtrial)
        end

        if data.role_fightpower then
            self:InitRoleFightPower(data.role_fightpower)
        end

        if data.role_red then
            self:InitRedState(data.role_red)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_CHANG_NTF,  function(data)
        ManagerContainer.DataMgr.TrunWheelDataMgr:OnDataChangeNtf(data)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CONVER_SKILL_EXP_ACK,  function(data)
        if data.error == 0 then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("GetAdvanceSkillExpSucc")
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_BASE_INFO_NTF, function(data)
         --LogError(Inspect(data))
        local lastData = clone(self.data)
        self.data.roleBase.coin             = data.coin
        self.data.roleBase.diamond          = data.rmb
		self.data.roleBase.RepressSkillPvpVal = data.repress_skill_pvp_val
        self:InitRoleRes(data.res_list)
        self:InitAdditionalRoleData(data.role_data)
        --self:InitHeroAttrFromBattle()
        self:RefreshHeroCurMaxExp()

        ManagerContainer.RedPointMgr.HeroRPCtr:RoleRedPointNotify()
        self:CompareDataChange(lastData)

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_UI_REDPOINT_CHANGE)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_COIN_AND_DIAMOND)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_COIN_AND_JOBEXP)

        if lastData.roleBase.roleData.cruise ~= self.data.roleBase.roleData.cruise then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_TREASURE_CRUISE)
        end
        if lastData.roleBase.roleData.heroData.baseLevel ~= self.data.roleBase.roleData.heroData.baseLevel then
            self:SyncActorBaseLevel()
            self:GetNewActorAttrs()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_HERO_LVUP_ATTR)
            self:SDKUpdateRoleLv()
        end
        if lastData.roleBase.roleData.heroData.battlePetId ~=  self.data.roleBase.roleData.heroData.battlePetId then
            self:CalcPetAttrs()
        end

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_HERO_UI)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ADD_ATTR_POINT_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            if data.hero_id == 1 then
                self:RefreshAddPointAttr()
                ManagerContainer.RedPointMgr.HeroRPCtr:HeroAttrRPNotify()
            else
                ManagerContainer.DataMgr.PartnerData:RefreshAddPointAttr(data.hero_id)
                ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(data.hero_id)
            end

            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_ATTR_ADD_SUCCESS)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SLOT_DATA_NTF, function(data)

        self:RefreshSlotData(data.slot)
        if self:IsHeroSlot(data.slot.hero_id) then
            self:InitHeroAttrFromBattle()

            ManagerContainer.RedPointMgr.HeroRPCtr:HeroEquipNotify()

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
        else
            ManagerContainer.DataMgr.PartnerData:InitPartnerAttrById(data.slot.hero_id)

            --ManagerContainer.RedPointMgr.HeroRPCtr:PartnerRedPointNotifyById(data.slot.hero_id)

            --ManagerContainer.RedPointMgr.HeroRPCtr:HeroEquipNotify()
            ManagerContainer.RedPointMgr.HeroRPCtr:PartnerEquipNotify()

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_EQUIP_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
        end

    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EQUIP_SLOT_LEVEL_UP_ACK, function(data)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SLOT_REFINE_LV_UP_SUCCESS, data.error)
    end)

    -- 名字修改
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_NAME_ACK, self.OnUserNameChanged, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RENAME_ACK, self.OnUserNameChanged, self)

    --战力修改
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FIGHT_POWER_CHAGNE_NTF, function(data)
        --LogError(Inspect(data))
        if not self.data.roleBase then return end

        local IsSaveSidePower = false
        --保存未上阵的处理 英雄战力 宠物战力（服务器约定 不为空 只同步未上阵的 战斗力） 为空走正常战力修改
        if nil ~= data.data.actor_fightpower then
            for _,v in pairs(data.data.actor_fightpower) do
                if v ~= nil then
                    local Id = v.hero_id
                    local fightPower = v.hero_fight_power or 0
                    local petFightPower = v.pet_fight_power or 0
                    if fightPower > 0 then 
                        self:AddAsideFighterSvrPower(Id,false,fightPower)
                    end
                    if petFightPower > 0 then
                        self:AddAsideFighterSvrPower(Id,true,petFightPower)
                    end                   
                    IsSaveSidePower = true
                end
            end
            if IsSaveSidePower then
                --LogError("未上阵SAVE")
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SIDEFIGHTPOWER_REFRESH)
                return
            end
        end

        --上阵的战力修改 保存当前战力 弹窗显示
        --LogError("Save 上阵")
        local lastFightPower = self:GetTotalFightPower()
        self:InitRoleFightPower(data.data)
        local newFightPower = self:GetTotalFightPower()

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FIGHTPOWER_REFRESH)

        if newFightPower > lastFightPower then
            local data = {startNum = lastFightPower, endNum = newFightPower}
            ManagerContainer.LuaUIMgr:FightPowerAddNotice(data)
        end
    end)

    --寻宝NTF
    -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_BATTLE_BOX_NTF, function(data)
    --     ManagerContainer.DataMgr.TreasureData:InitTreasureData(data)
    -- end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RESET_ATTR_POINT_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            if data.hero_id == 1 then
                self:RefreshAddPointAttr()
                ManagerContainer.RedPointMgr.HeroRPCtr:HeroAttrRPNotify()
            else
                ManagerContainer.DataMgr.PartnerData:RefreshAddPointAttr(data.hero_id)
                ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(data.hero_id)
            end

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_ATTR_ADD_SUCCESS, true)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_CHANGE_JOB_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:OnChangeJobAck(data)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_REPLACE_JOB_ACK, function (data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:OnChangeJobAck(data, true)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_FIGH_POWER_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FIGHTPOWER_PARTNER_ACK)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_VIP_CHANGE_NTF, self.OnVipChangedNtf, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_SLOT_DATA_NTF,self.OnSkillSlotDataNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_JOB_SKILL_DATA_NTF,self.OnJobSkillDataNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVE_SKILL_ACK,self.OnActiveSkillAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_LEVEL_UP_ACK, self.OnSkillLevelUpAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SET_SKILL_LIST_ACK, self.OnSetSkillListAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RESET_SKILL_LEVEL_ACK, self.OnResetSkillLvAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_RESET_COUNT_NTF, self.OnSkillResetCountNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CREATE_ROLE_ACK, self.OnCreateRoleAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_RED_NTF, function(data)
        self:RefreshRedState(data.red)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SET_HEAD_ID_ACK, self.OnSetHeadIdAck, self)
    --头像交互功能
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_OTHER_PLAYER_DETAIL_INFO_ACK, self.SCGetOtherPlayerDetailInfoAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_USE_ITEM_ACK, self.OnUseItemAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CARD_SLOT_CHANGE_NTF, self.CardSlotChangeNtf, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_STARTUP_INFO_END_NTF, self.StartUpEnd, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GIFT_REWARD_ACK, self.OnGiftRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_QUESTION_REWARD_ACK, self.OnQuestionRewardAck, self)
end

function UserData:RoleChangeJobAttrSuccess()
    self:InitHeroAttrFromBattle()
    --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_ATTR_ADD_SUCCESS)
end

function UserData:OnCreateRoleAck(data)
    if data.error == 0 then
        self.createRole = true
        local gameRoleInfo = SDKMgr.Instance:GetGameRoleInfo()
        if gameRoleInfo then
            gameRoleInfo.openId = ManagerContainer.LuaGameMgr.openId
            local serverData = ManagerContainer.LuaGameMgr.serverData
            if serverData then
                gameRoleInfo.serverId = serverData.id
                gameRoleInfo.serverName = serverData.name
            end
            gameRoleInfo.roleId = tostring(data.uid) or ''
            gameRoleInfo.roleName = ""
            gameRoleInfo.roleLv = 0
            gameRoleInfo.roleCreateTime = data.create_role_time
            gameRoleInfo.roleUpLvTime = data.create_role_time
            gameRoleInfo.vipLv = 0
            gameRoleInfo.gender = tostring(data.gender) or ''
            gameRoleInfo.jobId = 0
            gameRoleInfo.jobName = ""
            gameRoleInfo.guildId = 0
            gameRoleInfo.guildName = ""
            gameRoleInfo.fightPower = 0
        end
        SDKMgr.Instance:CreateRole()
        SDKMgr.Instance:ReportCreateRole()
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CREATE_ROLE_FAILED,data.error)
end

function UserData:CardSlotChangeNtf(data)
    ManagerContainer.RedPointMgr.HeroRPCtr:RoleCardSlotRPNotify(data.slot_list)
end

function UserData:InitRedState(data)
    self.data.mailRedState = data.is_unread_mail
end

function UserData:HasPassedNewbie()
    -- return CommonUtil.And(self:GetGuideId(),1) == 1
    return true
end

function UserData:RefreshRedState(data)
    self.data.mailRedState = data.is_unread_mail
end

function UserData:CompareDataChange(lastData)
    local changedRes = {}
    if lastData.roleBase.coin ~= self.data.roleBase.coin then
        changedRes[Enum.ItemIds.Coin] = (self.data.roleBase.coin - lastData.roleBase.coin)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.COIN_CHANGED)
    end
    if lastData.roleBase.diamond ~= self.data.roleBase.diamond then
        changedRes[Enum.ItemIds.Diamond] = (self.data.roleBase.diamond - lastData.roleBase.diamond)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DIAMOND_CHANGED)
    end

    if lastData.roleBase.roleData.cruise ~= self.data.roleBase.roleData.cruise then
        changedRes[Enum.ItemIds.SkillExp] = (self.data.roleBase.roleData.cruise - lastData.roleBase.roleData.cruise)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CRUISE_CHANGED)
    end

    if lastData.roleBase.roleData.heroData.baseLevel ~= self.data.roleBase.roleData.heroData.baseLevel then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_LV_CHANGED, self:GetId())
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_LV_CHANGED)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_EXP_CHANGED)
        --等级改变 同步
        ManagerContainer.LuaBattleMgr:SetTeamData(true,false)
    elseif lastData.roleBase.roleData.baseExp ~= self.data.roleBase.roleData.baseExp then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_EXP_CHANGED)
    end
    if lastData.roleBase.roleData.jobLevel ~= self.data.roleBase.roleData.jobLevel then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.JOB_LV_CHANGED)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.JOB_EXP_CHANGED)
    elseif lastData.roleBase.roleData.jobExp ~= self.data.roleBase.roleData.jobExp then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.JOB_EXP_CHANGED)
    end

    local lastResMap = lastData.roleBase.resMap
    local curResMap = self.data.roleBase.resMap
    for k,v in pairs(curResMap) do
        local lastV = lastResMap[k]
        if lastV ~= v then
            changedRes[k] = v - (lastV or 0)
        end
        lastResMap[k] = nil
    end
    for k, v in pairs(lastResMap) do
        changedRes[k] = -v
    end
    for key, value in pairs(changedRes) do
        if key == Enum.RoleResType.HeroSpirit then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_HERO_SPIRIT_CHANGED, value)
        elseif key == Enum.ItemType.EvilExp then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_ROLE_EVIL_EXP_CHANGED)
        elseif key == Enum.ItemType.AdvanceSkillExp then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_ADVANCESKILLEXP_CHANGED)
        end
    end
    if not CommonUtil.TableIsEmpty(changedRes) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENY_CHANGED, changedRes)
    end
end

function UserData:GetCardBuffs(index)
    local list = {}
    local slots = self:GetCurSlotInfos(index)
    if slots ~= nil then
        for i = 1,#slots do
            if slots[i].equip_id > 0 then
                local cardList = slots[i].card_id_list
                for _,v in pairs(cardList) do
                    if v > 0 then
                        local cardData = ManagerContainer.CfgMgr:GetCardDataById(v)
                        if cardData.BUFF ~= nil then
                            for _,v1 in pairs(cardData.BUFF) do
                                list[#list + 1] = v1
                            end
                        end
                    end
                end
            end
        end
    end
    return list
end

function UserData:GetTeamData(ignore)
    local battleIds = {}
    local petId = self.data.roleBase.roleData.heroData.battlePetId
    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
    local data = {
        uid = self.data.roleBase.roleData.heroData.id,
        id = self.data.roleBase.roleCfgId,
        jobId = self.data.roleBase.roleData.heroData.configId,
        lv = self.data.roleBase.roleData.heroData.baseLevel,
        headFrameId = self.data.roleBase.roleData.headFrameId,
        role = false, 
        mainRole = true,
        -- skills = ManagerContainer.DataMgr.SkillsData:GetUsedSkills(),
        skills = self.data.roleBase.roleData.heroData.skillData:GetUsedSkills(),
        buffs = self:GetCardBuffs(1),
        fashion = self:GetViewData(),
        petId = petId > 0 and petId + Enum.ActorUidField.Pet or 0,
        petBaseId = petData and petData.cfgId or 0,
        Name = self:GetUserNickname()
    }

    CommonUtil.ReplaceBattleSkillBySkillEquip(self.data.roleBase.roleData.heroData, data.skills)
   
    battleIds[#battleIds + 1] = data

    local list = ManagerContainer.DataMgr.PartnerData:GetBattlePartnerDatas(attrsChanged, ignore)
    if list then
        for _,v in pairs(list) do
            battleIds[#battleIds + 1] = v
        end
    end
    --lastTeamEquipAttrs = lastEquipAttrs
    --lastTeamCardAttrs = lastCardAttrs
    attrsChanged = false

    self:SyncFashionToActorData()

    return battleIds
end

function UserData:GetHeroActorParam()
    local actors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, 1)
    actors[0] = ManagerContainer.LuaActorDataMgr:GetActorData(true,0)
    return actors
end

function UserData:GetSuitNum(slots, slotType)
    if slots == nil then return 0 end
    if slots[slotType].equip_id == 0 then return 0 end

    local suits = {}
    local equipData = ManagerContainer.CfgMgr:GetEquipById(slots[slotType].equip_id)
    if not equipData then
        return
    end

    local suitNum = 0
    if equipData.Suit == 0 then
        return suitNum, suits
    end

    local suitId = ManagerContainer.CfgMgr:GetEquipSuitById(equipData.Suit)

    for i = 1, #slots do
        if slots[i].equip_id > 0 then
            local equipData1 = ManagerContainer.CfgMgr:GetEquipById(slots[i].equip_id)
            local suitId1 = ManagerContainer.CfgMgr:GetEquipSuitById(equipData1.Suit)
            if suitId == suitId1 or equipData1.EquipLevel >= equipData.EquipLevel then
                suitNum = suitNum + 1
                suits[equipData1.Type] = equipData1.Name
            end
        end
    end

    return suitNum, suits
end

function UserData:GetMinRefineLevel(slots)
    if slots == nil then return 0 end

    local minLv = 100
    for i = 1, #slots do
        if slots[i].level < minLv then
            minLv = slots[i].level
        end
    end
    if minLv == 100 then
        return 0
    end
    if minLv >= 3 then
        return minLv
    end
    return 0
end

function UserData:GetSlotsEquipAttr(slots)
    if slots == nil then return nil end

    local baseAttrs = {}
    for _,v in pairs(Enum.HeroAttrType) do
        baseAttrs[v] = 0
    end

    local suitIds = {}
    local suitCounts = {}
    local refineSuitLv = self:GetMinRefineLevel(slots)
    for i = 1,#slots do
        if slots[i].equip_id > 0 then
            local suitNum = ManagerContainer.DataMgr.UserData:GetSuitNum(slots, i)
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

function UserData:GetSlotsCardAttr(slots)
    if slots == nil then return nil end

    local baseAttrs = {}
    for _,v in pairs(Enum.HeroAttrType) do
        baseAttrs[v] = 0
    end

    for i = 1,#slots do
        --if slots[i].equip_id > 0 then
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
        --end
    end

    return baseAttrs
end

function UserData:Clear()
    self.data = {}
    self:ClearFighterSvrPowers()
    baseAttrs = nil
    lastEquipAttrs = nil
    lastCardAttrs = nil
    lastFashionAttrs = nil
    lastTeamEquipAttrs = nil
    lastTeamCardAttrs = nil
    lastPointAttrs = nil
    lastBaseAttrs = nil
    lastSkillAttrs = nil
    lastPetAttrs = nil
    lastHeadFrameAttrs = nil
    lastKeepSakeAttrs = nil

    self.initedOver = false
    --self:UnRegisterNetEvents()
    self.createRole = nil
    self.createRoleTime = nil
    self.roleUpLvTime = nil
    self.loginTime = nil
end

function UserData:Destroy()
    if self.Clear then
        self:Clear()
        self:ClearFighterSvrPowers()
    end

    self:UnRegisterNetEvents()
end

function UserData:UnRegisterNetEvents()
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("SC_CREATE_ROLE_ACK")
    --ManagerContainer.NetManager:UnRegisterPbNameCallback("SC_STARTUP_INFO_NTF")
end

function UserData:GetCurrency(type)
    if type == Enum.ItemType.Coin then
        return self.data.roleBase.coin
    end

    if type == Enum.ItemType.Diamond then
        return self.data.roleBase.diamond
    end

    if type == Enum.ItemType.RoleBaseExp then
        return self.data.roleBase.roleData.baseExp
    end

    if type == Enum.ItemType.RoleJobExp then
        return self.data.roleBase.roleData.jobExp
    end

    if type == Enum.ItemType.ParterExp then
        return self.data.roleBase.roleData.heroExp
    end

    if type == Enum.ItemType.SkillExp then
        return self.data.roleBase.roleData.cruise
    end

    if type == Enum.ItemType.AdvanceSkillExp then
        return self.data.roleBase.resMap[Enum.ItemType.AdvanceSkillExp] or 0
    end

    return self:GetResById(type)
end

function UserData:OnSetHeadIdAck(data)
    if not data then return end
    local headPortraitId = data.head_id
    local cfgData = ManagerContainer.CfgMgr:GetHeadPortraitDataById(headPortraitId)
    if not cfgData then return end
    self:InitHeadPortrait(headPortraitId)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.USER_HEADPROTRAIT_CHANGED)
end

function UserData:OnUserNameChanged(data)
    if data.error ~= 0 then return end
    if not data.name or data.name == '' then return end
    self.data.roleBase.nickname = data.name

    local mainActor = ManagerContainer.LuaActorDataMgr:GetHeroActorData(1)
    if mainActor ~= nil then
        mainActor.Name = ManagerContainer.DataMgr.UserData:GetUserNickname()
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.NICK_NAME_CREATED)
end

--增加对应压制mark
function UserData:SetActorPveMark(ActorId,actor)
    --LogError(tostring(ActorId))
    local skillData = self:GetSkillData(ActorId)
    if nil == skillData then
        return
    end
    local currNerveLv = skillData:GetCurrNerveLv()
    local allCfgDatas = ManagerContainer.CfgMgr:GetAllSkillSuitNewCfg()
    if currNerveLv > 0 then            --设置压制ID           
        for k, v in pairs(allCfgDatas) do
            if v.Id == currNerveLv then                
                local mark = GvGMark.New(v.buffid, 1)
                actor:SetPveMark(mark)
                --LogError("添加压制markid"..tostring(v.buffid))       
            end
        end                 
    end
end

function UserData:OnVipChangedNtf(data)
    -- LogError('[Wboy] OnVipChangedNtf  ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local exp = self.data.roleBase.resMap[Enum.ItemType.VipExp] or 0
    local lv = self.data.roleBase.vipLv
    local newExp = data.vip_exp
    local newLv = data.vip_level
    self.data.roleBase.resMap[Enum.ItemType.VipExp] = newExp
    self.data.roleBase.vipLv = newLv
    if newLv ~= lv then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VIP_LV_CHANGED, lv, newLv)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_VIP_FUNCLOCK_OPEN_NTF, Enum.TaskType.VIP_Level)
    end
    if newExp ~= exp then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VIP_EXP_CHANGED, newLv, exp, newExp)
    end
end

function UserData:GetHeroLv(heroId)
    if self:IsLeaderHero(heroId) then
        return self:GetRoleLv()
    else
        return ManagerContainer.DataMgr.PartnerData:GetHeroLv(heroId)
    end
end

--- 获得英雄的jobCfgId
---@return integer 主角是JobCfgId, 伙伴是PartnerCfgId
function UserData:GetHeroJobCfgId(heroId)
    if self:IsLeaderHero(heroId) then
        return self:GetJobCfgId()
    else
        return ManagerContainer.DataMgr.PartnerData:GetHeroCfgId(heroId)
    end
end

----------------------------- 未上阵的 战斗力数据

function UserData:GetAOrCreatesideFighterSvrPower()
    if nil == self.AsideFighterPower then
        self.AsideFighterPower = {}
    end
    return self.AsideFighterPower
end

function UserData:ClearFighterSvrPowers()
    self.AsideFighterPower = {}
end

function UserData:AddAsideFighterSvrPower(Id,IsPet,Power)
    --LogError("AddAsideFighterPower"..tostring(Id))
    local tbFigherPower = self:GetAOrCreatesideFighterSvrPower()
    for k,v in pairs(tbFigherPower) do
        if v.Id == Id and v.IsPet == IsPet then
            v.Power = Power
            return
        end
    end
    local PowerInfo = {Id = Id,IsPet = IsPet,Power = Power}
    table.insert( tbFigherPower , PowerInfo)
end

function UserData:RemoveAsideFighterSvrPower(Id,IsPet)
    local NewTb = {}
    local tbFigherPower = self:GetAOrCreatesideFighterSvrPower()
    for k,v in pairs(tbFigherPower) do
        local IsInsert = true
        if v.Id == Id and v.IsPet == IsPet then            
            IsInsert = false
        end
        if IsInsert then
            table.insert(NewTb,v) 
        end
    end
    self.AsideFighterPower = NewTb
end

function UserData:GetAsideFighterSvrPower(Id,IsPet)
    local tbFigherPower = self:GetAOrCreatesideFighterSvrPower()
    for k,v in pairs(tbFigherPower) do
        if v.Id == Id and v.IsPet == IsPet then                  
            return v.Power
        end
    end
    return -1   --服务器未同步计算
end


----------------------------


-------------------------------  技能相关 Start  -------------------------------
function UserData:GetSkillData(heroId)
    local skillData = nil
    local heroData = nil
    if self:IsLeaderHero(heroId) then
        heroData = self.data.roleBase.roleData.heroData
        skillData = heroData.skillData
    else
        heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(heroId)
        skillData = heroData and heroData.skillData or nil
    end
    return skillData, heroData
end

function UserData:GetAllUnlockRoleSkillPress()
    local maxPress = 0
    local skillData = self.data.roleBase.roleData.heroData.skillData
    if skillData then
        maxPress = maxPress + skillData:GetMaxPress()
    end
    local allPartners = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    for k, v in pairs(allPartners) do
        if v.skillData then
            maxPress = maxPress + v.skillData:GetMaxPress()
        end
    end
    return maxPress
end
function UserData:GetCurrRoleSkillPress()
    return self.data.roleBase.RepressSkillPvpVal or 0
end

function UserData:OnJobSkillDataNtf(data)
    if ManagerContainer.NetManager:IsErrorData(data) then return end
    local heroId = data.hero_id
    local skillData, heroData = self:GetSkillData(heroId)
    if skillData then
        local isSlotChanged, newSkills, upLvSkills, downLvSkills = skillData:OnJobSkillDataChange(data)
        local isRefeSelectId = false
        if newSkills and #newSkills > 0 then
            -- 获得新技能
            ManagerContainer.NewGotTipsMgr:AddShowData(1, newSkills)
            isRefeSelectId = true
            self:ReportStudySkill(heroId, newSkills, true)
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SKILL_CHANGED, heroId, newSkills, upLvSkills, downLvSkills,isRefeSelectId)
        if isSlotChanged then
            self:RefreshActorDataSkill(heroData, skillData)
        end
    else
        LogError("[Wboy] SC_JOB_SKILL_DATA_NTF Hero SkillData is not Find, heroId = " .. tostring(heroId) .. "\n" .. Inspect(data))
    end
    local isChanged
    if self:IsLeaderHero(heroId) then
        isChanged = self:CalcSkillAttrs()
    else
        isChanged = ManagerContainer.DataMgr.PartnerData:OnJobSkillDataChanged(heroId)
    end
    if isChanged then
        --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_ATTR_ADD_SUCCESS)
    end
end

function UserData:ReportStudySkill(heroId, newSkills, success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    if self:IsLeaderHero(heroId) then
        for i = 1, #newSkills do
            local datas = System.Collections.Generic.Dictionary_object_object()
            datas:Add('event', 'mj_roleskill')
            datas:Add('num', newSkills[i].skillId)
            SDKMgr.Instance:ReportAction(datas)
        end
    else
        local datas = System.Collections.Generic.Dictionary_object_object()
        datas:Add('event', 'mj_heroskill')
        datas:Add('is_achieve', (success and 1 or 0))
        SDKMgr.Instance:ReportAction(datas)
    end
end

function UserData:OnSkillSlotDataNtf(data)
    if ManagerContainer.NetManager:IsErrorData(data) then return end
    local heroId = data.hero_id
    local skillData, heroData = self:GetSkillData(heroId)
    if skillData then
        skillData:OnSkillSlotDataChange(data)
        self:RefreshActorDataSkill(heroData, skillData)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SKILL_SLOT_CHANGED, heroId)
    else
        LogError("[Wboy] SC_SET_SKILL_LIST_ACK Hero SkillData is not Find, heroId = " .. tostring(heroId) .. "\n" .. Inspect(data))
    end
end

function UserData:RefreshActorDataSkill(heroData, skillData)
    local heroId = heroData.id
    local heroActorData = nil
    local isBattle = false
    if self:IsLeaderHero(heroId) then
        heroActorData = ManagerContainer.LuaActorDataMgr:GetActorData(true, 0)
        isBattle = true
    else
        if heroData.owned then
            heroActorData = ManagerContainer.LuaActorDataMgr:GetActorData(false, heroData.configId)
        end
        isBattle = heroData.isBattle
    end
    if heroActorData then
        if isBattle then
            local usedSkills = skillData:GetUsedSkills() or {}
            CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, usedSkills)
            ManagerContainer.LuaGameMgr:UpdateTeamSkills({{ uid = heroData.id, skills = usedSkills }})
        else
            local usedSkillParams = skillData:GetUsedSkillParams()

            CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, usedSkillParams)

            heroActorData:RefreshSkills(usedSkillParams)
        end
    end
end

function UserData:OnActiveSkillAck(data)
    ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
    -- if ManagerContainer.NetManager:IsErrorData(data) then
    --     LogError("[Wboy] SC_ACTIVE_SKILL_ACK is Error " .. Inspect(data))
    -- end
end

function UserData:OnSkillLevelUpAck(data)
    -- if ManagerContainer.NetManager:IsErrorData(data) then
    --     LogError("[Wboy] SC_SKILL_LEVEL_UP_ACK is Error " .. Inspect(data))
    -- end
end

function UserData:OnSetSkillListAck(data)
    ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
    -- if ManagerContainer.NetManager:IsErrorData(data) then
    --     LogError("[Wboy] SC_SET_SKILL_LIST_ACK is Error " .. Inspect(data))
    -- end
end

function UserData:OnResetSkillLvAck(data)
    if ManagerContainer.NetManager:IsErrorData(data) then return end
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('SkillResetDscTxt3')
end

function UserData:OnSkillResetCountNtf(data)
    if ManagerContainer.NetManager:IsErrorData(data) then return end
    local lastCount = self:GetSkillResetCount()
    local count = data.reset_count or -1
    if lastCount == count then return end
    self.data.roleBase.roleData.skillResetCount = count
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SKILL_RESET_LV_COUNT_CHANGED)
end

function UserData:IsLeaderHero(heroId)
    return heroId == 1
end
-------------------------------   技能相关 End   -------------------------------

--开启了好友的信息界面
function UserData:SCGetOtherPlayerDetailInfoAck(_data, isCross)
    if not isCross then isCross = false end

    _data._targetTag = 1;    
    _data._isCross = isCross;
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMessage, _data)	--打开头像交互界面，显示好友的信息
end

--使用item的返回
function UserData:OnUseItemAck(_data)
    if ManagerContainer.NetManager:IsErrorData(_data) then
        -- LogError("使用商品消息错误返回，错误码：" .. tostring(_data.error));
        return
    end

    CommonUtil.ACKShowRewardList(_data.item_list)
end

function UserData:StartUpEnd()
    if not self.initedOver then
        self.initedOver = true
        ManagerContainer.LuaActorAttributeMgr:SendAttrReq()
        ManagerContainer.DataMgr.PetDataMgr:InitPetRelationAttrs()

        ManagerContainer.LuaBattleMgr:SetTeamData(true,true)

        ManagerContainer.LuaGameMgr:LoadGameSpeed()
        ManagerContainer.RedPointMgr.HeroRPCtr:RoleRedPointNotify()
        ManagerContainer.RedPointMgr.HeroRPCtr:SkillUnlockNotify()

        ManagerContainer.DataMgr.FriendDataMgr:RequestAllData()
        ManagerContainer.DataMgr.MailData:QueryMailData()
        ManagerContainer.DataMgr.GuildDataMgr:SendGuildLoginReq()
        ManagerContainer.DataMgr.CollectionBookData:QueryCardHandBook()
        ManagerContainer.DataMgr.KeepSakeBookData:QueryKeepSakeHandBook()
        ManagerContainer.DataMgr.SignData:QuerySignUpInfoReq()
        ManagerContainer.PayMgr:SendStartUpPayComplete()

        ManagerContainer.DataMgr.RankActivitiesMgr:QueryRankActivitiesData(true)

        ManagerContainer.DataMgr.RuneShopDataMgr:QueryAirShipActivityData()
        ManagerContainer.DataMgr.RuneShopDataMgr:SendShopInfoReq(Enum.RuneShopType.MonthCard,nil)
        ManagerContainer.LuaUIMgr:CloseInputMask()

        --重连后刷新顶部资源
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.COIN_CHANGED)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DIAMOND_CHANGED)

        LogWarning("UserData:StartUpEnd StartEnterGame ")
        self:StartEnterGame()

        self:SDKEnterGame()
        -- 给服务器发送数据，用于Log
        local deviceSystemData = SDKMgr.Instance:GetDeviceSystemData()
        if deviceSystemData then
            local msgData = {
                client_info = {
                    device_model = deviceSystemData.deviceModel,
                    device_height = deviceSystemData.deviceHeight,
                    device_width = deviceSystemData.deviceWidth,
                    os_name = deviceSystemData.osName,
                    os_ver = deviceSystemData.osVer,
                    mac_addr = deviceSystemData.macAddr,
                    udid = deviceSystemData.udid,
                    isp = deviceSystemData.isp,
                    network = deviceSystemData.network,
                    app_channel = deviceSystemData.appChannel,
                    app_ver = deviceSystemData.appVer,
                    trans_id = deviceSystemData.transId,
                    unisdk_deviceid = deviceSystemData.deviceId,
                    is_emulator = deviceSystemData.isEmulator,
                    is_root = deviceSystemData.isRoot,
                    account_id = deviceSystemData.accountId,
                    old_accountid = deviceSystemData.oldAccountId,
                    IMEI = deviceSystemData.imei,
                    country_code = deviceSystemData.countryCode,
                    oaid = deviceSystemData.oaid,
                    engine_ver = deviceSystemData.engineVer,
                }
            }
            ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CLIENT_PARAM_NTF, msgData)
        end
    end
end

function UserData:StartEnterGame(skipCreateRole)
    LogWarning("UserData:StartEnterGame");
    if not skipCreateRole and self.createRole then return end
    if not ManagerContainer.FSMMgr:IsFightingState() then
        -- if self:HasPassedNewbie() then
        if not self.createRole then
            ManagerContainer.LuaGameMgr:EnterBattle(true)
        else
            ManagerContainer.LuaGameMgr:EnterNewbie()
        end
    end
end

function UserData:IsInitedOver()
    return self.initedOver
end

function UserData:SendGiftCode(code)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GIFT_REWARD_REQ, {gift_code = code, uuid = self:GetUserId()})
end

function UserData:OnGiftRewardAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then
        return
    end
    CommonUtil.ACKShowRewardList(data.reward_list)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EXCHANGE_REWARD_SUCCESS)
    self:ReportGiftReward(true)
end

function UserData:ReportGiftReward(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_package_code')
    datas:Add('is_achieve', (success and 1 or 0))
    SDKMgr.Instance:ReportAction(datas)
end

function UserData:SendQuestionReward()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_QUESTION_REWARD_REQ, {})
end

function UserData:OnQuestionRewardAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    self.data.roleBase.questionReward = 1
    CommonUtil.ACKShowRewardList(data.reward_list)

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QUESTION_REWARD_SUCCESS)
end

function UserData:OnChangeJobAck(data, isReplace)
    attrsChanged = true
    if data.hero_id == 1 then
        AvatarRTMgr.Instance:RemoveActor(1)
        --ManagerContainer.LuaBattleMgr:SetTeamData(true)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ROLE_JOB_CHANGE_SUCCESS)
    else
        --ManagerContainer.DataMgr.PartnerData:RefreshPartnerTransfer(data.hero_id)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HERO_JOB_CHANGE_SUCCESS, data.hero_id, isReplace)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.JOB_CHANGE_SUCCESS, data.hero_id, isReplace)

    ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
    ManagerContainer.LuaBattleMgr:UpdateTeamSkills()
  
    if data.hero_id == 1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.USER_HEADPROTRAIT_CHANGED)
    end
end

function UserData:SyncRoleDataToSDK()
    local gameRoleInfo = SDKMgr.Instance:GetGameRoleInfo()
    if not gameRoleInfo then
        return nil
    end
    gameRoleInfo.openId = ManagerContainer.LuaGameMgr.openId
    local serverData = ManagerContainer.LuaGameMgr.serverData
    if serverData then
        gameRoleInfo.serverId = serverData.id or 0
        gameRoleInfo.serverName = serverData.name or ''
    else
        gameRoleInfo.serverId = 0
        gameRoleInfo.serverName = ''
    end
    gameRoleInfo.roleId = tostring(self:GetUserId())
    gameRoleInfo.roleName = tostring(self:GetOriUserNickname())
    gameRoleInfo.roleLv = self:GetRoleLv() or 0
    gameRoleInfo.roleCreateTime = self.createRoleTime or ManagerContainer.LuaTimerMgr:CurServerTime()
    gameRoleInfo.roleUpLvTime = self.roleUpLvTime or ManagerContainer.LuaTimerMgr:CurServerTime()
    gameRoleInfo.vipLv = self:GetVipLv() or 0
    gameRoleInfo.gender = self:GetSex() or 0
    gameRoleInfo.jobId = self:GetJobCfgId() or 0
    gameRoleInfo.jobName = self.data.roleBase.roleData.jobName
    local guildId = 0
    local guildName = ""
    local guildDataMgr = ManagerContainer.DataMgr.GuildDataMgr
    if guildDataMgr then
        if guildDataMgr:HasGuild() then
            local briefData = guildDataMgr:GetCurGuildData():GetBriefData()
            guildId = briefData.id
            guildName = briefData.name
        end
    end
    gameRoleInfo.guildId = guildId
    gameRoleInfo.guildName = guildName
    gameRoleInfo.fightPower = self:GetTotalFightPower()
    gameRoleInfo.lastLogoutTime = self.data.roleBase.roleData.lastLogoutTime
    gameRoleInfo.loginTime = self.loginTime or ManagerContainer.LuaTimerMgr:CurServerTime()
    if self.serverStartTime then
        gameRoleInfo.openServerTime = self.serverStartTime / 1000
    end
    return gameRoleInfo
end


function UserData:SDKEnterGame()
    self.loginTime = ManagerContainer.LuaTimerMgr:CurServerTime()
    self:SyncRoleDataToSDK()
    SDKMgr.Instance:EnterGame()
    SDKMgr.Instance:ReportLoginRole(0, 0, nil)
end

function UserData:SDKExitGame()
    self:SyncRoleDataToSDK()
    SDKMgr.Instance:ExitGame()
    SDKMgr.Instance:ReportLogoutRole(ManagerContainer.LuaTimerMgr:CurServerTime(), nil, nil, nil, 0, 0, nil)
end

function UserData:SDKUpdateRoleLv()
    self.roleUpLvTime = ManagerContainer.LuaTimerMgr:CurServerTime()
    self:SyncRoleDataToSDK()
    SDKMgr.Instance:UpdateRoleLv()
end

function UserData:GetHeroPetFightPowerByHeroId(id)
    local heroData = self:GetHeroData(id)
    if heroData then
        return heroData.petFightPower or 0
    end
    return 0
end

return UserData