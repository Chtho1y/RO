local UIJumpMgr = class("UIJumpMgr")

-- 类型       uiId        ui中对象

local jumpTasks = {}
local curTask

local jumpingStatus = false
local timeId

function UIJumpMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterUIEvent("UIJumpMgr", UIEventNames.UI_FILLCONTENT_COMPELETED, function ()
        self:NextJump();
    end)
end

function UIJumpMgr:NextJump()
    if not self._curId then
        return;
    end
    self._curId = self._curId + 1;
    if not self._panelsData or not self._panelsData[self._curId] then
        self._panelsData = nil;
        self._curId = nil;
        return;
    end
    local _panelData = self._panelsData[self._curId];
    local _curPageData = ManagerContainer.CfgMgr:GetUIData(_panelData._panelId);
    local _backPageId = nil;
    if _curPageData.type == Enum.UIType.TotalWin then
        _backPageId = _panelData._backPageId;
    end

    if _panelData._panelId == Enum.UIPageName.UISeason then
        ManagerContainer.DataMgr.CompetitionData:QueryCurCompetitionReq()
    else
        local paramData = _panelData._param
        if _panelData._panelId == Enum.UIPageName.UIActivityChipRewardCom then
            local actData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(_panelData._param)
            if not actData then
                return
            end
            paramData = {pageBg = actData.pageBg, actId = actData.actId}
        end
        if _panelData._panelId == Enum.UIPageName.UIRoleMain1 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role, 1)
        elseif _panelData._panelId == Enum.UIPageName.UIShopNew then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Battle)
        elseif _panelData._panelId == Enum.UIPageName.UIMainCity1 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Town)
        elseif _panelData._panelId == Enum.UIPageName.UIBag then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Pub)
        elseif _panelData._panelId == Enum.UIPageName.UIBattle then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Adventure)
        elseif _panelData._panelId == Enum.UIPageName.UISkillSettings then
            ManagerContainer.LuaUIMgr:Open(_panelData._panelId, {paramData}, _backPageId);
        else
            ManagerContainer.LuaUIMgr:Open(_panelData._panelId, paramData, _backPageId);
        end
    end
end

function UIJumpMgr:StartContinueUIJump()
    timeId = nil
    self:StartJump(curTask)
end

function UIJumpMgr:CreateJumpTaskById(id)
    --[[
    local data = ManagerContainer.CfgMgr:GetUIJumpData(id)
    self:CreateJumpTask(data)]]--
end

function UIJumpMgr:Destroy()
    ManagerContainer.LuaEventMgr:Unregister("UIJumpMgr")

    curTask = nil
    jumpTasks = nil
    jumpingStatus = false
    self._panelsData = nil
    self._curId = nil

    if timeId ~= nil then
        ManagerContainer.LuaTimerMgr:ResumeTimer(timeId)
    end

    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

--_panelsData = {{_panelId = ***, _param = {}, _backPageId = **}};打开的界面的id，打开界面需要传的参数，打开的界面关闭的时候要返回的界面的id
function UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_CLOSE_TASK_PAGE);

    self._panelsData = _panelsData;
    self._curId = 0;
    local _isOpened = ManagerContainer.LuaUIMgr:GetPage(_mainPanelId)
    if _isOpened and _isOpened.IsShowed then
        self:NextJump();
        return true;
    end

    if _mainPanelId == Enum.UIPageName.UIRoleMain1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role, 1)
    elseif _mainPanelId == Enum.UIPageName.UIPetRoot then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Battle)
    elseif _mainPanelId == Enum.UIPageName.UIMainCity1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Town)
    elseif _mainPanelId == Enum.UIPageName.UIBag then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Pub)
    elseif _mainPanelId == Enum.UIPageName.UIBattle then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Adventure)
    end
end

return UIJumpMgr