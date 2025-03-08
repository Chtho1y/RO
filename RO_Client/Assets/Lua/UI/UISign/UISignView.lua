local UISignView = require("UISign/UISignView_Generate")

local _planeWait = "Planewait";
local _planeMove = "Planemove";
local _planeMoveTime = 0.5;
local _circle

local _signInFun	--签到的函数

function UISignView:OnAwake(data)
	self.controller = require("UISign/UISignCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISignView:AddEventListener()
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SIGN_UP_ACK, self.ShowReward, self)
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.REFRESH_SIGN_UP_ACK, self, self.RefreshSignUpAck)

end

function UISignView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	--self.super:FillContent(self)
end

function UISignView:Init()
	self:GetUITargets();
	self:SetUI();
end

function UISignView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISignView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick);
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.Replay);
	self.uiBase:AddButtonEventListener(self.chestReward.btnClose.button, self, self.OnBtnCloseClick);
end

function UISignView:OnHide()
end

function UISignView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UISignView:OnClose()

end

function UISignView:OnDispose()

end
---------------custom code start---------------------
--刷新页面
function UISignView:RefreshSignUpAck()
	self:SetUI();
end

--获取游戏中需要用到的对象
function UISignView:GetUITargets()
	self._signButton = {};
	for _i = 1, 30 do
		self._signButton[_i] = self["point_" .. tostring(_i)];
	end
end
--填充UI
function UISignView:SetUI()
	_signInFun = nil;
	_circle = ManagerContainer.DataMgr.SignData:GetCircle();
	self.chestReward.gameObject:SetActive(false);
	--设置按钮
	local _data = ManagerContainer.DataMgr.SignData:GetData();
	local _logicCurDay = math.fmod(_data._curDay, ManagerContainer.DataMgr.SignData:GetCircle());
	if _logicCurDay == 0 then
		if not _data._canSign and _data._curDay ~= 0 then
			_logicCurDay = _circle;
		end
	end
	local _signIndex = 1;
	for _i = 1, #_data._cfgData do
		local _signState = 2;	--默认是已签到
		if _i >= _logicCurDay + 1 then _signState = 0; end	--大于以签到天数就是未签到
		if _i == _logicCurDay + 1 then	--设置的是已经签到的后一天，而且可以再次签到了
			if _data._canSign then _signState = 1; end
			_signIndex = _i;
		end
		self:SetSignInButton(_i, _signState, _data._cfgData[_i], _signIndex);
	end
	local _fmod = math.fmod(_data._curDay, _circle);
	--设置可签到标记的位置
	self.halo.gameObject:SetActive(_data._canSign);
	if _data._canSign then
		if _fmod == 0 then
			local _realDay = _logicCurDay;
			if _logicCurDay == 0 then _realDay =1; end
			self.halo.transform.localPosition = self._signButton[_realDay].gameObject.transform.localPosition;
		else
			self.halo.transform.localPosition = self._signButton[_logicCurDay + 1].gameObject.transform.localPosition;
		end
	end

	--设置飞艇的位置和状态
	local _startPos = self.point_0.gameObject.transform.position;
	if _fmod == 0 then
		if _logicCurDay == _circle then
			_startPos = self._signButton[_logicCurDay].gameObject.transform.position;
		end
	else
		_startPos = self._signButton[_logicCurDay].gameObject.transform.position;
	end
	self.plane.transform.localRotation = Quaternion.identity;

	if _logicCurDay ~= 0 then
		local _cfgData = _data._cfgData[_logicCurDay];
		if _cfgData and _cfgData.balloon == 0 then
			self.plane.transform.localRotation = Quaternion.Euler(0, 180, 0);
		end
	end
	self.plane.animator:Play(_planeWait);
	self.plane.transform.position = _startPos;

	self.clickMask:SetActive(false);
	if _signInFun then
		self.clickMask:SetActive(true);
		_signInFun();
	end
end
--设置单个签到对象,传入参数为：要设置的按钮的index,该按钮的状态。_signState，0是未签到，1是可签到但是未签到，2是已签到
function UISignView:SetSignInButton(_buttonIdx, _signState, _cfgData, _signIndex)
	local _buttonTarget = self._signButton[_buttonIdx];
	_buttonTarget.text.text = I18N.SetLanguageValue("SignInTips1", tostring(_buttonIdx));	-- 第{0}天

	local _icon;
	if _signState == 2 then
		_icon = _cfgData.OpenBoxImg;
	else
		local _fmod = math.fmod(_buttonIdx, 5);
		if _fmod == 0 then	--这是宝箱签到
			if _signState == 1 then
				_icon = _cfgData.GetBoxImg;
			else
				_icon = _cfgData.BoxImg;
			end
		else
			_icon = _cfgData.BoxImg;
		end
	end

	CommonUtil.LoadIcon(self, _icon, function (sprite)
		self:GetPointImage(_buttonIdx).sprite = sprite
	end)

	if _signState == 1 then
		_signInFun = function()
			self.btnBack.button.interactable = false;
			self.plane.animator:Play(_planeMove);	--播放飞机飞起
			self.plane.transform:DOMove(self._signButton[_buttonIdx].transform.position, _planeMoveTime):OnComplete(function ()
				ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SIGN_UP_REQ);	--请求签到
				self.halo.gameObject:SetActive(false);
				self.btnBack.button.interactable = true;
				self:SetSignInButton(_buttonIdx, 2, _cfgData, _signIndex + 1);	--玩家点击之后就将按钮设置成以签到，不让他连续点击
				self.clickMask:SetActive(false);
			end)
		end
	end

	local _button = self:GetPointButton(_buttonIdx);
	if _button then
		_button.onClick:RemoveAllListeners();
		self.uiBase:AddButtonEventListener(_button, function (button, params)
			self:ShowRewardByClick(_cfgData);
		end)
	end
end

--获取button
function UISignView:GetPointButton(_buttonIndex)
	local _target = self._signButton[_buttonIndex];
	local _fmod = math.fmod(_buttonIndex, 5);
	if _fmod == 0 then	--这是宝箱签到
		if _buttonIndex == 30 then	--终极宝箱
			return _target.button;
		else
			return _target.icon.button;
		end
	end
	return nil;
end

--获取image
function UISignView:GetPointImage(_buttonIndex)
	local _target = self._signButton[_buttonIndex];
	local _fmod = math.fmod(_buttonIndex, 5);
	if _fmod == 0 then	--这是宝箱签到
		if _buttonIndex == 30 then	--终极宝箱
			return _target.image;
		else
			return _target.icon.image;
		end
	else	--这是普通签到
		return _target.image;
	end
end

--打开展示获得奖励的界面
function UISignView:ShowReward(_data)
	if _data.error ~= Enum.NetErrorCode.ERROR_OK then
		LogError("签到后返回错误，错误码：" .. tostring(_data.error));
		return;
	end
	local _rewards = {};
	if _data.day_list and #_data.day_list then	--记录日签到的奖励
		for _i = 1, #_data.day_list do
			table.insert(_rewards, {
				cfgId = _data.day_list[_i].key;
				num = _data.day_list[_i].value;
			})
		end
	end
	if _data.accu_list and #_data.accu_list then	--累计签到
		for _i = 1, #_data.accu_list do
			table.insert(_rewards, {
				cfgId = _data.accu_list[_i].key;
				num = _data.accu_list[_i].value;
				cornerType = Enum.FromType.Extra;
			})
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {rewards = _rewards})
	self.plane.animator:Play(_planeWait);	--播放飞机待机
	--签到完了，关闭红点
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SignIn, false);
end

--获取奖励
function UISignView:ShowRewardByClick(_cfgData)
	self.chestReward.gameObject:SetActive(true);
	local _rewards = {};
	if _cfgData.SignInReward and #_cfgData.SignInReward then
		for _i = 1, #_cfgData.SignInReward do
			table.insert(_rewards, {
				cfgId = _cfgData.SignInReward[_i][1];
				num = _cfgData.SignInReward[_i][2];
			})
		end
	end
	if _cfgData.SignInAddReward and #_cfgData.SignInAddReward then
		for _i = 1, #_cfgData.SignInAddReward do
			table.insert(_rewards, {
				cfgId = _cfgData.SignInAddReward[_i][1];
				num = _cfgData.SignInAddReward[_i][2];
				cornerType = Enum.FromType.Extra;
			})
		end
	end

	local length = #_rewards
	for i = 1, 10 do
		local _target = self.chestReward["iconItem"..i];

		for i = _target.transform.childCount - 1, 0, -1 do
			local _child = _target.transform:GetChild(i)
			CommonUtil.DestroyGOImmediate(_child.gameObject);
		end

		local status = i <= length
		_target:SetActive(status)
		if status then
			local data = _rewards[i]
			local cfgId = data.cfgId
			local item = _target.gameObject
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
			ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
				CommonUtil.BatchCreateItems(self, itemlua, item.transform, data, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
			end)
		end
	end
end

function UISignView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UISignView:OnCloseClick()
	self:UIHide();
	local _backPanelId = ManagerContainer.DataMgr.SignData:GetBackPanelId();
	ManagerContainer.LuaUIMgr:Open(_backPanelId)
end

--TODO：等待删除的功能
function UISignView:Replay()
	ManagerContainer.LuaUIMgr:ShowMessageBox("NetworkTips",nil,nil,self,
			function()
				ManagerContainer.DataMgr.SignData:KeepDialogue();
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISign2, true);
			end ,
			function()
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISign2);
			end)
end

function UISignView:OnBtnCloseClick()
	self.chestReward.gameObject:SetActive(false);
end

---------------custom code end-----------------------
return UISignView

