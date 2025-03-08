local DmgRankItemCtr = {}

function DmgRankItemCtr:SetData(wnd, item, logicData, enterType)
    local harmValue  = logicData.damage or 0
    local rank = logicData.rank or 0
    item.rank:SetActive(rank > 3)
    item.medalIcon:SetActive(rank > 0 and rank <= 3)
    if rank > 0 and rank <= 3 then
        item.medalIcon.image.sprite = item.medalIcon.switchSprite:GetSprite("icon_medal_"..rank)
    end
    item.rank.text.text = tostring(rank)
    item.number.text.text = CommonUtil.FormatNumber(harmValue)
    local playerInfos = ManagerContainer.DataMgr.GuildDemonData:GetPlayerInfos()
    local brief = playerInfos and playerInfos[logicData.uid]
    if brief then
        local name = CommonUtil.GetVaildNickName(brief.nick_name)
        item.name.text.text = name
        local curRoleLv = brief.level
        local jobCfgId = brief.config_id
        local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
        local headIcon = CommonUtil.GetPlayerHeadIcon(brief)
        local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
        local _headFrameId = brief.head_frame_id
        CommonUtil.SetPlayerHeadAndFrame(wnd, item.headItem, _fakerData,false, _headFrameId,wnd,wnd.OnClickOtherHeadBtn,brief.uid);
    end
end

return DmgRankItemCtr