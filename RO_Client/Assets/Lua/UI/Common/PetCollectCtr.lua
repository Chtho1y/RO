local PetCollectCtr = {}

function PetCollectCtr:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    local cfgData = logicData
    CommonUtil.LoadIcon(self.host, cfgData.Icon, function (sprite)
        itemLua.icon.image.sprite = sprite
    end, itemLua, "icon")

    local frameIcon = Constant.Quality_PetFrame_Icons[cfgData.Fame]
    CommonUtil.LoadIcon(self.host, frameIcon, function (sprite)
        itemLua.frame.image.sprite = sprite
    end, itemLua, "frame")

    CommonUtil.LoadIcon(self.host, Constant.Natural_Icons..cfgData.NatureType, function (sprite)
        itemLua.nature.image.sprite = sprite
    end, itemLua, "nature")

    wnd.uiBase:AddButtonUniqueEventListener(itemLua.bg.button, onClickOwner, onClickCB, cfgData.Id)

    --mask.gameObject:SetActive(cfgData.canActive)

    CommonUtil.SetTotalChildrenGray(itemLua.gameObject, cfgData.canActive)

    itemLua.uIRedPointRP.gameObject:SetActive(false)
end

return PetCollectCtr