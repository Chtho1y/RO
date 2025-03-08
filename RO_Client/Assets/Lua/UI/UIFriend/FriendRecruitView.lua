local FriendRecruitView = class("FriendRecruitView")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")
local UIRecruitTipsView = require("UIFriend/UIRecruitTipsView")
local TeacherLogUIView = require("UIFriend/TeacherLogUIView")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

local UIRecruitTipsPath = "UIFriend/UIRecruitTips"
local TeacherLogUIPath = "UIFriend/TeacherLogUI"

local PageType = {
    Task = 1,
    Students = 2,
}
local pageToggleData = {}
local lvLimit = 30
local studentLimit = 40
function FriendRecruitView:ctor()
    self.controller = require("UIFriend/FriendRecruitCtr"):new()
end

function FriendRecruitView:Init(root, parent)
    pageToggleData = {}

    self.root = root
    self.parent = parent

    self.loadSystem1 = MultiTypeAssetLoadSystem:new()
    self.loadSystem1:SetCompleteCB(self, self.PreloadedAssets1)

    self.loadSystem2 = MultiTypeAssetLoadSystem:new()
    self.loadSystem2:SetCompleteCB(self, self.PreloadedAssets2)

    lvLimit = GlobalConfig.Instance:GetConfigIntValue(241)
    studentLimit = GlobalConfig.Instance:GetConfigIntValue(242)
    self:InitGrid()

    CommonUtil.CreateToggleMouduleOnlyBtns(self.root, pageToggleData, self.parent.center.toggleGroup, PageType.Task, self.OnToggleValueChanged, self)
end

function FriendRecruitView:InitGrid()
    self.parent.center.taskScrollview.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
        return self:GetTaskItemByRowColumn(gridView, itemIndex, row, column)
    end, nil)

    --self.parent.center.studentScrollview.loopListView:InitGridView(0, function(gridView, itemIndex, row, column)
    --    return self:GetStudentItemByRowColumn(gridView, itemIndex, row, column)
    --end, nil)

    if self.loadStatusLoopListCtr then
        self.loadStatusLoopListCtr:Dispose()
        self.loadStatusLoopListCtr = nil
    end
    local totalListCount = self.controller:GetStudentListTotalCount()
    self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self.root, self.parent.center.studentScrollview.loopListView, 0, totalListCount,
            false, 'LoadingItem', Enum.ListLoadingStatus.None,
            true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
            self.GetItemByIndex,nil, self.OnBeginLoad, self)

    self.parent.center.studentScrollview.loopListView.ScrollRect.enabled = false
    local errorCode = self.controller:QueryNextStudentBriefInfo()
    if errorCode ~= 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
    end
end

function FriendRecruitView:Refresh()
    local masterUid = self.controller:GetMasterUId()
    self.parent.top.noTeacher:SetActive(masterUid == 0)
    self.parent.top.hasTeacher:SetActive(masterUid > 0)
    if masterUid > 0 then
        self.parent.top.info:SetActive(false)
    else
        self:RefreshNoTeacherUI()
    end

    self:RefreshCurrency()
    self:RefreshRecruitCode()
    self:RefreshStudentCount()
    self:RefreshRemainClapCount()
end

function FriendRecruitView:RefreshCurrency()
    local owned = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.RecruitStone)
    self.parent.center.currency.number.text.text = owned > 0 and owned or "--"
end

function FriendRecruitView:RefreshRecruitCode()
    self.root.myRecruitCode.code.text.text = self.controller:GetRecruitCode()
end

function FriendRecruitView:RefreshStudentCount()
    local studentCount = self.controller:GetStudentCount()
    self.parent.center.studentCount.text.text = studentCount == 0 and "--" or studentCount

    self.parent.center.dscMax.uILocalizeScript:SetContentAndValues("StudentLimit", {studentLimit})
end

function FriendRecruitView:RefreshRemainClapCount()
    self.parent.clapCount.text.text = self.controller:GetRemainClapCount()
end

function FriendRecruitView:RefreshNoTeacherUI()
    self.parent.top.dsc.uILocalizeScript:SetContentAndValues("DscNoTeacher", {lvLimit})
end

function FriendRecruitView:OnToggleValueChanged(index)
    self.parent.taskBg:SetActive(pageToggleData.toggleDefaultIndex == PageType.Task)
    self.parent.studentBg:SetActive(pageToggleData.toggleDefaultIndex == PageType.Students)

    self.parent.center.studentScrollview.loopListView.ScrollRect.enabled = pageToggleData.toggleDefaultIndex == PageType.Students
    if pageToggleData.toggleDefaultIndex == PageType.Task then
        self:RefreshTaskList()
    elseif pageToggleData.toggleDefaultIndex == PageType.Students then
        self:RefreshStudentList()
    end
end

function FriendRecruitView:RefreshTaskList(resetPos)
    self.controller:GetAllTaskCfgDatas()
    local length = self.controller:GetShowDatasLength()

    local loopListView = self.parent.center.taskScrollview.loopListView
    if resetPos then
        loopListView:SetListItemCount(length, true)
    else
        loopListView:SetListItemCount(length)
    end
end

function FriendRecruitView:GetTaskItemByRowColumn(gridView, itemIndex, row, column)
    local logicData = self.controller:GetShowDataByIdx(itemIndex)
    if not logicData then return nil end
    local item = gridView:NewListViewItem('RecruitTaskItem')
    local itemLua = CommonUtil.BindGridViewItem2Lua(self.root, 'RecruitTaskItem', item.gameObject)
    if itemLua then
        CommonUtil.UpdateItemPrefab(self.root, itemLua, logicData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
        self.root.uiBase:AddButtonUniqueEventListener(itemLua.btnGet.button,self,self.OnTaskGetClick, logicData.cfgId)
    end
    return item
end

function FriendRecruitView:OnTaskGetClick(button, params)
    local cfgId = params[0]
    self.controller:SendTaskReward(cfgId)
end

--function FriendRecruitView:RefreshStudentList(resetPos)
--    local showDatas = self.controller:GetAllStudentDatas()
--    local length = #showDatas
--
--    local loopListView = self.parent.center.studentScrollview.loopListView
--    if resetPos then
--        loopListView:RefreshListByIndex(length, 0)
--    else
--        loopListView:RefreshListByIndex(length)
--    end
--end

function FriendRecruitView:OnStudentScrollRefresh()
    --local loopListView = self.parent.center.studentScrollview.loopListView
    --loopListView:RefreshAllShownItem()
    self:RefreshStudentList()
end

function FriendRecruitView:GetStudentItemByRowColumn(gridView, itemIndex, row, column)
    local logicData = self.controller:GetShowDataByIdx(itemIndex)
    if not logicData then return nil end
    local item = gridView:NewListViewItem('StudentItemList')
    local itemLua = CommonUtil.BindGridViewItem2Lua(self.root, 'StudentItemList', item.gameObject)
    if itemLua then
        CommonUtil.UpdateItemPrefab(self.root, itemLua, logicData, nil, self, self.OnClapClick)
        --self.root.uiBase:AddButtonUniqueEventListener(itemLua.btnGet.button,self,self.OnTaskGetClick, logicData.cfgId)
        if itemIndex + 1 == self.controller:GetShowDatasLength() then
            self.controller:QueryNextStudentBriefInfo()
        end
    end
    return item
end

function FriendRecruitView:RefreshMasterInfo(briefInfo)
    local playerHead = CommonUtil.GetPlayerHeadIcon(briefInfo);
    local jobData = ManagerContainer.CfgMgr:GetJobDataById(briefInfo.config_id)
    local _fakerData = {Level = briefInfo.level, ProfessionIcon = jobData.JobIcon, HeadIcon = playerHead, IsHero = true};
    CommonUtil.SetPlayerHeadAndFrame(self.root, self.parent.top.info.headItem, _fakerData,false, briefInfo.head_frame_id);

    self.parent.top.info.nickname.text.text = CommonUtil.GetVaildNickName(briefInfo.nick_name)
    self.parent.top.fighterPower.text.text = briefInfo.fight_power
    self.parent.top.time.text.text = CommonUtil.GetOnlineStatus(briefInfo.online_state, briefInfo.online_time)

    self.root.top.info:SetActive(true)
end

function FriendRecruitView:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.root.uiData.name,UIEventNames.FRIEND_INVITATION_QUERY_MASTER_INFO,self,self.OnQueryMasterRefresh)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.root.uiData.name,UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO,self,self.OnStudentScrollRefresh)
end

function FriendRecruitView:AddUIEventListener()
    self.root.uiBase:AddButtonEventListener(self.root.myRecruitCode.btnCopy.button,self,self.OnCodeCopyClick)
    self.root.uiBase:AddButtonEventListener(self.parent.top.submitBtn.button,self,self.OnQueryMasterClick)
    self.root.uiBase:AddButtonEventListener(self.parent.btnOnekeyClap.button,self,self.OnOneKeyClapClick)
    self.root.uiBase:AddButtonEventListener(self.parent.btnLog.button,self,self.OnLogClick)
end

function FriendRecruitView:OnCodeCopyClick()
    UnityEngine.GUIUtility.systemCopyBuffer = tostring(self.controller:GetRecruitCode())
end

function FriendRecruitView:OnQueryMasterClick()
    local code = self.parent.top.inputField.inputField.text.text
    if code == "" then
        return
    end
    self.controller:SendInvitationNumberUserInfoReq(code)
end

function FriendRecruitView:OnQueryMasterRefresh(briefInfo, studentCount)
    if not self.uIRecruitTipsView then
        if self.loadSystem1 then
            self.loadSystem:RemoveLoadAllAsset()

            self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, UIRecruitTipsPath)
            self.loadSystem:Begin()

            self.masterBriefInfo = briefInfo
            self.studentCount = studentCount
        end
    else
        self.uIRecruitTipsView:Show(briefInfo, studentCount)
    end
end

function FriendRecruitView:PreloadedAssets1()
    local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, UIRecruitTipsPath)
    if go then
        if self.uIRecruitTipsView == nil then
            self.uIRecruitTipsView = UIRecruitTipsView:new()
        end

        self.uIRecruitTipsView:InitGo(self.root,go)
        --self.uIRecruitTipsView:Hide()

        self.uIRecruitTips:Show(self.masterBriefInfo, self.studentCount)

        self.masterBriefInfo = nil
        self.studentCount = nil
    end
end

function FriendRecruitView:OnLogClick()
    if not self.teacherLogUIView then
        if self.loadSystem2 then
            self.loadSystem2:RemoveLoadAllAsset()

            self.loadSystem2:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, TeacherLogUIPath)
            self.loadSystem2:Begin()
        end
    else
        self.teacherLogUIView:Show()
    end
end

function FriendRecruitView:PreloadedAssets2()
    local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, TeacherLogUIPath)
    if go then
        if self.teacherLogUIView == nil then
            self.teacherLogUIView = TeacherLogUIView:new()
        end

        self.teacherLogUIView:InitGo(self.root,go)
        --self.teacherLogUIView:Hide()
        self.teacherLogUIView:Show()
    end
end

function FriendRecruitView:OnClapClick(button, params)
    local uid = params[0]
    self.controller:ClapStudents(uid)
end

function FriendRecruitView:OnOneKeyClapClick(button, params)
    self.controller:ClapStudents()
end

function FriendRecruitView:GetItemByIndex(loopListView, idx, dataIdx)
    local itemData = self.controller:GetShowDataByIdx(dataIdx)
    if not itemData then return nil end
    local item = loopListView:NewListViewItem('StudentListItem')
    local itemLua = CommonUtil.BindGridViewItem2Lua(self.root, 'StudentListItem', item.gameObject)
    if itemLua then

    end
    ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
    return item
end

function FriendRecruitView:OnBeginLoad(isBegin)
    local errorCode = self.controller:QueryNextStudentBriefInfo(isBegin)
    if errorCode ~= 0 then
        self:RefreshStudentList(isBegin)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
    end
end

function FriendRecruitView:RefreshStudentList(isBegin)
    self.controller:GetAllStudentDatas()

    local whole = self.controller:IsStudentListWhole()
    local dataLength = self.controller:GetShowDatasLength()

    self.parent.noStudent:SetActive(whole and dataLength == 0)

    self.loadStatusLoopListCtr:SetHasBegin(true)
    self.loadStatusLoopListCtr:OnAllLoaded()
    self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
    self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function FriendRecruitView:Dispose()
    if self.loadSystem1 then
        self.loadSystem1:Dispose()
        self.loadSystem1 = nil
    end

    if self.loadSystem2 then
        self.loadSystem2:Dispose()
        self.loadSystem2 = nil
    end

    if self.uIRecruitTipsView then
        self.uIRecruitTipsView:Dispose()
        self.uIRecruitTipsView = nil
    end

    if self.teacherLogUIView then
        self.teacherLogUIView:Dispose()
        self.teacherLogUIView = nil
    end

    self.parent.center.taskScrollview.loopListView:Dispose()
    self.parent.center.studentScrollview.loopListView:Dispose()

    if self.loadStatusLoopListCtr then
        self.loadStatusLoopListCtr:Dispose()
        self.loadStatusLoopListCtr = nil
    end

    self.root = nil
    self.parent = nil

    if self.controller then
        self.controller:Dispose()
        self.controller = nil
    end
    pageToggleData = nil
end

return FriendRecruitView
