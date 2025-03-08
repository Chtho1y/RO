local RoleListItemCtr = {}
local RedPointItemCtr = require("Common/RedPointItemCtr")

function RoleListItemCtr:SetData(wnd, item, data, onClickOwner, onClickCB)
    local idx = data[1]
    local logicData = data[2]
    local cfgData = data[3]

    item.labelLead:SetActive(idx == 1)
    item.labelUp:SetActive(idx ~= 1 and logicData.isBattle)

    CommonUtil.SetTotalChildrenGray(item.gameObject, idx ~= 1 and not logicData.owned)

    if cfgData == nil then
        LogError("partner cfg  id "..logicData.configId.."  error")
        return
    end

    local quality = logicData.strengthLevel
    local frameIcon = Constant.Quality_Role_Frame_Default_Icons
    if quality == 100 then
        frameIcon = Constant.Quality_Lead_Role_Icon
    elseif quality > 0 then
        frameIcon = Constant.Quality_Role_Frame_Icons[math.min(quality, #Constant.Quality_Role_Frame_Icons)]
    end
    CommonUtil.LoadIcon(wnd, frameIcon, function (sprite)
        item.frame.image.sprite = sprite
        --item.frame.image:SetNativeSize()
        --local size = Constant.Quality_Role_Frame_Size[quality] or Constant.Quality_Role_Frame_Size[1]
        --if size then
        --    item.frame.rectTransform.sizeDelta = Vector2(size[1], size[2])
        --end
    end)

    CommonUtil.LoadIcon(wnd, cfgData.Avatar, function (sprite)
        item.head.image.sprite = sprite
    end)

    CommonUtil.LoadIcon(wnd, cfgData.JobIcon2, function (sprite)
        item.job.image.sprite = sprite
    end)

    item.numLv.text.text = logicData.baseLevel

    if onClickOwner and onClickCB then
        wnd.uiBase:AddButtonUniqueEventListener(item.head.button, onClickOwner, onClickCB, idx, logicData.id)
    end
end

return RoleListItemCtr