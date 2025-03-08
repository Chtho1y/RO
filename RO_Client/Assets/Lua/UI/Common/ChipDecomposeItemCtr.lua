local ChipDecomposeItemCtr = {}

function ChipDecomposeItemCtr:SetData(wnd, itemlua, logicData)
    local cfgId = logicData.cfgId
    local num = logicData.num
    local cost = logicData.cost or 0
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

    if itemCfgData.Icon and itemCfgData.Icon ~= '' then
        CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
            itemlua.icon.image.sprite = sprite
        end)
    end
    local quality = itemCfgData.Quality
    CommonUtil.LoadIcon(wnd, Constant.Quality_Chip_Frame_Icons[quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end)

    local composeItem = itemCfgData.ComposeItem
    local multi = false
    local parterId = nil
    if composeItem and #composeItem > 0 then
        if type(composeItem[1]) == 'number' then
            -- 单个
            parterId = composeItem[1]
        else
            -- 多个
            parterId = composeItem[1][1]
            multi = true
        end
    end

    local parterCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(parterId)

    local natureData = ManagerContainer.CfgMgr:GetNatureDataById(parterCfgData.NatureId)
    CommonUtil.LoadIcon(wnd, natureData.Icon, function (sprite)
        itemlua.natureIcon.image.sprite = sprite
    end)

    itemlua.number.text.text.text = cost .. '/' .. num
    itemlua.btnRemove:SetActive(cost ~= 0)

    local add = function(idx, isOver)
        logicData.cost = logicData.cost or 0
        if logicData.cost < logicData.num then
            if isOver then
                logicData.cost = logicData.num
            else
                logicData.cost = logicData.cost + 1
            end
            itemlua.number.text.text.text = logicData.cost .. '/' .. logicData.num
            itemlua.btnRemove:SetActive(logicData.cost ~= 0)
        end
    end

    local remove = function(idx, isOver)
        logicData.cost = logicData.cost or 0
        if logicData.cost > 0 then
            if isOver then
                logicData.cost = 0
            else
                logicData.cost = logicData.cost - 1
            end
            itemlua.number.text.text.text = logicData.cost .. '/' .. logicData.num
            itemlua.btnRemove:SetActive(logicData.cost ~= 0)
        end
    end

    itemlua.bg.repeatButton:AddRepeatClickEventListener(add)
    itemlua.btnRemove.repeatButton:AddRepeatClickEventListener(remove)
end

return ChipDecomposeItemCtr