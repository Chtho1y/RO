local SignData = class("SignData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")

function SignData:ctor()
    self.data = {}
end

function SignData:InitData(data)
    self.data.signInfo = ProtocalDataNormal.ParseSignInfo(data)
    --LogHRWarning(Inspect(self.data.signInfo))
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SignIn, self:CanTodaySign());
end

function SignData:QuerySignUpInfoReq(needOpenUI)
    if needOpenUI then
        local isUnLock = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(55);
        if not isUnLock then return end
    end

    self.needOpenUI = needOpenUI
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SIGN_UP_INFO_REQ, {})
end

function SignData:SendSignUpReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SIGN_UP_REQ, {})
end

function SignData:RegisterNetEvents()
    --签到数据请求
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SIGN_UP_INFO_ACK, self.SCSignUpInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SIGN_UP_ACK, self.ScSignUpAck, self)
end

function SignData:SCSignUpInfoAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        self:InitData(data)

        if self.needOpenUI then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISign2)
            self.needOpenUI = nil
        end
    end
end

function SignData:ScSignUpAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        self:InitData(data)
        --LogHRWarning(Inspect(data))
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SIGN_UP_SUCCESS)

        local signCfgData = ManagerContainer.CfgMgr:GetSignInCfg(self.data.signInfo.curSignDay)
        if not signCfgData then
            return
        end

        local rewardList = {}
        for _,v in pairs(data.day_list) do
            rewardList[#rewardList + 1] = {key = v.key, value = v.value, vip = 0}
        end
        for _,v in pairs(data.double_list) do
            rewardList[#rewardList + 1] = {key = v.key, value = v.value, vip = signCfgData.VipLevel}
        end

        CommonUtil.ACKSpecialShowRewardList(rewardList)
    end
end

function SignData:GetSignInfoData()
    return self.data.signInfo
end

function SignData:GetCanSignDay()
    return self.data.signInfo.curSignDay
end

function SignData:GetCurSignedDay()
    return self.data.signInfo.signUp.curDay
end

function SignData:CanTodaySign()
    if not self.data.signInfo then
        return false
    end

    if not self.data.signInfo.nextSignTime then
        return false
    end
    local time = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    return time > self.data.signInfo.nextSignTime
end

function SignData:Clear()
    self.data = {}
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

return SignData