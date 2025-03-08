local EquipBaseAttrItemCtr = {}

function EquipBaseAttrItemCtr:SetData(wnd, item, logicData, enterType, isNext)
    local attrId = logicData[1]
    local attrValue = logicData[2]
    local refineLv = logicData[3]
    local isRefineMax = logicData[4]

    if refineLv ~= nil and refineLv > 0 then
        local refineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(refineLv)
        attrValue = math.floor(attrValue * (100 + refineData.Result) * 0.01)
    end
    item.number:SetActive(not isRefineMax)
    if enterType == Enum.ItemIEnterType.HeroEquip then
        item.text.uILocalizeScript:SetContent("Attr_" .. attrId)
    else
        if not isRefineMax then
            item.text.uILocalizeScript:SetContent("Attr_" .. attrId)
        else
            item.text.uILocalizeScript:SetContentWithColor("ValueLimit", Constant.GreenColorText)
            --CommonUtil.SetTextColor(item.text.text, Constant.GreenColorText)
        end
    end
    item.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrValue)
    item.arrow:SetActive(isNext ~= nil and not isNext)
    if isNext then
        CommonUtil.SetTextColor(item.number.text, Constant.GreenColorText)
    end
end

return EquipBaseAttrItemCtr