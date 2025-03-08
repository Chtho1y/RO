local RecruitTaskItem = {}

function RecruitTaskItem:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    local playerHead = CommonUtil.GetPlayerHeadIcon(logicData);
    local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
    local fakerData = {Level = logicData.level, ProfessionIcon = jobData.JobIcon, HeadIcon = playerHead, IsHero = true};
    CommonUtil.SetPlayerHeadAndFrame(wnd, itemLua.headItem, fakerData,false, logicData.headFrameId);

    itemLua.playerName.text.text = logicData.nickName
    itemLua.statusLbl.text.text = CommonUtil.GetOnlineStatus(logicData.onlineState, logicData.onlineTime)

    local studentData = ManagerContainer.DataMgr.FriendDataMgr:GetMyStudentDataByUid(logicData.uid)
    itemLua.recruitValueNum.text.text = studentData and studentData.resVal or "---"

    local isClapped = ManagerContainer.DataMgr.FriendDataMgr:IsStudentClappedByUid(logicData.uid)
    CommonUtil.SetTotalChildrenGray(itemLua.clapBtn, isClapped)

    itemLua.clapBtn.button.enabled = not isClapped
    if not isClapped and onClickOwner and onClickCB then
        wnd.uiBase:AddButtonUniqueEventListener(itemLua.clapBtn.button,onClickOwner,onClickCB, logicData.uid)
    end
end

return RecruitTaskItem