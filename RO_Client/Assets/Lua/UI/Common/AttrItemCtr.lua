local AttrItemCtr = {}

function AttrItemCtr:SetData(wnd, item, logicData, enterType)
    local id = logicData[1]
    local val = logicData[2]
    if enterType == Enum.ItemIEnterType.Attr then
        item.nameText.text.text = I18N.T("Attr_" .. id)
        item.numberText.text.text = CommonUtil.HeroAttrFormatValue(id, val)
    elseif enterType == Enum.ItemIEnterType.SkillPveBenediction then
        item.nameText.text.text = I18N.T("SkillSuitNew_" .. id)
        item.numberText.text.text = (SDataUtil.IsGreater(val, 0) and '+' or (SDataUtil.IsLess(val, 0) and '-'or '')) .. val .. "%"
    elseif enterType == Enum.ItemIEnterType.CostMat then
        local itemCfgData = ManagerContainer.CfgMgr:GetItemById(id)
        if itemCfgData == nil then
            return
        end
        item.nameText.text.text = I18N.T(itemCfgData.Name)

        local ownCost = CommonUtil.GetOwnResCountByItemId(id)
        item.numberText.text.text = ownCost.."/"..val

        CommonUtil.SetTextColor(item.nameText.text, Constant.ColorTextArray[itemCfgData.Quality])
        CommonUtil.SetTextColor(item.numberText.text, ownCost >= val and Constant.GreenColorText or Constant.RedColorText)
    end
end

return AttrItemCtr