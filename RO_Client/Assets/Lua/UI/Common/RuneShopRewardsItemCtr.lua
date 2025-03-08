local RuneShopRewardsItemCtr = {}
--战令悬赏每级
function RuneShopRewardsItemCtr:SetData(wnd, itemlua, logicData1, enterType, onClickOwner, onClickCB, params)
    if logicData1 == nil then return end
    self:SetIconDatatt(wnd, itemlua.rewardsLeft.iconItem, logicData1, enterType, onClickOwner, self.ShowItemTips, params,false)
    self:SetIconDatatt(wnd, itemlua.rewardsRight.iconItem, logicData1, enterType, onClickOwner, self.ShowCashItemTips, params,true)
end
local function GetPath(path, isSmall)
    return isSmall and path.."_s" or path
end

function RuneShopRewardsItemCtr:ShowItemTips(button, params)
	
	local data = clone(params[0])
	--LogError("进入了图标tips"..Inspect(data))
	--data.displayBtn = true
	local _extData = {_id = data.cfgData.ID, cfgId = data.cfgId}
	local tipsdara = {}
	
	tipsdara.cfgId = data.cfgData.Reward[1][1]
	tipsdara.num = data.cfgData.Reward[1][2]
	
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(data.cfgId)
	if itemCfgData and itemCfgData.SkipInterface > 0 then
		if data.state == nil then data.state = 0 end

		data.state = Bit.bor(data.state, Bit.lshift(1, Enum.TipsEnterType.BtnGoto)) --data.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BtnGoto)
    end
    if data.isReward == 2 then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_REWARD_REQ,{level = data.cfgData.Lv, reward_type = 1})
        --LogError("领取普通奖励"..data.cfgData.Lv)
    else
        ManagerContainer.LuaUIMgr:OpenTips(tipsdara, _extData)
    end
	
end

function RuneShopRewardsItemCtr:ShowCashItemTips(button, params)
	
	local data = clone(params[0])
	--LogError("进入了图标tips"..Inspect(data))
	--data.displayBtn = true
	local _extData = {_id = data.cfgData.ID, cfgId = data.cfgId}
	local tipsdara = {}
	
	tipsdara.cfgId = data.cfgData.CashReward[1][1]
	tipsdara.num = data.cfgData.CashReward[1][2]
	
	
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(data.cfgId)
	if itemCfgData and itemCfgData.SkipInterface > 0 then
		if data.state == nil then data.state = 0 end

		data.state = Bit.bor(data.state, Bit.lshift(1, Enum.TipsEnterType.BtnGoto)) --data.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BtnGoto)
    end
    
    if data.isCashReward == 2 then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_REWARD_REQ,{level= data.cfgData.Lv,reward_type= 2})
        --LogError("领取了高级奖励"..data.cfgData.Lv)
    elseif data.isCashReward == 1 then
        ManagerContainer.LuaUIMgr:OpenTips(tipsdara, _extData)
    else
        if  ManagerContainer.DataMgr.RuneShopDataMgr:GetRewardsData():GetRewardsIsCash() == 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRewardsBuyTips, {runeShopType, nil, 0})
        else
            ManagerContainer.LuaUIMgr:OpenTips(tipsdara, _extData)
        end
        
    end
	
end

function RuneShopRewardsItemCtr:SetIconDatatt(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params , isAnvanced)
    --LogError("bbb"..Inspect(logicData))
    local cfgdatat 
    local redpointState = false
    local baseData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(Enum.RuneShopType.Rewards,nil,false)
    if isAnvanced then
        cfgdatat = logicData.cfgData.CashReward
        -- if logicData.isCashReward == 0 and baseData:GetRewardsIsCash() == 1 then
        --     local curlv = baseData:GetShowRewardCurLv()
        --     if logicData.cfgData.lv < curlv or logicData.cfgData.lv == curlv then
        --         redpointState = true
        --     end
            
        -- end
        if logicData.isCashReward == 2 then
            redpointState = true
        end
        
        --logicData.cfgData.isCash = 1
    else
         cfgdatat = logicData.cfgData.Reward
        --  if logicData.isReward == 0 and baseData:GetRewardsIsCash() == 1 then
        --     local curlv = baseData:GetShowRewardCurLv()
        --     if logicData.cfgData.lv < curlv or logicData.cfgData.lv == curlv then
        --         redpointState = true
        --     end
            
        -- end
        if logicData.isReward == 2 then
            redpointState = true
        end
         --logicData.cfgData.isCash = 0
    end
   
    if redpointState then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, true)
    end
    local cfgId = cfgdatat[1][1]
    local num = cfgdatat[1][2] or 0
    local vip = cfgdatat.vip or 0
    local strengthLevel = logicData.strengthLevel or 0
    local advLv = logicData.advanceLevel or 0
   
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
        frameIcon = Constant.Quality_HeadFrame_Icons[quality]
    elseif iconType == Enum.ItemType.Parter then
        frameIcon = strengthLevel == 0 and Constant.Quality_White_Head_Frame_Icon or Constant.Quality_HeadFrame_Icons[math.min(strengthLevel, #Constant.Quality_HeadFrame_Icons)]
    elseif iconType == Enum.ItemType.FashionPaper then
        frameIcon = Constant.Quality_Frame_Icons[quality]
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

    itemlua.num:SetActive(num > 1)

    itemlua.refineLv:SetActive(enterType == Enum.ItemIEnterType.EquipTips and num > 0)
    itemlua.refineLv.text.text = "+"..num

    itemlua.limited:SetActive(itemCfgData and itemCfgData.ItemTime > 0)

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

    if onClickOwner and onClickCB then
        itemlua.bg.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData, itemlua, params)
    else
        itemlua.bg.button.enabled = false
    end
    return itemCfgData
end

function RuneShopRewardsItemCtr:DebrisShow(wnd, itemCfgData, itemlua)
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
    end
end

return RuneShopRewardsItemCtr