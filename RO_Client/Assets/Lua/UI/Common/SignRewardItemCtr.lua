local SignRewardItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function SignRewardItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)
    if not logicData then
        return
    end

    local idx = logicData.idx
    local cfgData = logicData.cfgData
    local canSignToday = logicData.canSignToday
    local enterType = logicData.enterType or 0
    local signDays = logicData.signDays or 0
    local reward = cfgData.SignInReward and cfgData.SignInReward[1] or nil
    local vipLevel = cfgData.VipLevel
    local canSignDay = 0
    local curSignedDay = 0
    if enterType == 0 then  --默认每日签到
        canSignDay = ManagerContainer.DataMgr.SignData:GetCanSignDay()
        curSignedDay = ManagerContainer.DataMgr.SignData:GetCurSignedDay()
    elseif enterType == 1 then  --暑期活动签到
        canSignDay =  canSignToday and signDays + 1 or signDays
        curSignedDay = signDays
    end

    item.dayTxt.text.text = I18N.SetLanguageValue("SignInTips1", idx)
    if reward then
        local data = {cfgId = reward[1], num = reward[2], vip = vipLevel}
        IconItemCtr:SetData(wnd, item.iconItem, data, Enum.ItemIEnterType.Bag)
    end

    item.gotRewardNode:SetActive(cfgData.ID <= curSignedDay)
    item.uIRedPointRP:SetActive(canSignToday and cfgData.ID == canSignDay)

    if onClickOwner and onClickCB then
        item.iconItem.bg.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(item.iconItem.bg.button, onClickOwner, onClickCB, cfgData)
    else
        item.iconItem.bg.button.enabled = false
    end
end

return SignRewardItemCtr