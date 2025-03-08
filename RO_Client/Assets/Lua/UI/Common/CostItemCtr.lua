local CostItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function CostItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local itemId = logicData.cfgId
    local costNum = logicData.cost
    local isMax = logicData.isMax

    --local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemId)
    --ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
    --    CommonUtil.BatchCreateItems(wnd, itemlua, item.item.transform, logicData, Enum.ItemIEnterType.Cost, onClickOwner, onClickCB)
    --end)
    IconItemCtr:SetData(wnd, item.iconItem, logicData, Enum.ItemIEnterType.Cost, onClickOwner, onClickCB)

    local ownedItem = CommonUtil.GetOwnResCountByItemId(itemId)

    local ownedStr = ownedItem
    if ownedItem < costNum and not isMax then
        ownedStr = CommonUtil.FormatNumber(ownedItem)
        ownedStr = string.format(Constant.RedColorText, ownedStr)
    else
        ownedStr = CommonUtil.FormatNumber(ownedItem)
    end
    local str = CommonUtil.StringConcat(ownedStr, "/", CommonUtil.FormatNumber(costNum))
    if isMax then
        str = "-/-"
    end
    item.text.text.text = str
    --CommonUtil.IsConditionOutColor(item.text.text, ownedItem < costNum and not isMax, str)

    return costNum <= ownedItem
end

return CostItemCtr