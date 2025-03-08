local HundredDojoLogData = class('HundredDojoLogData')

local LogSort = function(a, b)
    return b.time < a.time
end

function HundredDojoLogData:ctor()
    self.logWhole = false
    self.logs = {}
end

function HundredDojoLogData:Clear()
    self.logWhole = false
    self.logs = {}
end

function HundredDojoLogData:Dispose()
    self.logWhole = nil
    self.logs = nil
end

---@return boolean,boolean|nil,boolean|nil
function HundredDojoLogData:SetLogs(logs, isEnd)
    local len = logs and #logs or 0
    if len <= 0 then
        isEnd = true
    end
    local addStart = false
    local add = false
    local addEnd = false
    if isEnd then
        if self.logWhole ~= isEnd then
            self.logWhole = isEnd
            addEnd = true
        end
    end
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
        if startTime and int64.__lt(startTime, log.record_time) then
            addStart = true
        elseif endTime and int64.__lt(log.record_time, endTime) then
            addEnd = true
        else
            -- 这时候就需要查看是否列表中已存在
            for j = 1, exitLen do
                if int64.equals(self.logs[j].time, log.record_time) then
                    needAdd = false
                    break
                end
            end
        end
        if needAdd then
            add = true
            self.logs[#self.logs + 1] = {
                type        = log.type,
                state       = log.state,
                playerName  = CommonUtil.GetVaildNickName(log.target_player_name),
                guildName   = log.target_guild_name,
                uid         = log.target_player_uid,
                areaId      = log.pos_idx,
                time        = log.record_time,
                rewardTime  = log.reward_time,
            }
        end
    end
    if add then
        table.sort(self.logs, LogSort)
        if #self.logs > 50 then
            for i = 51, #self.logs do
                self.logs[i] = nil
            end
        end
    end
    return add, addStart, addEnd
end


function HundredDojoLogData:GetReloadLogStartTime()
    return 0
end

function HundredDojoLogData:GetNextLoadLogStartTime()
    if self.logWhole then return nil end
    if self.logs then
        local log = self.logs[#self.logs]
        if log and log.time then
            return log.time
        end
    end
    return self:GetReloadLogStartTime()
end

function HundredDojoLogData:GetLogById(idx)
    if not self.logs then return nil end
    return self.logs[idx]
end

function HundredDojoLogData:GetLogs()
    return self.logs
end

function HundredDojoLogData:GetLogNum()
    if not self.logs then return 0 end
    return #self.logs
end

function HundredDojoLogData:GetLogWhole()
    return self.logWhole
end

return HundredDojoLogData