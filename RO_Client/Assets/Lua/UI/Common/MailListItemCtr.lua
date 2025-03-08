local MailListItemCtr = {}
local BitUtil = require("BitUtil")

function MailListItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    item:SetActive(logicData ~= nil)
    if logicData == nil then
        return
    end

    local state = logicData.state
    local readState = BitUtil.ParseMailReadState(state) == 1
    local rewardState = BitUtil.ParseMailRewardState(state) == 1

    item.litter:SetActive(not readState)
    item.item:SetActive(not readState and not rewardState and #logicData.rewardList > 0)
    item.litterOpen:SetActive(readState)
    item.itemOpen:SetActive(readState and not rewardState and #logicData.rewardList > 0)
    item.readMark:SetActive(readState)

    local mailTitle = logicData.title
    local mailCfgData = ManagerContainer.CfgMgr:GetMailDataByCfgId(logicData.configId)
    if mailCfgData then
        mailTitle = I18N.T(mailCfgData.Title)
    end

    item.mailTtle.text.text = mailTitle
    if logicData.expireTime then
        local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(logicData.expireTime)
        if remainTime > ManagerContainer.LuaTimerMgr:GetOneDaySeconds() then
            local time = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true)
            item.timer.text.text = I18N.SetLanguageValue("MailBeginTime", time)
        else
            item.timer.text.text = I18N.T("MailOver")
        end
    end

    item.redPointNewItem:SetActive(not readState)

    if onClickOwner ~= nil and onClickCB ~= nil then
        wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB, item, logicData)
    end
end

return MailListItemCtr