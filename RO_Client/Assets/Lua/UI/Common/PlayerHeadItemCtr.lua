local PlayerHeadItem = {}

function PlayerHeadItem:SetData(wnd, item, logicData)
    local briefInfo = logicData.briefInfo
    local needHideName = logicData.needHideName

    item.playerName:SetActive(not needHideName)
    item.image.enabled = not needHideName

    item.jobIcon:SetActive(briefInfo ~= nil)
    if briefInfo ~= nil then
        item.playerName.text.text = briefInfo.nickName

        local headIcon = CommonUtil.GetPlayerHeadIcon(briefInfo)
        if headIcon ~= nil and headIcon ~= "" then
            CommonUtil.LoadIcon(wnd, headIcon, function(sprite)
                item.icon.image.sprite = sprite
            end, item, 'headPortraitIconIdx')
        else
            item.icon.image.sprite = nil
        end

        local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(briefInfo.configId)
        if jobCfgData ~= nil and jobCfgData.JobIcon ~= nil and jobCfgData.JobIcon ~= "" then
            CommonUtil.LoadIcon(wnd, jobCfgData.JobIcon, function (sprite)
                item.jobIcon.image.sprite = sprite
            end, item, 'jobIconIdx')
        else
            item.jobIcon.image.sprite = nil
        end
    else
        item.playerName.text.text = I18N.T("NoData")
    end
end

return PlayerHeadItem