local CardCollectCtr = {}

function CardCollectCtr:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    local cfgData = logicData
    local logicData = ManagerContainer.DataMgr.CollectionBookData:GetCollectionBookDataById(cfgData.Cardid)

    CommonUtil.LoadIcon(wnd, cfgData.Cardicon, function (sprite)
        itemLua.icon.image.sprite = sprite
    end, itemLua, "icon")

    local frameIcon = Constant.Quality_Frame_Icons[cfgData.FrameQuality]
    CommonUtil.LoadIcon(wnd, frameIcon, function (sprite)
        itemLua.frame.image.sprite = sprite
    end, itemLua, "frame")

    CommonUtil.LoadIcon(wnd, Constant.Quality_CardType_Icons[cfgData.CardQuality], function (sprite)
        itemLua.cardLabel.image.sprite = sprite
    end, itemLua, "label")

    CommonUtil.SetTotalChildrenGray(itemLua.gameObject, logicData == nil)

    wnd.uiBase:AddButtonUniqueEventListener(itemLua.bg.button, onClickOwner, onClickCB, cfgData.Cardid)

    itemLua.uIRedPointRP.gameObject:SetActive(false)
end

return CardCollectCtr