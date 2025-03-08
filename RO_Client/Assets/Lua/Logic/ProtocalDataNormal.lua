local ProtocalDataNormal = {}
local SkillData = require('SkillData')

--- 协议数据格式化成lua自己的格式(角色用于表现的数据，头发，眼睛，头发颜色，时装)
function ProtocalDataNormal.FashionDataToViewData(serverFashionData)
    if serverFashionData == nil then return nil end

    local viewData          = {}
    viewData.eye            = serverFashionData.eye
    viewData.hairColor      = serverFashionData.hair
    viewData.hair           = serverFashionData.hair_avatar
    viewData.fashionData    = ProtocalDataNormal.FashionUpDataToData(serverFashionData.fashion_up_list)
    return viewData
end

--- 更新表现数据 把newViewData赋值给oldViewData
function ProtocalDataNormal.UpdateViewData(oldViewData, newViewData)
    if newViewData.eye then oldViewData.eye = newViewData.eye end
    if newViewData.hairColor then oldViewData.hairColor = newViewData.hairColor end
    if newViewData.hair then oldViewData.hair = newViewData.hair end
    if newViewData.fashionData then oldViewData.fashionData = newViewData.fashionData end
end

--- 协议数据格式化成lua自己的格式(角色身上装备的时装数据)
function ProtocalDataNormal.FashionUpDataToData(fashionUpData)
    local fashionData = {}
    for _, value in pairs(fashionUpData) do
        local fashionCfg = ManagerContainer.CfgMgr:GetFashionById(value)
        if fashionCfg then
            fashionData[fashionCfg.FashionLocation] = value
        end
    end
    return fashionData
end

function ProtocalDataNormal.ParseFightPowerData(message)
    local data = {}
    data.totalFightpower = message.total_fightpower
    data.slotFightpower = {}
    for _,v in pairs(message.slot_fightpower) do
        data.slotFightpower[v.key] = v.value
    end
    return data
end

function ProtocalDataNormal.ParseBattleBoxData(message)
    local data = {}
    data.id = message.id
    data.boxId = message.box_id
    data.coolTime = message.cool_time
    data.heroCoolList = message.hero_cool_list
    data.state = message.state
    return data
end

--TASK_REWARD_STATE_NONE = 0 //未完成
--TASK_REWARD_STATE_COMPLETED = 1 //任务完成未领取奖励
--TASK_REWARD_STATE_REWARD = 2 //已经领取奖励
--
--TASK_CONDITION_NONE = 4
--TASK_CONDITION_CHANGE = 5
--TASK_CONDITION_OK = 6
function ProtocalDataNormal.ParseTaskData(message)
    local data = {}
    data.taskId = message.task_id
    data.progress = message.progress
    data.state = message.state
    data.begin_time = message.beginTime
    return data
end

function ProtocalDataNormal.ParseTaskDataList(message)
    local list = nil
    for k,v in pairs(message) do
        if list == nil then
            list = {}
        end
        local data = ProtocalDataNormal.ParseTaskData(v)
        list[v.task_id] = data
    end
    return list
end

function ProtocalDataNormal.ParseRoleTaskData(message)
    if message == nil then return nil end

    local list = {}
    list.condition = {}
    for k,v in pairs(message.condition) do
        local taskList = ProtocalDataNormal.ParseTaskDataList(v.task_list)
        list.condition[v.hero_id] = taskList
    end

    return list
end

function ProtocalDataNormal.ParseHeroData(heroData, userData, isMainRole, isRole)
    local baseAttr = SInt.Convert(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_base_attr_id))

    local data = {}
    data.id             = heroData.id
    data.configId       = heroData.config_id
    data.avatar         = heroData.avatar
    data.isBattle       = heroData.is_battle
    data.headFrame      = heroData.headFrame
    data.baseLevel      = heroData.base_level
    data.fightPower     = heroData.fight_power
    data.skillData      = SkillData:new()
    data.skillData:InitData(heroData.skill)
    data.slot           = heroData.slot
    data.advanceLevel   = heroData.advance_level or 0
    data.strengthLevel  = heroData.strength_level or 0
    data.titleId        = heroData.head_id
    data.owned          =  true --查看别人的信息需要用到的字段，服务器发过来的队友都是获得的
    data.attrs          = {[Enum.HeroAttrType.STR] = baseAttr, [Enum.HeroAttrType.AGI] = baseAttr, [Enum.HeroAttrType.INT] = baseAttr,
                           [Enum.HeroAttrType.DEX] = baseAttr, [Enum.HeroAttrType.VIT] = baseAttr, [Enum.HeroAttrType.LUK] = baseAttr}

    if userData ~= nil then
        userData.roleCfgId  = CommonUtil.JobIdToRoleId(data.configId, userData.gender)
    else
        data.post = ManagerContainer.CfgMgr:GetPartnerDataById(data.configId).PostId
    end

    data.buffs = {}
    if heroData.slot ~= nil and #heroData.slot.slot_list > 0 then
        for k,v in pairs(heroData.slot.slot_list) do
            if #v.card_id_list > 0 then
                for _,v1 in pairs(v.card_id_list) do
                    if v1 > 0 then
                        local cardData = ManagerContainer.CfgMgr:GetCardDataById(v1)
                        if cardData.BUFF and #cardData.BUFF > 0 then
                            data.buffs[#data.buffs + 1] = cardData.BUFF
                        end
                    end
                end
            end
        end
    end

    data.attrList        = clone(heroData.attr_list)
    for _,v in pairs(data.attrList) do
        v.value = SInt.Convert(v.value)
    end
    data.attrPoint      = SInt.Convert(heroData.attr_point)

    data.isMainRole = isMainRole
    data.isRole = isRole

    data.battlePetId = heroData.battle_pet_id
    data.petFightPower = heroData.pet_fight_power or 0
    data.battle_attr_list = heroData.battle_attr_list

    data.skillEquipSlot = ProtocalDataNormal.ParseSkillEquipSlotData(data.skillEquipSlot, heroData.skill_equip_slot) 
    data.petQiyueData = ProtocalDataNormal.ParsePetQiyueData(data.petQiyueData, heroData.pet_qiyue_data) 
    return data
end

function ProtocalDataNormal.ParsePlayerBriefInfo(briefInfoMessage, userData)
    if userData == nil then userData = {} end
    if briefInfoMessage then
        userData.uid            = briefInfoMessage.uid
        userData.nickName       = CommonUtil.GetVaildNickName(briefInfoMessage.nick_name)
        userData.headPortraitId = briefInfoMessage.img_id
        userData.gender         = briefInfoMessage.gender == 0 and 1 or briefInfoMessage.gender
        userData.level          = briefInfoMessage.level
        userData.configId       = briefInfoMessage.config_id
        userData.fightPower     = briefInfoMessage.fight_power
        userData.onlineState    = briefInfoMessage.online_state
        userData.onlineTime     = briefInfoMessage.online_time
        userData.towerLevel     = briefInfoMessage.tower_level
        userData.towerTime      = briefInfoMessage.tower_time
        userData.headFrame      = briefInfoMessage.head_frame_id
        userData.vipLv          = briefInfoMessage.vip_level
        userData.headPortraitName   = CommonUtil.GetPlayerHeadIcon(briefInfoMessage)
        userData.hundredDojoSlogan = briefInfoMessage.daochang100_tips
        userData.roleCfgId = CommonUtil.JobIdToRoleId(userData.configId, userData.gender)
        userData.selectZone = briefInfoMessage.select_zone
        userData.titleId     = briefInfoMessage.head_id
    end
    return userData
end

function ProtocalDataNormal.ParseRobotHeroData(id, configId, robotCfgData, isMainRole, isRole)
    local baseAttr = SInt.Convert(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_base_attr_id))

    local data = {}
    data.id             = id
    data.configId       = configId
    data.avatar         = robotCfgData.RobotAvatar
    data.isBattle       = true
    data.baseLevel      = id == 1 and robotCfgData.RobotLevel or robotCfgData.PartnerLevel[id - 1]
    data.attrs          = {[Enum.HeroAttrType.STR] = baseAttr, [Enum.HeroAttrType.AGI] = baseAttr, [Enum.HeroAttrType.INT] = baseAttr,
                           [Enum.HeroAttrType.DEX] = baseAttr, [Enum.HeroAttrType.VIT] = baseAttr, [Enum.HeroAttrType.LUK] = baseAttr}
    data.strengthLevel = 0

    if id > 1 then
        data.advanceLevel = 0
    end

    data.skills = {}

    -- 和真实玩家一样，对齐技能格式
    local unlockSkillList = {}
    local skillList = {}
    local skill = {job_skill_list = {{unlock_skill_list = unlockSkillList}}, skill_list = skillList}
    if id == 1 then
        for k,v in pairs(robotCfgData.RobotSkill) do
            local skillId = GetMathInteger(v,1000)
            local skillLv = GetMathRemainder(v,1000)
            skillList[#skillList + 1] = {skill_id = skillId, unlock = 1}
            unlockSkillList[#unlockSkillList + 1] = {key = skillId, value = skillLv}
        end
    else
        for k,v in pairs(robotCfgData.PartnerSkill[id - 1]) do
            local skillId = GetMathInteger(v,1000)
            local skillLv = GetMathRemainder(v,1000)
            skillList[#skillList + 1] = {skill_id = skillId, unlock = 1}
            unlockSkillList[#unlockSkillList + 1] = {key = skillId, value = skillLv}
        end
    end
    data.skillData      = SkillData:new()
    data.skillData:InitData(skill)

    data.slot = {}
    data.slot.hero_id = id
    data.slot.slot_list = {}
    if id == 1 then
        for i = 1,6 do
            local data1 = {}
            data1.level = 0
            data1.equip_id = robotCfgData.RobotEquip[i]
            data1.card_id_list = {}
            data.slot.slot_list[i] = data1
        end
    else
        for k,v in pairs(robotCfgData.PartnerEquip[id - 1]) do
            local data1 = {}
            data1.level = 0
            data1.equip_id = v
            data1.card_id_list = {}
            data.slot.slot_list[k] = data1
        end
    end

    data.buffs = {}
    data.isMainRole = isMainRole or false
    data.isRole = isRole or false

    data.battlePetId = 0
    data.skillEquipSlot = nil
    return data
end

function ProtocalDataNormal.ParseMailContentData(message)
    local data = {}
    data.id = message.id
    data.configId = message.config_id
    data.type = message.type
    data.rewardList = message.reward_list
    data.beginTime = message.begin_time
    data.expireTime = message.expire_time
    data.state = message.state
    data.paramList = message.param_list
    data.title = message.title
    data.content = message.content

    return data
end

function ProtocalDataNormal.ParseWorldBossContentInfoData(message)
    if not message then return nil end
    local data = {}
    data.cfgId          = message.cfg_id
    data.bossId         = message.boss_id
    data.bossSummonIdx  = message.boss_summon_idx
    data.boss_summon_type = message.boss_summon_type
    data.brief          = ProtocalDataNormal.ParsePlayerBriefInfo(message.brief)
    data.fighterNum     = message.fighter_num
    data.expireTime     = message.expire_time
    data.nextTime       = message.next_refresh_time
    data.totalHp        = message.total_hp
    data.curHp          = message.cur_hp
    data.isFight        = message.is_fight
    return data
end

function ProtocalDataNormal.ParseWorldBossRandPointInfoData(message)
    if not message then return nil end
    local data = {}
    data.rewardList     = message.reward_list
    data.bossId         = message.boss_id
    data.bossSummonIdx  = message.boss_summon_idx
    return data
end

-- 赛季解析
function ProtocalDataNormal.ParseCompetitionRewardInfo(message)
    if not message then return end

    local data = {}
    data.rewardIdx     = message.reward_idx
    data.rewardEndTme = message.reward_end_tme
    data.paramList  = message.param_list
    return data
end

function ProtocalDataNormal.ParseCompetitionData(message)
    if not message then return nil end
    local data = {}
    data.competitionId     = message.competition_id
    data.curEndTime         = message.cur_end_time
    data.comParam  = message.com_param
    data.nextComScore = message.next_com_score
    data.lastComScore = message.last_com_score
    data.comParamAddTime  = message.com_param_add_time
    data.selfRank  = message.self_rank
    data.totalRank  = message.total_rank

    data.rewardInfoList = {}
    for _,v in pairs(message.reward_info_list) do
        local data1 = ProtocalDataNormal.ParseCompetitionRewardInfo(v)
        data.rewardInfoList[data1.rewardIdx] = data1
    end
    
    if data.rewardInfoList[3] and not data.rewardInfoList[1] then
        local data1 = clone(data.rewardInfoList[3])
        data1.rewardIdx     = 1
        data1.rewardEndTme = data1.rewardEndTme - 2 * ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*2000
        data.rewardInfoList[1] = data1
    end
    if data.rewardInfoList[1] and not data.rewardInfoList[2] then
        local data1 = clone(data.rewardInfoList[1])
        data1.rewardIdx     = 2
        data1.rewardEndTme = data1.rewardEndTme + ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*2000
        data.rewardInfoList[2] = data1
    end
    if data.rewardInfoList[2] and not data.rewardInfoList[3] then
        local data1 = clone(data.rewardInfoList[2])
        data1.rewardIdx     = 3
        data1.rewardEndTme = data1.rewardEndTme + ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*2000
        data.rewardInfoList[3] = data1
    end
    if data.rewardInfoList[3] and not data.rewardInfoList[1] then
        local data1 = clone(data.rewardInfoList[3])
        data1.rewardIdx     = 1
        data1.rewardEndTme = data1.rewardEndTme - 2 * ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*2000
        data.rewardInfoList[1] = data1
    end
    return data
end

function ProtocalDataNormal.ParseArenaRankInfo(message)
    local data = {}
    data.rank = message.rank
    data.briefInfo = ProtocalDataNormal.ParsePlayerBriefInfo(message.brief_info)
    data.score = message.score
    return data
end

function ProtocalDataNormal.ParseSeasonData(message)
    local data = {}
    data.competitionData = ProtocalDataNormal.ParseCompetitionData(message.competition_data)
    data.rankList = {}
    for _,v in pairs(message.rank_list) do
        data.rankList[#data.rankList + 1] = ProtocalDataNormal.ParseArenaRankInfo(v)
    end
    data.nextCompetitionTime = message.next_competition_time
    return data
end

function ProtocalDataNormal.ParseChatMessageInfo(message)
    if message == nil then return end

    local data = {}
    data.message = message.message
    local time = message.send_time/1000
    data.sendTime = #time
    data.sendTime64 = message.send_time
    data.subType = message.sub_type
    data.used = false
    return data
end

function ProtocalDataNormal.ParseChatPlayerBriefInfo(message)
    local data = {}
    data.uid = tostring(message.uid)
    data.nickname = message.nick_name
    data.imgId = CommonUtil.GetPlayerHeadIcon(message)
    data.jobId = message.config_id
    data.level = message.level
    data.headFrameId = message.head_frame_id
    data.sex = message.gender
    data.vipLv = message.vip_level
    data.titleId = message.head_id
    return data
end

function ProtocalDataNormal.ParseChatData(message)
    if message == nil then return end

    local data = {}
    data.type = message.type
    data.message = ProtocalDataNormal.ParseChatMessageInfo(message.message)
    data.targetId = tostring(message.target_id)
    data.fromData = ProtocalDataNormal.ParseChatPlayerBriefInfo(message.from_id)
    return data
end

function ProtocalDataNormal.ParseSystemMessageData(message)
    if message == nil then return end

    local data = {}
    data.type = message.type
    data.nickname = message.nick_name
    data.paramIds = message.param_id
    local time = message.send_time/1000
    data.sendTime = #time
    data.sendTime64 = message.send_time
    return data
end

function ProtocalDataNormal.ParseGMNoticeData(message)
    if message == nil then return end

    local data = {}
    data.content = message.notice_color;
    data.speed = message.notice_speed;
    data.count = message.notice_count;
    data.interval = message.notice_interval;
    return data
end

function ProtocalDataNormal.ParseCardHandBook(message)
    if message == nil then return end

    local data = {}
    data.cardId = message.card_id;
    data.cardLevel = message.card_level;
    data.rewardRec = message.reward_rec;
    return data
end

function ProtocalDataNormal.ParsePetSkillData(message)
    if message == nil then return end

    local data = {}
    data.cfgId = message.config_id;
    data.level = message.level;
    data.rate = message.rate;
    return data
end

function ProtocalDataNormal.ParsePetData(message, data)
    if message == nil then return end

    if not data then
        data = {}
    end
    data.id = message.id;
    data.cfgId = message.config_id;
    data.level = message.level;
    data.advanceLevel = message.advance_level;
    data.heroId = message.hero_id;
    data.isBattle = data.heroId > 0
    data.isRelevant = false
    data.isSupport = false
    data.totalFightPower = 0
    data.pet_svrfight_power = message.pet_fight_power
    data.battle_attr_list = message.battle_attr_list
    data.skillList = {}
    data.totalSkillUpCount = 0
    for _,v in pairs(message.skill_list) do
        local skillData = ProtocalDataNormal.ParsePetSkillData(v)
        data.skillList[#data.skillList + 1] = skillData
        data.totalSkillUpCount = data.totalSkillUpCount + (skillData.level - 1)
    end

    local cfgData = ManagerContainer.CfgMgr:GetPetDataById(data.cfgId)
    data.quality = cfgData.Quality
    data.natureType = cfgData.NatureType

    data.slots = {}
    if message.slot_equip_list then
        for i = 1, #message.slot_equip_list do
            local slotData = message.slot_equip_list[i]
            data.slots[slotData.idx] = {idx = slotData.idx, stampId = slotData.equip_id, stoneIdList = slotData.stone_id_list}
        end
    end

    data.qiyueHeroId = message.qiyue_hero_id
    return data
end

function ProtocalDataNormal.ParsePetBondPosData(message)
    if message == nil then return end

    local data = {}
    data.uid = message.owner_uid;
    data.petId = message.pet_id;
    data.cfgId = message.pet_cfg_id;
    data.advanceLevel = message.advance_level
    return data
end

function ProtocalDataNormal.ParsePetBondData(message)
    if message == nil then return end

    local data = {}
    data.cfgId = message.bond_cfg_id;
    data.relationPets = {}
    for _,v in pairs(message.bond_list) do
        data.relationPets[#data.relationPets + 1] = ProtocalDataNormal.ParsePetBondPosData(v)
    end
    return data
end

function ProtocalDataNormal.ParseAssistData(message)
    if message == nil then return end

    local data = {}
    data.uid = message.owner_uid;
    data.nickname = message.owner_nick_name
    data.supportPets = {}
    for _,v in pairs(message.pet_info_list) do
        data.supportPets[#data.supportPets + 1] = ProtocalDataNormal.ParsePetData(v)
    end
    return data
end

function ProtocalDataNormal.ParseCurRoundSign(message)
    if message == nil then return end

    local data = {}
    data.lastSign = message.last_sign;
    return data
end

function ProtocalDataNormal.ParseSignUp(message)
    if message == nil then return end

    local data = {}
    data.curDay = message.cur_day;
    data.curSignInfo = ProtocalDataNormal.ParseCurRoundSign(message.cur_sign_info);
    return data
end

function ProtocalDataNormal.ParseSignInfo(message)
    if message == nil then return end

    local data = {}
    data.signUp = ProtocalDataNormal.ParseSignUp(message.sign_info);
    data.curSignDay = message.cur_sign_day;
    data.nextSignTime = message.next_sign_time;
    return data
end

function ProtocalDataNormal.ParseInvitationTaskData(message)
    if message == nil then return end

    local data = {}
    data.taskId = message.task_id;
    data.progress = message.progress;
    data.rewardedCount = message.rewarded_count;
    data.rewardCount = message.reward_count ;
    data.completeMaxCount = message.complete_max_count

    data.state = Enum.InvitationTaskStateType.NoCompeleted
    if data.rewardedCount == data.rewardCount and data.rewardCount < data.completeMaxCount then
    elseif data.rewardedCount < data.rewardCount then
        data.state = Enum.InvitationTaskStateType.CompletedAndNoReceive
    elseif data.rewardedCount == data.rewardCount and data.rewardCount == data.completeMaxCount then
        data.state = Enum.InvitationTaskStateType.Received
    end
    return data
end

function ProtocalDataNormal.ParseInvitationLogData(message)
    if message == nil then return end

    local data = {}
    data.memberNickName = message.member_nick_name;
    data.processTime = message.process_time;
    data.resVal = message.res_val;

    return data
end

function ProtocalDataNormal.ParseInvitationMemberValData(message)
    if message == nil then return end

    local data = {}
    data.uid = message.uid;
    data.resVal = message.res_val;

    return data
end

function ProtocalDataNormal.ParseRoleInvitation(message)
    if message == nil then return end

    local data = {}
    data.clickNum = message.click_num;
    data.selfInvitationNumber = message.self_invitation_number;
    data.masterUid = message.master_uid;
    data.masterEndTime = message.master_end_time ;
    data.clickMemberList = message.click_member_list
    data.taskList = {}
    if message.task_list then
        for i = 1, #message.task_list do
            local task = ProtocalDataNormal.ParseInvitationTaskData(message.task_list[i])
            --table.insert(data.taskList, task)
            data.taskList[task.taskId] = task
        end
    end

    data.memberUidList = {}
    if message.member_uid_list then
        for i = 1, #message.member_uid_list do
            local data1 = ProtocalDataNormal.ParseInvitationMemberValData(message.member_uid_list[i])
            table.insert(data.memberUidList, data1)
            --data.memberUidList[data1.uid] = data1
        end
    end

    data.logList = {}
    if message.log_list then
        for i = 1, #message.log_list do
            local log = ProtocalDataNormal.ParseInvitationLogData(message.log_list[i])
            table.insert(data.logList, log)
        end
    end

    data.clickReplayMasterList = message.click_replay_master_list
    return data
end

function ProtocalDataNormal.ParseCommonPlayerBriefInfo(message)
    if not message then return end
    local data = {}
    data.uid            = message.uid
    data.nickName       = CommonUtil.GetVaildNickName(message.nick_name)
    data.headPortraitId = message.img_id
    data.gender         = message.gender
    data.level          = message.level
    data.configId       = message.config_id
    data.fightPower         = message.fight_power
    data.onlineState        = message.online_state
    data.onlineTime         = message.online_time
    data.towerLevel         = message.tower_level
    data.towerTime          = message.tower_time
    data.mapLevelId       = message.map_level_id
    data.battleRecordId   = message.battle_record_id
    data.headFrame          = message.head_frame_id
    data.playerHead     = CommonUtil.GetPlayerHeadIcon(message)
    data.vipLv          = message.vip_level
    data.selectZone     = message.select_zone
    return data
end

function ProtocalDataNormal.RushActivityData(message)
    if not message then return end
    local data = {}
    data.rushType       = message.rush_type
    data.inRush         = message.in_rush
    data.nextRush       = message.next_rush
    data.stage          = message.stage
    data.stageEnd       = message.stage_end
    data.rushCount      = message.rush_count
    return data
end

function ProtocalDataNormal.ParseTowerActivityData(message)
    if not message then return end
    local data = {}
    data.fightCount             = message.fight_count
    data.selfRank               = message.self_rank
    data.selfLevel              = message.self_level
    data.endTime                = message.end_time
    data.challengReward         = message.challeng_reward
    data.rankReward             = message.rank_reward
    data.rushLevel              = message.rush_level
    data.topData = {}
    if message.top_data then
        table.sort(message.top_data, function (a,b)
            return a.rank < b.rank
        end)
        for i = 1,#message.top_data do
            local data1 = {}
            data1.name = message.top_data[i].name
            data1.data = message.top_data[i].data
            data1.rank = message.top_data[i].rank
            data.topData[#data.topData + 1] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParseArenaActivityData(message)
    if not message then return end
    local data = {}
    data.fightCount             = message.fight_count
    data.selfRank               = message.self_rank
    data.selfLevel              = message.self_level
    data.endTime                = message.end_time
    data.challengReward         = message.challeng_reward
    data.rankReward             = message.rank_reward
    data.topData = {}
    if message.top_data then
        table.sort(message.top_data, function (a,b)
            return a.rank < b.rank
        end)
        for i = 1,#message.top_data do
            local data1 = {}
            data1.name = message.top_data[i].name
            data1.data = message.top_data[i].data
            data1.rank = message.top_data[i].rank
            data.topData[#data.topData + 1] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParseRushPetInfoData(message)
    if not message then return end
    local data = {}
    if message then
        for i = 1,#message do
            local data1 = {}
            data1.petCfgId = message[i].pet_config_id
            data1.petScore = message[i].pet_score
            data1.petLevel = message[i].pet_level
            data1.totalSkillLevel = message[i].total_skill_level
            data1.qualityScore = message[i].quality_score
            data1.levelScore = message[i].level_score
            data1.skillScore = message[i].skill_score
            data[#data + 1] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParsePetActivityData(message)
    if not message then return end
    local data = {}
    data.selfScore              = message.self_score
    data.selfRank               = message.self_rank
    data.endTime                = message.end_time
    data.challengReward         = message.challeng_reward
    data.rankReward             = message.rank_reward
    data.topData = {}
    local defaultData = {
        name = "NoneRank",
        totalScore = 0,
        info = {},
        rank = 1,
    }
    for i = 1, 51 do
        local data1 = clone(defaultData)
        data1.rank = i
        data.topData[i] = data1
    end
    if message.top_data then
        table.sort(message.top_data, function (a,b)
            return a.rank < b.rank
        end)
        for i = 1,#message.top_data do
            local data1 = {}
            data1.name = message.top_data[i].name
            data1.totalScore = message.top_data[i].total_score
            if message.top_data[i].pet_info then
                data1.info = ProtocalDataNormal.ParseRushPetInfoData(message.top_data[i].pet_info.info)
            else
                data1.info = {}
            end
            data1.rank = message.top_data[i].rank
            data.topData[data1.rank] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParseSkillActivityData(message)
    if not message then return end
    local data = {}
    data.fightCount             = message.self_level
    data.selfLevel              = message.self_level
    data.selfRank               = message.self_rank
    data.endTime                = message.end_time
    data.challengReward         = message.challeng_reward
    data.rankReward             = message.rank_reward
    data.topData = {}
    local defaultData = {
        name = "NoneRank",
        data = 0,
        rank = 1,
    }
    for i = 1, 51 do
        local data1 = clone(defaultData)
        data1.rank = i
        data.topData[i] = data1
    end
    if message.top_data then
        table.sort(message.top_data, function (a,b)
            return a.rank < b.rank
        end)
        for i = 1,#message.top_data do
            local data1 = {}
            data1.name = message.top_data[i].name
            data1.data = message.top_data[i].data
            data1.rank = message.top_data[i].rank
            data.topData[data1.rank] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParseKeepSakeData(message)
    if not message then return end
    local data = {}
    if message then
        for i = 1,#message do
            local data1 = {}
            data1.keepSakeId = message[i].keep_sake_id
            data1.keepSakeLevel = message[i].keep_sake_level
            data[#data + 1] = data1
        end
    end
    return data
end

function ProtocalDataNormal.ParseSkillEquipData(message)
    local data = {}
    data.id = message.id
    data.cfgId = message.config_id
    data.starLv = message.star_level
    local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data.cfgId)
    data.maxStarLv = cfgData.ArtifactMaxLevel
    data.quality = cfgData.Quality
    data.jobType = cfgData.JobType
    data.jobBranch = cfgData.JobBranch
    data.jobStage = cfgData.JobStage

    data.reforgeSelected = false
    return data
end

function ProtocalDataNormal.ParseSkillEquipSlotData(skillEquipSlot, message)
    if not skillEquipSlot then
        skillEquipSlot = {}
    end
    skillEquipSlot.heroId = message and message.hero_id or 0
    if not skillEquipSlot.slotList then
        skillEquipSlot.slotList = {}
    end
    if not message then 
        return skillEquipSlot
    end
  
    for i = 1 , #message.slot_list do
        local v = message.slot_list[i]
        local data1 = skillEquipSlot.slotList[i]
        if not data1 then
            data1 = {}
            skillEquipSlot.slotList[i] = data1
        end
        data1.id = v.skill_equip_id
        data1.cfgId = v.skill_equip_config_id
        data1.starLv = v.skill_equip_star_level
        data1.slotLv = v.slot_level
        data1.slotAttrs = {}
        for _,v1 in pairs(v.slot_attrs) do
            data1.slotAttrs[v1.key] = v1.value
        end
        local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data1.cfgId)
        data1.maxStarLv = cfgData and cfgData.ArtifactMaxLevel or 0
        data1.quality = cfgData and cfgData.Quality or 0
        data1.jobType = cfgData and cfgData.JobType or 0
    end
    return skillEquipSlot
end

function ProtocalDataNormal.ParsePetQiyueData(petQiyueData, message)
    if not petQiyueData then
        petQiyueData = {}
    end
    petQiyueData.petId = message and message.pet_id or 0
    if not petQiyueData.slotList then
        petQiyueData.slotList = {}
    end
    if not message then 
        return petQiyueData
    end
  
    for i = 1 , #message.qiyue_slot_list do
        local v = message.qiyue_slot_list[i]
        local data1 = petQiyueData.slotList[i]
        if not data1 then
            data1 = {}
            petQiyueData.slotList[i] = data1
        end
        data1.slotIdx = v.slot_idx
        data1.petId = v.pet_id
        data1.petCfgId = v.pet_cfg_id
    end
    return petQiyueData
end

return ProtocalDataNormal