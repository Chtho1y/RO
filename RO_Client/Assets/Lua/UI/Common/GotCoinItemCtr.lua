local GotCoinItemCtr = {}

function GotCoinItemCtr:SetData(wnd, itemlua, logicData, enterType)
    local cfgId = logicData.cfgId
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

    if itemCfgData.Icon and itemCfgData.Icon ~= '' then
        CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
            itemlua.icon.image.sprite = sprite
        end)
    end
end

return GotCoinItemCtr