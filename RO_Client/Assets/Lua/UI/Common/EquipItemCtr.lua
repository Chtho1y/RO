local EquipItemCtr = {}

function EquipItemCtr:SetData(wnd, equipItem, logicData, enterType, onClickOwner, onClickCB, redPointStatus)
    local cfgId = logicData.cfgId == nil and logicData.Id or logicData.cfgId
    local num = logicData.num == nil and 0 or logicData.num

    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)

    if not itemCfgData then
        LogError("在道具表中找不到该装备" .. cfgId)
    end

    if not equipCfgData then
        LogError("在装备表中找不到该装备" .. cfgId)
    end

    if itemCfgData.Icon and itemCfgData.Icon ~= '' then
        CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
            equipItem.equip.image.sprite = sprite
        end)
    end

    local divide = Constant.Quality_Equip_Divide[equipCfgData.EquipLevel]
    local quality = divide[1]
    local qualitylv = divide[2]

    CommonUtil.LoadIcon(wnd, Constant.Quality_NatureBg_Icons[quality], function (sprite)
        equipItem.lvBG.image.sprite = sprite
    end)
    CommonUtil.LoadIcon(wnd, Constant.Quality_Frame_Icons[quality], function (sprite)
        equipItem.frame.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, Constant.Quality_Equip_LV_Icons[qualitylv], function (sprite)
        equipItem.equipLv.image.sprite = sprite
    end)

    --equipItem.number.text.text = Constant.Quality_Equip_LV_Des[qualitylv]
    equipItem.num.text.text = tostring(num)
    equipItem.redPoint:SetActive(false)

    if Enum.ItemIEnterType.Bag == enterType then
        equipItem.textLV:SetActive(false)
        equipItem.num:SetActive(true)
    elseif Enum.ItemIEnterType.ItemTips == enterType then
        equipItem.textLV:SetActive(false)
        equipItem.num:SetActive(false)
    elseif Enum.ItemIEnterType.HeroEquip == enterType then
        equipItem.textLV:SetActive(false)
        equipItem.num:SetActive(false)
        equipItem.redPoint:SetActive(false)
    elseif Enum.ItemIEnterType.EquipForge == enterType then
        equipItem.textLV:SetActive(false)
        equipItem.num:SetActive(false)
        equipItem.redPoint:SetActive(redPointStatus)
    elseif Enum.ItemIEnterType.EquipForgePop == enterType then
        equipItem.textLV:SetActive(false)
        equipItem.num:SetActive(true)
        equipItem.redPoint:SetActive(false)
    else
        equipItem.textLV:SetActive(true)
        equipItem.num:SetActive(false)
    end

    if onClickOwner and onClickCB then
        equipItem.bg.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(equipItem.bg.button, onClickOwner, onClickCB, logicData, equipItem)
    else
        equipItem.bg.button.interactable = false
    end
end

return EquipItemCtr