local TaskItemMainCtr = {}
local IconItemCtr = require("Common/IconItemCtr")
local _rewardItemCountMax = 5;

function TaskItemMainCtr:SetData(wnd, itemLua, logicData, onClickOwner, onClickCB)
    local _itemData = logicData.itemData;
    local _buttonName = logicData.buttonName;
    local _getState = logicData._getState;
    local _jumpType = logicData.jumpType;
    local _canJump = _jumpType > 0;

    itemLua.btnGoto.gameObject:SetActive(_getState == Enum.TaskState.NotGot and _canJump);
    itemLua.btnGet.gameObject:SetActive(_getState == Enum.TaskState.Got);
    itemLua.bgActive:SetActive(_getState == Enum.TaskState.Got);
    itemLua.btnNotFinish:SetActive(_getState == Enum.TaskState.NotGot and (not _canJump))

    itemLua.taskName.text.text = _itemData._cfgData.TargetTaskDescribe;
    itemLua.scrollbar.scrollbar.size = _itemData._progressNum;

    local _value, _total = _itemData:GetProgressData();
    itemLua.ratio.text.text = _value .. "/" .. _total;

    if _getState == Enum.TaskState.NotGot then
        itemLua.btnGoto.text.text = _buttonName;
    end

    local _button;
    if _getState == Enum.TaskState.NotGot then
        _button = itemLua.btnGoto.button;
        if _jumpType > 0 then
            _button = itemLua.btnGoto.button;
        else
            _button = itemLua.btnGet.button;
        end
    elseif _getState == Enum.TaskState.Got then
        _button = itemLua.btnGet.button;
    end

    if _getState == Enum.TaskState.NotGot and (not _canJump) then
        onClickOwner.uiBase:AddButtonUniqueEventListener(itemLua.btnNotFinish.button, onClickOwner, function ()
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("MissionUnFinish"));
        end, nil)
        CommonUtil.SetTotalChildrenGray(itemLua.btnNotFinish.gameObject, true);
    else
        if onClickOwner and onClickCB then
            _button.interactable = true
            onClickOwner.uiBase:AddButtonUniqueEventListener(_button, onClickOwner, onClickCB, logicData)
        else
            _button.onClick:RemoveAllListeners();
            _button.interactable = false
        end
    end

    local _rewardList = _itemData._cfgData.Reward;
    for _i = 1, _rewardItemCountMax, 1 do
        local _item = itemLua["item" .. tostring(_i)];
        if _i <= #_rewardList then
            _item.gameObject:SetActive(true);
            local _data = _rewardList[_i];
            local _logicData = {
                cfgId = _data[1];
                num = _data[2];
            }
            IconItemCtr:SetData(wnd, _item, _logicData, Enum.ItemIEnterType.Bag, wnd, wnd.ShowItemTips)
        else
            _item.gameObject:SetActive(false);
        end
    end
end

return TaskItemMainCtr