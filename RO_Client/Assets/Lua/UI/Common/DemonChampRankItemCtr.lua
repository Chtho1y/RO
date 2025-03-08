local DemonChampRankItemCtr = {}

function DemonChampRankItemCtr:SetData(wnd, item, logicData, enterType)
    local harmValue  = logicData.damage or 0
    local rank = logicData.rank or 0
    local guildname = logicData.guildName or ""
    local level = logicData.lv or 0 
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

    item.allianceName.text.text = guildname
    local brief = nil 
    if not logicData.isSelf then
        local mvpInfos = ManagerContainer.DataMgr.GuildDemonData:GetMvpInfos()
        brief = mvpInfos and mvpInfos[logicData.uid]
    else
        brief = ManagerContainer.DataMgr.GuildDemonData:GetRankSelfMvpBrief()
    end
    if brief then
		local vipLv = brief.vip_level
        local vipIcon = nil
        if vipLv and vipLv >= 0 then
            local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
            if vipCfg then
                vipIcon = vipCfg.SmallIcon
            end
        end
		CommonUtil.LoadIcon(wnd, vipIcon , function (sprite)
			item.vipIcon.image.sprite = sprite
		end)
        local name = CommonUtil.GetVaildNickName(brief.nick_name)
        item.nameTxt.text.text = name
        local curRoleLv = brief.level
        local jobCfgId = brief.config_id
        local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
        local headIcon = CommonUtil.GetPlayerHeadIcon(brief)
        local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
        local _headFrameId = brief.head_frame_id
        CommonUtil.SetPlayerHeadAndFrame(wnd, item.headItem, _fakerData,false, _headFrameId,wnd,wnd.OnClickOtherHeadBtn,brief.uid);
    end
end

return DemonChampRankItemCtr