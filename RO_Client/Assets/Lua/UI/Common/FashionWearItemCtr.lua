local FashionWearItemCtr = {}

function FashionWearItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local isVaild = (logicData ~= nil)

    itemlua.icon:SetActive(isVaild)
    itemlua.bg:SetActive(isVaild)
    itemlua.frame:SetActive(isVaild)
    if not isVaild then
        itemlua.selected:SetActive(isVaild)
        itemlua.redPoint:SetActive(isVaild)
        return
    end

    local cfgId = logicData.cfgId
    local isNew = logicData.isNew or false
    local isWear = logicData.isWear or false

    local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(fashionCfgData.FashionPaper)

    if fashionCfgData.FashionIcon and fashionCfgData.FashionIcon ~= '' then
        CommonUtil.LoadIcon(wnd, fashionCfgData.FashionIcon, function (sprite)
            itemlua.icon.image.sprite = sprite
        end, itemlua, 'IconAsyncIdx')
    end

    CommonUtil.LoadIcon(wnd, Constant.Quality_Frame_Icons[itemCfgData.Quality], function (sprite)
        itemlua.frame.image.sprite = sprite
    end, itemlua, 'FrameAsyncIdx')

    itemlua.selected:SetActive(isWear)
    itemlua.redPoint:SetActive(isNew)

    if onClickOwner and onClickCB then
        itemlua.bg.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, onClickOwner, onClickCB, logicData)
    else
        itemlua.bg.button.interactable = false
    end
end

return FashionWearItemCtr