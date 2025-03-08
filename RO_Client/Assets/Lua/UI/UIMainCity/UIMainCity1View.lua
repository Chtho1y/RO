local UIMainCity1View = require("UIMainCity/UIMainCity1View_Generate")
local ConditionJudge = require("Common/ConditionJudge")
local TaskJumpCtr = require("Common/TaskJumpCtr")

function UIMainCity1View:OnAwake(data)
	self.controller = require("UIMainCity/UIMainCity1Ctr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIMainCity1View:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.WORLD_BOSS_LIST_CHANGED, self, self.OpenWorldBoss)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_RELATION_OPEN_NTF, self, self.OpenPetRelation)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_ENVELOPE_REMAIN_TIME_REFRESH, self, self.OnRedEnvelopeRemainTimeRefresh)
end

function UIMainCity1View:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIMainCity1View:Init()
	--self:OnCheckFriendRedpoint()

	--ManagerContainer.LuaUIMgr:OpenLimitRechargeUI()

	self:RefreshAllDataState()
	self:RefreshBtnsDisplayState()
end

function UIMainCity1View:RefreshAllDataState()

	--时装红点
	ManagerContainer.DataMgr.FashionData:RefreshAllFashionLvUpNotify()
end


function UIMainCity1View:RefreshBtnsDisplayState()
	if not Constant.OpenPay then
		self.redEnvelope:SetActive(false)
		return
	end
	--现金红包
	local reActItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(Enum.ActivityType.ACTIVITY_TYPE_CASH_SHOP)
	local state = reActItem and reActItem:IsUnlocked() and reActItem:IsOpened() and not reActItem:IsOutofDate()
	self.redEnvelope:SetActive(state)
	self:OnRedEnvelopeRemainTimeRefresh()
end

function UIMainCity1View:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMainCity1View:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnEquipForge.button, self, self.OpenEquipForgeUI)
	self.uiBase:AddButtonEventListener(self.btnCard.button, self, self.OpenCardUI)
	self.uiBase:AddButtonEventListener(self.btnMail.button, self, self.OpenMailUI)
	self.uiBase:AddButtonEventListener(self.btnArena.button, self, self.OpenArenaUI)
	self.uiBase:AddButtonEventListener(self.btnWorldBoss.button, self, self.OpenWorldBoss)
	self.uiBase:AddButtonEventListener(self.btnFashion.button, self, self.OpenFashion)
	self.uiBase:AddButtonEventListener(self.btnFriend.button,self,self.OpenFriendListPage)
	self.uiBase:AddButtonEventListener(self.btnNotifyActivity.button,self,self.OpenNoticeAndActivity)
	self.uiBase:AddButtonEventListener(self.btnSign.button,self,self.OpenSignIn)
	self.uiBase:AddButtonEventListener(self.btnClimbingTower.button,self,self.OpenClimbingTowerPage)
	self.uiBase:AddButtonEventListener(self.btnEvil.button,self,self.OpenSkillExpBattlePage)
	self.uiBase:AddButtonEventListener(self.btnGuild.button, self, self.OnClickGuildBtn)
	self.uiBase:AddButtonEventListener(self.btnExpedition.button, self, self.OnClickExpeditionBtn)
	self.uiBase:AddButtonEventListener(self.btnSummon.button, self, self.OnClickSummonBtn)
	self.uiBase:AddButtonEventListener(self.redEnvelope.btnSmall.button, self, self.OnRedEnvelope)
	self.uiBase:AddButtonEventListener(self.btnDojo.button, self, self.OnClickHundredDojoBtn)
	self.uiBase:AddButtonEventListener(self.btnKapula.button, self, self.OnClickKapulaBtn)
	self.uiBase:AddButtonEventListener(self.btnAirship.button, self, self.OnClickVoyageBtn)
end

function UIMainCity1View:OpenEquipForgeUI()
	-- ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForge1, Enum.EquipForgeType[Enum.ForgeType.Sword])
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, nil, self.uiData.id)
end

function UIMainCity1View:OpenCardUI()
	--self:UIHide(false)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardList, Enum.CardFuncType.Recreate, self.uiData.id)
	--ManagerContainer.DataMgr.CollectionBookData:QueryCardHandBook(Enum.UIPageName.UIMainCity1)

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICollect, nil, self.uiData.id)
end

function UIMainCity1View:OpenMailUI()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMailBox, nil, self.uiData.id)
end

function UIMainCity1View:OpenArenaUI()
	ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIDojo2D)
end

function UIMainCity1View:OpenWorldBoss()
	TaskJumpCtr:OpenWorldBoss(self.uiData.id);
end

function UIMainCity1View:OpenFashion()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashion, nil, self.uiData.id)
end

function UIMainCity1View:OpenFriendListPage()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFriendList, nil, self.uiData.id)
end

function UIMainCity1View:OnClickExpeditionBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpedition, false, self.uiData.id)
end

function UIMainCity1View:OpenClimbingTowerPage()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTower,nil, self.uiData.id)
end

function UIMainCity1View:OpenSkillExpBattlePage()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillExpBattle,nil, self.uiData.id)
end

function UIMainCity1View:OpenNoticeAndActivity()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINotifyActivityTips)
end

function UIMainCity1View:OpenSignIn()
	--ManagerContainer.DataMgr.SignData:CSSignUpReq(1, Enum.UIPageName.UIMainCity1, function ()
	--	self:UIHide(false)
	--end);
	--ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SIGN_UP_INFO_REQ)

	ManagerContainer.DataMgr.PetDataMgr:QueryPetRelation()
end

function UIMainCity1View:OpenPetRelation()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetRelations)
end

function UIMainCity1View:OnClickGuildBtn()
	local state = ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataState()
	if state == Enum.GuildDataState.NoGuild then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildRecommend, nil, self.uiData.id)
	elseif state == Enum.GuildDataState.HasGuild then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildMain, nil, self.uiData.id)
	else
		local errorCode = ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataStateErrorCode()
		if errorCode then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIMainCity1View:OnClickSummonBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummon, nil, self.uiData.id)
end

function UIMainCity1View:OnRedEnvelope()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIREShop, nil, self.uiData.id)
end

function UIMainCity1View:OnClickHundredDojoBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojo, nil, self.uiData.id)
end

function UIMainCity1View:OnClickKapulaBtn()
	local _nickName = ManagerContainer.DataMgr.UserData:GetOriUserNickname()
	if _nickName == "" or _nickName == nil or _nickName == "NickName" then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChangeName")
		return
    end
	ManagerContainer.DataMgr.UserData:SyncRoleDataToSDK()
	SDKMgr.Instance:OpenGM()
end

function UIMainCity1View:OnClickVoyageBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyage, nil, self.uiData.id)
end

function UIMainCity1View:CloseInputMask()
	ManagerContainer.LuaUIMgr:CloseInputMask()
end

function UIMainCity1View:OnRedEnvelopeRemainTimeRefresh()
	local reActItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(Enum.ActivityType.ACTIVITY_TYPE_CASH_SHOP)
	local state = reActItem and reActItem:IsUnlocked() and reActItem:IsOpened() and not reActItem:IsOutofDate()
	if not state then
		if self.redEnvelope.activeSelf then
			self.redEnvelope:SetActive(false)
		end
		return
	end

	local leftSeconds = reActItem:LeftTime()
	if leftSeconds > 0 then
		if leftSeconds <= 60 then
			self.redEnvelope.text.text.text = I18N.T("LessOneMinu")
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(leftSeconds, true, false)
			self.redEnvelope.text.text.text = time
		end
	else
		if self.redEnvelope.activeSelf then
			self.redEnvelope:SetActive(false)
		end
	end
end

function UIMainCity1View:OnHide()

end

function UIMainCity1View:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIMainCity1View:OnClose()
end

function UIMainCity1View:OnDispose()

end

return UIMainCity1View

