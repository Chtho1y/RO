local TaskItemRefreshCtr = {}

function TaskItemRefreshCtr:SetData(wnd, itemLua, logicData, onClickOwner, onClickCB)
    local _state = logicData.state == Enum.TaskState.GotAndHas; --true是已经领取，false是还未领取
    local _itemData = logicData.itemData;
    local _getState = logicData._getState;
    local _buttonName = logicData.buttonName;
    local _jumpType = logicData.jumpType;
    local _canJump = _jumpType > 0;
    local _fakeIcon = logicData.fakeIcon

    CommonUtil.SetTotalChildrenGray(itemLua.item.gameObject, _state);
    itemLua.scrollbar.gameObject:SetActive(not _state);
    itemLua.overText.gameObject:SetActive(_state);
    itemLua.ratio.gameObject:SetActive(not _state);

    itemLua.item.num.text.text = tostring(_itemData._cfgData.Active);
    itemLua.taskName.text.text = _itemData._cfgData.TargetTaskDescribe;

    itemLua.btnGoto.gameObject:SetActive(_getState == Enum.TaskState.NotGot and _canJump);
    itemLua.btnGet.gameObject:SetActive(_getState == Enum.TaskState.Got);
    itemLua.seal.gameObject:SetActive(_getState == Enum.TaskState.GotAndHas);
    itemLua.btnNotFinish.gameObject:SetActive(_getState == Enum.TaskState.NotGot and not _canJump);

    if _getState == Enum.TaskState.NotGot then
        itemLua.btnGoto.text.text = _buttonName;
    end

    if _state == false then
        local _progress = _itemData._progressNum;
        itemLua.scrollbar.scrollbar.size = _progress;
        local _value, _total = _itemData:GetProgressData()
        itemLua.ratio.text.text =  _value .. "/" .. _total;

        local _button;
        if _getState == Enum.TaskState.NotGot then
            _button = itemLua.btnGoto.button;
        elseif _getState == Enum.TaskState.Got then
            _button = itemLua.btnGet.button;
        end

        _button.interactable = true;

        if _getState == Enum.TaskState.NotGot and not _canJump then
            onClickOwner.uiBase:AddButtonUniqueEventListener(itemLua.btnNotFinish.button, onClickOwner, function ()
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("MissionUnFinish"));
            end, nil)
            CommonUtil.SetTotalChildrenGray(itemLua.btnNotFinish.gameObject, true);
        else
            if onClickOwner and onClickCB then
                local _newFun = nil;
                if _getState == Enum.TaskState.Got then
                    _newFun = function()
                        local _tweenTime = GlobalConfig.Instance:GetConfigFloatValue(174);
                        ManagerContainer.DataMgr.TaskDataNew._refreshImmediately = false;
                        self._delayShowEnemy = ManagerContainer.LuaTimerMgr:AddTimer(_tweenTime * 1000, 1, wnd, function()
                            ManagerContainer.DataMgr.TaskDataNew._refreshImmediately = true;
                            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_TASK_CHANGE);
                            _fakeIcon.gameObject:SetActive(false);
                        end, nil);
                        _fakeIcon.transform.position = itemLua.item.transform.position;
                        _fakeIcon.gameObject:SetActive(true);
                        LuaBattleBridge.BeginTweenPosition(_fakeIcon.gameObject, _tweenTime, wnd.refreshTaskParent.totalScore.item.transform.position, true)
                    end
                end
                _button.interactable = true;
                onClickOwner.uiBase:AddButtonUniqueEventListener(_button, onClickOwner, onClickCB, logicData, _newFun)
            else
                _button.onClick:RemoveAllListeners();
                _button.interactable = false;
            end
        end
    end

end

return TaskItemRefreshCtr