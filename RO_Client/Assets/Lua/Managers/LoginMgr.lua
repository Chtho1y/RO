local LoginMgr = class('LoginMgr')

local LoginStatus = {
    Error = 0,
    Clear = 1,
    OpenLoading = 2,
    OpenLoaded = 3,
    SdkInit = 4,
    SdkLogin = 5,
    CheckSpecialInfo = 6,
    CheckServer = 7,
    WaitClickEnter = 8,
    UpdateCheck = 9,
    ConnectGate = 10,
    GameLogin = 11,
    EnterGame = 12,
    InternalRelogin = 20
}

function LoginMgr:ctor()
    self:RegisterNetEvents()
end

function LoginMgr:Clear()
    self:Exit()
end

function LoginMgr:Destroy()
    self:Clear()
    self:UnRegisterNetEvents()
end

function LoginMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_LOGIN_ACK, self.OnLoginAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_LOGOUT_NTF, self.OnLogoutNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KICK_OUT_NTF, self.OnKickoutNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RECONNECT_ACK, self.OnReconnectAck, self)
end

function LoginMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_LOGIN_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_LOGOUT_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_KICK_OUT_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_RECONNECT_ACK)
end

function LoginMgr:OnLoginAck(data)
    self.logined = true
    self.isNewPlayer = false
    self.loginErrorCode = data and data.error or nil
    if self.loginStatus == LoginStatus.GameLogin then
        self:StartEnterGame()
    end
end

function LoginMgr:OnLogoutNtf()
    ManagerContainer.LuaBattleMgr:StopSyncServerTimeTimer()
    ManagerContainer.NetManager:ResetNetMgr()
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    local data = {"LoginTips8", nil, nil, self, self.ReLogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:OnKickoutNtf(msgData)
    local noticeKey = 'LoginTips8'
    local noticeContent = nil
    if msgData then
        local remainTime = msgData.ban_end_time
        if remainTime and remainTime > 0 then
            remainTime = type(remainTime) == "number" and remainTime or #remainTime
            noticeContent = {DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, true)}
        end
        if msgData.error == Enum.NetErrorCode.ERROR_RELOGIN then
            noticeKey = 'LoginTips6'
        elseif msgData.error == Enum.NetErrorCode.ERROR_ROLE_BANED then
            if noticeContent then
                noticeKey = 'LoginTips10'
            end
        elseif msgData.error == Enum.NetErrorCode.ERROR_SERVER_KICK_CHEAT then
            if noticeContent then
                noticeKey = 'LoginTips10'
            end
        elseif msgData.error == Enum.NetErrorCode.ERROR_SERVER_MAINAIN then
            noticeKey = 'LoginTips7'
        elseif msgData.error == Enum.NetErrorCode.ERROR_ROLE_BANED_TYPE_PERSONALCHAT then
            noticeKey = 'LoginTips11'
        end
    end
    ManagerContainer.LuaBattleMgr:StopSyncServerTimeTimer()
    ManagerContainer.NetManager:ResetNetMgr()
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    local data = {noticeKey, noticeContent, nil, self, self.ReLogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:OnReconnectAck(msgData)
    if msgData then
        if msgData.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaBattleMgr:SetReconnected(true)
            ManagerContainer.LuaBattleMgr:SendGetServerTimeReq()
            if ManagerContainer.FSMMgr:IsFightingState() then
                local battleMode = LuaBattleBridge.CurrentBattleMode()
                local battleSubMode = LuaBattleBridge.CurrentBattleSubMode()
                if battleMode == BattleMode.Versus or battleMode == BattleMode.Boss or battleMode == BattleMode.Time then
                    local cmdId = nil
                    if battleSubMode == BattleSubMode.Guild then
                        cmdId = ProtoMsgId.CS_GUILD_BOSS_CHALLENGE_REQ
                    elseif battleSubMode == BattleSubMode.ClimbingTower then
                        cmdId = ProtoMsgId.CS_CLIMBING_TOWER_END_REQ
                    elseif battleSubMode == BattleSubMode.Arena then
                        cmdId = ProtoMsgId.CS_ARENA_RESULT_REQ
                    elseif battleSubMode == BattleSubMode.HundredDojo then
                        cmdId = ProtoMsgId.CS_DAO_CHANG100_CHALLENGE_RESULT_REQ
                    end
                    if not cmdId or not ManagerContainer.NetManager:HasCmdIdAtConfirmQueue(cmdId) then
                        ManagerContainer.LuaGameMgr:EnterBattle(false)
                    end
                end
            end
        elseif msgData.error == Enum.NetErrorCode.ERROR_ROLE_INVALID then
            self:ReconnectRefuse(true)
        else
            self:ReconnectRefuse()
        end
    else
        self:ReconnectRefuse()
    end
end

function LoginMgr:ReconnectRefuse(logout)
    ManagerContainer.LuaBattleMgr:StopSyncServerTimeTimer()
    ManagerContainer.NetManager:ResetNetMgr()
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    local data = {logout and "LoginTips12" or 'LoginTips13', nil, logout, self, self.ReLogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:ReconnectFail()
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    local data = {"LoginTips1", nil, nil, self, self.TryReconnect, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:TryReconnect()
    ManagerContainer.NetManager:StartReconnect()
end

----------------------------- 以下是第一次登录或重新登录的流程 -----------------------------

function LoginMgr:Enter(relogin)
    self:Exit()
    self.relogin = relogin
    self.preLoginStatus = nil
    self.loginStatus = LoginStatus.Clear
    self.logined = nil
    self.loginErrorCode = nil
    self.waitClicked = nil
    self.checkServerAgain = nil
    local leBianSDK = Wenting.Lebian.LeBianSDK.instance
    if leBianSDK then
        local clientChId = leBianSDK:GetClientChId()
        if not clientChId then
            clientChId = ''
        end
        ManagerContainer.LuaGameMgr.channelName = clientChId
    end
    self.agreement = nil
    self.showNotify = true
end

function LoginMgr:Exit()
    self.relogin = nil
    self.stayTime = nil
    self.preLoginStatus = nil
    self.loginStatus = nil
    if self.checkWWW then
        self.checkWWW:Dispose()
    end
    self.checkWWW = nil
    self.logined = nil
    self.loginErrorCode = nil
    self.waitClicked = nil
    self.checkServerAgain = nil
    self.serverPorts = nil
    if self.endUpdateCheckCB then
        local leBianSDK = Wenting.Lebian.LeBianSDK.instance
        if leBianSDK then
            leBianSDK.queryUpdateCallback = leBianSDK.queryUpdateCallback - self.endUpdateCheckCB
            self.endUpdateCheckCB = nil
        end
    end
    self.showNotify = nil
end

function LoginMgr:Update()
    if self.loginStatus == LoginStatus.Error then
        return
    end
    if self.loginStatus == LoginStatus.Clear then
        ManagerContainer:Reset()
        self:StartStartLoading()
    elseif ManagerContainer.LuaGameMgr.NetStatus == eNetType.NetType_None then
        self:NetWorkError()
        return
    elseif self.loginStatus == LoginStatus.OpenLoading then
        if ManagerContainer.LuaGameMgr.loadingPageOk then
            LogWarning("LoginStatus.OpenLoading --->")
            self:StartStartLoaded()
        end
    elseif self.loginStatus == LoginStatus.OpenLoaded then
        self.stayTime = self.stayTime - Time.deltaTime
        if self.stayTime <= 0 then
            self:StartSdkInit()
        end
    elseif self.loginStatus == LoginStatus.SdkInit then
        if ManagerContainer.LuaGameMgr.sdkInited == Enum.ParamState.Success then
            self:StartSdkLogin()
        elseif ManagerContainer.LuaGameMgr.sdkInited == Enum.ParamState.Fail then
            self:SdkInitFail()
        else
            self.stayTime = self.stayTime - Time.deltaTime
            if self.stayTime <= 0 then
                self:SdkInitFail()
            end
        end
    elseif self.loginStatus == LoginStatus.SdkLogin then
        if ManagerContainer.LuaGameMgr.sdkLogined == Enum.ParamState.Success then
            self:StartCheckSpecialInfo()
        elseif ManagerContainer.LuaGameMgr.sdkLogined == Enum.ParamState.Fail then
            self:SdkLoginFail()
        else
            if self.stayTime > 0 then
                self.stayTime = self.stayTime - Time.deltaTime
                if self.stayTime < 0 then
                    self.waitClicked = nil
                end
            else
                if self.waitClicked then
                    -- LogWarning("LoginStatus.SdkLogin -----> ");
                    self:InternalRelogin()
                end
            end
        end
    elseif self.loginStatus == LoginStatus.CheckSpecialInfo then
        if self.checkWWW then
            if self.checkWWW.isDone then
                self:CheckSpecialInfoSuccess()
            else
                self.stayTime = self.stayTime - Time.deltaTime
                if self.stayTime <= 0 then
                    self:CheckSpecialInfoFail()
                end
            end
        else
            self:CheckSpecialInfoFail()
        end
    elseif self.loginStatus == LoginStatus.CheckServer then
        if self.checkWWW then
            if self.checkWWW.isDone then
                self:CheckServerSuccess()
            else
                self.stayTime = self.stayTime - Time.deltaTime
                if self.stayTime <= 0 then
                    self:CheckServerFail()
                end
            end
        else
            self:CheckServerFail()
        end
    elseif self.loginStatus == LoginStatus.WaitClickEnter then
        if self.waitClicked then
            -- LogWarning("LoginStatus.SdkLogin -----> ");
            self:EndWaitClickEnter()
        end
    elseif self.loginStatus == LoginStatus.UpdateCheck then
    elseif self.loginStatus == LoginStatus.ConnectGate then
        if ManagerContainer.NetManager.connectGated == Enum.ParamState.Success then
            self:StartLoginGame()
        elseif ManagerContainer.NetManager.connectGated == Enum.ParamState.Fail then
            self:ReConnectGate()
        end
    elseif self.loginStatus == LoginStatus.GameLogin then
        if self.logined then
            self:StartEnterGame()
        else
            self.stayTime = self.stayTime - Time.deltaTime
            if self.stayTime <= 0 then
                self:LoginGameFail()
            end
        end
    elseif self.loginStatus == LoginStatus.InternalRelogin then
        self:StartStartLoading()
    end
end

function LoginMgr:GetTask()
    return nil
end

function LoginMgr:StartStartLoading()
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UILanuch) then
        self:StartStartLoaded()
    else
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.OpenLoading
        ManagerContainer.LuaGameMgr:OpenLoading(Enum.UIPageName.UILanuch)
    end
end

function LoginMgr:StartStartLoaded()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.OpenLoaded
    self.stayTime = 0.5
    if self.relogin then
        ManagerContainer.LuaGameMgr:ReLoginClearData()
    end
    ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UILanuch)
end

function LoginMgr:StartSdkInit()
    if ManagerContainer.LuaGameMgr.sdkInited == Enum.ParamState.Success then
        LogWarning("LoginMgr:StartSdkLogin ");
        self:StartSdkLogin()
    else
        LogWarning("LoginMgr:StartSdkInit ");

        SDKMgr.Instance:SetHttpCheckUrl(PlatformPack.URL_KEY)
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.SdkInit
        self.stayTime = 5
        ManagerContainer.LuaGameMgr.sdkInited = Enum.ParamState.None
        ManagerContainer.LuaGameMgr:SdkInit()
    end
end

function LoginMgr:SdkInitFail()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
    local data = {"LoginTips2", nil, nil, self, self.InternalRelogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:StartSdkLogin()
    if ManagerContainer.LuaGameMgr.sdkLogined == Enum.ParamState.Success then
        self:StartCheckSpecialInfo()
    else
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.SdkLogin
        self.stayTime = 5
        ManagerContainer.LuaGameMgr.sdkLogined = Enum.ParamState.None
        ManagerContainer.LuaGameMgr:SdkLogin()
    end
end

function LoginMgr:SdkLoginFail()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
    local data = {"LoginTips3", nil, nil, self, self.InternalRelogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:StartCheckSpecialInfo()
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.CheckSpecialInfo
    self.stayTime = 5

    -- if self.checkWWW then
    --     self.checkWWW:Dispose()
    -- end
    -- local url = PlatformPack.SPECIAL_INFO_URL .. '?timesamp=' .. tostring(os.time())
    -- local platform = ManagerContainer.LuaGameMgr.platform
    -- if platform and platform ~= '' then
    --     url = url .. '&platform=' .. tostring(platform)
    -- end
    -- local subplatform = ManagerContainer.LuaGameMgr.channelName
    -- if subplatform and subplatform ~= '' then
    --     url = url .. '&sub_platform=' .. tostring(subplatform)
    -- end
    -- LogWarning("LoginMgr:StartCheckSpecialInfo " .. url);

    -- self.checkWWW = UnityEngine.WWW(url)

    self:CheckSpecialInfoSuccess()
end

function LoginMgr:CheckSpecialInfoSuccess()
    if not self.checkWWW then
        self:CheckSpecialInfoFail()
        return
    end
    if self.checkWWW.error and self.checkWWW.error ~= '' then
        self:CheckSpecialInfoFail()
        return
    end
    local ok, result = RO_XPCALL(JSON.decode, debug.traceback, JSON, self.checkWWW.text)
    if ok then
        self.agreement = result.agreement
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SPECIAL_INFO_CHANGED)
        self:StartCheckServer()
    else
        LogError("[wboy] CheckSpecialInfoFail " .. tostring(self.checkWWW.text))
        self:CheckSpecialInfoFail()
    end
end

function LoginMgr:CheckSpecialInfoFail()
    if self.checkWWW then
        self.checkWWW:Dispose()
    end
    self.checkWWW = nil
    self:StartCheckServer()
end

function LoginMgr:StartCheckServer(isAgain)
    self.checkServerAgain = isAgain
    local openId = ManagerContainer.LuaGameMgr.openId
    if not openId or openId == '' then
        openId = UnityEngine.PlayerPrefs.GetString("LoginName")
    end
    if not openId or openId == '' then
        openId = ManagerContainer.LuaGameMgr.DeviceId
    end
    ManagerContainer.LuaGameMgr.openId = openId

    if Constant.SERVER_FORCE_INFO then
        self:SetServerInfo(Constant.SERVER_FORCE_INFO)
        -- if isAgain then
        self:StartConnectGate()
        -- else
        --     self:StartWaitClickEnter()
        -- end
        return
    end
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    self.stayTime = 5
    local serverId = ManagerContainer.LuaGameMgr.serverData.id
    local url = PlatformPack.SERVERLIST_URL
    if serverId and serverId > 0 then
        url = url .. "?type=21&id=" .. tostring(serverId)
    else
        url = url .. "?"
    end
    url = ManagerContainer.LuaGameMgr:ComposeCommonServerInfo(url)

    if self.checkWWW then
        self.checkWWW:Dispose()
    end

    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.CheckServer

    LogWarning("StartCheckServer url " .. url)

    self.checkWWW = UnityEngine.WWW(url)
end

function LoginMgr:CheckServerFail()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
    if self.checkWWW then
        self.checkWWW:Dispose()
    end
    self.checkWWW = nil
    self.checkServerAgain = nil
    ManagerContainer.LuaUIMgr:CloseNetWaiting()
    local data = {"LoginTips4", nil, nil, self, self.InternalRelogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
    ManagerContainer.LuaGameMgr:ClearServerData()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SERVER_CHANGED)
end

function LoginMgr:CheckServerSuccess()
    if not self.checkWWW then
        self:CheckServerFail()
        return
    end
    if self.checkWWW.error and self.checkWWW.error ~= '' then
        self:CheckServerFail()
        return
    end
    local ok, result = RO_XPCALL(JSON.decode, debug.traceback, JSON, self.checkWWW.text)
    if ok then
        LogWarning("CheckServerSuccess " .. Inspect(result))
        if result.IsNewPlayer ~= nil and result.IsNewPlayer == 1 then
            self.isNewPlayer = true
            ManagerContainer.LuaGameMgr.IsNewPlayer = 1
            -- 1LoadingBegin	第一个loading的开始	统计每日新增玩家进入到第一个loading页面（带人物带logo）	新增玩家/老玩家
            LogWarning("Loading finish -----------------")
        end

        local datas = System.Collections.Generic.Dictionary_object_object()
        datas:Add('eventName', 'LoadingFinish1')
        datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
        SDKMgr.Instance:ReportAction(datas)

        self:SetServerInfo(result)
        self.checkWWW:Dispose()
        self.checkWWW = nil
        if self.checkServerAgain then
            self.checkServerAgain = nil
            self:StartConnectGate()
        else
            self:StartWaitClickEnter()
        end
    else
        LogError("[wboy] CheckServerFail " .. tostring(self.checkWWW.text))
        self:CheckServerFail()
    end
end

function LoginMgr:SetServerInfo(server)
    ManagerContainer.LuaGameMgr:InitServerData(server.ServerId, server.ServerName, server.Ip, server.Port, server.State)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SERVER_CHANGED)
end

function LoginMgr:StartWaitClickEnter()
    ManagerContainer.LuaUIMgr:CloseNetWaiting()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.WaitClickEnter
    self.waitClicked = nil
    local serverData = ManagerContainer.LuaGameMgr.serverData

    if self.isNewPlayer == true then
        self:EndWaitClickEnter()
    end

    -- self:EndWaitClickEnter()

    -- if serverData and serverData.id and serverData.id > 0 and self.showNotify then
    --     ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINotifyTips)
    --     self.showNotify = false
    -- end
end

function LoginMgr:EndWaitClickEnter()
    if ManagerContainer.LuaGameMgr.sdkLogined == Enum.ParamState.Success then
        if self:IsAgreement() then
            local isOn = ManagerContainer.PlayerPrefsMgr:GetGlobalBoolean(Constant.AGREEMENT_RECORD_KEY, false)
            if not isOn then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GameLogin19')
                self.preLoginStatus = self.loginStatus
                self.loginStatus = LoginStatus.WaitClickEnter
                self.waitClicked = nil
                return
            end
        end
        self:StartUpdateCheck()
    else
        self:InternalRelogin()
    end
end

function LoginMgr:StartUpdateCheck()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.UpdateCheck
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    local leBianSDK = Wenting.Lebian.LeBianSDK.instance
    if leBianSDK then
        if not self.endUpdateCheckCB then
            self.endUpdateCheckCB = System.Action_Wenting_Lebian_QueryUpdateErrorCode(self.EndUpdateCheck, self)
        end
        leBianSDK.queryUpdateCallback = leBianSDK.queryUpdateCallback + self.endUpdateCheckCB
        leBianSDK:QueryUpdate()
    else
        self:EndUpdateCheck(Wenting.Lebian.QueryUpdateErrorCode.Error)
    end
end

function LoginMgr:EndUpdateCheck(resultCode)
    local leBianSDK = Wenting.Lebian.LeBianSDK.instance
    if leBianSDK then
        if self.endUpdateCheckCB then
            leBianSDK.queryUpdateCallback = leBianSDK.queryUpdateCallback - self.endUpdateCheckCB
            self.endUpdateCheckCB = nil
        end
        local QueryUpdateErrorCode = Wenting.Lebian.QueryUpdateErrorCode
        if resultCode == QueryUpdateErrorCode.NoUpdate then
            self:StartCheckServer(true)
            return
        elseif resultCode == QueryUpdateErrorCode.Update then
            self:StartCheckServer(true)
            return
        elseif resultCode == QueryUpdateErrorCode.ForceUpdate then
            -- 停止后续流程
            self.preLoginStatus = self.loginStatus
            self.loginStatus = LoginStatus.Error
            return
        end
    end
    -- self:ResetClickState()
    self:ErrorNoticeDisplay('GameLogin20')
    self:StartCheckServer(true)
end

--- --连接gate网关服务器
function LoginMgr:StartConnectGate()
    local serverData = ManagerContainer.LuaGameMgr.serverData
    if serverData.state == Enum.ServerState.Maintain then
        self:StartMaintain()
        return
    elseif serverData.state == Enum.ServerState.Full then
        self:ConnectGateFail()
        return
    end
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.ConnectGate
    ManagerContainer.NetManager.connectGated = Enum.ParamState.None
    self.logined = nil
    self.loginErrorCode = nil
    local serverPorts = serverData.ports
    local len = serverPorts and #serverPorts or 0
    if len <= 0 then
        self:ConnectGateFail()
    elseif len <= 1 then
        serverData.portidx = 1
        ManagerContainer.NetManager:ConnectGate(serverData.ip, serverPorts[1])
    else
        math.randomseed(os.time())
        local serverPortIdx = math.random(len)
        serverData.portidx = serverPortIdx
        self.serverPorts = clone(serverData.ports)
        ManagerContainer.NetManager:ConnectGate(serverData.ip, serverPorts[serverPortIdx])
    end
end

function LoginMgr:ReConnectGate()
    ManagerContainer.NetManager.connectGated = Enum.ParamState.None
    self.logined = nil
    self.loginErrorCode = nil
    local serverData = ManagerContainer.LuaGameMgr.serverData
    if serverData.state == Enum.ServerState.Maintain then
        self:StartMaintain()
        return
    elseif serverData.state == Enum.ServerState.Full then
        self:ConnectGateFail()
        return
    end
    local len = self.serverPorts and #self.serverPorts or 0
    if len <= 0 then
        self:ConnectGateFail()
    else
        local serverPortIdx = serverData.portidx
        if serverPortIdx then
            table.remove(self.serverPorts, serverPortIdx)
        end
        len = #self.serverPorts
        if len <= 0 then
            self:ConnectGateFail()
        else
            serverPortIdx = math.random(len)
            serverData.portidx = serverPortIdx
            ManagerContainer.NetManager:ConnectGate(serverData.ip, self.serverPorts[serverPortIdx])
        end
    end
end

function LoginMgr:ConnectGateFail()
    self:ResetClickState()
    self:ErrorNoticeDisplay('GameLogin21')
end

function LoginMgr:StartMaintain()
    self:ResetClickState()
    self:ErrorNoticeDisplay('GameLogin11')
end

function LoginMgr:StartLoginGame()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.GameLogin
    self.stayTime = 10
end

function LoginMgr:LoginGameFail(error, ...)
    self:ResetClickState()
    if not error then
        error = 'GameLogin14'
    end
    self:ErrorNoticeDisplay(error, ...)
end

function LoginMgr:StartEnterGame()
    local loginErrorCode = self.loginErrorCode
    if loginErrorCode == Enum.NetErrorCode.ERROR_OK then
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.EnterGame
        ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UILanuch)
        LogWarning("LoginSuccess start loading scene");
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Begin)
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_ROLE_NOT_FOUND then
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.EnterGame
        ManagerContainer.LuaGameMgr:EnterCreateRole(false)
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_ROLE_NOT_FOUND_NEED_ACTIVE_CODE then
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.EnterGame
        ManagerContainer.LuaGameMgr:EnterCreateRole(true)
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_SDK_ACCOUNT_INVALID then
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.Error
        ManagerContainer.NetManager:ResetNetMgr()
        ManagerContainer.LuaUIMgr:CloseNetWaiting()
        local data = {"LoginTips9", nil, true, self, self.ReLogin, self.QuitGame}
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
            Enum.UISibling[Enum.UIType.Top + 1] + 10)
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_GAME_VERSION then
        self.preLoginStatus = self.loginStatus
        self.loginStatus = LoginStatus.Error
        ManagerContainer.NetManager:ResetNetMgr()
        ManagerContainer.LuaUIMgr:CloseNetWaiting()
        local data = {"LoginTips5", nil, nil, self, self.InternalRelogin, self.QuitGame}
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
            Enum.UISibling[Enum.UIType.Top + 1] + 10)
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_ROLE_BANED then
        self:GameBanedError()
    elseif loginErrorCode == Enum.NetErrorCode.ERROR_ROLE_BANED_TYPE_PERSONALCHAT then
        self:GameBanedError()
    else
        local langStr = string.formatbykey(loginErrorCode)
        if not langStr or langStr == '' then
            self:LoginGameFail(loginErrorCode)
        else
            self:ResetClickState()
        end
    end
end

function LoginMgr:GameBanedError()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
end

function LoginMgr:ResetClickState()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
    ManagerContainer.NetManager:ResetNetMgr()
    ManagerContainer.LuaUIMgr:CloseNetWaiting()
    self:StartWaitClickEnter()
end

function LoginMgr:IsLoginWaiting()
    return (not self.loginStatus or self.loginStatus == LoginStatus.WaitClickEnter)
end

function LoginMgr:NetWorkError()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.Error
    ManagerContainer.NetManager:ResetNetMgr()
    ManagerContainer.LuaUIMgr:CloseNetWaiting()
    local data = {"LoginTips1", nil, nil, self, self.InternalRelogin, self.QuitGame}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil,
        Enum.UISibling[Enum.UIType.Top + 1] + 10)
end

function LoginMgr:ErrorNoticeDisplay(error, ...)
    if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {
            errorId = error,
            params = {...}
        }, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {
            errorId = error,
            params = {...}
        })
    end
end

function LoginMgr:InternalRelogin()
    self.preLoginStatus = self.loginStatus
    self.loginStatus = LoginStatus.InternalRelogin
    ManagerContainer.LuaUIMgr:ShowNetWaiting()
    ManagerContainer.LuaGameMgr:ClearServerData()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SERVER_CHANGED)
end

function LoginMgr:ReLogin(logout)
    if logout and ManagerContainer.LuaGameMgr.sdkLogined == Enum.ParamState.Success then
        ManagerContainer.LuaGameMgr:SdkLogout()
    else
        ManagerContainer.LuaGameMgr:ClearServerData()
        ManagerContainer.LuaGameMgr:ReLogin()
    end
end

function LoginMgr:QuitGame()
    ManagerContainer.LuaGameMgr:QuitGame(true)
    return true
end

function LoginMgr:IsAgreement()
    return self.agreement and self.agreement ~= '' or false
end

function LoginMgr:GetAgreement()
    return self.agreement
end

return LoginMgr
