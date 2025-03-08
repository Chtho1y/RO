local DemonGuildRankItemCtr = {}

function DemonGuildRankItemCtr:SetData(wnd, item, logicData, enterType)
    local harmValue  = logicData.damage or 0
    local rank = logicData.rank or 0
    item.rankTxt:SetActive(rank == 0 or rank > 3)
    item.rank1:SetActive(rank == 1)
    item.rank2:SetActive(rank == 2)
    item.rank3:SetActive(rank == 3)
    local PlayerInfoMaxLimit = GlobalConfig.Instance:GetConfigIntValue(338) or 50
    if rank <= 0 or rank > PlayerInfoMaxLimit then
        item.rankTxt.text.text = I18N.SetLanguageValue('NoRank')
    else
        item.rankTxt.text.text = tostring(rank)
    end
    item.number.text.text = CommonUtil.FormatNumber(harmValue)
    local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
    local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
    if not demonData then
        return
    end
    local totalHarm = harmValue
    local currScore = 1
    local HarmSection = CommonUtil.DeserializeGlobalStrToNumberTable(demonData.DamageSegment)
    if HarmSection and #HarmSection > 0 then
        if totalHarm > HarmSection[#HarmSection][2]  then
            currScore = HarmSection[#HarmSection][1]
        else
            for i = 1, #HarmSection - 1 do
                local lastvalue = HarmSection[i][2]
                local nextvalue = HarmSection[i][3]
                if totalHarm >= lastvalue and totalHarm <= nextvalue then
                    currScore = HarmSection[i][1]
                    break
                end
            end
        end
    end
    local scoreList =  CommonUtil.DeserializeGlobalStrToTable(demonData.ScorePic)
    if currScore > 0  and currScore <= #scoreList then
        local scoreIcon = scoreList and scoreList[currScore] or ""
        item.iconScore:SetActive(true)
        CommonUtil.LoadIcon(wnd, scoreIcon , function (sprite)
            item.iconScore.image.sprite = sprite
        end)
    else
        item.iconScore:SetActive(false)
    end
    local brief = logicData.brief
    if brief then
        local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(brief.guild_badge)
        local badgeResPath = nil
        if badgeCfgData then
            badgeResPath = badgeCfgData.Pic
        end
        CommonUtil.LoadIcon(wnd, badgeResPath, function(sprite)
            item.flag.image.sprite = sprite
        end, item, 'BadgeIcon')
        item.lvTxt.text.text = "LV."..brief.guild_level
        item.guildName.text.text = brief.guild_name
    end
end

return DemonGuildRankItemCtr