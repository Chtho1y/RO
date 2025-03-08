local KeepSakeCollectCtr = {}

function KeepSakeCollectCtr:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    local cfgData = logicData
    local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(cfgData.Id)

    CommonUtil.LoadIcon(wnd, cfgData.CollectionImg, function (sprite)
        itemLua.icon.image.sprite = sprite
    end, itemLua, "icon")

    local frameIcon = Constant.Quality_CardBg_Icons[cfgData.CollectionLevel]
    CommonUtil.LoadIcon(wnd, frameIcon, function (sprite)
        itemLua.frame.image.sprite = sprite
    end, itemLua, "frame")

    CommonUtil.LoadIcon(wnd, Constant.Quality_CardType_Icons[cfgData.CollectionLevel - 1], function (sprite)
        itemLua.cardLabel.image.sprite = sprite
    end, itemLua, "label")

    CommonUtil.LoadIcon(wnd, Constant.Quality_Equip_LV_Icons[lv or 1], function (sprite)
        itemLua.level.image.sprite = sprite
    end, itemLua, "level")

    CommonUtil.SetTotalChildrenGray(itemLua.gameObject, lv == nil and not cfgData.canLvUp)

    wnd.uiBase:AddButtonUniqueEventListener(itemLua.bg.button, onClickOwner, onClickCB, cfgData.Id)

    itemLua.uIRedPointRP.gameObject:SetActive(false)
end

return KeepSakeCollectCtr