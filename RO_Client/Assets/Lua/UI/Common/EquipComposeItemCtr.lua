local EquipComposeItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

local function RefreshInfo(item, equipCfgData, logicData)
    local ownedCoin = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Coin)
    local cost = logicData.curForgeCount == 0 and equipCfgData.CostMoney or logicData.curForgeCount * equipCfgData.CostMoney
    CommonUtil.IsConditionOutColor(item.cost.text.text, cost > ownedCoin, cost)

    item.num.text.text = logicData.curForgeCount

    local value = logicData.curForgeCount/logicData.maxForgeCount
    item.slider.slider.value = logicData.maxForgeCount == 0 and 0 or value
    item.lastValue = item.slider.slider.value

    item.btnMinus:SetActive(logicData.curForgeCount > 0 )
    item.btnPlus:SetActive(logicData.curForgeCount < logicData.maxForgeCount)
    item.isButton = nil
end

function EquipComposeItemCtr:SetData(wnd, item, logicData, enterType, owner, cb)
    local cfgId = logicData.cfgId
    local num = logicData.num

    item.isButton = nil

    logicData.maxForgeCount = math.floor(num/3)
    logicData.curForgeCount = logicData.maxForgeCount

    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
    -- 道具图标
    IconItemCtr:SetData(wnd, item.iconItem, logicData, Enum.ItemIEnterType.EquipForge)
    --CommonUtil.BatchCreateItems(wnd, item.source.equipItem, item.source.transform, logicData, Enum.ItemIEnterType.EquipForge)
    -- 道具名称
    local name = I18N.T(itemCfgData.Name)
    if equipCfgData.Forge == 0 then
        name = name..I18N.T("MAX")
    end
    item.itemName.text.text = name

    local baseAttrs = {}
    for k,v in pairs(Enum.HeroAttrType) do
        if equipCfgData[k] and equipCfgData[k] ~= 0 then
            table.insert(baseAttrs, {Enum.HeroAttrType[k], equipCfgData[k]})
        end
    end
    CommonUtil.BatchCreateItemsLoopSpawnPrefabNew(wnd, baseAttrs, Enum.PrefabNames.EquipBaseAttrItem, item.propertyGroup.transform)
    --
    --local index = 0
    --for k, v in pairs(baseAttrs) do
    --    index = index + 1
    --    CommonUtil.BatchCreateItemsLoopWithMould(wnd, item.equipBaseAttrItem, item.propertyGroup.transform, v, index)
    --end

    item.compositeNumber.txt.text.text = CommonUtil.StringConcat(num, "/3")

    if equipCfgData.Forge > 0 then
        local forgeItemCfgData = ManagerContainer.CfgMgr:GetItemById(equipCfgData.Forge)
        local itemCfgData1 = ManagerContainer.CfgMgr:GetItemById(equipCfgData.Forge)
        item.txtItemName.text.text = string.format(Constant.ColorTextArray[itemCfgData1.Quality], I18N.T(forgeItemCfgData.Name))
    end

    item.maxLv:SetActive(equipCfgData.Forge == 0)
    item.bottomBox:SetActive(equipCfgData.Forge > 0)
    item.btnCompose:SetActive(equipCfgData.Forge > 0)

    local ownedCoin = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Coin)

    local canCompose = ownedCoin >= equipCfgData.CostMoney and logicData.maxForgeCount > 0
    item.btnCompose.button.interactable = canCompose
    --CommonUtil.SetTotalChildrenGray(item.btnCompose, not canCompose)

    local maxCount = math.floor(ownedCoin/equipCfgData.CostMoney)

    local curCount = math.min(maxCount,  logicData.maxForgeCount)
    logicData.canForgeCount = maxCount
    logicData.maxForgeCount = curCount
    logicData.curForgeCount = curCount
    
    wnd.uiBase:AddButtonUniqueEventListener(item.btnMinus.button, wnd, function ()
        if logicData.curForgeCount <= 0 then
            return
        end
        if logicData.curForgeCount <= 1 and logicData.maxForgeCount > 1 then
            return
        end
        item.isButton = true

        logicData.curForgeCount = logicData.curForgeCount - 1
        RefreshInfo(item, equipCfgData, logicData)
    end)

    wnd.uiBase:AddButtonUniqueEventListener(item.btnPlus.button, wnd, function ()
        if logicData.curForgeCount >= logicData.maxForgeCount then
            return
        end
        item.isButton = true

        logicData.curForgeCount = logicData.curForgeCount + 1
        RefreshInfo(item, equipCfgData, logicData)
    end)

    wnd.uiBase:AddSliderUniqueEventListener(item.slider.slider, wnd, function (wnd, slider, value)
        if ManagerContainer.LuaTimerMgr:IsSomeFrameCount() then
            return
        end

        if item.isButton then
            return
        end

        logicData.curForgeCount = logicData.maxForgeCount * value
        logicData.curForgeCount = math.ceil(logicData.curForgeCount)

        if logicData.maxForgeCount > 1 and logicData.curForgeCount <= 0 then
            logicData.curForgeCount = 1
        end
        RefreshInfo(item, equipCfgData, logicData)
    end, nil)

    if canCompose and owner and cb then
        wnd.uiBase:AddButtonUniqueEventListener(item.btnCompose.button, owner, cb, logicData)
    end

    RefreshInfo(item, equipCfgData, logicData)
end

return EquipComposeItemCtr