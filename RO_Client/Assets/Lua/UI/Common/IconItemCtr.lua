local IconItemCtr = {}

local function GetPath(path, isSmall)
    return isSmall and path.."_s" or path
end

function IconItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    local cfgId = logicData.cfgId
    local itemcfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    if not itemcfgData then
        LogError(cfgId.. " isnt exist in ItemCfg")
        return
    end
    if itemcfgData.ResType == Enum.ItemType.PetStamp then
        return self:RefreshPetStampIcon(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    else
        return self:RefreshIcon(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    end
end

function IconItemCtr:RefreshIcon(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    local cfgId = logicData.cfgId
    local num = logicData.num or 0
    local vip = logicData.vip or 0
    local strengthLevel = logicData.strengthLevel or 0
    local advLv = logicData.advanceLevel or 0
    local redpointState = logicData.redpointState

    local gridViewItem = itemlua.gameObject:GetComponent(Enum.TypeInfo.UIGridViewMark)
    local isSmall = gridViewItem.OriName == "IconSmallItem"

    itemlua.icon.image.sprite = nil

    itemlua.conertips.gameObject:SetActive(logicData.cornerType and logicData.cornerType > 0);
    if logicData.cornerType == Enum.FromType.Extrra then
        itemlua.text.text.text = I18N.T("SignInTips2");    --额外
        --TODO:将来判定是否要改变角标图片
    end

    local itemCfgData, cfgData, iconType, quality
    if enterType == Enum.ItemIEnterType.Partner then
        itemCfgData = ManagerContainer.CfgMgr:GetPartnerMapItemDataById(cfgId)

        if itemCfgData == nil then
            LogError(cfgId.. " partner isnt exist in ItemCfg")
            return
        end
        iconType = Enum.ItemType.Parter
        cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(cfgId)
        if cfgData == nil then
            LogError(cfgId.. " isnt exist in PartnerCfg")
            return
        end
    else
        itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

        if itemCfgData == nil then
            LogError(cfgId.. " isnt exist in ItemCfg")
            return
        end
        iconType = itemCfgData.ResType

        cfgData = itemCfgData
        if iconType == Enum.ItemType.Equip then
            cfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in EquipCfg")
                return
            end
        elseif iconType == Enum.ItemType.Card then
            cfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in CardCfg")
                return
            end
        elseif iconType == Enum.ItemType.FashionPaper then
            cfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in FashionPaperCfg")
                return
            end
        elseif iconType == Enum.ItemType.Parter then
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in PartnerCfg")
                return
            end
        elseif iconType == Enum.ItemType.SkillEquip then
            cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in ArtifactCfg")
                return
            end
        elseif iconType == Enum.ItemType.Pet then
            cfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
            if cfgData == nil then
                LogError(cfgId.. " isnt exist in PetCfg")
                return
            end
            if itemCfgData.Quality == 0 then
                itemCfgData.Quality = cfgData.Fame
            end
            if itemCfgData.Icon == "" then
                itemCfgData.Icon = cfgData.Icon
            end
        end
    end

    quality = itemCfgData.Quality

    local qualityFxName = nil
    local frameIcon = Constant.Quality_Frame_Icons[quality]
    if quality >= Enum.QualityType.Purple then
        qualityFxName = Constant.Quality_FX[quality - Enum.QualityType.Blue]
    end

    if iconType == Enum.ItemType.Compose and itemCfgData.DebrisShow == 2 then
        iconType = Enum.ItemType.Pet
    end

    if iconType == Enum.ItemType.Equip or iconType == Enum.ItemType.Card then
        frameIcon = Constant.Quality_CardBg_Icons[quality]
    elseif iconType == Enum.ItemType.Pet then
        frameIcon = Constant.Quality_PetFrame_Icons[quality]
    elseif iconType == Enum.ItemType.Parter then
        frameIcon = strengthLevel == 0 and Constant.Quality_White_Head_Frame_Icon or Constant.Quality_HeadFrame_Icons[math.min(strengthLevel, #Constant.Quality_HeadFrame_Icons)]
    elseif iconType == Enum.ItemType.FashionPaper then
        frameIcon = Constant.Quality_Frame_Icons[quality]
    elseif iconType == Enum.ItemType.SkillEquip then
        if enterType == Enum.ItemIEnterType.HeroEquip then
            frameIcon = Constant.Quality_CardBg_Icons[quality]
        end
    end

    if itemlua.uiParticle ~= nil and itemlua.uiParticle.EffectName ~= qualityFxName then
        wnd:RemoveEffect(itemlua,itemlua.uiParticle.EffectName,itemlua.uiParticle.fxGo)
        ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath,itemlua.uiParticle.EffectName,itemlua.uiParticle.fxGo)
        itemlua.uiParticle = nil
    end
    if quality >= 5 then
        if qualityFxName == nil then
            itemlua.qualityFX:SetActive(false)
        else
            if itemlua.uiParticle == nil then
                local fxGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath,qualityFxName)
                if fxGo~= nil then
                    fxGo.transform:SetParent(itemlua.qualityFX.transform)
                    fxGo.transform.localPosition = Vector3.zero
                    fxGo.transform.localRotation = Quaternion.identity
                    fxGo.transform.localScale = Vector3.one

                    --if tolua.getpeer(fxGo) == nil then
                    --    tolua.setpeer(fxGo, {})
                    --end
                    itemlua.uiParticle = {}
                    itemlua.uiParticle.fxGo = fxGo
                    itemlua.uiParticle.EffectName = qualityFxName

                    local sizeX = itemlua.rectTransform.rect.width
                    --判断是否父节点为grid
                    if itemlua.transform.parent then
                        local parent = itemlua.transform.parent
                        local parentScale = parent.localScale.x

                        local grid = parent:GetComponent(Enum.TypeInfo.GridLayoutGroup)
                        local width = sizeX
                        if grid then
                            width = grid.cellSize.x
                        end

                        sizeX = width * parentScale
                    end

                    local scaleX = sizeX/160
                    --local sizeY = itemlua.layoutElement.preferredHeight
                    --local scaleY = sizeY/160
                    local uiParticle = fxGo:GetComponent(Enum.TypeInfo.UIParticle)
                    if uiParticle then
                        uiParticle.scale = scaleX
                    end

                    wnd:AddNewEffect(itemlua,qualityFxName,fxGo)
                    itemlua.qualityFX:SetActive(true)
                end
            end
        end
    end

    local _iconPath = itemCfgData.Icon
    if logicData.isLeader then _iconPath = logicData.leaderIcon end


    CommonUtil.SetTotalChildrenGray(itemlua.icon, false)

    CommonUtil.LoadIcon(wnd, _iconPath, function (sprite)
        itemlua.icon.image.sprite = sprite
    end, itemlua, 'IconIcon')

    CommonUtil.LoadIcon(wnd, GetPath(frameIcon, isSmall), function (sprite)
        itemlua.frame.image.sprite = sprite
    end, itemlua, 'IconFrame')

    itemlua.frame.image.material = quality >= 3 and ManagerContainer.ResMgr:GetFrameQualityMat() or nil

    local needLevel = iconType == Enum.ItemType.Equip or iconType == Enum.ItemType.Card
    itemlua.level:SetActive(needLevel)
    if needLevel then
        local level = 1
        if iconType == Enum.ItemType.Equip then
            local divide = Constant.Quality_Equip_Divide[cfgData.EquipLevel]
            level = divide[2]
        elseif iconType == Enum.ItemType.Card then
            level = cfgData.CardLevel
        end

        CommonUtil.LoadIcon(wnd, Constant.Quality_Equip_LV_Icons[level], function (sprite)
            itemlua.level.image.sprite = sprite
        end, itemlua, 'IconLevel')
    end

    itemlua.cardLabel:SetActive(iconType == Enum.ItemType.Card)
    if iconType == Enum.ItemType.Card then

        CommonUtil.LoadIcon(wnd, Constant.Quality_CardType_Icons[cfgData.CardType], function (sprite)
            itemlua.cardLabel.image.sprite = sprite
        end, itemlua, 'IconType')
    end

    local needJob = iconType == Enum.ItemType.Parter or iconType == Enum.ItemType.Pet
    itemlua.job:SetActive(needJob)
    if needJob then
        local jobIcon = cfgData.JobIcon
        if iconType == Enum.ItemType.Pet then
            jobIcon = Constant.Natural_Icons..itemCfgData.NatureType
        end
        CommonUtil.LoadIcon(wnd, jobIcon, function (sprite)
            itemlua.job.image.sprite = sprite
        end, itemlua, 'IconJob')
    end

    local sexLabelVisible = false
    if iconType == Enum.ItemType.FashionPaper then
        local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgData.FashionId)
        if fashionCfgData and fashionCfgData.FashionSex and fashionCfgData.FashionSex > 0 then
            sexLabelVisible = true
            CommonUtil.LoadIcon(wnd, Constant.Paper_Sex_Icons[fashionCfgData.FashionSex], function (sprite)
                itemlua.sexLabel.image.sprite = sprite
            end, itemlua, 'IconSex')
        end
    end
    itemlua.sexLabel:SetActive(sexLabelVisible)

    if iconType ~= Enum.ItemType.Parter then
        if num >= 10000 then
            if iconType < 100 then
                itemlua.num.text.text = CommonUtil.FormatNumber(num)
            else
                itemlua.num.text.text = CommonUtil.GetPreciseDecimalFloor(num/10000, 1) .. "w"
            end
        else
            itemlua.num.text.text = tostring(num)
        end
    else
        itemlua.num.text.text = "Lv."..tostring(num)
    end
    itemlua.redPoint:SetActive(redpointState)

    --if enterType == Enum.ItemIEnterType.Bag and num > 1 then
    --    itemlua.num:SetActive(true)
    --else
    --    itemlua.num:SetActive(false)
    --end

    local numState = false
    if iconType == Enum.ItemType.SkillEquip then
        if enterType == Enum.ItemIEnterType.Bag and num > 1 then
            numState = true
        end
    else
        if num > 1 then
            numState = true
        end
    end

    itemlua.num:SetActive(numState)

    itemlua.refineLv:SetActive(enterType == Enum.ItemIEnterType.EquipTips and num > 0)
    itemlua.refineLv.text.text = "+"..num

    itemlua.limited:SetActive(itemCfgData and itemCfgData.ItemTime > 0 and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.ForeverItem and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.SeasonForeverItem)

    --itemlua.advence:SetActive(iconType == Enum.ItemType.Pet and advLv > 0)
    --itemlua.advenceLv.text.text = "+"..advLv

    --vip
    itemlua.vip:SetActive(vip > 0)
    if vip > 0 then
        local vipCfgData = ManagerContainer.CfgMgr:GetVipCfgById(vip)
        if vipCfgData then
            CommonUtil.LoadIcon(wnd, vipCfgData.VipMarkIcon, function (sprite)
                itemlua.label.image.sprite = sprite
            end, itemlua, 'IconVip')
        end
    end

    self:DebrisShow(wnd, itemCfgData, itemlua)

    itemlua.repeatSign:SetActive(false)
    if itemCfgData.ActivationItem > 0 then
        local isRepeated = ManagerContainer.DataMgr.KeepSakeBookData:IsKeepSakeMaxLv(itemCfgData.ActivationItem)
        itemlua.repeatSign:SetActive(isRepeated)
    end

    if itemlua.artifactStar then
        itemlua.artifactStar:SetActive(iconType == Enum.ItemType.SkillEquip)
        itemlua.selected:SetActive(iconType == Enum.ItemType.SkillEquip and logicData.selected == 1)
        if iconType == Enum.ItemType.SkillEquip then
            local childCount = itemlua.artifactStar.transform.childCount
            for i = 1, childCount do 
                local starItem = itemlua.artifactStar["star"..i]
                if starItem then
                    starItem:SetActive(i <= cfgData.ArtifactMaxLevel)
                    starItem.star:SetActive(i <= (logicData.starLv or 0))
                end
            end
        end
        itemlua.artifactLv:SetActive(logicData.slotLv and logicData.slotLv > 0 and enterType == Enum.ItemIEnterType.HeroEquip)
        itemlua.artifactLv.text.text = logicData.slotLv
    end

    if onClickOwner and onClickCB then
        itemlua.bg.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData, itemlua, params)
    else
        itemlua.bg.button.enabled = false
    end

    return itemCfgData
end

function IconItemCtr:DebrisShow(wnd, itemCfgData, itemlua)
    itemlua.piece:SetActive(itemCfgData.DebrisShow == 2 or itemCfgData.DebrisShow == 4)

    if itemCfgData.DebrisShow == 3 or itemCfgData.DebrisShow == 4 then
        if not itemlua.cardLabel.activeSelf then
            itemlua.cardLabel:SetActive(true)
        end
        CommonUtil.LoadIcon(wnd, Constant.Quality_Card_Icons[itemCfgData.Quality], function (sprite)
            itemlua.cardLabel.image.sprite = sprite
        end, itemlua, 'IconType')
    elseif itemCfgData.DebrisShow == 1 or itemCfgData.DebrisShow == 2 then
        itemlua.cardLabel:SetActive(false)
    elseif itemCfgData.DebrisShow == 5 or itemCfgData.DebrisShow == 6 then
        itemlua.cardLabel:SetActive(false)
    end

    if itemCfgData.DebrisShow == 1 then
        --通用宠物碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, false)
    elseif itemCfgData.DebrisShow == 2 then
        --通用定向宠物碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, true)
        local iconPath = Constant.Pet_Debries_Icons[itemCfgData.Quality]
        CommonUtil.LoadIcon(wnd, iconPath, function (sprite)
            itemlua.piece.image.sprite = sprite
        end, itemlua, 'piece')
    elseif itemCfgData.DebrisShow == 3 then
        --通用卡片碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, false)
    elseif itemCfgData.DebrisShow == 4 then
        --通用定向卡片碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, true)
        local iconPath = Constant.Card_Debries_Icons[itemCfgData.Quality]
        CommonUtil.LoadIcon(wnd, iconPath, function (sprite)
            itemlua.piece.image.sprite = sprite
        end, itemlua, 'piece')
    elseif itemCfgData.DebrisShow == 5 then
        --通用神器碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, false)
    elseif itemCfgData.DebrisShow == 6 then
        --通用定向神器碎片
        CommonUtil.SetTotalChildrenGray(itemlua.icon, true)
        local iconPath = Constant.SkillEquip_Debries_Icons[itemCfgData.Quality]
        CommonUtil.LoadIcon(wnd, iconPath, function (sprite)
            itemlua.piece.image.sprite = sprite
        end, itemlua, 'piece')
    end
end

function IconItemCtr:RefreshPetStampIcon(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    local cfgId = logicData.cfgId
    local num = logicData.num or (logicData.lv or 1)

    local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(cfgId)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    if not cfgData or not itemCfgData then
        return
    end

    local quality = itemCfgData.Quality

    itemlua.icon.image.sprite = nil
    CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
        itemlua.icon.image.sprite = sprite
    end, itemlua, 'IconIcon')

    itemlua.frame.image.sprite = nil
    CommonUtil.LoadIcon(wnd, Constant.Quality_Frame_Icons[quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end, itemlua, 'IconFrame')

    itemlua.conertips.gameObject:SetActive(logicData.cornerType and logicData.cornerType > 0);
    if logicData.cornerType == Enum.FromType.Extrra then
        itemlua.text.text.text = I18N.T("SignInTips2");    --额外
        --TODO:将来判定是否要改变角标图片
    end
    itemlua.num.text.text = "Lv."..num

    itemlua.piece:SetActive(false)
    itemlua.job:SetActive(false)

    if onClickOwner and onClickCB then
        itemlua.bg.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData, itemlua, params)
    else
        itemlua.bg.button.enabled = false
    end
end

return IconItemCtr