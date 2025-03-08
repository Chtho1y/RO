local UIRecruitTipsView = class("UIRecruitTipsView")

local studentLimit = 40
function UIRecruitTipsView:ctor()

end

function UIRecruitTipsView:InitGo(root,uiGo)
    self.root = root
    self.viewLua = CommonUtil.BindGridViewItem2Lua(self.root, "UIRecruitTips", uiGo)

    self.viewLua.transform:SetParent(self.root.transform, false)
    self.viewLua.transform.localScale = Vector3.one
    self.viewLua.rectTransform.anchorMin = Vector2.zero
    self.viewLua.rectTransform.anchorMax = Vector2.one
    self.viewLua.rectTransform.pivot = Vector2(0.5, 0.5)
    self.viewLua.rectTransform.anchoredPosition3D = Vector3.zero
    self.viewLua.rectTransform.sizeDelta = Vector2.zero

    studentLimit = GlobalConfig.Instance:GetConfigIntValue(242)
    self:AddUIEventListener()
end

function UIRecruitTipsView:AddUIEventListener()
    self.root.uiBase:AddButtonEventListener(self.viewLua.btnCancle.button,self,self.OnCancleClick)
    self.root.uiBase:AddButtonEventListener(self.viewLua.btnBind.button,self,self.OnBindClick)
    self.root.uiBase:AddButtonEventListener(self.viewLua.btnUnbind.button,self,self.OnUnbindClick)
end

function UIRecruitTipsView:OnCancleClick()

end

function UIRecruitTipsView:OnBindClick()

end

function UIRecruitTipsView:OnUnbindClick()

end

function UIRecruitTipsView:AddEventListener()

end

function UIRecruitTipsView:RemoveEventListener()

end

function UIRecruitTipsView:Show(type, briefInfo, studentCount)
    if type == 1 then
        self.viewLua.noticeTitle.uILocalizeScript:SetContent("TitleTeacherInfo")
        self.viewLua.questionTxt:SetActive(studentCount == studentLimit)
        self.viewLua.questionTxt.uILocalizeScript:SetContent("DscSutentMax")
    elseif type == 2 then
        self.viewLua.noticeTitle.uILocalizeScript:SetContent("TitleStudentInfo")
        self.viewLua.questionTxt:SetActive(true)
        self.viewLua.questionTxt.uILocalizeScript:SetContent("SureUnbind")
    end
    local playerHead = CommonUtil.GetPlayerHeadIcon(briefInfo);
    local jobData = ManagerContainer.CfgMgr:GetJobDataById(briefInfo.config_id)
    local fakerData = {Level = briefInfo.level, ProfessionIcon = jobData.JobIcon, HeadIcon = playerHead, IsHero = true};
    CommonUtil.SetPlayerHeadAndFrame(self.root, self.viewLua.dscBox.headItem, fakerData,false, briefInfo.head_frame_id);

    self.viewLua.dscBox.nickname.text.text = CommonUtil.GetVaildNickName(briefInfo.nick_name)
    self.viewLua.dscBox.fightPBox.fighterPower.text.text = briefInfo.fight_power
    self.viewLua.dscBox.timeBox.time.text.text = CommonUtil.GetOnlineStatus(briefInfo.online_state, briefInfo.online_time)
    self.viewLua.dscBox.recruitValueBg.recruitValueNum.text.text =

    self.viewLua:SetActive(true)
    self:AddEventListener()
end

function UIRecruitTipsView:Hide()
    self.viewLua:SetActive(false)
    self:RemoveEventListener()
end

function UIRecruitTipsView:Dispose()
    self:Hide()
    self.viewLua = nil
end

return UIRecruitTipsView