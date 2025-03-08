local ChipItemCtr = {}

function ChipItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local num = logicData.num
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

    if itemCfgData.Icon and itemCfgData.Icon ~= '' then
        CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
            itemlua.icon.image.sprite = sprite
        end)
    end
    local quality = itemCfgData.Quality

    CommonUtil.LoadIcon(wnd, Constant.Quality_Chip_Frame_Icons[quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end)

    local composeItem = itemCfgData.ComposeItem
    local multi = false
    local limit = 0
    local parterId = nil
    if composeItem and #composeItem > 0 then
        if type(composeItem[1]) == 'number' then
            -- 单个
            parterId = composeItem[1]
            limit = composeItem[2]
        else
            -- 多个
            parterId = composeItem[1][1]
            limit = composeItem[1][2]
            multi = true
        end
    end

    local parterCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(parterId)

    local natureData = ManagerContainer.CfgMgr:GetNatureDataById(parterCfgData.NatureId)
    CommonUtil.LoadIcon(wnd, natureData.Icon, function (sprite)
        itemlua.natureIcon.image.sprite = sprite
    end)

    if enterType == Enum.ItemIEnterType.Bag then
        itemlua.num.text.text = num
        itemlua.num:SetActive(true)
        local data = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(parterId)
        local owned = ((data and data.owned) and data.owned or false)
        itemlua.redPoint:SetActive(not owned and num >= limit)
    else
        itemlua.redPoint:SetActive(false)
        itemlua.num:SetActive(false)
    end

    if onClickOwner and onClickCB then
        itemlua.bg.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData)
    else
        itemlua.bg.button.interactable = false
    end
end

return ChipItemCtr