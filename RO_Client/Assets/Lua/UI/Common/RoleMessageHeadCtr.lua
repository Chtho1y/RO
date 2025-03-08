local RoleMessageHeadCtr = {}
local IconItemCtr = require("Common/IconItemCtr")
local iconItemName = "IconItem";

function RoleMessageHeadCtr:SetData(_wnd, _item, _data, onClickOwner, onClickCB)
    local _logicData = _data._iconItemData;
    _item.headItem.frame.gameObject:SetActive(self._isLeader);
    _item.headItem.headFrame.gameObject:SetActive(not self._isLeader);

    local _isHero = _logicData.strengthLevel == Constant.MainPlayerStrengthLevel
    local _fakerData = {Level = _logicData.num, ProfessionIcon = _data._jobICon, HeadIcon = _data._headIcon, StrengthLevel = _logicData.strengthLevel, IsHero = _isHero };
    CommonUtil.SetPlayerHeadAndFrame(_wnd, _item.headItem, _fakerData,false, _logicData.headFrameId, onClickOwner, onClickCB, _data.sortIndex);
    --local _lua = CommonUtil.BindGridViewItem2Lua(self, iconItemName, _item.iconItem.gameObject);
    --IconItemCtr:SetData(_wnd, _lua, _logicData, Enum.ItemIEnterType.Partner, onClickOwner, onClickCB);
    --[[
        if _data._iconItemData.isLeader then
            CommonUtil.LoadIcon(_wnd, _data._iconItemData.leaderIcon, function (sprite)
                _item.headItem.head.image.sprite = sprite
            end)
        end]]--

    --主角默认选中
    _item.checkMark.gameObject:SetActive(false);
    --修改数量显示，IconItemCtr显示的数量前边没有LV.
    --_lua.num.text.text = "Lv."..tostring(_logicData.num);
    --设置是否上阵，和主角标签的显示
    _item.leaderTag.gameObject:SetActive(_data._isLeader);
    _item.battleTag.gameObject:SetActive(_data._isBattle);
    --[[
    _item.job.gameObject:SetActive(_data._isLeader);
    if _data._isLeader then
        local iconAsyncIdx = CommonUtil.GetAsyncIdx(_wnd, _item, 'IconJob')
        CommonUtil.LoadIcon(_data._leaderJobIcon, function (sprite)
            _item.job.image.sprite = sprite
        end, _wnd.uiData.id, iconAsyncIdx)
    end]]--

end

return RoleMessageHeadCtr