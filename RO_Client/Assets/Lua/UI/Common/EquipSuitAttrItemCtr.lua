local EquipSuitAttrItemCtr = {}

function EquipSuitAttrItemCtr:SetData(wnd, item, logicData)
    local suitId = logicData[1]
    local attr1 = logicData[2][1]
    if type(attr1) == "number" then
        local attrId = logicData[2][1]
        local attrValue = logicData[2][2]
        self:RefreshSuitAttrText(suitId, item, logicData, attrId, attrValue)
    else
        for _,v in pairs(logicData[2]) do
            local attrId = v[1]
            local attrValue = v[2]
            self:RefreshSuitAttrText(suitId, item, logicData, attrId, attrValue)
            return
        end
    end
end

function EquipSuitAttrItemCtr:RefreshSuitAttrText(suitId, item, logicData, attrId, attrValue)
    local lanKey = "Attr_" .. attrId
    if attrId == Enum.HeroAttrType.Attack_Percent or attrId == Enum.HeroAttrType.MagicAttack_Percent then
        lanKey = Constant.Lang_Attack
    end
    item.text.uILocalizeScript:SetContent(lanKey)
    item.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrValue)
    item.textDsc.uILocalizeScript:SetValues({suitId * 2})

    local activated = logicData[3]
    local index = logicData[4]
    local activedCount = index * 2
    item.actived.textDsc.uILocalizeScript:SetContentAndValues("SuitAttrActCondition", {activedCount})

    if activated ~= nil then
        CommonUtil.SetGraphicColor(item.actived.bg.image, activated and Constant.DeepGreenColor or Constant.GrayColor)
    end
end

return EquipSuitAttrItemCtr