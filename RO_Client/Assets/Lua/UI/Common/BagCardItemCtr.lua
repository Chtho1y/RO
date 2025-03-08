local BagCardItemCtr = {}

function BagCardItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local num = logicData.num
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)

    if itemCfgData.Icon and itemCfgData.Icon ~= '' then
        CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
            itemlua.iconCard.image.sprite = sprite
        end)
    end

    CommonUtil.LoadIcon(wnd, Constant.Quality_Frame_Icons[itemCfgData.Quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, Constant.CardLocation_Icons[cardData.CardLocation], function (sprite)
        itemlua.icon.image.sprite = sprite
    end)

    itemlua.num.text.text = tostring(num)
    itemlua.redPoint:SetActive(false)

    itemlua.lableMini:SetActive(cardData.CardType == Enum.CardType.MINIBOSS)
    itemlua.lableMVP:SetActive(cardData.CardType == Enum.CardType.MVP)

    if enterType == Enum.ItemIEnterType.Bag then
        itemlua.num:SetActive(true)
    else
        itemlua.num:SetActive(false)
    end

    if onClickOwner and onClickCB then
        itemlua.bg.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData)
    else
        itemlua.bg.button.interactable = false
    end
end

return BagCardItemCtr