local NotifyItemCtr = {}
local _indexAndCloseFun = {};
local _limitCount;

function NotifyItemCtr:SetData(_wnd, _item, _data, _openCb, _closeCb)
    if not _limitCount then
        _limitCount = GlobalConfig.Instance:GetConfigIntValue(143)
    end

    self:SetBtnState(_data._showing, _item.btnRight, _item.btnDown, _item.content, _item.textNotifyTitle.text, _data.NoticeTitle);
    _wnd.uiBase:AddButtonUniqueEventListener(_item.textNotifyTitle.button, _wnd, function()
        if _data._showing then
            _closeCb(_wnd,_data)
            _data._showing = false
            self:SetBtnState(false, _item.btnRight, _item.btnDown, _item.content, _item.textNotifyTitle.text, _data.NoticeTitle);
        else
            local _lastItem,_title = _openCb(_wnd,_item,_data)
            if _lastItem ~= nil then
                self:SetBtnState(false, _lastItem.btnRight, _lastItem.btnDown, _lastItem.content, _lastItem.textNotifyTitle.text, _title);
            end
            _data._showing = true;
            self:SetBtnState(true, _item.btnRight, _item.btnDown, _item.content, _item.textNotifyTitle.text, _data.NoticeTitle);
        end
    end);
    _item.textMain.text.text = _data.NoticeTxt;
    if _data.LimitedTimeLabel then
        _item.textDate.text.text = string.sub(_data.NoticeBeginTime, 1, 10);
    else
        _item.textDate.text.text = ''
    end
end

--设置按钮状态
function NotifyItemCtr:SetBtnState(_open, _btnRight, _btnDown, _content, _text, _titleStr)
    _btnRight.gameObject:SetActive(not _open);
    _btnDown.gameObject:SetActive(_open);
    _content.gameObject:SetActive(_open);
    _text.text = self:JudgeTitle(_open, _titleStr);
end

--判断title的显示
function NotifyItemCtr:JudgeTitle(_open, _titleStr)
    if _open then
        return _titleStr;
    else
        local _count = StringUtil.GetStringByteLength(_titleStr);
        if _count >= _limitCount then
            return StringUtil.CutOutString(_titleStr, _limitCount) .. "...";  --策划要求显示16个中文字，一个中文字相当于非中文两个字
        else
            return _titleStr;
        end
    end
end

return NotifyItemCtr