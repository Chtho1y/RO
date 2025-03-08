--[[
该页面分三大块：玩家页面/角色页面/宠物页面
]]--
local UIRoleMessageView = require("UIRoleMessage/UIRoleMessageView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")
local PetViewSystem = require("PetViewSystem")

local RoleMessageHeadCtr = require("Common/RoleMessageHeadCtr")
local EquipmentShowSlotItemCtr = require("Common/EquipmentShowSlotItemCtr")
local NickNameCtr = require("Common/NickNameCtr")
local IconItemCtr = require ("Common.IconItemCtr")

local curIndex, lastIndex
local curModel;
local roleViewSystems = nil;
local previewSystem = nil;
local petViewSystem = nil

local isLeader = false;
local partnerId;
local petId;
local _roleHeadName = "RoleMessageHeadOriginal";
local _equipmentSlotName = "EquipmentShowSlotItem";
local _skillSlotName = "SkillSlotOriginal";
local _equipSlotNames = {};

local _data = nil;	--获取到的整理好的数据

local pageToggleData = {}
local attrSortList
local attrsShowState = false
local ActiveTitleList = {}
local isShowTitleScroll = false

function UIRoleMessageView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIRoleMessageCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRoleMessageView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.AFTER_REFRESH_NAME, self, self.SetPlayerName);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_CHANGED, self, self.OnChangeHeadEvent)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_DATA_TIDY, self, self.OnHeadDataEvent)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_SELECTION_NTF, self, self.AfterRefreshDanScore)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_OPEN_NTF, self, self.AfterRefreshSeason)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Used_New_HeadFrame, self, self.ChangeHeadFrame)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_REFRESH, self, self.RefreshTotalFightPower)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TITLE_WEARER_DISBOARD_NOTICE, self, self.ChangeTitle)
end

function UIRoleMessageView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleMessageView:Init()
	self:InitRoleSystems()
	self:Refresh()
	isShowTitleScroll = false
	self.titleScroll:SetActive(isShowTitleScroll)
	self.titleScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetTitleItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIRoleMessageView:InitRoleSystems()
	if not petViewSystem then
		petViewSystem = PetViewSystem:new()
	end

	if not roleViewSystems then
		roleViewSystems = {}
	end
	for i = 1, 6 do
		local roleViewSystem = RoleViewSystem:new()
		roleViewSystems[i] = roleViewSystem
	end
end

function UIRoleMessageView:Refresh()
	pageToggleData.toggleDefaultIndex = 1
	curIndex = 1

	attrSortList = {}
	for k,v in pairs(Enum.HeroAttrType) do
		attrSortList[#attrSortList + 1] = v
	end
	table.sort(attrSortList, function (a,b)
		return a < b
	end)
	self:ChangeTitle() --刷新称号
	self:CreateValues();
	self:CreateTargetTables();

	-- self.userButton:SetActive(SDKMgr.Instance:CheckHasModul(SDKModulType.USERMANAGER))
	self.userButton:SetActive(false)

	--开启界面默认选中玩家页面
	self.playerMessage.toggle.isOn = true;
	self:OnPageToggleClick(self.playerMessage.toggle, 1, true);
	--开启界面的时候就控制按钮的显示状态
	local _isSelf = self.controller:GetData()._targetTag == 0;
	self:SetChangeNameButton(_isSelf)
	self:SetBottomButtons(_isSelf);
	self.titleBtn:SetActive(_isSelf)

	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_PAGE_REDPOINT_NTF, self, self.OnPageRedpointNtf)
	if _isSelf then
		--ManagerContainer.DataMgr.CompetitionData:SetRefreshSeasonState(true);
		--请求赛季信息，赛季信息是在打开赛季界面的时候才会请求，如果玩家在打开赛季之前打开了自己信息界面，必须要先请求一下赛季消息
		--ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_REQ, {competition_id = 0})
		ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIRoleMessage)
	else
		self:SetRPState(false)
	end
end

function UIRoleMessageView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_PAGE_REDPOINT_NTF, self, self.OnPageRedpointNtf)

end

function UIRoleMessageView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.bottomRoot, 1, self.OnAttrOrSkillChangeToggleClick, nil, false, true)
	
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnBtnCloseClick);
	self:ToggleAddListener();
	self:BottomButtonAddListener(self.controller:GetData()._targetTag == 0);

	self:AddPlayerPageUIEventListener();
	self:DragModel();

	self.uiBase:AddButtonEventListener(self.goToDetailButton.button, self, self.OnGoToDetailClick);
	self.uiBase:AddButtonEventListener(self.goToBaseButton.button, self, self.OnGoToBaseClick);
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnBtnCloseClick)
	self.uiBase:AddButtonEventListener(self.serverButton.button, self, self.OnClickServerBtn)
	self.uiBase:AddButtonEventListener(self.userButton.button, self, self.OnClickUserBtn)
	self.uiBase:AddButtonEventListener(self.titleBtn.button, self, self.OntitleBtnClick)

	self.uiBase:AddButtonEventListener(self.petBaseAttRoot.goToDetailButton.button, self, self.OnClickPetDetailBtn)
	self.uiBase:AddButtonEventListener(self.petDetailAttRoot.goToBaseButton.button, self, self.OnClickPetBaseBtn)
	self.uiBase:AddButtonEventListener(self.btnPetAttrs.button, self, self.OnPetAttrsClick)
	self.uiBase:AddButtonEventListener(self.btnCardBless.button, self, self.OnCardBlessClick)
end

function UIRoleMessageView:OntitleBtnClick()
	isShowTitleScroll = not isShowTitleScroll
	self.titleScroll:SetActive(isShowTitleScroll)
	if isShowTitleScroll then
		ActiveTitleList = ManagerContainer.DataMgr.TitleData:GetAllActiveTitleList()
		self.titleScroll.loopGridView:RefreshListByIndex(ActiveTitleList and #ActiveTitleList or 0)
	end
end

function UIRoleMessageView:GetTitleItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('TitleItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'TitleItem', item.gameObject)
	self.uiBase:AddToggleEventListener(itemLua.toggle, self, self.ChangeViewPage, itemIndex)
	local activeTitleData = ActiveTitleList[itemIndex + 1]
	local titlecfg = ManagerContainer.CfgMgr:GetDesignationCfgById(activeTitleData.titleId)
	CommonUtil.LoadIcon(self, titlecfg.ChatSource, function (sprite)
		itemLua.img.image.sprite = sprite
	end)
	self.uiBase:AddButtonUniqueEventListener(itemLua.img.button, self, self.SendChangeTitleMsg,itemIndex)
	return item
end

function UIRoleMessageView:SendChangeTitleMsg(button,params)
	local itemIndex = params[0]
	local titleData = ActiveTitleList[itemIndex + 1]
	isShowTitleScroll = false
	self.titleScroll:SetActive(isShowTitleScroll)
	if titleData.state == 3 then
		return
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HEAD_OPERATE_REQ,{operateType = 2,headId = titleData.titleId})
end


function UIRoleMessageView:OnHide()
	for i = 1, 6 do
		roleViewSystems[i]:Dispose()
	end
	roleViewSystems = nil

	if petViewSystem then
		petViewSystem:Dispose()
	end
	petViewSystem = nil

	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil
end

function UIRoleMessageView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh()
end

function UIRoleMessageView:OnClose()
	self:DeleteGo(self._roleHeads);
	self:DeleteGo(self._roleDetailAttr);
	self:DeleteGo(self._roleBaseAttrs);
	self:DeleteGo(self._equipmentSlots);
	self:DeleteGo(self.petBaseAttrsList);

	self.baseView.loopVerticalScrollRect:ClearCells()
	self.petAddView.loopVerticalScrollRect:ClearCells()

	self:RemoveCurModel()

	if nil ~= self.SyncCbId then
		ManagerContainer.LuaActorAttributeMgr:ClearCb(self.SyncCbId)
	end

	self.petModel.uIEventTriggerListener.onClick = nil
	self.petModel.uIEventTriggerListener.onClick = nil

	self.leaderRoleModel.uIEventTriggerListener.onDrag = nil
	self.roleModel.uIEventTriggerListener.onDrag = nil

	for i = 1, 6 do
		roleViewSystems[i]:Dispose()
	end
	roleViewSystems = nil
	if petViewSystem then
		petViewSystem:Dispose()
	end
	petViewSystem = nil
	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil
	_data = nil;
end

function UIRoleMessageView:OnDispose()
	self.titleScroll.loopGridView:Dispose()
end

--删除实例化出来的对象
function UIRoleMessageView:DeleteGo(_table)
	if _table then
		for i = #_table, 1, -1 do
			--头像删除有bug，此处暂时用立即删除
			CommonUtil.DestroyGOImmediate(_table[i].go)
		end
	end
end

----公共模块start----
---事件start

function UIRoleMessageView:OnClickServerBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeServer)
end

function UIRoleMessageView:OnClickUserBtn()
	-- if SDKMgr.Instance:CheckHasModul(SDKModulType.USERMANAGER) then
	-- 	SDKMgr.Instance:OpenModul(SDKModulType.USERMANAGER)
	-- end
	SDKMgr.Instance:Logout()
end

--关闭按钮
function UIRoleMessageView:OnBtnCloseClick()
	--关闭界面前删除实例化出来的预设物
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIRoleMessage);
end
--改名事件
function UIRoleMessageView:OnChangeNameClick()
	local _isSelf = self.controller:GetData()._targetTag == 0;
	if _isSelf then
		local _openCreate = NickNameCtr:NeedOpenCreate();
		NickNameCtr:OpenNickNamePage(_openCreate);
	end
end
--改头像
function UIRoleMessageView:OnChangeHeadClick()
	local _isSelf = self.controller:GetData()._targetTag == 0;
	if _isSelf then
		ManagerContainer.DataMgr.HeadProtraitData:SendGetHeadInfo();
	end
end

--改头像框
function UIRoleMessageView:OnChangeHeadFrameClick()
	local _isSelf = self.controller:GetData()._targetTag == 0;
	if _isSelf then
		ManagerContainer.DataMgr.HeadFrameDataMgr:SendHeadFrameInfoReq();
	end
end

function UIRoleMessageView:OnPageRedpointNtf(pageId,state)
	local _isSelf = self.controller:GetData()._targetTag == 0
	if pageId == self.uiBase.PageId then	
		self:SetRPState(_isSelf and state)
	elseif not _isSelf then
		self:SetRPState(false)
	end
end

function UIRoleMessageView:RefreshTotalFightPower()
	--如果是自己的话  会有延迟更新战力  需要刷新最新战力
	local _isSelf = self.controller:GetData()._targetTag == 0
	if _isSelf  then
		local totalPower = ManagerContainer.DataMgr.UserData:GetTotalFightPower()
		self.powerText.text.text = tostring(totalPower)	--总战力
	end
end

function UIRoleMessageView:SetRPState(vis)
	local rpTrans = self.headItem.transform:Find("redPoint31")
	if rpTrans ~= nil then
		rpTrans.gameObject:SetActive(vis)
	end
end

--toggle事件
function UIRoleMessageView:OnAttrOrSkillChangeToggleClick(_params)
	--if _params == self._ASChangeToggleIndexCur then return; end
	--self._ASChangeToggleIndexCur = _params;
	lastIndex = nil

	self.attributeRoot.gameObject:SetActive(_params == 1);
	self.skillRoot.gameObject:SetActive(_params == 2);
	self.petRoot.gameObject:SetActive(_params == 3);
	self.noPet:SetActive(_params == 3)

	if _params then
		if _params == 1 then	--属性
			if curIndex == 1 then
				self:RefreshLeaderModel()
			else
				self:RefreshPartnerModel()
			end
			self:SetAttributeState(true);
		elseif _params == 2 then --技能
			self:SetAttributeState(false);
		elseif _params == 3 then --宠物
			self:RefreshPetInfo()
		end
	end
end

--Toggle事件
function UIRoleMessageView:OnPageToggleClick(_toggle, _params, _value)
	if _params == self._toggleIndexCur then
		return;
	else
		self._toggleIndexCur = _params;
	end
	if not _toggle.isOn then return; end

	if _params then self:OpenPageByTab(_params); end
end
--toggle添加事件
function UIRoleMessageView:ToggleAddListener()
	self.uiBase:AddToggleEventListener(self.playerMessage.toggle, self, self.OnPageToggleClick, 1);
	self.uiBase:AddToggleEventListener(self.roleMessage.toggle, self, self.OnPageToggleClick, 2);

	--self.uiBase:AddToggleEventListener(self.attributeToggle.toggle, self, self.OnAttrOrSkillChangeToggleClick, 1);
	--self.uiBase:AddToggleEventListener(self.skillToggle.toggle, self, self.OnAttrOrSkillChangeToggleClick, 2);
end
--bottom的button添加事件
function UIRoleMessageView:BottomButtonAddListener(_isSelf)
	if _isSelf then	--如果点开的是我自己的页面
		if Constant.OpenPay and not PlatformPack.SpecialFuncShield then
			self.giftButton:SetActive(true)
		else
			self.giftButton:SetActive(false)
		end
		self.uiBase:AddButtonEventListener(self.giftButton.button, self, self.OnGiftClick)
		-- self.uiBase:AddButtonEventListener(self.giftButton.button, function() ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("功能尚未开放，敬请期待！"); end);
		self.uiBase:AddButtonEventListener(self.bindButton.button, function() ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("功能尚未开放，敬请期待！"); end);
		self.uiBase:AddButtonEventListener(self.settingButton.button, function()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISettings);	--打开设置界面
		end);
	else	--点开的是别人的页面
		local _originalData = self.controller._userData
		local _uid = _originalData.uid
		local _nickName = _originalData.nickName;
		local _headIcon = _data._headIconId;
		local jobId = _originalData.jobId
		local level = _originalData.level
		local sex = _originalData.gender
		self.uiBase:AddButtonEventListener(self.talkButton.button, function()
			ManagerContainer.LuaUIMgr:PrivateChatOtherPlayer(_uid, _nickName, _headIcon, jobId, level,sex);	--打开私聊界面
		end);

		local _isBlack, _ = self:JudgeIsBlack();
		self:SetBlackButtonName(_isBlack);
		self.uiBase:AddButtonEventListener(self.shieldButton.button, self, self.OnBlackBtnClick);	--改头像

		local _isFriend, _ = self:JudgeIsFriend();
		self:SetFriendButtonName(_isFriend);
		self.uiBase:AddButtonEventListener(self.makeFriendButton.button, self, self.OnMakeFriendBtnClick);	--改头像
	end
end
---事件end

---初始化start
--游戏中一些数值对象
function UIRoleMessageView:CreateValues()
	self._toggleIndexCur = 0;	--初始的被选中的toggle的index
end
--游戏中用到的对象的table
function UIRoleMessageView:CreateTargetTables()
	self._pageTable = {};
	table.insert(self._pageTable, self.playerPage);
	table.insert(self._pageTable, self.rolePage);
	table.insert(self._pageTable, self.petPage);
end
---初始化end

---对象显示控制start
--页签控制页面开启关闭
function UIRoleMessageView:OpenPageByTab(_tabIndex)
	for i = 1, #self._pageTable do
		self._pageTable[i]:SetActive(i == _tabIndex);
	end
	if _tabIndex == 1 then	--展示玩家信息界面
		self:ShowPlayerData();
	elseif _tabIndex == 2 then	--展示角色信息界面
		self:ShowRoleData();
	end
end
--控制改名按钮的显示
function UIRoleMessageView:SetChangeNameButton(_isSelf)
	self.changeNameButton.gameObject:SetActive(_isSelf);
end

--控制底部按钮的显示
function UIRoleMessageView:SetBottomButtons(_isSelf)
	self.selfButtons:SetActive(_isSelf);
	local isCross = self.controller:IsCrossRole()
	self.friendButtons:SetActive(not isCross and not _isSelf);
	ManagerContainer.LuaUIMgr:ClearIsAcrossRoleState()
end
---对象显示控制end

---数据填充start
--刷新角色
function UIRoleMessageView:RefreshRoleView(roleId, viewData, extGoesShowData)
	roleViewSystems[1]:RefreshView(Enum.RoleInEnvType.RoleMainView, roleId, viewData, extGoesShowData, self, self.LoadModelCB)
end
--load 模型
function UIRoleMessageView:LoadModelCB(model)
	curModel = model
	if previewSystem then
		previewSystem:UpdateGo(model)
	end
	curModel:SetActive(true)

	if petViewSystem then
		petViewSystem:RolePlayAni(curModel, "s_click")
	end
end
--创建previewSystem,同时也隐藏了之前已经load过的模型
function UIRoleMessageView:CreatePreviewSystem()
	if not previewSystem then
		previewSystem = PreviewSystem:new()
	end
	previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	self:RemoveCurModel()
end

function UIRoleMessageView:RemoveCurModel()
	if curModel ~= nil then
		curModel:SetActive(false)
		previewSystem:RemoveGo(curModel)
		for i = 1, 6 do
			roleViewSystems[i]:Recycle()
		end
		curModel = nil
	end
end

--填充RawImage
function UIRoleMessageView:SetRawImage(_RawImage)
	_RawImage.texture = previewSystem:GetRenderTexture()
end
--显示角色
function UIRoleMessageView:ShowRole(_roleId, _viewData, _rawImage)
	self:RefreshRoleView(_roleId, _viewData);
	self:SetRawImage(_rawImage);
end
---数据填充end
----公共模块end----

----玩家页面start----
---事件start
--添加事件
function UIRoleMessageView:AddPlayerPageUIEventListener()
	--self.uiBase:AddButtonEventListener(self.head.button, self, self.OnChangeHeadClick);	--改头像
	self.uiBase:AddButtonEventListener(self.changeNameButton.button, self, self.OnChangeNameClick);	--改名
end
--添加Model的拖拽事件
function UIRoleMessageView:DragModel()
	--一次性把player界面和role界面model的拖拽都设置了吧，反正也不耗
	self.leaderRoleModel.uIEventTriggerListener.onDrag = nil;
	self.leaderRoleModel.uIEventTriggerListener.onDrag = function()
		local deltaX = self.leaderRoleModel.uIEventTriggerListener.currentEventData.delta.x
		if curModel then
			curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
		end
	end
	self.roleModel.uIEventTriggerListener.onDrag = nil;
	self.roleModel.uIEventTriggerListener.onDrag = function()
		local deltaX = self.roleModel.uIEventTriggerListener.currentEventData.delta.x
		if curModel then
			curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
		end
	end
	self.petModel.uIEventTriggerListener.onDrag = nil
	self.petModel.uIEventTriggerListener.onDrag = function()
		if curModel then
			local deltaX = self.petModel.uIEventTriggerListener.currentEventData.delta.x
			curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
		end
	end
	self.petModel.uIEventTriggerListener.onClick = nil
	self.petModel.uIEventTriggerListener.onClick = function()
		if petViewSystem then
			petViewSystem:RolePlayAni(curModel, "s_click")
		end
	end

end
---事件end
---数据填充start
--填充玩家的数据到UI
function UIRoleMessageView:ShowPlayerData()
	_data = self.controller:GetData()._tidyData._playerData;
	self:SetPlayerTopMessage();	--设置顶部信息
	self:SetPlayerModel(_data._roleId, _data._viewData, _data._extGoesShowData, self.leaderRoleModel.rawImage);	--设置model展示信息
end
--改变了头像，这个只有玩家打开的是自己的信息界面的时候才会调用到，因为只有玩家自己才能改变自己的头像
function UIRoleMessageView:OnChangeHeadEvent()
	_data._headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon();	--头像图片
	self:RefreshHeadIcon();
end

--获得了排名信息
function UIRoleMessageView:AfterRefreshDanScore()
	self:SetDunMessage(ManagerContainer.DataMgr.ArenaData:GetCurDanScore());
end

--刷新了赛季信息
function UIRoleMessageView:AfterRefreshSeason()
	local _titleName, _titleIcon, _competitionTitleIcon = ManagerContainer.DataMgr.CompetitionData:GetCurSeasonTitle();	--称号;
	self.controller:RefreshTitleIconAndName(_competitionTitleIcon, _titleName);
	self:SetTitle(_competitionTitleIcon,  _titleName);	--称号
end

--更改了头像框
function UIRoleMessageView:ChangeHeadFrame(headFrameIcon)
	CommonUtil.LoadIcon(self, headFrameIcon, function (sprite)
		self.headItem.frame.image.sprite = sprite
	end)
end

function UIRoleMessageView:ChangeTitle()
	local _isSelf = self.controller:GetData()._targetTag == 0;
	local titleId
	if  _isSelf then
		titleId = ManagerContainer.DataMgr.TitleData:GetCurrWearerTitleId()
	else
		titleId = self.controller:GetData()._tidyData._titleId
	end
	local titleCfg = ManagerContainer.CfgMgr:GetDesignationCfgById(titleId)

	if not titleCfg then
		self.titleName:SetActive(true)
		self.titleImg:SetActive(false)
	else
		self.titleName:SetActive(false)
		self.titleImg:SetActive(true)
		CommonUtil.LoadIcon(self, titleCfg.ChatSource, function (sprite)
			self.titleImg.image.sprite = sprite
		end)
	end
end

--开启头像设置界面
function UIRoleMessageView:OnHeadDataEvent()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeHead);	--开启改名界面
end
--设置头像
function UIRoleMessageView:RefreshHeadIcon()
	if _data._headIcon ~= nil then
			--设置头像
		CommonUtil.LoadIcon(self, _data._headIcon, function(sprite)
			self.headItem.head.image.sprite = sprite
		end, self, 'headPortraitIconIdx')
	else
		self.headItem.head.image.sprite = nil
	end
end

--刷新头像
function UIRoleMessageView:RefreshHead()
	local _jobIcon = ManagerContainer.CfgMgr:GetJobDataById(_data._jobId).JobIcon;
	local _fakerData = {Level = _data._baseLevel, ProfessionIcon = _jobIcon, HeadIcon = _data._headIcon, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, _fakerData, false, _data._headFrameId, self, self.OnChangeHeadFrameClick);
	local _isSelf = self.controller:GetData()._targetTag == 0
	if not _isSelf  then
		self:SetRPState(false)
	end

end

--设置顶部数据显示
function UIRoleMessageView:SetPlayerTopMessage()
	self:RefreshHead();
	--[[
	self:RefreshHeadIcon();
	--设置job
	local _jobCfgId = _data._jobId;
	local _jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(_jobCfgId);
	CommonUtil.LoadIcon(self, _jobCfgData.JobIcon, function (sprite)
		self.head.icon.image.sprite = sprite
	end, self, 'jobIconIdx');
	]]--
	self:SetPlayerName(_data._nickName);	--设置昵称
	self:SetPlayerVIp(_data._vipLv) --刷新vipicon
	--self.expBarBase.textLv.text.text = "LV" .. tostring(_data._baseLevel);	--base等级
	--self.expBarJob.textLv.text.text = "LV" .. tostring(_data._jobLevel);	--job等级
	self:SetTitle(_data._titleIcon,  _data._titleName);	--称号
	self.powerText.text.text = tostring(_data._totalPower)	--总战力
	self:SetAllianceMessage("", _data._allianceName);	--TODO:等待工会实现之后接入
	self:SetDunMessage(_data._dun);
end
--设置玩家的名字
function UIRoleMessageView:SetPlayerName(_name)
	_data._nickName = _name
	self.playerNameText.text.text = _name;	--设置昵称
end

--设置玩家的VIP等级
function UIRoleMessageView:SetPlayerVIp(vipLv)	
	self.vipIcon.image.enabled = false
	self.vipIcon.image.sprite = nil	
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self.vipIcon.image.sprite = sprite
					self.vipIcon.image.enabled = true
				end
			end)
		end
	end
end
--设置称号
function UIRoleMessageView:SetTitle(_icon, _name)
	if _icon then
		self.titleIcon.gameObject:SetActive(true);
		CommonUtil.LoadIcon(self, _icon, function (sprite)
			self.titleIcon.image.sprite = sprite
		end);	--设置图片
	else
		self.titleIcon.gameObject:SetActive(false);
	end
	self.titleName.text.text = _name;
end
--设置工会信息
function UIRoleMessageView:SetAllianceMessage(_icon, _name)
	--TODO:设置工会图片
	self.allianceName.text.text = _name;	--工会名称
end
--设置段位信息
function UIRoleMessageView:SetDunMessage(_dunScore)
	local levelCfg, nextKey = CommonUtil.GetCurDunData(_dunScore);
	CommonUtil.LoadIcon(self, levelCfg.LevelIcon, function (sprite)
		self.gradeIcon.image.sprite = sprite
	end);	--设置图片
	self.gradeName.text.text = levelCfg.ArenaLevelName;	--设置段位名称
end
--设置Model
function UIRoleMessageView:SetPlayerModel(_roleId, _viewData, _extGoesShowData, _rawImage)
	self.controller:SetCurPartnerUid(1);
	self:CreatePreviewSystem();
	self:RefreshRoleView(_roleId, _viewData, _extGoesShowData);
	self:SetRawImage(_rawImage);
end

function UIRoleMessageView:SetPartnerModel(id, partnerCfgId, viewData, extGoesShowData)
	if partnerCfgId == nil then return nil end
	return roleViewSystems[id]:RefreshView(Enum.RoleInEnvType.RoleMainView, partnerCfgId, viewData, extGoesShowData, self, self.LoadModelCB)
end
--更改Model
function UIRoleMessageView:ChangeModel(_id, _roleId, _viewData, _extGoesShowData, _rawImage)
	self.controller:SetCurPartnerUid(_id);
	if _id == 1 then
		self:SetPlayerModel(_roleId, _viewData, _extGoesShowData, _rawImage)
	else
		self:CreatePreviewSystem();
		partnerId = _roleId
		self:SetPartnerModel(_id, partnerId, _viewData, _extGoesShowData)
	end
end
---数据填充end
----玩家页面end----

----角色页面start----
---创建常用值start
function UIRoleMessageView:CreateEquipSlotNames()
	self._equipmentSlotName = {};
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_hat");	--帽子
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_clothing");	--衣服
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_weapon");	--武器
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_scarf");	--披肩
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_shoes");	--鞋子
	table.insert(self._equipmentSlotName, "FrameNew/ic_equip_ring");	--饰品
end
---创建常用值end
---事件start
--role界面中的属性界面，点击后开启详细属性
function UIRoleMessageView:OnGoToDetailClick()
	self:SetAttributeState(false);
end
--role界面中的属性界面，点击后开启基础属性
function UIRoleMessageView:OnGoToBaseClick()
	self:SetAttributeState(true);
end
--判断是否在黑名单中
function UIRoleMessageView:JudgeIsBlack()
	local _originalData = self.controller._userData
	local _uid = _originalData.uid;
	local _isBlack = ManagerContainer.DataMgr.FriendDataMgr:IsBlackPlayer(_uid);
	return _isBlack, _uid;
end
--点击屏蔽按钮
function UIRoleMessageView:OnBlackBtnClick()
	local _isBlack, _uid = self:JudgeIsBlack();
	if _isBlack then
		ManagerContainer.DataMgr.FriendDataMgr:RemoveBlackReq(_uid);
	else
		ManagerContainer.DataMgr.FriendDataMgr:AddBlackReq(_uid);
	end
	self:SetBlackButtonName(not _isBlack);
end
--判断是否是好友
function UIRoleMessageView:JudgeIsFriend()
	local _originalData = self.controller._userData
	local _uid = _originalData.uid;
	local _isFriend = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(_uid);
	return _isFriend, _uid;
end
--点击交友按钮
function UIRoleMessageView:OnMakeFriendBtnClick()
	local _isFriend, _uid = self:JudgeIsFriend();
	if _isFriend then	--是好友再点就是要删除了
		ManagerContainer.DataMgr.FriendDataMgr:DeleteFriendReq(_uid);
	else
		ManagerContainer.DataMgr.FriendDataMgr:AddFriendReq(_uid);
	end
	self:SetFriendButtonName(not _isFriend);
end
---事件end
---填充对象start
--填充角色界面的信息
function UIRoleMessageView:ShowRoleData()
	_data = self.controller:GetData()._tidyData._roleData;
	lastIndex = nil

	self:SetAttributeState(true);
	--self:SetShowAttrOrSkill();
	self:CreateRoleHead();
	self:CreateBaseAttributesItem();
	self:CreateDetailAttributeItem();
	self:CreateEquipSlots();
	self:CreateSkillSlots();
	--开始填充
	self:SetHeads();
	--默认选中属性toggle
	self.attributeToggle.toggle.isOn = true;
	self:OnAttrOrSkillChangeToggleClick(1);
end

function UIRoleMessageView:OnLeaderHeadClick()
	if 1 == lastIndex then return end

	curIndex = 1
	lastIndex = curIndex

	local _leaderData = self.controller:GetLeaderHeadData();		
	-- self:ChangeModel(1, _leaderData._roleId, _leaderData._viewData, _leaderData._extGoesShowData, self.roleModel.rawImage);
	local totalPower = tonumber(_leaderData.petFightPower) + tonumber(_leaderData._power) 
	--LogError("_leaderData.petFightPower"..tostring(_leaderData.petFightPower))
	--LogError("_leaderData._power"..tostring(_leaderData._power))		
	self:SetRoleNameAndPower(_leaderData._name, _leaderData._jobICon, tostring(totalPower));
	self:SetRoleBaseAttr(_leaderData._baseAttr);
	self:SetAddAttrList(_leaderData.addList);
	self:SetRoleDetailAttr(_leaderData._detailAttr);
	self:SetRoleEquSlot(_leaderData._slots, _leaderData._jobData, 1,1, _leaderData._jobCfgId,_leaderData._name);
	self:SetRoleSkillSlot(_leaderData._skills);

	self:OnAttrOrSkillChangeToggleClick(pageToggleData.toggleDefaultIndex);

	self:CloseAllCheckMark();
	self._roleHeads[1].lua.checkMark.gameObject:SetActive(true);

	self:RefreshCardSuitBtn()
	self:RefreshSkillEquip()
end

function UIRoleMessageView:RefreshLeaderModel()
	local _leaderData = self.controller:GetLeaderHeadData();
	self:ChangeModel(1, _leaderData._roleId, _leaderData._viewData, _leaderData._extGoesShowData, self.roleModel.rawImage);
end

function UIRoleMessageView:OnPartnerHeadClick(button, params)
	local sortIndex = params[0];
	self:OnPartnerHeadClick1(sortIndex)
end

function UIRoleMessageView:OnPartnerHeadClick1(sortIndex)
	if sortIndex + 1 == lastIndex then return end

	curIndex = sortIndex + 1
	lastIndex = curIndex	

	local _partnerData = self.controller:GetPartnerData(curIndex);		

	-- self:ChangeModel(curIndex, _partnerData._configId, nil, _partnerData._extGoesShowData);
	local totalPower = tonumber(_partnerData.petFightPower) + tonumber(_partnerData._power) 
	local _isSelf = self.controller:GetData()._targetTag == 0;
	if _isSelf then	--自己 战力获取
		local Power = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(_partnerData.id,false)
		--LogError(tostring(Power))
		if nil ~= Power and -1 ~= Power then	
			local PetPower = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(_partnerData.battlePetId,true)
			if nil ~= PetPower and -1 ~= PetPower then
				totalPower = Power + PetPower
			end
		end
	end
	self:SetRoleNameAndPower(_partnerData._name, _partnerData._jobICon,tostring(totalPower) );
	self:SetRoleBaseAttr(_partnerData._baseAttr);
	self:SetAddAttrList(_partnerData.addList);
	self:SetRoleDetailAttr(_partnerData._detailAttr);
	self:SetRoleEquSlot(_partnerData._slots, _partnerData._jobData, curIndex, _partnerData._id, _partnerData._jobCfgId);
	self:SetRoleSkillSlot(_partnerData._skills);
	self:OnAttrOrSkillChangeToggleClick(pageToggleData.toggleDefaultIndex);

	self:CloseAllCheckMark();
	self._roleHeads[curIndex].lua.checkMark.gameObject:SetActive(true);

	self:RefreshCardSuitBtn()
	self:RefreshSkillEquip()
end

function UIRoleMessageView:RefreshPartnerModel()
	local _partnerData = self.controller:GetPartnerData(curIndex);
	self:ChangeModel(curIndex, _partnerData._configId, nil, _partnerData._extGoesShowData);
end

--填充头像
function UIRoleMessageView:SetHeads()
	--填充主角
	local _leaderData = self.controller:GetLeaderHeadData();
	--local _onLeaderHeadClick = function ()
	--	self:ChangeModel(1, _leaderData._roleId, _leaderData._viewData, self.roleModel.rawImage);
	--	self:SetRoleNameAndPower(_leaderData._name, _leaderData._jobICon, _leaderData._power);
	--	self:SetRoleBaseAttr(_leaderData._baseAttr);
	--	self:SetAddAttrList(_leaderData.addList);
	--	self:SetRoleDetailAttr(_leaderData._detailAttr);
	--	self:SetRoleEquSlot(_leaderData._slots, _leaderData._jobData, 1,1, _leaderData._jobCfgId,_leaderData._name);
	--	self:SetRoleSkillSlot(_leaderData._skills);
	--	self:CloseAllCheckMark();
	--	self._roleHeads[1].lua.checkMark.gameObject:SetActive(true);
	--end
	self:SetSingleHead(1, _leaderData, self.OnLeaderHeadClick);
	--填充队友
	for i = 1, #_data._sortPartner do	--排序后的队友是从1开始的，但是真正的顺序应该是leader是1，队友的第一个的index是2
		local _logicIndex = i + 1;
		local _partnerData = self.controller:GetPartnerData(_logicIndex);
		--local _onPartnerHeadClick = function ()
		--	self:ChangeModel(_logicIndex, _partnerData._configId, _partnerData._strengthLevel);
		--	self:SetRoleNameAndPower(_partnerData._name, _partnerData._jobICon, _partnerData._power);
		--	self:SetRoleBaseAttr(_partnerData._baseAttr);
		--	self:SetAddAttrList(_partnerData.addList);
		--	self:SetRoleDetailAttr(_partnerData._detailAttr);
		--	self:SetRoleEquSlot(_partnerData._slots, _partnerData._jobData, i + 1, _partnerData._id, _partnerData._jobCfgId);
		--	self:SetRoleSkillSlot(_partnerData._skills);
		--	self:CloseAllCheckMark();
		--	self._roleHeads[_logicIndex].lua.checkMark.gameObject:SetActive(true);
		--end
		self:SetSingleHead(_logicIndex, _partnerData, self.OnPartnerHeadClick);
	end

	self:OnLeaderHeadClick();	--默认选择主角
end
--关闭所有的选中框
function UIRoleMessageView:CloseAllCheckMark()
	for _, _v in ipairs(self._roleHeads) do
		_v.lua.checkMark.gameObject:SetActive(false);
	end
end

--设置单个头像
function UIRoleMessageView:SetSingleHead(_index, _data, _clickCB)
	local _go = self._roleHeads[_index].go;
	_go:SetActive(_data._get);
	if _data._get then
		local _lua = self._roleHeads[_index].lua;
		_data._iconItemData = {cfgId = _data._configId, num = _data._baseLevel, strengthLevel = _data._strengthLevel, headFrameId = _data._headFrameId, isLeader = _index ==1, leaderIcon = _data._headIcon}
		RoleMessageHeadCtr:SetData(self, _lua, _data, self, _clickCB);
	end
end
--设置role界面的玩家名字和战力
function UIRoleMessageView:SetRoleNameAndPower(_name, _jobIcon, _power)
	CommonUtil.LoadIcon(self, _jobIcon, function(sprite)
		self.jobIcon.image.sprite = sprite
	end);

	self.roleNameText.text.text = _name;
	self.fightPower.text.text = _power;
end
--设置role界面的base attribute
function UIRoleMessageView:SetRoleBaseAttr(_baseAttrs)
	for i = 1, #_baseAttrs do
		if not self._roleBaseAttrs[i].go.gameObject.activeSelf then self._roleBaseAttrs[i].go.gameObject:SetActive(true); end
		self._roleBaseAttrs[i].name.text = I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(_baseAttrs[i].key));
		self._roleBaseAttrs[i].value.text = tostring(_baseAttrs[i].value);
	end
end
--设置role界面的detail attribute
function UIRoleMessageView:SetRoleDetailAttr(_detailAttrs)
	for i = 1, #_detailAttrs do
		if not self._roleDetailAttr[i].go.gameObject.activeSelf then self._roleDetailAttr[i].go.gameObject:SetActive(true); end
		self._roleDetailAttr[i].name.text = I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(_detailAttrs[i].key));
		self._roleDetailAttr[i].value.text = "+" .. tostring(_detailAttrs[i].value)
	end
end

--设置附加属性
function UIRoleMessageView:SetAddAttrList(_addAttrs)
	local _content = self.addSView.gameObject.transform;
	--清除所有的item对象
	for i = _content.childCount - 1, 1, -1 do
		local _child = _content:GetChild(i);
		CommonUtil.DestroyGOImmediate(_child.gameObject);
	end

	for _k, _v in pairs(_addAttrs) do
		local _go = CommonUtil.Instantiate(self.specialItem.gameObject, _content)
		local _text = _go.transform:Find("Text").gameObject:GetComponent(Enum.TypeInfo.Text);

		local attrId = _v[1]
		local attrValue = attrId >= Enum.HeroAttrType.RealHurt and CommonUtil.GetPreciseDecimalFloor(_v[2], 2) or math.floor(_v[2])
		local addVal = attrId >= Enum.HeroAttrType.RealHurt and CommonUtil.GetPreciseDecimalFloor(_v[3], 2) or math.floor(_v[3])
		if attrValue == 0 then
			attrValue = 0.01
		end
		local _language = "Attr_" .. tostring(attrId)
		local _languageText = I18N.T(_language)
		_text.text = _languageText .. CommonUtil.HeroAttrFormatValue(attrId, attrValue, true)

		if addVal > 0 then
			_text.text = _languageText .. CommonUtil.HeroAttrFormatValue(attrId, addVal, true)
		end

		_go.gameObject:SetActive(true);
	end
end

--设置role界面的装备槽位,_slotIndex是角色的index，主角是1，然后队友按照排序后的顺序，依次是2/3/4/5/6
function UIRoleMessageView:SetRoleEquSlot(_slotDatas, _jobData, _slotIndex, _id, _jobConfigId,_name)
	for i = 1, 6 do
		local _index = i;
		local _data = nil;
		if _slotDatas[i] then
			_data = _slotDatas[i];
			_data._jobData = _jobData;
		end
		local _target = self._equipmentSlots[_index];
		EquipmentShowSlotItemCtr:SetData(self, _target.lua, _data, _index, _slotDatas, _slotIndex, _id, _jobConfigId,_name)
	end
end
--设置没有技能的时候的技能槽位的表现
function UIRoleMessageView:SetNoSkillSlot(_lua)
	_lua.locked.gameObject:SetActive(false);
	_lua.noSkill.gameObject:SetActive(true);
	_lua.skillListItem.gameObject:SetActive(false);
end
--设置技能
function UIRoleMessageView:SetRoleSkillSlot(_slotData)
	if not _slotData then
		for i = 1, 4 do
			self:SetNoSkillSlot(self._skillSlots[i].lua);
		end
		return;
	end
	for i = 1, #_slotData.slotSkills do
		local _skillId = _slotData.slotSkills[i].skillId;
		local _target = self._skillSlots[i];
		if _skillId and _skillId > 0 then
			_target.lua.locked.gameObject:SetActive(false);
			_target.lua.noSkill.gameObject:SetActive(false);
			_target.lua.skillListItem.gameObject:SetActive(true);
			local _level = _slotData.unlockSkillMap[_skillId].skillLv;
			local _realSkillId = _skillId * 1000 + _level;
			local _cfgData = ManagerContainer.CfgMgr:GetSkillCfgById(_skillId);
			if not _cfgData then LogError("Custom error by hudp: Can't find skill cfgData by id :" .. tostring(_realSkillId)); end
			CommonUtil.LoadIcon(self, _cfgData.Icon, function (sprite)
				_target.lua.skillItem.icon.image.sprite = sprite
			end);
			local _lvText = "Lv." .. tostring(_level);
			_target.lua.skillItem.num.text.text = _lvText;
			_target.lua.textLV.text.text = _lvText;
			_target.lua.skillName.text.text = string.formatbykey(_cfgData.Name);	--TODO：等待技能名字录入多语言表

			local _skillLvCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(_realSkillId);
			if _skillLvCfgData.DescParam then
				if type(_skillLvCfgData.DescParam) == 'table' then
					_target.lua.desTxt.text.text = string.formatbykey(_skillLvCfgData.Desc, unpack(_skillLvCfgData.DescParam))
				else
					_target.lua.desTxt.text.text = string.formatbykey(_skillLvCfgData.Desc, _skillLvCfgData.DescParam)
				end
			else
				_target.lua.desTxt.text.text = string.formatbykey(_skillLvCfgData.Desc)
			end
			local skillTreeCfgData
			if ManagerContainer.DataMgr.UserData:IsLeaderHero(curIndex) then
				skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(_skillId)
			else
				skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(_skillId)
			end
			local quality = skillTreeCfgData and skillTreeCfgData.SkillQuality or 0
			if quality ~= 0 then
				CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[quality], function (sprite)
					_target.lua.skillItem.frame.image.sprite = sprite
				end)
			else
				CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
					_target.lua.skillItem.frame.image.sprite = sprite
				end)
			end
		else
			self:SetNoSkillSlot(_target.lua);
		end
	end
end
--判断技能槽位的解锁信息
function UIRoleMessageView:CheckSlotUnlock(slotId, slotLv,  _isLeader, _leaderLv)
	local skillSlotCfgId = CommonUtil.GetSkillSlotCfgIdByIdxAndLv(slotId, slotLv)
	local skillSlotCfgData = ManagerContainer.CfgMgr:GetSkillSlotCfgById(skillSlotCfgId)
	if not skillSlotCfgData then
		return false
	end
	local condition
	if _isLeader then
		condition = skillSlotCfgData.Condition
	else
		condition = skillSlotCfgData.ParterCondition
	end
	if not condition then
		return true
	end
	local item = condition[1]
	if not item then
		return true
	end
	if type(item) == 'number' then
		if #condition >= 2 then
			condition = {condition}
		else
			return true
		end
	end
	for i = 1, #condition do
		local con = condition[i]
		local typeEnum = con[1]
		local val = con[2]
		if typeEnum == 1 or typeEnum == 4 then
			local userLevel = _leaderLv
			if val > userLevel then
				return false, 'TextSkillLocked', {val}
			end
		end
		if typeEnum == 2 then
			local jobStage = self.controller:GetJobStage()
			if val > jobStage then
				return false
			end
		end
	end
	return true
end

--当是别人的信息的时候，设置底部按钮的名字，_isFriend——是否是好友
function UIRoleMessageView:SetFriendButtonName(_isFriend)
	local _friendBtnName = I18N.T("AddFriends");	--默认是关注
	if _isFriend then
		_friendBtnName = I18N.T("RemoveFriends");	--取关
	end
	self.makeFriendButton.text.text.text = _friendBtnName;
end

--当是别人的信息的时候，设置底部按钮的名字,_isBlack——是否是黑名单中的人
function UIRoleMessageView:SetBlackButtonName(_isBlack)
	local _blackBtnName = I18N.T("AddBlackList");	--默认显示屏蔽
	if _isBlack then
		_blackBtnName = I18N.T("RemoveBlackList");	--恢复
	end
	self.shieldButton.text.text.text = _blackBtnName;
	self.icon1:SetActive(not _isBlack)
	self.icon2:SetActive(_isBlack)
end
---填充对象end

---控制对象start
--创建头像
function UIRoleMessageView:CreateRoleHead()
	if self._roleHeads then return; end	--创建过了
	self._roleHeads = {}
	self.roleMessageHeadOriginal.gameObject:SetActive(false);	--隐藏素体
	for i = 1, 6 do
		local _go = CommonUtil.Instantiate(self.roleMessageHeadOriginal.gameObject, self.roleTopRoot.gameObject.transform);
		local _lua = CommonUtil.BindGridViewItem2Lua(self, _roleHeadName, _go);
		table.insert(self._roleHeads, {
			["go"] = _go,
			["lua"] = _lua,
		})
	end
end

--创建详细属性
function UIRoleMessageView:CreateDetailAttributeItem()
	if self._roleDetailAttr then return; end
	self._roleDetailAttr = {};
	self.originalAttr.gameObject:SetActive(false);
	for i = 1, 14 do
		local _go = CommonUtil.Instantiate(self.originalAttr.gameObject, self.baseSView.transform);
		local _nameText = _go.transform:Find("Text").gameObject:GetComponent("Text");
		local _valueText = _go.transform:Find("Number").gameObject:GetComponent("Text");
		table.insert(self._roleDetailAttr, {
			["go"] = _go;
			["name"] = _nameText,
			["value"] = _valueText,
		})
	end
end
--创建基础属性
function UIRoleMessageView:CreateBaseAttributesItem()
	if self._roleBaseAttrs then return; end	--创建过了
	self._roleBaseAttrs = {};
	self.originalAttribute.gameObject:SetActive(false);	--隐藏素体
	for i = 1, 10 do
		local _go = CommonUtil.Instantiate(self.originalAttribute, self.attributes.gameObject.transform);
		local _nameText = _go.transform:Find("AttributeNameText").gameObject:GetComponent("Text");
		local _valueText = _go.transform:Find("AttributeValueText").gameObject:GetComponent("Text");
		table.insert(self._roleBaseAttrs, {
			["go"] = _go;
			["name"] = _nameText,
			["value"] = _valueText,
		})
	end
end
--创建角色的装备栏
function UIRoleMessageView:CreateEquipSlots()
	self:CreateEquipSlotNames();
	if self._equipmentSlots then return; end
	self._equipmentSlots = {};
	self.equipmentShowSlotItem.gameObject:SetActive(false);
	for i = 1, 7 do
		local _parent = self["slot" .. tostring(i)].gameObject.transform;
		local _go = CommonUtil.Instantiate(self.equipmentShowSlotItem.gameObject, _parent);
		local _lua = CommonUtil.BindGridViewItem2Lua(self, _equipmentSlotName, _go);
		if i < 7 then
			CommonUtil.LoadIcon(self, self._equipmentSlotName[i], function (sprite)
				_lua.position.image.sprite = sprite
			end)
		end
		table.insert(self._equipmentSlots, {
			["go"] = _go,
			["lua"] = _lua,
		});
		_go.gameObject:SetActive(true);
	end
end
--创建技能
function UIRoleMessageView:CreateSkillSlots()
	if self._skillSlots then return; end
	self._skillSlots = {};
	for i = 1, 4 do
		local _lua = self["skillSlot_" .. tostring(i)];
		table.insert(self._skillSlots, {["lua"] = _lua,});
	end
end
--控制属性显示详细界面还是基础界面
function UIRoleMessageView:SetAttributeState(_showBase)
	self.baseAttRoot.gameObject:SetActive(_showBase);
	self.detailAttRoot.gameObject:SetActive(not _showBase);
end
--控制希纳是属性还是显示技能
function UIRoleMessageView:SetShowAttrOrSkill(_showAttr)
	self.attributeRoot.gameObject:SetActive(_showAttr);
	self.skillRoot.gameObject:SetActive(not _showAttr);

	if _showAttr then
		self:SetAttributeState(true);
	end
end
---控制对象end
----角色页面end----


function UIRoleMessageView:OnGiftClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExchangeCode)
end

----宠物页面start----

function UIRoleMessageView:RefreshPetInfo()
	local petData
	local heroData
	if curIndex == 1 then
		--同时点击头像刷新角色属性
		local herodata = self.controller:GetLeaderHeadData()
		self:SetRoleBaseAttr(herodata._baseAttr)
		petData = self.controller:GetPetDataByHeroId(1)
		heroData = self.controller:GetLeaderHeadData()
	else
		local partnerdata = self.controller:GetPartnerData(curIndex)
		self:SetRoleBaseAttr(partnerdata._baseAttr)
		heroData = self.controller:GetPartnerData(curIndex);
		petData = self.controller:GetPetDataByHeroId(heroData._id)
	end
	if not petData then
		self.noPet:SetActive(true)
		self.petRoot:SetActive(false)
		return
	else
		self.noPet:SetActive(false)
		self.petRoot:SetActive(true)
	end

	local power = self.controller:GetPetFightPowerByHeroId(heroData._id)
	self.petfightPowerText.text.text = power == 0 and "-----" or tostring(power)

	self:RefreshPetModel(petData)
	self:RefreshPetTop(petData)
	self:RefreshPetSkills(petData)
	self:RefreshPetBaseAttrs(petData)
end

function UIRoleMessageView:RefreshPetModel(petData)
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	local camPos = petCfgData.CamPos or {-0.116, 2.28, 3.89}
	local camRot = petCfgData.CamRot or {12.174, 177.372, 0.085}
	if not previewSystem then
		previewSystem = PreviewSystem:new("RoleMessage", 1024, 1024)
	end
	previewSystem:SetView(Vector3(camPos[1], camPos[2], camPos[3]), Quaternion.Euler(camRot[1], camRot[2], camRot[3]))

	self:RemoveCurModel()
	self:RefreshPetView(petData)
	self.petModel.rawImage.texture = previewSystem:GetRenderTexture()
end

function UIRoleMessageView:RefreshPetView(petData)
	if petData == nil then return nil end

	return petViewSystem:RefreshView(Enum.RoleInEnvType.PetLvUp, petData.cfgId, petData.extGoesShowData, self, self.LoadModelCB)
end

function UIRoleMessageView:RefreshPetTop(petData)
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	if not petCfgData then
		return
	end
	local natureId = petCfgData.NatureType
	local natureCfgData = ManagerContainer.CfgMgr:GetNatureDataById(natureId)
	local icon = natureCfgData.Icon

	CommonUtil.LoadIcon(self, icon, function (sprite)
		self.petJobIcon.image.sprite = sprite
	end, self, "petJobIcon")

	CommonUtil.LoadIcon(self, Constant.Quality_CardType_Icons[petData.quality], function (sprite)
		self.petLabelIcon.image.sprite = sprite
	end, self, "labelIcon")

	self.petNameText.text.text = petData.advanceLevel > 0 and I18N.T(petCfgData.Name).."+"..petData.advanceLevel or I18N.T(petCfgData.Name)
	self.petLv.text.text = petData.level

	local multiply = petCfgData.ConversionRate*0.0001
	self.btnPetAttrs.text.uILocalizeScript:SetContentAndValues("DscAttrToRole", {multiply*100})

	local petStarIcon, textContent = CommonUtil.GetPetSkillStarIconAndColor(petData.skillList)
	CommonUtil.LoadIcon(self, petStarIcon, function (sprite)
		self.advence.image.sprite = sprite
	end)
	self.advenceLv.text.text = textContent
end

function UIRoleMessageView:RefreshPetSkills(petData)
	for i = 1, 3 do
		local data = petData.skillList[i]
		local item = self.skillView["skillItem"..i]
		item:SetActive(data ~= nil)
		if data then
			local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(data.cfgId)
			if skillCfgData then
				local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillItem', item.gameObject)
				itemlua.icon.image.sprite = nil
				if skillCfgData.Icon then
					CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
						itemlua.icon.image.sprite = sprite
					end)

					itemlua.icon.button.enabled = true
					self.uiBase:AddButtonUniqueEventListener(itemlua.icon.button, self, self.OnSkillClick, data)
				end
				itemlua.num.text.text = I18N.T('Lv').. tostring(data.level)
			end
		end
	end
end

function UIRoleMessageView:OnSkillClick(button, params)
	local data = params[0]
	local data = {tipsType = Enum.UITipsType.Skill, cfgId = data.cfgId, num = data.level}
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIRoleMessageView:RefreshPetBaseAttrs(petData)
	if not self.petBaseAttrsList then
		self.petBaseAttrsList = {};
		self.originalAttribute.gameObject:SetActive(false);	--隐藏素体
		for i = 1, 10 do
			local _go = CommonUtil.Instantiate(self.originalAttribute, self.petBaseAttRoot.attributes.gameObject.transform);
			local _nameText = _go.transform:Find("AttributeNameText").gameObject:GetComponent("Text");
			local _valueText = _go.transform:Find("AttributeValueText").gameObject:GetComponent("Text");
			table.insert(self.petBaseAttrsList, {
				["go"] = _go;
				["name"] = _nameText,
				["value"] = _valueText,
			})
		end
	end

	attrsShowState = false
	self.petBaseAttRoot:SetActive(not attrsShowState)
	self.petDetailAttRoot:SetActive(attrsShowState)

	local petActorData = self.controller:GetPetActorDataByPetId(petData.id)
	if not petActorData then
		return
	end

	self.SyncCbId = ManagerContainer.LuaActorAttributeMgr:SyncServerActorData(petActorData,function()
		self:RefreshPetDetailAttrs()
		self:RefreshAttr()
	end
	)

	local attrKeys = {7,8,9,10,11,12,13,14,15,16}
	for i = 1, #attrKeys do
		local key = attrKeys[i]
		local val = petActorData:GetFinalAttr(key)
		val = SDataUtil.InvConvert(val)
		self.petBaseAttrsList[i].name.text = I18N.T("Attr_" .. key)
		val = key > 21 and CommonUtil.GetPreciseDecimal(val, 3) or math.floor(val)
		self.petBaseAttrsList[i].value.text = val
		self.petBaseAttrsList[i].go:SetActive(true)
	end

	self:RefreshPetDetailAttrs()
end

function UIRoleMessageView:RefreshPetDetailAttrs()
	local petData
	if curIndex == 1 then
		petData = self.controller:GetPetDataByHeroId(1)
	else
		local _partnerData = self.controller:GetPartnerData(curIndex);
		petData = self.controller:GetPetDataByHeroId(_partnerData._id)
	end
	if not petData then
		return
	end
	local petActorData = self.controller:GetPetActorDataByPetId(petData.id)
	if not petActorData then
		return
	end

	self.baseList = {}
	self.addList = {}
	for k,v in pairs(attrSortList) do
		if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.CastAcceleration then
			local num = petActorData:GetFinalAttr(v)
			if SDataUtil.IsGreater(num, 0) then
				self.baseList[#self.baseList + 1] = {v, num, 0}
			end
		else
			if v >= Enum.HeroAttrType.Nature_None_Damage_Percent then
				local num = petActorData:GetFinalAttr(v)
				if SDataUtil.IsGreater(num, 0) then
					self.addList[#self.addList + 1] = {v, num, 0}
				end
			end
		end
	end
end

function UIRoleMessageView:RefreshAttr()
	if self.baseView.loopVerticalScrollRect.totalCount ~= #self.baseList then
		self.baseView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.baseView.loopVerticalScrollRect, nil, self.baseList, 0, nil, function (itemLua, idx)
			local data = self.baseList[idx + 1]
			local key = data[1]
			local val = SDataUtil.InvConvert(data[2])
			itemLua.text.text.text = I18N.T("Attr_" .. key)
			itemLua.number.text.text = math.floor(val)
		end)
	else
		self.baseView.loopVerticalScrollRect:RefreshCellsData()
	end

	if self.petAddView.loopVerticalScrollRect.totalCount ~= #self.addList then
		self.petAddView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.petAddView.loopVerticalScrollRect, nil, self.addList, 0, nil, function (itemLua, idx)
			local data = self.addList[idx + 1]
			local key = data[1]
			local val = SDataUtil.InvConvert(data[2])
			local val1 = key > 21 and CommonUtil.GetPreciseDecimalFloor(val, 3) or math.floor(val)
			if val1 <= 0.001 then
				val1 = 0.001
			end     
			itemLua.text.text.text = I18N.T("Attr_" .. key)
			itemLua.number.text.text = CommonUtil.HeroAttrFormatValue(key, val1, true)
		end)
	else
		self.petAddView.loopVerticalScrollRect:RefreshCellsData()
	end
end

function UIRoleMessageView:OnClickPetDetailBtn()
	attrsShowState = true
	self.petBaseAttRoot:SetActive(not attrsShowState)
	self.petDetailAttRoot:SetActive(attrsShowState)

	self:RefreshAttr()

	self.petAddView:SetActive(#self.addList > 0)
	self.petNone:SetActive(#self.addList == 0)
end

function UIRoleMessageView:OnClickPetBaseBtn()
	attrsShowState = false
	self.petBaseAttRoot:SetActive(not attrsShowState)
	self.petDetailAttRoot:SetActive(attrsShowState)
end

function UIRoleMessageView:OnPetAttrsClick(button, params)
	local petData
	if curIndex == 1 then
		petData = self.controller:GetPetDataByHeroId(1)
	else
		local _partnerData = self.controller:GetPartnerData(curIndex);
		petData = self.controller:GetPetDataByHeroId(_partnerData._id)
	end
	if not petData then
		return
	end
	local data = {id = petData.id, cfgId = petData.cfgId, type = 2, baseList = self.baseList, addList = self.addList}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetAttribute, data)
end
-------宠物页面end----

function UIRoleMessageView:RefreshCardSuitBtn()
	local id = 1
	if curIndex > 1 then
		local _partnerData = self.controller:GetPartnerData(curIndex)
		id = _partnerData._id
	end
	local data = self.controller:GetCardBlessData(id)
	local curLv = 0
	if data then
		curLv = data.curLv
	end
	if data and not data.state then
		curLv = curLv - 1
	end
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
	self.cardBlessLv.lv0:SetActive(curLv == 0)
	for i = 1, #allCfgDatas do
		if self.cardBlessLv["lv"..i] then
			self.cardBlessLv["lv"..i]:SetActive(curLv == i)
		end
	end
end

function UIRoleMessageView:OnCardBlessClick()
	local id = 1
	if curIndex > 1 then
		local _partnerData = self.controller:GetPartnerData(curIndex)
		id = _partnerData._id
	end
	local data = self.controller:GetCardBlessData(id)
	if not data then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardBlessTips, data)
end

function UIRoleMessageView:RefreshSkillEquip()
	local skillEquipData
	if curIndex == 1 then
		skillEquipData = self.controller:GetSkillEquipData(1)
	else
		local _partnerData = self.controller:GetPartnerData(curIndex);
		skillEquipData = self.controller:GetSkillEquipData(_partnerData._id)
	end
	local slotlua = self._equipmentSlots[7].lua
	slotlua.iconItem:SetActive(skillEquipData ~= nil and skillEquipData.id > 0)
	if not skillEquipData then
		return
	end
	
	if skillEquipData and skillEquipData.cfgId > 0 then
		IconItemCtr:SetData(self, slotlua.iconItem, skillEquipData, Enum.ItemIEnterType.HeroEquip) 
		self.uiBase:AddButtonUniqueEventListener(slotlua.tipButton.button, self, self.OnSkillEquipClick)
	end
end

function UIRoleMessageView:OnSkillEquipClick(button, params)
	local curSkillEquipData
	if curIndex == 1 then
		curSkillEquipData = self.controller:GetSkillEquipData(1)
	else
		local _partnerData = self.controller:GetPartnerData(curIndex);
		curSkillEquipData = self.controller:GetSkillEquipData(_partnerData._id)
	end
	if not curSkillEquipData or curSkillEquipData.id == 0 then
		return
	end

	local heroData
	if curIndex == 1 then
		heroData = self.controller:GetLeaderHeadData()
	else
		heroData = self.controller:GetPartnerData(curIndex);
	end
	local jobType = heroData._jobData.JobType
	local data = {{cfgId = curSkillEquipData.cfgId, jobType = jobType, logicData = curSkillEquipData, heroId = heroData._id, heroCfgId = heroData._jobCfgId, nickname = heroData._name}, Enum.ItemIEnterType.Bag, Enum.UIPageName.UIBag}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, data)
end

return UIRoleMessageView

