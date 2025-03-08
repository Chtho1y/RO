local SupportItemCtr = {}
local IconPetItemCtr = require("Common/IconPetItemCtr")

function SupportItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)
    local id = logicData.id
    local idx = logicData.idx

    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
    item.notice1:SetActive(petData == nil)
    item.notice2:SetActive(petData ~= nil)

    item.item.owned:SetActive(petData ~= nil)
    item.item.unowned:SetActive(petData == nil)
    if petData then
        IconPetItemCtr:SetData(wnd, item.item.iconPetItem, petData, Enum.ItemIEnterType.Pet)
        item.item.iconPetItem.selected:SetActive(false)
    end
    if onClickOwner and onClickCB then
        wnd.uiBase:AddButtonUniqueEventListener(item.item.unowned.icon.button, onClickOwner, onClickCB, idx)
    end
    item.btnRemove:SetActive(petData ~= nil)
    wnd.uiBase:AddButtonUniqueEventListener(item.btnRemove.button, wnd, wnd.OnItemRemoveClick, id)

    --local time = GlobalConfig.Instance:GetConfigIntValue(228)
    --item.notice2.text.uILocalizeScript:SetContentAndValues("DscSupportNotice2", {math.ceil(time/60)})
end

return SupportItemCtr