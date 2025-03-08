local CardListItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function CardListItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local idx = logicData.idx
    local needRecommend = logicData.needRecommend

    local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
    if cardCfgData == nil then
        LogError(cfgId.." card isnt exist")
        return
    end

    local itemLua = item.iconItem

    IconItemCtr:SetData(wnd, itemLua, logicData, Enum.ItemIEnterType.Bag, onClickOwner, onClickCB)

    item.cardName.uILocalizeScript:SetContent(cardCfgData.CardName)

    CommonUtil.BatchCreateItemsLoopSpawnPrefabNew(wnd, CommonUtil.DeserializeCfgItemList(cardCfgData.Attribute1), Enum.PrefabNames.CardAttrItem, item.attribs.transform, Enum.ItemIEnterType.EquipedCard)
    --local idx = 0
    --for _,v in pairs(CommonUtil.DeserializeCfgItemList(cardCfgData.Attribute1)) do
    --    idx = idx + 1
    --    CommonUtil.BatchCreateItemsLoopSpawnPrefab(wnd, Enum.PrefabNames.CardAttrItem, item.attribs.transform, v, idx, Enum.ItemIEnterType.EquipedCard)
    --end

    item.recommend:SetActive(idx == 1 and needRecommend)
end

return CardListItemCtr