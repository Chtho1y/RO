local EquipListItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function EquipListItemCtr:SetData(wnd, itemLua, logicData, cbOwner, cb, enterType)
    local equipLua = itemLua.iconItem
    itemLua.textName:SetActive(logicData ~= nil)
    local itemCfgData
    if logicData then
        itemCfgData = ManagerContainer.CfgMgr:GetItemById(logicData.cfgId)
        itemLua.textName.text.text = I18N.T(itemCfgData.Name)
    end

    local state = enterType == Enum.ItemIEnterType.SkillEquip
    itemLua.grid:SetActive(not state)
    itemLua.itemDsc:SetActive(state)
    if not state then
        IconItemCtr:SetData(wnd, equipLua, logicData, Enum.ItemIEnterType.HeroEquip, cbOwner, cb)
        local equipData = ManagerContainer.CfgMgr:GetEquipById(logicData.cfgId)
        local baseAttrs = {}
        for k,v in pairs(Enum.HeroAttrType) do
            if equipData[k] and equipData[k] ~= 0 then
                table.insert(baseAttrs, {Enum.HeroAttrType[k], equipData[k]})
            end
        end
        CommonUtil.BatchCreateItemsLoopSpawnPrefabNew(wnd, baseAttrs, Enum.PrefabNames.EquipBaseAttrItem, itemLua.grid.transform)
    else
        if logicData and logicData.cfgId > 0 then
            IconItemCtr:SetData(wnd, equipLua, logicData, Enum.ItemIEnterType.Bag, cbOwner, cb)
            itemLua.itemDsc.text.text = I18N.T(itemCfgData and itemCfgData.Describe or "")
        end
    end
    itemLua.btnChange:SetActive(logicData and not logicData.equiped)
    itemLua.btnDown:SetActive(logicData and logicData.equiped)
end

return EquipListItemCtr