local UIIdolRankItemCtr = {}

function UIIdolRankItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)
    local selfRank = logicData.rank or 0
    local selfTicket = logicData.score or 0
    local enterType = logicData.enterType or 0
    item.rank:SetActive(selfRank ==0 or selfRank > 3)
    item.madel01:SetActive(selfRank == 1)
	item.madel02:SetActive(selfRank == 2)
	item.madel03:SetActive(selfRank == 3)
	local PlayerInfoMaxLimit = GlobalConfig.Instance:GetConfigIntValue(343) or 50
    if selfRank <= 0 or selfRank > PlayerInfoMaxLimit then
		item.rank.text.text = I18N.SetLanguageValue('NoRank')
    else
		item.rank.text.text = tostring(selfRank)
    end
    item.hotVal.text.text = selfTicket
    if enterType == 1 then  --点击自己头像进入
        local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
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
        local name = CommonUtil.GetVaildNickName(ManagerContainer.DataMgr.UserData:GetUserNickname())
        item.playerName.text.text = name
        local playerName = ManagerContainer.DataMgr.UserData:GetRoleLv()
        local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
        local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
        local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
        local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
        local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
        CommonUtil.SetPlayerHeadAndFrame(wnd, item.headItem, _fakerData,false, _headFrameId,wnd,wnd.OnClickOtherHeadBtn,logicData.uid);
    else
        local brief = ManagerContainer.DataMgr.IdolData:GetPlayerBriefInfoByUid(logicData.uid)
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
            item.playerName.text.text = name
            local curRoleLv = brief.level
            local jobCfgId = brief.config_id
            local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
            local headIcon = CommonUtil.GetPlayerHeadIcon(brief)
            local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
            local _headFrameId = brief.head_frame_id
            CommonUtil.SetPlayerHeadAndFrame(wnd, item.headItem, _fakerData,false, _headFrameId,wnd,wnd.OnClickOtherHeadBtn,brief.uid);
        end
    end
    if onClickOwner and onClickCB then
        item.btnSupport.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(item.btnSupport.button, onClickOwner, onClickCB, logicData)
    else
        item.btnSupport.button.enabled = false
    end
end

return UIIdolRankItemCtr