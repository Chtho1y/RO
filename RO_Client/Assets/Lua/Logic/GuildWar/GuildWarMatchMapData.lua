local GuildWarMatchMapData = class('GuildWarMatchMapData')

local MatchMapState = Enum.GuildWarMatchMapState

function GuildWarMatchMapData:ctor()
end

function GuildWarMatchMapData:Clear()
    self.curMatchMapState = nil
    self.beign1 = nil
    self.end1 = nil
    self.beign2 = nil
    self.end2 = nil
    self.beign3 = nil
    self.end3 = nil
    self.matchMap = nil
end

function GuildWarMatchMapData:Dispose()
    self.curMatchMapState = nil
    self.beign1 = nil
    self.end1 = nil
    self.beign2 = nil
    self.end2 = nil
    self.beign3 = nil
    self.end3 = nil
    self.matchMap = nil
end

function GuildWarMatchMapData:InitData(msgData)
    if not msgData then
        self:Clear()
        return
    end
    self.curMatchMapState = msgData.cur_stge
    self.ready1 = msgData.tournament_prepare
    self.beign1 = msgData.tournament_begin
    self.end1 = msgData.tournament_end
    self.ready2 = msgData.semifinals_prepare
    self.beign2 = msgData.semifinals_begin
    self.end2 = msgData.semifinals_end
    self.ready3 = msgData.finals_prepare
    self.beign3 = msgData.finals_begin
    self.end3 = msgData.finals_end
    local matchMap = nil
    if msgData.data then
        matchMap = {}
        for _, value in pairs(msgData.data) do
            local data =
            {
                idx = value.battle_index,
                id1 = value.guild1_id,
                name1 = value.guild1_name,
                badge1 = value.guild1_badge,
                id2 = value.guild2_id,
                name2 = value.guild2_name,
                badge2 = value.guild2_badge,
                state = value.state,
                isWin = value.win_guild,
            }
            matchMap[data.idx] = data
        end
    end
    self.matchMap = matchMap
end

function GuildWarMatchMapData:HasValid()
    local luaServerTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local time1, time2
    if self.curMatchMapState == MatchMapState.Start then
        time1 = self.ready1
    elseif self.curMatchMapState == MatchMapState.OneReady then
        time1 = self.beign1
        time2 = self.ready1
    elseif self.curMatchMapState == MatchMapState.One then
        time1 = self.end1
        time2 = self.beign1
    elseif self.curMatchMapState == MatchMapState.TwoWait then
        time1 = self.ready2
        time2 = self.end1
    elseif self.curMatchMapState == MatchMapState.TwoReady then
        time1 = self.beign2
        time2 = self.ready2
    elseif self.curMatchMapState == MatchMapState.Two then
        time1 = self.end2
        time2 = self.beign2
    elseif self.curMatchMapState == MatchMapState.ThreeWait then
        time1 = self.ready3
        time2 = self.end2
    elseif self.curMatchMapState == MatchMapState.ThreeReady then
        time1 = self.beign3
        time2 = self.ready3
    elseif self.curMatchMapState == MatchMapState.Three then
        time1 = self.end3
        time2 = self.beign3
    elseif self.curMatchMapState == MatchMapState.Result then
        return luaServerTime > self.end3
    elseif self.curMatchMapState == MatchMapState.End then
        return luaServerTime > self.end3
    else
        time1 = self.beign1
    end
    if time1 then
        if time1 > luaServerTime then
            if time2 then
                return time2 <= luaServerTime
            else
                return true
            end
        end
    end
    return false
end

function GuildWarMatchMapData:GetNextRefreshRemainTime()
    local luaServerTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local remainTime = nil
    if luaServerTime <= self.ready1 then
        remainTime = self.ready1 - luaServerTime
    elseif luaServerTime <= self.beign1 then
        remainTime = self.beign1 - luaServerTime
    elseif luaServerTime <= self.end1 then
        remainTime = self.end1 - luaServerTime
    elseif luaServerTime <= self.ready2 then
        remainTime = self.ready2 - luaServerTime
    elseif luaServerTime <= self.beign2 then
        remainTime = self.beign2 - luaServerTime
    elseif luaServerTime <= self.end2 then
        remainTime = self.end2 - luaServerTime
    elseif luaServerTime <= self.ready3 then
        remainTime = self.ready3 - luaServerTime
    elseif luaServerTime <= self.beign3 then
        remainTime = self.beign3 - luaServerTime
    elseif luaServerTime <= self.end3 then
        remainTime = self.end3 - luaServerTime
    end
    if remainTime then
        remainTime = remainTime / 1000
		if type(remainTime) == 'userdata' then
			remainTime = #remainTime
        end
        remainTime = remainTime + 3
    end
    return remainTime
end


function GuildWarMatchMapData:GetBattleDataById(id)
    return self.matchMap and self.matchMap[id] or nil
end

function GuildWarMatchMapData:GetCurMatchMapState()
    return self.curMatchMapState
end


return GuildWarMatchMapData