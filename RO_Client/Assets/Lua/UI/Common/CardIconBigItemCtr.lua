local CardIconBigItemCtr = {}

function CardIconBigItemCtr:SetData(wnd, item, logicData, enterType, needName)
    local cfgId = logicData == nil and 0 or (logicData.cfgId or 0)

    item.level:SetActive(cfgId > 0)
    item.name:SetActive(needName and cfgId > 0)
    item.iconCard:SetActive(false)
    item.cardLabel:SetActive(false)

    if cfgId > 0 then
        local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
        if cardData == nil then
            LogError("next lv card isnt exist")
            return
        end
        local itemData = ManagerContainer.CfgMgr:GetItemById(cfgId)

        CommonUtil.LoadIcon(wnd, cardData.CardImg, function (sprite)
            item.iconCard.image.sprite = sprite
            item.iconCard:SetActive(true)
        end)

        CommonUtil.LoadIcon(wnd, Constant.Quality_CardBg_Icons[itemData.Quality], function (sprite)
            item.frame.image.sprite = sprite
        end)

        CommonUtil.LoadIcon(wnd, Constant.Quality_Equip_LV_Icons[cardData.CardLevel], function (sprite)
            item.level.image.sprite = sprite
        end)

        local needCardType = cardData.CardType > Enum.CardType.NORMAL
        item.cardLabel:SetActive(needCardType)
        if needCardType then
            CommonUtil.LoadIcon(wnd, Constant.Quality_CardType_Icons[cardData.CardType], function (sprite)
                item.cardLabel.image.sprite = sprite
            end)
        end

        item.name.text.uILocalizeScript:SetContent(cardData.CardName)
    else
        item.iconCard.image.sprite = nil

        CommonUtil.LoadIcon(wnd, Constant.Quality_White_Frame_Icon, function (sprite)
            item.frame.image.sprite = sprite
        end)

        item.name.text.uILocalizeScript:SetContent("None")
    end
end

return CardIconBigItemCtr