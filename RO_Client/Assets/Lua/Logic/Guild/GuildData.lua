local GuildData = class('GuildData')

function TableRemove(ls, value)
    for i = #ls, 1, -1 do
        if ls[i] == value then
            table.remove(ls, i)
        end
    end
end

local MemberSort = function(a, b)
    if a.brief.post == b.brief.post then
        if a.brief.offlineTime == b.brief.offlineTime then
            return a.brief.uid < b.brief.uid
        else
            if a.brief.offlineTime == 0 then
                return true
            elseif b.brief.offlineTime == 0 then
                return false
            else
                return a.brief.offlineTime > b.brief.offlineTime
            end
        end
    else
        return a.brief.post > b.brief.post
    end
end

local AuditApplySort = function(a, b)
    if a.playerBrief.onlineState == b.playerBrief.onlineState then
        if a.playerBrief.onlineTime == b.playerBrief.onlineTime then
            if a.playerBrief.fightPower == b.playerBrief.fightPower then
                return a.playerBrief.uid < b.playerBrief.uid
            else
                return a.playerBrief.fightPower > b.playerBrief.fightPower
            end
        else
            return a.playerBrief.onlineTime > b.playerBrief.onlineTime
        end
    else
        return a.playerBrief.onlineState
    end
end

local LogSort = function(a, b)
    return b.time < a.time
end


function GuildData:ctor()
end

function GuildData:Dispose()
    self:ClearGuildData()
    self.isSubmitApply = nil    --  是否申请过加入该公会
    self.nextCDTime = nil   -- 下一次可加入公会的时间戳
end

function GuildData:SetBriefData(msg)
    if not msg then return end
    local brief = self.brief
    if not brief then
        brief = {}
        self.brief = brief
    end
    brief.id = msg.guild_id
    brief.name = msg.guild_name
    brief.badge = msg.guild_badge
    brief.level = msg.guild_level
    brief.active = msg.guild_active
    if brief.badge then
        local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(brief.badge)
        if badgeCfgData then
            brief.badgeResPath = badgeCfgData.Pic
        end
    end
    if brief.level then
        local lvCfgData = ManagerContainer.CfgMgr:GetGuildLvCfgById(brief.level)
        if lvCfgData then
            self.memberLimit = lvCfgData.PeopleLimit
            brief.activeLimit = lvCfgData.ActiveLimit
        end
    end
end

function GuildData:SetMemberNum(msg)
    self.memberNum = msg
end

function GuildData:SetSubmitApply(msg)
    self.isSubmitApply = msg
end

function GuildData:SetHasApply(msg)
    self.isHasApply = msg
end

function GuildData:SetNextCDTime(msg)
    self.nextCDTime = msg
end

function GuildData:SetNotifyData(msg)
    if not msg then return end
    self:SetBriefData(msg.brief)
    self:SetMemberNum(msg.mem_count)
    self:SetSubmitApply(msg.is_apply)
end

function GuildData:SetBaseData(msg)
    if not msg then return end
    self:SetBriefData(msg.guild_brief)
    local base = self.base
    if not base then
        base = {}
        self.base = base
    end
    base.exp = msg.guild_exp or 0
    base.activeDay = msg.day_active or 0
    base.notice = msg.notice
    base.activeTime = msg.active_time
    base.recuritType = msg.recruit_type
    base.recuritLevel = msg.recruit_level
    base.recruitNotice = msg.recruit_notice
    if self.brief.level then
        local lvCfgData = ManagerContainer.CfgMgr:GetGuildLvCfgById(self.brief.level)
        if lvCfgData then
            base.expLimit = lvCfgData.ExpRequire
        end
    end
    if not base.expLimit then
        base.expLimit = 0
    end
end

function GuildData:SetMemberBriefDatas(msg)
    if not msg then return end
    self.members = {}
    self.memberMap = {}
    for _, value in pairs(msg) do
        local memberBrief = {
            uid = value.uid,
            offlineTime = value.offline_time,
            post = value.title,
        }
        if self.memberMap[memberBrief.uid] then
            self.memberMap[memberBrief.uid].brief = memberBrief
        else
            local member = {}
            member.brief = memberBrief
            self.members[#self.members + 1] = member
            self.memberMap[memberBrief.uid] = member
        end
    end
    self.memberNum = #self.members
    table.sort(self.members, MemberSort)
end

function GuildData:SetMemberInfoDatas(msg)
    if not msg then return end
    if not self.members or not self.memberMap then return end
    for _, value in pairs(msg) do
        local brief = value.brief
        if brief then
            local uid = brief.uid
            local member = self.memberMap[uid]
            if member then
                member.playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(brief)
                member.active = value.total_active
            end
        end
    end
end

function GuildData:SetRoleGuildData(msg, active)
    if not msg then return end
    local id = msg.guild_id
    if id ~= self.brief.id then
        return
    end
    self.nextCDTime = msg.next_join
    local role = self.role
    if not role then
        role = {}
        self.role = role
    end
    local activeInfo = msg.guild_active
    if activeInfo then
        role.activeTotal = activeInfo.active_value
        role.activeDay = activeInfo.day_active_value
        role.activeUpdateTime = activeInfo.active_time
    else
        role.activeTotal = 0
        role.activeDay = 0
        role.activeUpdateTime = 0
    end
    role.active = active
    role.quitNum = msg.quit_num
end

function GuildData:SetGuildQuitData(quitNum, nextCDTime)
    local changed = false
    if self.nextCDTime ~= nextCDTime then
        self.nextCDTime = nextCDTime
        changed = true
    end
    if self.role then
        if self.role.quitNum ~= quitNum then
            self.role.quitNum = quitNum
            changed = true
        end
    end
    return changed
end

function GuildData:ChangeMemberPost(uid, post)
    if not self.members or not self.memberMap then return false end
    local member = self.memberMap[uid]
    if not member then return false end
    local brief = member.brief
    if not brief then return false end
    if brief.post == post then return false end
    brief.post = post
    table.sort(self.members, MemberSort)
    return true
end

function GuildData:KickMember(uid)
    if not self.members or not self.memberMap then return false end
    local member = self.memberMap[uid]
    if not member then return false end
    for i = #self.members, 1, -1 do
        if self.members[i] == member then
            table.remove(self.members, i)
            break
        end
    end
    self.memberNum = #self.members
    self.memberMap[uid] = nil
    return true
end

function GuildData:SetGuildName(newName)
    if not self.brief then return false end
    if self.brief.name == newName then return false end
    self.brief.name = newName
    return true
end

function GuildData:SetGuildNotice(newNotice)
    if not self.base then return false end
    if self.base.notice == newNotice then return false end
    self.base.notice = newNotice
    return true
end

function GuildData:SetGuildBadge(newBadge)
    if not self.brief then return false end
    if self.brief.badge == newBadge then return false end
    self.brief.badge = newBadge
    local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(newBadge)
    if badgeCfgData then
        self.brief.badgeResPath = badgeCfgData.Pic
    end
    return true
end

function GuildData:SetGuildRecuitInfo(recuritType, recuritLevel, recruitNotice)
    if not self.base then return false end
    if self.base.recuritType == recuritType
        and self.base.recuritLevel == recuritLevel
        and self.base.recruitNotice == recruitNotice then
        return false
    end
    self.base.recuritType = recuritType
    self.base.recuritLevel = recuritLevel
    self.base.recruitNotice = recruitNotice
    return true
end

function GuildData:SetAuditApplyData(uidList)
    if not uidList then
        self.isHasApply = false
        return
    end
    local dataMap = {}
    local datas = {}
    if uidList then
        for i = 1, #uidList do
            local uid = uidList[i]
            local data = {}
            data.uid = uid
            dataMap[uid] = data
            datas[#datas + 1] = data
        end
    end
    self.auditApplys = datas
    self.auditApplyMap = dataMap
    self.isHasApply = (#self.auditApplys > 0)
end

function GuildData:SetAuditApplyPlayBrief(playerBriefs)
    if not playerBriefs then return end
    if not self.auditApplys or not self.auditApplyMap then return nil end
    for i = 1, #playerBriefs do
        local playerBrief = playerBriefs[i]
        local uid = playerBrief.uid
        local auditApply = self.auditApplyMap[uid]
        if auditApply then
            auditApply.playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(playerBrief)
        end
    end
    if self.auditLoadings then
        for i = #self.auditLoadings, 1, -1 do
            local loadUid = self.auditLoadings[i]
            local auditApply = self.auditApplyMap[loadUid]
            if auditApply and not auditApply.playerBrief then
                self.auditApplyMap[loadUid] = nil
                TableRemove(self.auditApplys, auditApply)
            end
        end
    end
    self.isHasApply = (#self.auditApplys > 0)
    self.auditLoadings = {}
end

---@return integer  0：无变化；1：删除了申请；2：公会成员有变化；3:无变化
function GuildData:SetAuditApplyHandle(handleType, uidList)
    if not self.auditApplys or not self.auditApplyMap then return 0 end
    local errorCode = nil
    if handleType == Enum.GuildAduitApplyHandleType.AllRefuse then
        self.auditApplys = nil
        self.auditApplyMap = nil
        self.isHasApply = false
        return 1, errorCode
    else
        local auditApplyChanged = false
        local memberChanged = false
        if uidList then
            for _, value in pairs(uidList) do
                local uid = value.key
                local applyType = value.value
                errorCode = value.value2
                local auditApply = self.auditApplyMap[uid]
                if auditApply and applyType ~= Enum.GuildAduitApplyType.Untreated then
                    self.auditApplyMap[uid] = nil
                    TableRemove(self.auditApplys, auditApply)
                    auditApplyChanged = true
                end
                if applyType == Enum.GuildAduitApplyType.Allow then
                    if self.members and self.memberMap then
                        if not self.memberMap[uid] then
                            local memberBrief = {
                                uid = uid,
                                post = Enum.GuildPostType.None,
                            }
                            if auditApply then
                                if auditApply.playerBrief then
                                    if auditApply.playerBrief.onlineState then
                                        memberBrief.offlineTime = 0
                                    else
                                        memberBrief.offlineTime = auditApply.playerBrief.onlineTime
                                    end
                                else
                                    memberBrief.offlineTime = 0
                                end
                            else
                                memberBrief.offlineTime = 0
                            end
                            local member = {}
                            member.brief = memberBrief
                            self.members[#self.members + 1] = member
                            self.memberMap[uid] = member
                            memberChanged = true
                        end
                    end
                end
            end
        end
        self.isHasApply = (#self.auditApplys > 0)
        if memberChanged then
            if self.members and self.memberMap then
                self.memberNum = #self.members
                table.sort(self.members, MemberSort)
            end
            return 2, (handleType == Enum.GuildAduitApplyHandleType.One and errorCode or nil)
        else
            return auditApplyChanged and 1 or 3, (handleType == Enum.GuildAduitApplyHandleType.One and errorCode or nil)
        end
    end
end

---@return boolean,boolean|nil,boolean|nil
function GuildData:SetLogs(logs, isEnd)
    local addStart = false
    local add = false
    local addEnd = false
    if isEnd then
        if self.logWhole ~= isEnd then
            self.logWhole = isEnd
            addEnd = true
        end
    end
    if not logs then return add, addStart, addEnd end
    local len = #logs
    if len <= 0 then return add, addStart, addEnd end
    if not self.logs then
        self.logs = {}
    end
    local exitLen = #self.logs
    local startTime = nil
    local endTime = nil
    if self.logs[1] then
        startTime = self.logs[1].time
    end
    if self.logs[exitLen] then
        endTime = self.logs[exitLen].time
    end
    for i = 1, len do
        local log = logs[i]
        local needAdd = true
        if startTime and int64.__lt(startTime, log.event_time) then
            addStart = true
        elseif endTime and int64.__lt(log.event_time, endTime) then
            addEnd = true
        else
            -- 这时候就需要查看是否列表中已存在
            for j = 1, exitLen do
                if int64.equals(self.logs[j].time, log.event_time) then
                    needAdd = false
                    break
                end
            end
        end
        if needAdd then
            add = true
            self.logs[#self.logs + 1] = {
                opPost      = log.op_title,
                opName      = CommonUtil.GetVaildNickName(log.op_name),
                beOpPost    = log.be_op_title,
                beOpName    = CommonUtil.GetVaildNickName(log.be_op_name),
                type        = log.event_type,
                time        = log.event_time,
            }
        end
    end
    if add then
        table.sort(self.logs, LogSort)
    end
    return add, addStart, addEnd
end

function GuildData:SetHuntBossList(huntBossMsgs, huntBossExts, huntBossCd)
    self.huntBossCd = huntBossCd
    if not huntBossMsgs then return end
    local huntBossMap = self.huntBossMap
    if not huntBossMap then
        huntBossMap = {}
        self.huntBossMap = huntBossMap
    end
    for i = 1, #huntBossMsgs do
        local huntBossMsg = huntBossMsgs[i]
        if huntBossMsg then
            local huntBoss = {
                id = huntBossMsg.boss_id,
                fightTime = huntBossMsg.fight_time,
                fightCdTime = huntBossMsg.fight_cd_time
            }
            if huntBossMap[huntBoss.id] then
                LogWarning('[Wboy] Exist Some Boss lastBoss : ' .. Inspect(huntBossMap[huntBoss.id]) .. '\ncurBoss : ' .. Inspect(huntBoss))
            end
            huntBossMap[huntBoss.id] = huntBoss
        end
    end
    for i = 1, #huntBossExts do
        local huntBossExt = huntBossExts[i]
        if huntBossExt then
            if huntBossMap[huntBossExt.key] then
                huntBossMap[huntBossExt.key].remainNum = huntBossExt.value
            end
        end
    end
end

function GuildData:SetHuntBossInfo(bossId, guildActive, fightTime, remainNum)
    if self.brief then
        self.brief.active = guildActive
    end
    if not self.huntBossMap then return end
    local huntBoss = self.huntBossMap[bossId]
    if not huntBoss then
        huntBoss = {}
        huntBoss.id = bossId
        self.huntBossMap[bossId] = huntBoss
    end
    huntBoss.fightTime = fightTime
    huntBoss.fightCdTime = 0
    if remainNum then
        huntBoss.remainNum = remainNum
    end
end

---@return boolean,boolean|nil,boolean|nil
function GuildData:SetHuntBossLogs(bossId, huntBossLogMsgs, isEnd)
    local addStart = false
    local add = false
    local addEnd = false
    if not self.huntBossMap then return add, addStart, addEnd end
    local huntBoss = self.huntBossMap[bossId]
    if not huntBoss then return add, addStart, addEnd end
    local logInfo = huntBoss.logInfo
    if not logInfo then
        logInfo = {}
        huntBoss.logInfo = logInfo
    end
    if isEnd then
        if logInfo.logWhole ~= isEnd then
            logInfo.logWhole = isEnd
        end
    end
    if not huntBossLogMsgs then return add, addStart, addEnd end
    local len = #huntBossLogMsgs
    if len <= 0 then return add, addStart, addEnd end
    local logs = logInfo.logs
    if not logs then
        logs = {}
        logInfo.logs = logs
    end
    local exitLen = #logs
    local startTime = nil
    local endTime = nil
    if logs[1] then
        startTime = logs[1].time
    end
    if logs[exitLen] then
        endTime = logs[exitLen].time
    end
    for i = 1, len do
        local huntBossLogMsg = huntBossLogMsgs[i]
        local fightLog = huntBossLogMsg.fight_log
        if fightLog then
            local needAdd = true
            if startTime and int64.__lt(startTime, fightLog.fight_time) then
                addStart = true
            elseif endTime and int64.__lt(fightLog.fight_time, endTime) then
                addEnd = true
            else
                -- 这时候就需要查看是否列表中已存在
                for j = 1, exitLen do
                    if int64.equals(logs[j].time, fightLog.fight_time) then
                        needAdd = false
                        break
                    end
                end
            end
            if needAdd then
                add = true
                local log = {}
                log.playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(huntBossLogMsg.info)
                log.uid = fightLog.uid
                log.time = fightLog.fight_time
                log.damage = fightLog.damage
                logs[#logs + 1] = log
            end
        end
    end
    if add then
        table.sort(logs, LogSort)
    end
    return add, addStart, addEnd
end

function GuildData:SetHuntBossMasterReward(bossId, brief, damage)
    if not self.huntBossMap then return end
    local huntBoss = self.huntBossMap[bossId]
    if not huntBoss then return end
    local masterReward = huntBoss.masterReward
    if not masterReward then
        masterReward = {}
        huntBoss.masterReward = masterReward
    end
    masterReward.playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(brief)
    masterReward.damage = damage
end

function GuildData:SetGuildWarInfo(curState, nextStateTime, cp, rank)
    local guildWarInfo = self.guildWarInfo
    if guildWarInfo and guildWarInfo.curState == curState
        and guildWarInfo.nextStateTime == nextStateTime
        and guildWarInfo.cp == cp
        and guildWarInfo.rank == rank then
        return false
    end
    if not guildWarInfo then
        guildWarInfo = {}
        self.guildWarInfo = guildWarInfo
    end
    guildWarInfo.curState = curState
    guildWarInfo.nextStateTime = nextStateTime
    guildWarInfo.cp = cp
    guildWarInfo.rank = rank
    return true
end









function GuildData:GetValidMemberNum()
    local num = 0
    for i = 1, #self.members do
        local member = self.members[i]
        if member.playerBrief then
            num = num + 1
        end
    end
    return num
end

function GuildData:GetNextLoadMemberUid(loadNum)
    if not self.members or not self.memberMap then return nil end
    local ls = {}
    for i = 1, #self.members do
        local member = self.members[i]
        if not member.playerBrief then
            ls[#ls + 1] = member.brief.uid
            if #ls >= loadNum then
                break
            end
        end
    end
    return ls
end

function GuildData:GetNeedLoadMemberMoreInfo(startIdx, endIdx)
    if not self.members or not self.memberMap then return nil end
    local uids = {}
    for i = startIdx, endIdx do
        local member = self.members[i]
        if member and not member.playerBrief then
            uids[#uids + 1] = member.brief.uid
        end
    end
    return uids
end

function GuildData:GetMemberMoreInfoByidx(idx)
    if not self.members or not self.memberMap then return nil end
    return self.members[idx]
end

function GuildData:GetMemberMoreInfoByUid(uid)
    if not self.members or not self.memberMap then return nil end
    return self.memberMap[uid]
end

function GuildData:GetId()
    return self.brief and self.brief.id or 0
end

function GuildData:GetName()
    return self.brief and self.brief.name or nil
end

function GuildData:IsSameGuild(id)
    if not id then return false end
    if self.brief then
        if self.brief.id then
            return self.brief.id == id
        end
    end
    return false
end

function GuildData:GetBriefData()
    return self.brief
end

function GuildData:GetBaseData()
    return self.base
end

function GuildData:GetRoleData()
    return self.role
end

function GuildData:GetGuildMemberNum()
    return self.memberNum or 0
end

function GuildData:GetGuildMemberLimit()
    return self.memberLimit or 0
end

function GuildData:GetGuildMemberPost(uid)
    if not self.members or not self.memberMap then return Enum.GuildPostType.None end
    local member = self.memberMap[uid]
    if not member then return Enum.GuildPostType.None end
    local brief = member.brief
    if not brief then return Enum.GuildPostType.None end
    return brief.post or Enum.GuildPostType.None
end

function GuildData:ClearGuildData()
    self.brief = nil
    self.base = nil
    self.members = nil
    self.memberMap = nil
    self.memberNum = nil
    self.memberLimit = nil
    self.role = nil
    self.isHasApply = nil
    self:ClearAuditApplyData()
    self:ClearLogs()
    self:ClearHuntBoss()
    self:ClearGuildWarInfo()
end

function GuildData:GetIsSubmitApply()
    return self.isSubmitApply
end

function GuildData:GetIsHasApply()
    return self.isHasApply
end

function GuildData:GetNextCDTime()
    return self.nextCDTime
end

function GuildData:GetNextLoadAuditApplyUids(loadNum)
    if self.auditLoadings and #self.auditLoadings > 0 then return nil end
    if not self.auditApplys or not self.auditApplyMap then return nil end
    if not self.auditLoadings then self.auditLoadings = {} end
    for i = 1, #self.auditApplys do
        local auditApply = self.auditApplys[i]
        if not auditApply.playerBrief then
            self.auditLoadings[#self.auditLoadings + 1] = auditApply.uid
            if #self.auditLoadings >= loadNum then
                break
            end
        end
    end
    if not self.auditLoadings or #self.auditLoadings <= 0 then
        table.sort(self.auditApplys, AuditApplySort)
    end
    return self.auditLoadings
end

function GuildData:GetNextAuditApplyById(idx)
    if not self.auditApplys or not self.auditApplyMap then return nil end
    return self.auditApplys[idx]
end

function GuildData:GetAuditApplys()
    return self.auditApplys
end

function GuildData:GetAuditApplyUids()
    if not self.auditApplys or not self.auditApplyMap then return nil end
    local uids = {}
    for uid, _ in pairs(self.auditApplyMap) do
        uids[#uids + 1] = uid
    end
    return uids
end

function GuildData:GetAuditApplyNum()
    if not self.auditApplys or not self.auditApplyMap then return 0 end
    return #self.auditApplys
end

function GuildData:ClearAuditApplyData()
    self.auditLoadings = nil
    self.auditApplys = nil
    self.auditApplyMap = nil
end



function GuildData:GetReloadLogStartTime()
    return 0
end

function GuildData:GetNextLoadLogStartTime()
    if self.logWhole then return nil end
    if self.logs then
        local log = self.logs[#self.logs]
        if log and log.time then
            return log.time
        end
    end
    return self:GetReloadLogStartTime()
end

function GuildData:GetLogById(idx)
    if not self.logs then return nil end
    return self.logs[idx]
end

function GuildData:GetLogs()
    return self.logs
end

function GuildData:GetLogNum()
    if not self.logs then return 0 end
    return #self.logs
end

function GuildData:GetLogWhole()
    return self.logWhole
end

function GuildData:ClearLogs()
    self.logs = nil
    self.logWhole = nil
end





function GuildData:GetHuntBossInfoById(id)
    if not self.huntBossMap then return end
    return self.huntBossMap[id]
end

function GuildData:GetHuntBossCd()
    return self.huntBossCd
end

function GuildData:ClearHuntBoss()
    if self.huntBossMap then
        for key, _ in pairs(self.huntBossMap) do
            self:ClearHuntBossLogs(key)
            self:ClearHuntBossMasterReward(key)
        end
    end
    self.huntBossMap = nil
    self.huntBossCd = nil
end

function GuildData:GetReloadHuntBossLogStartTime(id)
    if not self:GetHuntBossInfoById(id) then return nil end
    return 0
end

function GuildData:GetNextLoadHuntBossLogStartTime(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return nil end
    local logInfo = huntBoss.logInfo
    if not logInfo then return nil end
    if logInfo.logWhole then return nil end
    if logInfo.logs then
        local log = logInfo.logs[#logInfo.logs]
        if log and log.time then
            return log.time
        end
    end
    return self:GetReloadHuntBossLogStartTime(id)
end

function GuildData:GetHuntBossLogById(id, idx)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return nil end
    local logInfo = huntBoss.logInfo
    if not logInfo then return nil end
    if not logInfo.logs then return nil end
    return logInfo.logs[idx]
end

function GuildData:GetHuntBossLogs(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return nil end
    local logInfo = huntBoss.logInfo
    if not logInfo then return nil end
    return logInfo.logs
end

function GuildData:GetHuntBossLogNum(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return nil end
    local logInfo = huntBoss.logInfo
    if not logInfo then return nil end
    return logInfo.logs and #logInfo.logs or 0
end

function GuildData:GetHuntBossLogWhole(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return false end
    local logInfo = huntBoss.logInfo
    if not logInfo then return false end
    return logInfo.logWhole and true or false
end

function GuildData:ClearHuntBossLogs(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return end
    huntBoss.logInfo = nil
end


function GuildData:GetHuntBossMasterReward(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return end
    return huntBoss.masterReward
end

function GuildData:ClearHuntBossMasterReward(id)
    local huntBoss = self:GetHuntBossInfoById(id)
    if not huntBoss then return end
    huntBoss.masterReward = nil
end

function GuildData:GetGuildWarInfo()
    return self.guildWarInfo
end

function GuildData:ClearGuildWarInfo()
    self.guildWarInfo = nil
end

return GuildData