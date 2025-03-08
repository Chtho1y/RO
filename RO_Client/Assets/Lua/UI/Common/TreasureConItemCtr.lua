local TreasureConItemCtr = {}

function TreasureConItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local type = logicData.type
    local val = logicData.val

    local icon
    if type == Enum.TreasureConditionType.Nature then
        local natureData = ManagerContainer.CfgMgr:GetNatureDataById(val)
        icon = natureData.Icon
    elseif type == Enum.TreasureConditionType.Quality then
        icon = Constant.Quality_Treasure_Icons[val]
    end
    CommonUtil.LoadIcon(wnd, icon, function (sprite)
        item.background.image.sprite = sprite
    end)

    --item.toggle.group = logicData.toggleGroup

    item.toggle.isOn = logicData.condition

    --if onClickOwner ~= nil and onClickCB ~= nil then
    --    wnd.uiBase:AddToggleEventListener(item.toggle, onClickOwner, onClickCB, logicData)
    --end
end

return TreasureConItemCtr