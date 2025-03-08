local CardEquipItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")
local ConditionJudge = require("Common/ConditionJudge")

function CardEquipItemCtr:SetData(wnd, itemLua, logicData, onClickOwner, onClickCB)
    IconItemCtr:SetData(wnd, itemLua.iconItem, logicData, Enum.ItemIEnterType.HeroEquip, onClickOwner, onClickCB)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(logicData.cfgId)
    itemLua.textName.text.text = I18N.T(itemCfgData.Name)
    -- 道具类型

    itemLua.belong.text.text = logicData.belongName

    for j = 1, Constant.CARD_SLOT_LIMIT do
        itemLua["slot"..j]:SetActive(false)
        itemLua["slot"..j]["check"]:SetActive(false)
        --itemLua["slot"..j]["shadow"]:SetActive(false)
    end

    local hasSlot = false
    local cardSlotIndex = 0
    for j = 1, Constant.CARD_SLOT_LIMIT do
        local id = logicData.card_list[j] or 0
        local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(logicData.slotType * 100 + j)

        if condition ~= nil then
            local result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition[1])
            itemLua["slot"..j]:SetActive(result)
            itemLua["slot"..j]["check"]:SetActive(result and id > 0)
            --itemLua["slot"..j]["shadow"]:SetActive(result and id > 0)
            if result then
                if id > 0 then
                    local cardData = ManagerContainer.CfgMgr:GetCardDataById(id)
                    CommonUtil.LoadIcon(wnd, Constant.Card_Quality_L_Icons[cardData.CardType], function (sprite)
                        itemLua["slot"..j]["check"].image.sprite = sprite
                    end, itemLua, "cardType"..j)
                else
                    hasSlot = true
                    if cardSlotIndex == 0 then
                        cardSlotIndex = j
                    end
                end
            end
        end
    end
    itemLua.btnEquip:SetActive(hasSlot)
    itemLua.btnChange:SetActive(not hasSlot)
    return cardSlotIndex
end

return CardEquipItemCtr