local RecruitTaskItem = {}
local IconItemCtr = require("Common/IconItemCtr")

function RecruitTaskItem:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    local cfgId = logicData.cfgId
    local state = logicData.state

    local cfgData = ManagerContainer.CfgMgr:GetInvitationTaskDataByCfgId(cfgId)
    local taskData = ManagerContainer.DataMgr.FriendDataMgr:GetRecruitTaskDataByCfgId(cfgId)
    if not cfgData.Reward then return end

    local completeMaxCount = taskData and taskData.completeMaxCount or cfgData.CompleteNum
    local rewardCount = taskData and taskData.rewardCount or 0

    local itemData = {cfgId = cfgData.Reward[1][1], num = cfgData.Reward[1][2]}
    IconItemCtr:SetData(wnd, itemLua.iconSmallItem, itemData, enterType, onClickOwner, onClickCB)

    itemLua.taskName.text.text = I18N.T(cfgData.Title)
    itemLua.count.text.text = completeMaxCount - rewardCount

    itemLua.btnGet:SetActive(state == Enum.InvitationTaskStateType.CompletedAndNoReceive)
    itemLua.btnNotFinish:SetActive(state == Enum.InvitationTaskStateType.NoCompeleted)
    itemLua.seal:SetActive(state == Enum.InvitationTaskStateType.Received)
end

return RecruitTaskItem