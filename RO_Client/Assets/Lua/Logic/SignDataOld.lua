local SignData = class("SignData", require("DataBase"))

local _toOpenUISign = 0;    --0：哪个都不开启，1是开启UISign，2是开启UISign2，3是刷新签到界面
local _backPanelId = 0;     --要返回得界面得id，签到界面可以返回主城和冒险两个界面
local _circle = 30;	--签到周期，一个周期30天
local _getDataCb;   --收到签到数据返回之后的回调

function SignData:ctor()
    self.data = {}
end


function SignData:RegisterNetEvents()
    --签到数据请求
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SIGN_UP_INFO_ACK, self.SCSignUpInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SIGN_UP_ACK, self.ScSignUpAck, self)
end

function SignData:Clear()

end

function SignData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function SignData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SIGN_UP_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SIGN_UP_ACK)
end

-------------------custom code start------------------
function SignData:ScSignUpAck(_data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AFTER_SIGN_UP_ACK, _data);
end

--判断是否播放过签到动画
function SignData:PlayedAnimation()

end
--向服务器请求签到的消息,传进来的参数 0：哪个都不开启，1是开启UISign，2是开启UISign2,3是刷新签到界面
function SignData:CSSignUpReq(_openPanelIndex, _backlId, _cb)
    local _isUnLock = self:GetIsUnLocked();
    if not _isUnLock then return; end

    _toOpenUISign = _openPanelIndex or 0;
    _backPanelId = _backlId or Enum.UIPageName.UIMainCity1;
    _getDataCb = _cb;
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SIGN_UP_INFO_REQ);
end

--收到了请求的服务器的签到数据
function SignData:SCSignUpInfoAck(_data)
    local _isUnLock = self:GetIsUnLocked();
    if not _isUnLock then return; end

    if _data.error ~= Enum.NetErrorCode.ERROR_OK then
        LogError("获取签到信息错误，错误码：", _data.error);
        return;
    end

    self:SendData(_data);
end

--分发签到数据
function SignData:SendData(_data)
    if _toOpenUISign == 0 then      --哪个界面都不想打开，就是显示一下红点
        local _canSign = self:JudgeCanSign(_data.sign_info.cur_sign_info.last_sign or 0);
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SignIn, _canSign);
    else
        --显示及一下红点
        local _canSign = self:JudgeCanSign(_data.sign_info.cur_sign_info.last_sign or 0);
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SignIn, _canSign);
        --整理数据
        self:TidyData(_data);
        if _toOpenUISign == 1 then  --打开签到界面
            self:OpenSign(_backPanelId);
        elseif _toOpenUISign == 2 and _canSign then  --打开签到的动画界面，动画播放完之后才会开启签到界面,这波操作只有当可签到的时候才会走到
            if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
                ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIBattle);
                ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISign2);
            end
            --记录播放时间到玩家本地数据
            --local _timeSecond = ManagerContainer.LuaTimerMgr:GetTimeSecond();
            --UnityEngine.PlayerPrefs.SetInt("SignInAnimationState", _timeSecond)
        elseif _toOpenUISign == 3 then  --刷新签到页面
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_SIGN_UP_ACK);
        end
    end
end

--开启签到界面
function SignData:OpenSign(_id)
    local _backId = Enum.UIPageName.UIMainCity1;
    if _id ~= 0 then _backId = _id end
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISignIn, nil, _backPanelId)
    if _getDataCb then
        _getDataCb();
        _getDataCb = nil;
    end
end

--判断是否可播放签到前的动画
function SignData:JudgeCanPlay()
    local _state = UnityEngine.PlayerPrefs.GetInt("SignInAnimationState") or 0;   --这个存放的是上次签到的时间的转换成秒的数值
    local _canSign = self:JudgeCanSign(_state);
    return _canSign;
end

--整理签到数据
function SignData:TidyData(_data)
    self._data = {};
    --记录数据
    self._data._curSignDay = _data.cur_sign_day or 1;	--累计签到的下一天
    self._data._curDay = _data.sign_info.cur_day or 0;	--当前签到的累计天数
    self._data._lastSign = 0;	--上次签到的时间
    if _data.sign_info.cur_sign_info then
        self._data._lastSign = _data.sign_info.cur_sign_info.last_sign;
    end
    --根据记录的数据进行整理
    self._data._cfgData = {};
    self._data._canSign = self:JudgeCanSign(self._data._lastSign);
    local _startDay, _endDay;
    local _fmod = math.fmod(self._data._curDay, _circle);
    if _fmod == 0 then
        if self._data._canSign then
            local _modf = math.modf(self._data._curSignDay / _circle);
            _startDay = _modf * _circle + 1;
            _endDay = (_modf + 1) * _circle;
        else
            local _modf = math.modf(self._data._curDay / _circle) - 1;
            _startDay = _modf * _circle + 1;
            _endDay = (_modf + 1) * _circle;
        end
    else
        local _modf = math.modf(self._data._curDay / _circle);
        _startDay = _modf * _circle + 1;
        _endDay = (_modf + 1) * _circle;
    end

    for _i = _startDay, _endDay do
        local _cfgData = ManagerContainer.CfgMgr:GetSignInCfg(_i);
        table.insert(self._data._cfgData, _cfgData);
    end
end

--获取已经整理好的数据
function SignData:GetData()
    return self._data;
end
--获取签到界面关闭的时候要返回的界面的id
function SignData:GetBackPanelId()
    return _backPanelId;
end

--判断是否能签到
function SignData:JudgeCanSign(_lastSign)
    local _canSign = false;	--当前是否能够签到
    local _fiveOClickSecond = self:GetCurDayInFiveOClock();
    local _lastFiveOClickSecond = _fiveOClickSecond - Constant.OneDaySeconds
    local _curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond();
    if _lastSign < _lastFiveOClickSecond then   --上次签到在昨天五点之前
        _canSign = true;
    else    --上次签到在昨天五点之后
        if _lastSign >= _fiveOClickSecond then  --上次签到在今天五点之后，你就别签到了，已经签到过了
            _canSign = false;
        else
            if _curTime > _fiveOClickSecond then    --当前时间在今天五点之后
                _canSign = true;
            end
        end
    end
    return _canSign;
end

--获取当天五点的时间戳，以秒为单位
function SignData:GetCurDayInFiveOClock()
    local _second = CommonUtil.GetTodayTimeStamp(5);
    return _second;
end

--获取当前签到功能是否解锁
function SignData:GetIsUnLocked()
    local _isUnLock = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(30);
    return _isUnLock;
end

--获取周期
function SignData:GetCircle()
    return _circle;
end

--TODO:临时代码，以后删除，所有跟_keepDialogue相关的都要删除
function SignData:KeepDialogue()
    self._keepDialogue = true;
end

function SignData:GetKeepDialogue()
    return self._keepDialogue;
end

-------------------custom code end--------------------

return SignData