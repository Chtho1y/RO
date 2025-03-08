local CardIconItemCtr = {}
local ConditionJudge = require("Common/ConditionJudge")
local IconItemCtr = require("Common/IconItemCtr")

function CardIconItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB, idx, needName)
    local cfgId = logicData == nil and 0 or (logicData.cfgId or 0)

    local slotType = logicData == nil and 0 or (logicData.slotType or 0)
    local idx = logicData == nil and 0 or (logicData.idx or 0)
    local selected = logicData ~= nil and logicData.selected or false

    local result = true
    if slotType > 0 then
        local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(slotType * 100 + idx)
        if condition == nil then
            LogError(slotType.."  "..idx.."  card slot error")
            return
        end

        result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition)
        if not result then
            item.lock.text.uILocalizeScript:SetContentAndValues("LvLack", {condition.UnlockingCondition[2]})
        end
    end

    item.mask:SetActive(cfgId == 0)
    item.add:SetActive(cfgId == 0)
    item.cardName:SetActive(cfgId > 0 and needName == true)
    item.lock:SetActive(slotType > 0 and not result)
    item.selected:SetActive(selected)

    item.iconItem:SetActive(cfgId > 0)
    item.btnRemove:SetActive(false)

    if cfgId > 0 then
        local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)

        item.cardName.text.text = I18N.T(cardData.CardName)

        IconItemCtr:SetData(wnd, item.iconItem, logicData, enterType)
        item.iconItem.num:SetActive(enterType == Enum.ItemIEnterType.CardRecreate or enterType == Enum.ItemIEnterType.CardCompose
                or enterType == Enum.ItemIEnterType.Bag)
        if logicData.num ~= nil then
            if enterType == Enum.ItemIEnterType.Bag then
                item.iconItem.num.text.text = logicData.num
            else
                --local num = logicData.num > 90 and "..." or logicData.num
                item.iconItem.num.text.text = CommonUtil.StringConcat("0/", logicData.num)
            end
        end
    end

    if onClickOwner and onClickCB then
        if cfgId == 0 then
            item.bg.button.enabled = false
            item.add.button.enabled = false
        else
            item.add.button.enabled = false
            item.bg.button.enabled = true
            onClickOwner.uiBase:AddButtonUniqueEventListener(item.bg.button, onClickOwner, onClickCB, logicData, item, idx)
        end
    else
        item.bg.button.enabled = false
        item.add.button.enabled = false
    end
end

return CardIconItemCtr