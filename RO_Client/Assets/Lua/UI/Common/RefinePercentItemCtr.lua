local RefinePercentItemCtr = {}

function RefinePercentItemCtr:SetData(wnd, item, logicData)
    item.text.text.text = CommonUtil.StringConcat("+", logicData)
end

return RefinePercentItemCtr