local NotifyData = class("NotifyData", require("DataBase"))

function NotifyData:ctor()
    self._notices = nil;
end


function NotifyData:RegisterNetEvents()
end

function NotifyData:Clear()
    self._notices = nil;
end

function NotifyData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function NotifyData:UnRegisterNetEvents()
end

function NotifyData:GetNoticeList()
    if self._notices == nil then
        self._notices = {}
        local _noticeCfgAll = ManagerContainer.CfgMgr:GetNoticeCfgAll();
        for _, _v in pairs(_noticeCfgAll) do
            table.insert(self._notices, _v);
        end
    end

    --剔除不能显示的
    self:JudgeOutTimeNotice();

    --排序
    self:SortData();

    --设置notice的开启和关闭的状态
    for _i = 1, #self._notices do
        self._notices[_i]._showing = _i == 1;   --默认第一个开启
    end
    return self._notices;
end

--数据排序
function NotifyData:SortData()
    if self._notices and #self._notices then
        table.sort(self._notices, function (_a, _b)
            return (_a.NoticOrder < _b.NoticOrder) or (_a.NoticOrder == _b.NoticOrder and _a._newAdd and (not _b._newAdd));
        end)
    end
end

--剔除不能显示得公告
function NotifyData:JudgeOutTimeNotice()
    for _i = #self._notices, 1, -1 do
        local _data = self._notices[_i];
        local _beginTime = DateTimeUtil.DateTime2UtcTimeStamp(DateTimeUtil.convertTime(_data.NoticeBeginTime));
        local _endTime = DateTimeUtil.DateTime2UtcTimeStamp(DateTimeUtil.convertTime(_data.NoticeEndTime));
        local _timeNow = DateTimeUtil.GetCurrentUtcTimeStamp();
        if _timeNow >= _endTime or _timeNow <= _beginTime then
            table.remove(self._notices, _i);
        end
    end
end

return NotifyData