local HeroHeadIcon = {}
local RedPointItemCtr = require("Common/RedPointItemCtr")

function HeroHeadIcon:SetActivationHeroIcon(uiOwner, isLeader, cfgData, logicData, head, needStatus, needRedP)
    if logicData == nil then
        if isLeader then
            LogError(cfgData.Id .." logicData is nil")
        else
            LogError(cfgData.ParterId .." logicData is nil")
        end
    end

    if head == nil then
        return
    end

    local quality
    if isLeader then
        quality = cfgData.Quality
    else
        quality = logicData.strengthLevel
    end

    local natureData = ManagerContainer.CfgMgr:GetNatureDataById(cfgData.NatureId)
    CommonUtil.LoadIcon(uiOwner, natureData.Icon, function (sprite)
        head.natureIcon.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(uiOwner, quality == 0 and Constant.Quality_White_Head_Frame_Icon or Constant.Quality_NatureBg_Icons[quality], function (sprite)
        head.natureBg.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(uiOwner, quality == 0 and Constant.Quality_White_Frame_Icon or Constant.Quality_Frame_Icons[quality], function (sprite)
        head.frame.image.sprite = sprite
    end)

    if isLeader then
        local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
        if headIcon then
            CommonUtil.LoadIcon(uiOwner, headIcon, function (sprite)
                head.head.image.sprite = sprite
            end)
        end
    else
        CommonUtil.LoadIcon(uiOwner, cfgData.HeadId, function (sprite)
            head.head.image.sprite = sprite
        end)
    end

    CommonUtil.LoadIcon(uiOwner, cfgData.JobIcon, function (sprite)
        head.jobIcon.image.sprite = sprite
    end)

    head.leader:SetActive(isLeader)
    head.battle:SetActive(not isLeader and logicData.isBattle and needStatus ~= false)

    RedPointItemCtr:SetData(uiOwner, head.redPointItem, needRedP, Enum.HeroRPSource.HeadIcon)

    local baseLv = 0
    if isLeader then
        baseLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
    else
        baseLv = logicData.baseLevel
    end
    head.textLV.text.text = "LV."..baseLv
end

function HeroHeadIcon:SetInactivationHeroIcon(uiOwner, cfgData, head, logicData)

    local quality = 0
    if logicData ~= nil then
        if logicData.id == 1 then
            quality = cfgData.Quality

            local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
            if headIcon then
                CommonUtil.LoadIcon(uiOwner, headIcon, function (sprite)
                    head.head.image.sprite = sprite
                end)
            end

        else
            quality = logicData.strengthLevel

            CommonUtil.LoadIcon(uiOwner, cfgData.HeadId, function (sprite)
                head.head.image.sprite = sprite
            end)
        end
    end

    CommonUtil.LoadIcon(uiOwner, quality == 0 and Constant.Quality_White_Head_Frame_Icon or Constant.Quality_NatureBg_Icons[quality], function (sprite)
        head.natureBg.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(uiOwner, quality == 0 and Constant.Quality_White_Frame_Icon or Constant.Quality_Frame_Icons[quality], function (sprite)
        head.frame.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(uiOwner, cfgData.HeadId, function (sprite)
        head.head.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(uiOwner, cfgData.JobIcon, function (sprite)
        head.jobIcon.image.sprite = sprite
    end)

    head.textLV:SetActive(false)
end

function HeroHeadIcon:SetTreasurePartnerHeadIcon(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local id = logicData.id

    local cfgData
    if id == 1 then
        local jobId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
        cfgData = ManagerContainer.CfgMgr:GetJobDataById(jobId)
    else
        local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
        cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
    end

    self:SetInactivationHeroIcon(wnd, cfgData, itemlua, CommonUtil.GetHeroLogicDataByUid(id))
    itemlua.textLV:SetActive(true)

    local logicData1 = CommonUtil.GetHeroLogicDataByUid(id)
    itemlua.textLV.text.text = "LV."..logicData1.baseLevel

    itemlua.checkmark:SetActive(enterType == Enum.ItemIEnterType.Treasure and logicData.selected)
    itemlua.treasureState:SetActive(enterType == Enum.ItemIEnterType.Treasure and not logicData.treasureFree)
    --if enterType == Enum.ItemIEnterType.Treasure then
    --    itemlua.btnRemove.button.interactable = logicData.selected
    --    wnd.uiBase:AddButtonUniqueEventListener(itemlua.btnRemove.button, wnd, wnd.RemoveCurSelectedHero, logicData, itemlua)
    --end

    if onClickOwner and onClickCB then
        if logicData.treasureFree then
            itemlua.head.button.interactable = true
            onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.head.button, onClickOwner, onClickCB, logicData, itemlua)
        else
            itemlua.head.button.interactable = false
        end
    else
        itemlua.head.button.interactable = false
    end
end

return HeroHeadIcon