local ChangeHeadItemCtr = {}

function ChangeHeadItemCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local selected = logicData.selected or false

    local cfgData = ManagerContainer.CfgMgr:GetHeadPortraitDataById(cfgId)
    local HeadProtraitData = ManagerContainer.DataMgr.HeadProtraitData
    local state = HeadProtraitData:GetState(cfgId)

    local used = (ManagerContainer.DataMgr.UserData:GetUserHeadPortraitId() == cfgId)
    local noComplete = (state == Enum.TaskStateType.NoCompeleted)
    local locked = (state ~= Enum.TaskStateType.Received)
    itemlua.used:SetActive(used)
    itemlua.locked:SetActive(locked)
    itemlua.icon:SetActive(noComplete)
    itemlua.selected:SetActive(selected)

    if cfgData.HeadPortraitPic and cfgData.HeadPortraitPic ~= '' then
        CommonUtil.LoadIcon(wnd, cfgData.HeadPortraitPic, function (sprite)
            itemlua.head.image.sprite = sprite
        end)
    end

    if onClickOwner and onClickCB then
        itemlua.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemlua.button, onClickOwner, onClickCB, logicData)
    else
        itemlua.button.interactable = false
    end
end

return ChangeHeadItemCtr