local CardSlotItemCtr = {}
local ConditionJudge = require("Common/ConditionJudge")
local IconItemCtr = require("Common/IconItemCtr")

function CardSlotItemCtr:SetData(wnd, item, logicData, enterType)
    local cfgId = logicData.cfgId
    local condition = logicData.condition

    if cfgId > 0 then
        IconItemCtr:SetData(wnd, item.iconItem, logicData, Enum.ItemIEnterType.CardTips, wnd, wnd.ShowCardList)

        item.cardIcon.unowned.icon.button.interactable = false
    else
        item.cardIcon.unowned.icon.button.interactable = true
        wnd.uiBase:AddButtonUniqueEventListener(item.cardIcon.unowned.icon.button, wnd,  wnd.ShowCardList, logicData)
    end

    local result, val, content = ConditionJudge:ConditionPassResult1(condition)

    item.cardIcon.owned:SetActive(result and cfgId > 0)
    item.cardName.owned:SetActive(result and cfgId > 0)
    item.cardIcon.unowned:SetActive(result and cfgId == 0)
    item.cardName.unowned:SetActive(result and cfgId == 0)
    item.cardIcon.locked:SetActive(not result)
    item.cardName.locked:SetActive(not result)

    item.noCard:SetActive(result and cfgId == 0)
    item.lvLocked:SetActive(not result)
    item.grid:SetActive(cfgId > 0)

    if cfgId == 0 then
        if not result then
            item.lvLocked.text.text = content
        end
    else
        local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)

        item.normal:SetActive(cardData.CardType == Enum.CardType.NORMAL)
        item.mini:SetActive(cardData.CardType == Enum.CardType.MINIBOSS)
        item.mVP:SetActive(cardData.CardType == Enum.CardType.MVP)

        if cardData.CardType == Enum.CardType.NORMAL then
            item.nameTextNormal.uILocalizeScript:SetContent(cardData.CardName)
        elseif cardData.CardType == Enum.CardType.MINIBOSS then
            item.nameTextMini.uILocalizeScript:SetContent(cardData.CardName)
        elseif cardData.CardType == Enum.CardType.MVP then
            item.nameTextMVP.uILocalizeScript:SetContent(cardData.CardName)
        end

        local idx = 0
        for _,v in pairs(CommonUtil.DeserializeCfgItemList(cardData.Attribute1)) do
            idx = idx + 1
            CommonUtil.BatchCreateItemsLoopSpawnPrefab(wnd, Enum.PrefabNames.CardAttrItem, item.grid.transform, v, idx)
        end
    end
end

return CardSlotItemCtr