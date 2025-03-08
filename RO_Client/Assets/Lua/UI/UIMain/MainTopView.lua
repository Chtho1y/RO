local MainTopView = class("MainTopView")
local ScrollNoticeView = require("UIMain/ScrollNoticeView")

local showAni = "TopShow"
local closeAni = "TopClose"

local scrollNoticeView

local updateHandle

local curLimitedTime
local interLimitedTime = 10

local curRankTime
function MainTopView:ctor()
    self.root = nil
    self.state = true
    self.animator = nil
    self.mCanvas = nil
    self.lastSortingOrder = 0
    self.defaultSortingOrder = 0
end

function MainTopView:Init(root, canvas, animator, sortingOrder)
    self.root = root
    self.mCanvas = canvas
    self.animator = animator
    self.defaultSortingOrder = sortingOrder
    self.lastSortingOrder = self.defaultSortingOrder

    if not scrollNoticeView then
        scrollNoticeView = ScrollNoticeView.new()
        scrollNoticeView:Init(self.root.noticeBg)
    end

    self:StartUpdate()

    self:InitBtnState()
end

function MainTopView:InitBtnState()
    self.root.topRoot.btnActivityTower:SetActive(false)
    self.root.topRoot.btnActivityDojo:SetActive(false)
    self.root.topRoot.btnActivityMap:SetActive(false)
    self.root.topRoot.btnActivityPet:SetActive(false)
    --开发阶段 打开主页面上的战令系统
    self.root.topRoot.btnAirshipRewards:SetActive(false)

    self.root.topRoot.btnActivitySkill:SetActive(false)
    self:ChangeRefreshCombineServerBtn()
end

function MainTopView:StartUpdate()
    if not updateHandle then
        updateHandle = UpdateBeat:CreateListener(self.Update, self)
    end

    UpdateBeat:AddListener(updateHandle)

    curLimitedTime = 0
    curRankTime = 0
end

function MainTopView:EndUpdate()
    if updateHandle ~= nil then
        UpdateBeat:RemoveListener(updateHandle)
        updateHandle = nil
    end
end

function MainTopView:Change(state, order)
    if self.mCanvas == nil then return end

    if state then
        if ManagerContainer.LuaUIMgr:NeedMainHideTop() then
            return
        end
    end
    if state then
        self.lastSortingOrder = self.mCanvas.sortingOrder
        self.mCanvas.sortingOrder = math.max(1000, (order or 1000) + 1)
        self:RefreshTopBtns(true)
    else
        self.mCanvas.sortingOrder = self.lastSortingOrder

        self:RefreshTopBtns(false)
    end

    if self.state ~= state then
        self.state = state
        self.animator:Play(state and showAni or closeAni, 0, 0)
        self:ChangeRefreshCombineServerBtn()
    end
end

function MainTopView:Resume()
    if self.mCanvas == nil then return end

    self.mCanvas.sortingOrder = self.defaultSortingOrder

    self.state = false
    self.animator:Play(closeAni)
end

function MainTopView:Update()
    if self.limitState and self.root and curLimitedTime then
        curLimitedTime = curLimitedTime + Time.deltaTime
        if curLimitedTime >= interLimitedTime then
            curLimitedTime = 0
            self:RefreshLimitEndTime()
        end
    end
end

function MainTopView:RefreshTopBtns(state)
    self.root.topRoot.topBtns:SetActive(state)
    if state then
        local _unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(34);
        if _unlockState then
            self.root.topRoot.btnTask.gameObject:SetActive(state);
        end
        if Constant.OpenPay then
            local limitRechargeData = ManagerContainer.DataMgr.ActsDataMgr:GetLimitRechargeItem()
            if limitRechargeData then
                local isExist = limitRechargeData:IsLimitRechargeExist()
                self.root.topRoot.btnLimitedGift:SetActive(isExist)

                self.limitState = true
            else
                self.root.topRoot.btnLimitedGift:SetActive(false)
                self.limitState = false
            end
        else
            self.root.topRoot.btnLimitedGift:SetActive(false)
            self.limitState = false
        end

        _unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(59);
        if _unlockState then
            local rewardState = ManagerContainer.DataMgr.UserData:GetQuestionRewardState()
            self.root.topRoot.btnQuestionnaire:SetActive(not rewardState)
        else
            self.root.topRoot.btnQuestionnaire:SetActive(false)
        end
    else
        self.root.topRoot.btnLimitedGift:SetActive(false)
        self.limitState = false
    end
end

function MainTopView:OpenLimitRecharge()
    --local _unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(34);
    --if not _unlockState then
    --    self.root.topRoot.btnTask.gameObject:SetActive(false);
    --    self.limitState = false
    --    return
    --end
    if not Constant.OpenPay then
        self.root.topRoot.btnLimitedGift:SetActive(false)
        self.limitState = false
        return
    end
    local limitRechargeData = ManagerContainer.DataMgr.ActsDataMgr:GetLimitRechargeItem()
    if not limitRechargeData then
        self.limitState = false
        self.root.topRoot.btnLimitedGift:SetActive(false)
        return
    end
    local isExist = limitRechargeData:IsLimitRechargeExist()
    self.root.topRoot.btnLimitedGift:SetActive(isExist)
    if not isExist then
        self.limitState = false
        return
    else
        self.limitState = true
    end
end

function MainTopView:RefreshLimitEndTime()
    local limitRechargeData = ManagerContainer.DataMgr.ActsDataMgr:GetLimitRechargeItem()
    if not limitRechargeData then return end

    local isExist = limitRechargeData:IsLimitRechargeExist()
    if not isExist then
        self.limitState = false
        self.root.topRoot.btnLimitedGift:SetActive(false)
        return
    end
end

function MainTopView:RefreshAirShipActivityEnter(state)
    if state then
        local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(54)
        if not unlockState then
            state = false
        end
    end
    if not Constant.OpenPay then
		state = false
	end
    --LogError('222'..tostring(state))
    self.root.topRoot.btnAirshipRewards:SetActive(state)
    if not state then
        return
    end
    self:RefreshAirShipActivityEndTime()
end

function MainTopView:RefreshAirShipActivityEndTime()
    local  endTime  = ManagerContainer.DataMgr.RuneShopDataMgr:GetCurAirShipActivityEndTime()
    if not endTime then
        return
    end
    local text
        text = self.root.topRoot.btnAirshipRewards.textTime
       -- text.text.text = ManagerContainer.LuaTimerMgr:ParseEndTimeStamp2TimeWithUInt64(endTime)
        local remains = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)
        --LogError("时间"..remains)
        if remains > 0 then
            if remains <= 60 then
                text.text.text = I18N.T("LessOneMinu")
            else
                local time = DateTimeUtil.convertSeconds2TimeStr1(remains, true, false)
                text.text.text = time
            end
        end
end

function MainTopView:RefreshRankActivityEnter(type, state)
    if type == Enum.RankActivitiesType.ClimbingTower then
        if state then
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(60)
            if not unlockState then
                state = false
            end
        end
        self.root.topRoot.btnActivityTower:SetActive(state)
    elseif type == Enum.RankActivitiesType.Dojo then
        if state then
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(61)
            if not unlockState then
                state = false
            end
        end
        self.root.topRoot.btnActivityDojo:SetActive(state)
    elseif type == Enum.RankActivitiesType.MapProgress then
        if state then
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(64)
            if not unlockState then
                state = false
            end
        end
        self.root.topRoot.btnActivityMap:SetActive(state)
    elseif type == Enum.RankActivitiesType.Pet then
        if state then
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(71)
            if not unlockState then
                state = false
            end
        end
        self.root.topRoot.btnActivityPet:SetActive(state)
    elseif type == Enum.RankActivitiesType.Skill then
        if state then
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(71)
            if not unlockState then
                state = false
            end
        end
        self.root.topRoot.btnActivitySkill:SetActive(state)
    end

    self:RefreshRankActivityEndTime()
end

function MainTopView:RefreshRankActivityEndTime()
    for k,v in pairs(Enum.RankActivitiesType) do
        local type = v
        local stage, endTime, inRush = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(type)
        if inRush then
            local text
            if type == Enum.RankActivitiesType.ClimbingTower then
                text = self.root.topRoot.btnActivityTower.textTime
            elseif type == Enum.RankActivitiesType.Dojo then
                text = self.root.topRoot.btnActivityDojo.textTime
            elseif type == Enum.RankActivitiesType.MapProgress then
                text = self.root.topRoot.btnActivityMap.textTime
            elseif type == Enum.RankActivitiesType.Pet then
                text = self.root.topRoot.btnActivityPet.textTime
            elseif type == Enum.RankActivitiesType.Skill then
                text = self.root.topRoot.btnActivitySkill.textTime
            end

            local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)
            if stage == 1 then
                if remainS <= 0 then
                    ManagerContainer.DataMgr.RankActivitiesMgr:QueryRankActivitiesData()
                elseif remainS <= 60 then
                    text.text.text = I18N.T("LessOneMinu")
                else
                    local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
                    text.text.text = time
                end
            elseif stage == 2 then
                text.text.text = I18N.T("RushBtnEnd")
            end
        end
    end
end

function MainTopView:InsertGMNotice(notice)
    if scrollNoticeView then
        scrollNoticeView:InsertGMNotice(notice)
    end
end

function MainTopView:ChangeRefreshCombineServerBtn()
    local nextTime = ManagerContainer.DataMgr.CombineServerDataMgr:GetNextTime()
    self.root.topRoot.btnCombineService:SetActive(nextTime and nextTime > 0)
    if not self.state then
        if self.combineServerTimer and self.combineServerTimer.running then
            self.combineServerTimer:Stop()
        end
    else
        self:RefreshCombineServerBtn()
    end
end

function MainTopView:DisposeRefreshCombineServerBtn()
    if self.combineServerTimer then
        if self.combineServerTimer.running then
            self.combineServerTimer:Stop()
        end
        self.combineServerTimer = nil
    end
end

function MainTopView:RefreshCombineServerBtn()
    local nextTime = ManagerContainer.DataMgr.CombineServerDataMgr:GetNextTime()
    if not nextTime or nextTime <= 0 then
        self:DisposeRefreshCombineServerBtn()
        self.root.topRoot.btnCombineService.textTime.text.text = string.formatbykey('CombinedServiceTips', 1)
        return
    end
    local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(nextTime)
    if remainS < 86400 then
        self:DisposeRefreshCombineServerBtn()
        self.root.topRoot.btnCombineService.textTime.text.text = string.formatbykey('CombinedServiceTips', 1)
        return
    end
    if not self.combineServerTimer then
        self.combineServerTimer = Timer.New(slot(self.RefreshCombineServerBtn, self), 86400, -1, true)
    end
    self.combineServerTimer.time = remainS % 86400 + 1
    if not self.combineServerTimer.running then
        self.combineServerTimer:Start()
    end
    self.root.topRoot.btnCombineService.textTime.text.text = string.formatbykey('CombinedServiceTips', Mathf.Ceil(remainS / 86400))
end





function MainTopView:Dispose()
    self:EndUpdate()
    self:DisposeRefreshCombineServerBtn()

    scrollNoticeView:Dispose()
    scrollNoticeView = nil

    self.animator = nil
    self.mCanvas = nil

    self.trans = nil
end

return MainTopView