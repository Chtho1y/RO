local LevelIncreaseItemCtr = {}

function LevelIncreaseItemCtr:SetData(wnd, itemlua, data)
    local iconPath = data.iconPath
    local lastNum = data.lastNum
    local newNum = data.newNum

    local parent = itemlua.transform.parent
    if parent then
        local parentRect = parent:GetComponent(Enum.TypeInfo.RectTransform)
        itemlua.rectTransform.sizeDelta = parentRect.sizeDelta
    end

    if iconPath and iconPath ~= '' then
        CommonUtil.LoadIcon(wnd, iconPath, function (sprite)
            itemlua.icon.image.sprite = sprite
        end, itemlua, "IconAsyncIdx")
    end

    itemlua.BZenyLbl.text.text = lastNum.."/m"
    itemlua.AZenyLbl.text.text = newNum.."/m"

    itemlua.ZenyUpgrade:SetActive(newNum > lastNum)
end

return LevelIncreaseItemCtr