local NatureAttrItemCtr = {}


function NatureAttrItemCtr:SetData(wnd, item, logicData)
    local attrId = logicData[1]
    local val1  = SDataUtil.InvConvert(logicData[2])
    local val2 = SDataUtil.InvConvert(logicData[3])
    local attrValue = attrId > 21 and CommonUtil.GetPreciseDecimalFloor(val1,3) or math.floor(val1)
    local addVal = attrId > 21 and CommonUtil.GetPreciseDecimalFloor(val2,3) or math.floor(val2)
    if attrValue <= 0.001 then
        attrValue = 0.001
    end        
    item.numberGreen:SetActive(addVal > 0)
    item.text.uILocalizeScript:SetContent("Attr_" .. attrId)
    item.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrValue, true)

    if addVal > 0 then
        item.numberGreen.text.text = CommonUtil.HeroAttrFormatValue(attrId, addVal, true)
        CommonUtil.SetTextColor(item.numberGreen.text, Constant.GreenColorText)
    end

    item.gameObject:SetActive(true)
end

return NatureAttrItemCtr