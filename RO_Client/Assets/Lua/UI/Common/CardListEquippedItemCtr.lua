local CardListEquippedItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function CardListEquippedItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local heroId = logicData.heroId

    local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
    if cardCfgData == nil then
        LogError(cfgId.." card isnt exist")
        return
    end

    local itemLua = item.iconItem
    local data = {cfgId = cfgId}
    IconItemCtr:SetData(wnd, itemLua, data, Enum.ItemIEnterType.EquipedCard, onClickOwner, onClickCB)

    item.cardName.uILocalizeScript:SetContent(cardCfgData.CardName)

    local curLv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(heroId)
    local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(heroId)
    local cfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(curLv)
    item.cardBless:SetActive(curLv > 0 and state)
    item.blessLv.text.text = I18N.SetLanguageValue("CardSuitTips1", curLv)

    local idx = 0
    for _,v in pairs(CommonUtil.DeserializeCfgItemList(cardCfgData.Attribute1)) do
        idx = idx + 1
        local data = clone(v)
        data[3] = cfgData
        data[4] = state
        CommonUtil.BatchCreateItemsLoopSpawnPrefab(wnd, Enum.PrefabNames.CardAttrItem, item.attribs.transform, data, idx, Enum.ItemIEnterType.EquipedCard)
    end
end

return CardListEquippedItemCtr