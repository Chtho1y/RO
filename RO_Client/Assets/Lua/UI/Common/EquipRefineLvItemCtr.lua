local EquipRefineLvItemCtr = {}

function EquipRefineLvItemCtr:SetData(wnd, refineItem, logicData, enterType)
    local attr = logicData.attr
    if attr == nil or attr == "" then
        LogError(logicData  .." lv  refine is nil")
        return
    end

    refineItem.text.uILocalizeScript:SetContentAndValues("RefineLvTip", {logicData.lv})
    if logicData.lv > logicData.curLv then
        refineItem.text.uILocalizeScript:SetContentAndValues("RefineLvTip", {logicData.lv})
        --refineItem.text.uILocalizeScript:SetContentAndValuesWithColor("RefineLvTip", {logicData.lv}, Constant.GrayColorText)
        --CommonUtil.SetTextColor(refineItem.text.text, Constant.GrayColorText)
    end

    refineItem.actived:SetActive(logicData.lv <= logicData.curLv)
    local attrId = attr[1]
    local num = attr[2]/100
    local content = I18N.T("Attr_" .. attrId)
    refineItem.text2.text.text = string.format(content.." %s%%", num)
    if logicData.lv > logicData.curLv then
        --CommonUtil.SetTextColor(refineItem.text2.text, Constant.GrayColorText)
    end
end

return EquipRefineLvItemCtr