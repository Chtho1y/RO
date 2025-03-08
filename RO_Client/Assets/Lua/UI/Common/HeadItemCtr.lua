local HeadItemCtr = {}

function HeadItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    local composeItem = itemCfgData.ComposeItem
    local parterCfgId = composeItem[1]
    local parterCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(parterCfgId)
    local natureData = ManagerContainer.CfgMgr:GetNatureDataById(parterCfgData.NatureId)
    CommonUtil.LoadIcon(wnd, natureData.Icon, function (sprite)
        itemlua.natureIcon.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, Constant.Quality_Frame_Icons[parterCfgData.Quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
        itemlua.head.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, parterCfgData.JobIcon, function (sprite)
        itemlua.jobIcon.image.sprite = sprite
    end)

    itemlua.leader:SetActive(false)
    itemlua.battle:SetActive(false)

    itemlua.redPointItem:SetActive(false)

    itemlua.textLV:SetActive(false)

    if onClickOwner and onClickCB then
        itemlua.head.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.head.button, onClickOwner, onClickCB, logicData)
    else
        itemlua.head.button.interactable = false
    end
end

return HeadItemCtr