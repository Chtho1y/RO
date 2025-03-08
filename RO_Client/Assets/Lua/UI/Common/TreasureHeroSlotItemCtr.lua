local TreasureHeroSlotItemCtr = {}
local HeroHeadIcon = require("Common/HeroHeadIcon")

function TreasureHeroSlotItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local id = logicData.id

    item.headItem:SetActive(id > 0)
    if id > 0 then
        HeroHeadIcon:SetTreasurePartnerHeadIcon(wnd, item.headItem, logicData, Enum.ItemIEnterType.Treasure, onClickOwner, onClickCB)
    end

    --if onClickOwner ~= nil and onClickCB ~= nil then
    --    wnd.uiBase:AddButtonUniqueEventListener(item.btnAdd.button, onClickOwner, onClickCB, logicData)
    --end
end

return TreasureHeroSlotItemCtr