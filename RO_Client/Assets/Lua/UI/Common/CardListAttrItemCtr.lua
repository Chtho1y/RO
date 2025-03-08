local CardListAttrItemCtr = {}

function CardListAttrItemCtr:SetData(wnd, item, logicData, enterType)
    local attrId = logicData[1]
    local val = logicData[2]

    item.name.uILocalizeScript:SetContent("Attr_" .. attrId)
    item.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, val)
    if enterType ~= Enum.ItemIEnterType.EquipedCard and enterType ~= Enum.ItemIEnterType.CardRecreate then
        item.name.uILocalizeScript:SetContentWithColor("Attr_" .. attrId, Constant.BrownColorText)
        --CommonUtil.SetTextColor(item.name.text, Constant.BrownColorText)
        CommonUtil.SetTextColor(item.number.text, Constant.BrownColorText)
    end
end

return CardListAttrItemCtr