local CardItemCtr = {}
local ConditionJudge = require("Common/ConditionJudge")

function CardItemCtr:SetData(wnd, item, logicData, enterType)
    local cfgId = logicData.cfgId
    local condition = logicData.condition

    local result, val, content = ConditionJudge:ConditionPassResult1(condition)

    item.attrBg:SetActive(result and cfgId > 0)
    item.owned:SetActive(result and cfgId > 0)
    item.unowned:SetActive(result and cfgId == 0)
    item.locked:SetActive(not result)

    item.noCard:SetActive(result and cfgId == 0)
    item.lvLocked:SetActive(not result)
    item.nameTextNormal:SetActive(false)
    item.nameTextMini:SetActive(false)
    item.nameTextMVP:SetActive(false)
    item.grid:SetActive(cfgId > 0)

    item.notice:SetActive(enterType ~= Enum.ItemIEnterType.HeroEquip)

    if cfgId == 0 then
        if not result then
            item.lvLocked.text.text = content
        end
    else
        local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)

        item.nameTextNormal:SetActive(cardData.CardType == Enum.CardType.NORMAL)
        item.nameTextMini:SetActive(cardData.CardType == Enum.CardType.MINIBOSS)
        item.nameTextMVP:SetActive(cardData.CardType == Enum.CardType.MVP)

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

return CardItemCtr