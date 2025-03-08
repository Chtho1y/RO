local IconPetItemCtr = {}

function IconPetItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    local cfgId = logicData.cfgId
    local num = logicData.level
    local id = logicData.id
    local skilllv = logicData.skilllv

    local itemCfgData, cfgData, iconType, quality

    itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

    if itemCfgData == nil then
        LogError(cfgId.. " isnt exist in ItemCfg")
        return
    end
    iconType = itemCfgData.ResType

    cfgData = itemCfgData
    if iconType == Enum.ItemType.Pet then
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

    quality = itemCfgData.Quality

    local qualityFxName = nil
    local frameIcon = Constant.Quality_PetFrame_Icons[quality]
    if quality >= Enum.QualityType.Purple then
        qualityFxName = Constant.Quality_FX[quality - Enum.QualityType.Blue]
    end

    --frameIcon = Constant.Quality_HeadFrame_Icons[quality]

    if itemlua.uiParticle ~= nil and itemlua.uiParticle.EffectName ~= qualityFxName then
        wnd:RemoveEffect(itemlua,itemlua.uiParticle.EffectName,itemlua.uiParticle.fxGo)
        ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath,itemlua.uiParticle.EffectName,itemlua.uiParticle.fxGo)
        itemlua.uiParticle = nil
    end
    if quality >= 5 then
        if qualityFxName == nil then
            itemlua.qualityFX:SetActive(false)
        else
            itemlua.qualityFX:SetActive(true)
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
                        local selfScale = itemlua.transform.localScale.x

                        local grid = parent:GetComponent(Enum.TypeInfo.GridLayoutGroup)
                        local width = sizeX
                        if grid then
                            width = grid.cellSize.x
                        end

                        sizeX = width * parentScale * selfScale
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
    itemlua.icon.image.sprite = nil

    CommonUtil.LoadIcon(wnd, _iconPath, function (sprite)
        itemlua.icon.image.sprite = sprite
    end, itemlua, 'IconIcon')

    CommonUtil.LoadIcon(wnd, frameIcon, function (sprite)
        itemlua.frame.image.sprite = sprite
    end, itemlua, 'IconFrame')

    itemlua.frame.image.material = quality >= 3 and ManagerContainer.ResMgr:GetFrameQualityMat() or nil

    itemlua.num.text.text = "Lv."..tostring(num)

    itemlua.nature:SetActive(true)
    local natureIcon = Constant.Natural_Icons..cfgData.NatureType
    CommonUtil.LoadIcon(wnd, natureIcon, function (sprite)
        itemlua.nature.image.sprite = sprite
    end, itemlua, 'IconJob')

    local petStarIcon, textContent = CommonUtil.GetPetSkillStarIconAndColor(logicData.skillList,skilllv)
    itemlua.star:SetActive(petStarIcon ~= nil)
    CommonUtil.LoadIcon(wnd, petStarIcon, function (sprite)
        itemlua.star.image.sprite = sprite
    end, itemlua, 'IconStar')
    itemlua.star.advenceLv.text.text = textContent

    itemlua.advence:SetActive(logicData.advanceLevel ~= nil and logicData.advanceLevel > 0)
    if logicData.advanceLevel then
        if logicData.advanceLevel > 0 then
            CommonUtil.LoadIcon(wnd, Constant.Pet_Quality_Bg_Icons[quality], function (sprite)
                itemlua.advence.image.sprite = sprite
            end, itemlua, 'IconAdvence')
        end
        itemlua.advenceLv.text.text = string.format(Constant.Pet_Quality_Text_Colors[quality],"+"..logicData.advanceLevel)
    end

    itemlua.num:SetActive(enterType ~= Enum.ItemIEnterType.PetRelation and enterType ~= Enum.ItemIEnterType.PetSupport)

    itemlua.locked:SetActive((enterType == Enum.ItemIEnterType.PetMats and logicData.isBattle)
            or (enterType == Enum.ItemIEnterType.PetRelation and logicData.canUse == false)
            or (enterType == Enum.ItemIEnterType.PetSupport and logicData.isUsed == true))
    itemlua.selected:SetActive(logicData.selected and logicData.selected > 0)

    itemlua.nameBg:SetActive(enterType == Enum.ItemIEnterType.PetRelation)
    itemlua.petName.text.text = CommonUtil.GetShortVaildNickName(logicData.nickname)

    if onClickOwner and onClickCB then
        itemlua.bg.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData, itemlua, params)
    else
        itemlua.bg.button.interactable = false
    end

    itemlua.battle:SetActive(logicData.isBattle == true)
    itemlua.relation:SetActive(logicData.isRelevant == true)
    itemlua.support:SetActive(logicData.isSupport == true)
    itemlua.contract:SetActive(enterType == Enum.ItemIEnterType.PetQiyueMat and logicData.qiyueHeroId > 0)

    local parent = itemlua.transform
    local redPoint = parent:Find("redPoint")
    if enterType == Enum.ItemIEnterType.PetRoot and logicData.isBattle then
        local result = ManagerContainer.RedPointMgr.PetRPCtr:GetPetCultivatingState(logicData.id)
        if not result then
            result = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotInsertRPState(id)
        end
        if not result then
            result = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotLvUpRPState(id)
        end
        if not result then
            result = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotAdvanceRPState(id)
        end
        if redPoint then
            redPoint.gameObject:SetActive(result)
        else
            if result then
                self:CreateRP(parent, redPoint, "redPoint", "Common/UIRedPointRP")
            end
        end
    else
        if redPoint then
            redPoint.gameObject:SetActive(false)
        end
    end
end

function IconPetItemCtr:CreateRP(parent, redPoint, name, path)
    local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, path)
    if go then
        redPoint = go.transform
        redPoint:SetParent(parent)
        redPoint.localRotation = Quaternion.identity
        redPoint.localScale = Vector3.one
        local rectTransform = redPoint:GetComponent(Enum.TypeInfo.RectTransform)
        rectTransform.anchoredPosition3D = Vector3(78, 78, 0)
        go.name = name
    end
end

return IconPetItemCtr