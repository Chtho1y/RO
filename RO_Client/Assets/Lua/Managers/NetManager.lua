local NetManager = class("NetManager", function ()
	return NetworkMgr.Instance	
end)

local connectGateSuccess = false; --连接gate是否成功，如果成功就不需要重新断开再此重连。除非强制断开重连

local registerPbCallback = {}
local waitingCo = nil

function NetManager:ctor()
	self.connectGated = Enum.ParamState.None
	self.isConnectingGate = false
    self.ReceiveMessageFunc = self.ReceiveMessage
    self.OpenReconnectionWndFunc = self.OpenReconnectionWnd
	self.LuaNoitceFunc = self.LuaNoitce
	self:SetGameServerConnectedLuaFunc(self.OnConnectGateCallback)
end

function NetManager:OnInit()
	Log("LuaNetwork...OnInit...OK!!!");
end

--向服务器发送消息...
function NetManager:SendMessage(id, data)
    -- LogError("Send msgId : " .. id);

	local connectStatus = self:GetConnectStatus()
	if not connectStatus then
		LogError("net is disconnected ")
		ManagerContainer.LuaUIMgr:ShowNetWaiting()
		return
	end

	if self.IsLogin == false and (id ~= ProtoMsgId.CS_LOGIN_REQ and id ~= ProtoMsgId.CS_RECONNECT_REQ) then
		LogError("未登录状态,不能发送消息: " .. id)
		return
	end

	local msgBody_ = ManagerContainer.PbManager:EncodePb(id, data)
	if id == ProtoMsgId.CS_LOGIN_REQ  or  id == ProtoMsgId.CS_RECONNECT_REQ then
		self:SendMsgWithAES(msgBody_, id,false,self:IsConfirmMsg(id))
	else
		self:SendMsgWithAES(msgBody_, id,false,self:IsConfirmMsg(id))
	end

    -- self:SendMsg(msgBody_, id,false,self:IsConfirmMsg(id))
end

function NetManager:IsConfirmMsg(id)
	for k,v in pairs(ProtoConfirmMsgId) do
		if v == id then
			return true
		end
	end
	return false
end

--接收服务器发送过来的消息...
function NetManager:ReceiveMessage(msgBody_, msgId_)
	--LogError("!!!!!!!!!!!!!!!!!Receive msgId : " .. msgId_ );
	--是否关闭屏蔽框..
	--CloseNetSendMaskWnd(msgId_);
	local data = ManagerContainer.PbManager:DecodePb(msgId_, msgBody_)
	if msgId_ == ProtoMsgId.SC_HAND_SHAKE_NTF then
		self:SendConnectReq(data.crypt_pass)
		return
	end

	if msgId_ == ProtoMsgId.SC_LOGIN_ACK or msgId_ == ProtoMsgId.SC_RECONNECT_ACK then
		LogWarning("Login Finish -------------- >")
		self.IsLogin = true   --登录成功状态
		self:CloseWaitingCo()
		ManagerContainer.LuaUIMgr:CloseNetWaiting()
	end

	if data ~=nil and data.error ~= nil and data.error ~= Enum.NetErrorCode.ERROR_OK then
		if data.error ~= Enum.NetErrorCode.ERROR_ROLE_NOT_FOUND and data.error ~= Enum.NetErrorCode.ERROR_ROLE_NOT_FOUND_NEED_ACTIVE_CODE then
			local message = I18N.T(data.error)
			if tonumber(message) ~= data.error then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(data.error)
			end
		end
	end

	if registerPbCallback[msgId_] ~= nil then
		if registerPbCallback[msgId_].obj~= nil then
			registerPbCallback[msgId_].callback(registerPbCallback[msgId_].obj,data)
		else
			registerPbCallback[msgId_].callback(data)
		end 
    end
end

function NetManager:IsErrorData(data)
	if data == nil then
		return true
	end
	if data ~=nil and data.error ~= nil and data.error ~= Enum.NetErrorCode.ERROR_OK then
		return true
	end
	return false
end

function NetManager:NetRegister(id, func, obj)
    registerPbCallback[id] = {}
    registerPbCallback[id].callback = func
	registerPbCallback[id].obj = obj
end

function NetManager:UnRegisterPbIdCallback(msgId)
	if registerPbCallback[msgId] ~= nil then
		registerPbCallback[msgId] = nil;
	else
		if(msgId) then
			LogWarning("UnRegister NTF Protocol Callback Fail :" .. msgId);

		else
			LogWarning("UnRegister NTF Protocol Callback Fail : msgId is nil");

		end

	end
end

function NetManager:UnRegisterPbNameCallback(id)
	if registerPbCallback[id] ~= nil then
		registerPbCallback[id] = nil;
	else
		if(id) then
			LogWarning("UnRegister NTF Protocol Callback Fail :" .. id);

		else
			LogWarning("UnRegister NTF Protocol Callback Fail : name is nil");

		end

	end
end

--释放掉所以的注册协议函数
function NetManager:UnRegisterMsgReqAll()
	for _,v in pairs(registerPbCallback) do
		v = nil
	end
end

--连接gate网关服务器
function NetManager:ConnectGate(address_, port_)
	self.isConnectingGate = true
	self:ConnectServer(address_, port_)
end

function NetManager:GetProtoVersion()
	return ManagerContainer.PbManager:GetEnumValue('GameVersion', 'GameVersion_Main')
end

function NetManager:SendConnectReq(crypt_pass)
	self:SetAesKey(crypt_pass)
	if self.isConnectingGate then
		ManagerContainer.LuaGameMgr:LoadCommonUIAssets()
		local openid = ManagerContainer.LuaGameMgr.openId
		local token = ManagerContainer.LuaGameMgr.token
		local pf = ManagerContainer.LuaGameMgr.platform
		local gameVer = self:GetProtoVersion()
		local serverData = ManagerContainer.LuaGameMgr.serverData
		local serverId = serverData and serverData.id or nil
		local subplatform = ManagerContainer.LuaGameMgr.channelName

		local loginData = {open_id = openid, platform_token = token, platform = pf, sub_platform = subplatform, game_version = gameVer, select_zone = serverId}
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_LOGIN_REQ, loginData)
		self.isConnectingGate = false;
	else
		local openid = ManagerContainer.LuaGameMgr.openId
		local uid = tostring(ManagerContainer.DataMgr.UserData:GetUserId())
		local token = ManagerContainer.LuaGameMgr.token
		local pf = ManagerContainer.LuaGameMgr.platform
		-- 发送重连消息
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RECONNECT_REQ, {open_id = openid, platform_token = token, platform = pf, uid = uid})
	end
end

function NetManager:OnConnectGateCallback(result, reconnect)
	self.connectGated = (result and Enum.ParamState.Success or Enum.ParamState.Fail)
	if result then
		connectGateSuccess = true;
	else
		if reconnect then
			self:CloseWaitingCo()
			local cb = function()
				waitingCo = nil
				ManagerContainer.LoginMgr:ReconnectFail()
			end
			waitingCo = RegisterDelayStep(cb)
		else
			if not waitingCo then
				local cb = function()
					waitingCo = nil
					ManagerContainer.LuaUIMgr:ShowNetWaiting()
				end
				waitingCo = RegisterDelayStep(cb)
			end
		end
	end
end

function NetManager:CloseWaitingCo()
	if waitingCo then
		coroutine.stop(waitingCo)
		waitingCo = nil
	end
end

--是否连接gate服务器成功
function NetManager:IsConnectGateSuccess()
	return connectGateSuccess;
end

-- 重连后回到界面
function OnReConnected()
end

-- LuaNetHandler过来的通知lua的事件广播
function NetManager:LuaNoitce(type_, value_)
	-- LuaEventMgr:DispatchEvent(type_, value_);
end

--打开重连窗口
function NetManager:OpenReconnectionWnd(value_)
end

function NetManager:ResetNetMgr()
	-- LogError("ResetNetMgr")
	connectGateSuccess = false;
	self.connectGated = Enum.ParamState.None
	self:CloseGameServerConnect()
	self:CloseWaitingCo()
end

function NetManager:DisconnectSrv()
	self:Disconnect()
end

function NetManager:Destroy()
	--LogError("Destroy")
    self.ReceiveMessageFunc = nil
    self.OpenReconnectionWndFunc = nil
    self.LuaNoitceFunc = nil

    self:UnRegisterMsgReqAll()
    registerPbCallback = nil

	connectGateSuccess = false;
	self.connectGated = nil
    self:CloseGameServerConnect()
	self:CloseWaitingCo()
	

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end

return NetManager

