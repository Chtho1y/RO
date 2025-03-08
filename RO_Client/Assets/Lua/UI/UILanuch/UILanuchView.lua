local UILanuchView = require("UILanuch/UILanuchView_Generate")

function UILanuchView:OnAwake(data)
	self.controller = require("UILanuch/UILanuchCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UILanuchView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_IN_END_NTF, self, self.OnUIViewOpenAnimEnd)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Begin, self, self.OnLoadingBegin)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Progress, self, self.OnLoadingProgress)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Complete, self, self.OnLoadingComplete)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Close, self, self.OnLoadingClose)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_ENTER_CREATE_ROLE, self, self.OnEnterCreateRole)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CURRENT_SERVER_CHANGED, self, self.OnCurrentServerChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CURRENT_SPECIAL_INFO_CHANGED, self, self.OnCurrentSpecialInfoChanged)
end

function UILanuchView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UILanuchView:Init()
	if ManagerContainer.LoginMgr.relogin then
		self.loginAnim.animator:Play('LoginShow', -1)
		self.loginAnim.animator:Update(0)
	else
		self.loginAnim.animator:Play('LoginKeep')
	end
	self.loginRoot:SetActive(false)
	self.loadingRoot:SetActive(false)
	self.logo:SetActive(true)
	self.serverBtnState = nil
	self:RefreshServer()
	self:RefreshVersionCode()
	self:RefreshSpecialInfo()
	if PlatformPack.ShowHealthBulletin then
		self.editionTxt:SetActive(true)
	else
		self.editionTxt:SetActive(false)
	end

end

function UILanuchView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UILanuchView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnEnter.button, self, self.OnClickEnterBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnServer.button, self, self.OnClickServerBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnNotice.button, self, self.OnClickNoticeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCADPA.button, self, self.OnClickCadpaBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnShare.button, self, self.onShareClick)
	self.uiBase:AddButtonUniqueEventListener(self.btnStartRecord.button, self, self.onStartRecord)
	self.uiBase:AddButtonUniqueEventListener(self.btnStopRecord.button, self, self.onStopRecord)
	self.uiBase:AddButtonUniqueEventListener(self.btnBindTicktok.button, self, self.onBindTickTok)
	self.uiBase:AddButtonUniqueEventListener(self.btnCreateDesktop.button, self, self.onCreateDesk)
	self.uiBase:AddButtonUniqueEventListener(self.btnPageAD.button, self, self.onShowAd)
end

function UILanuchView:onShareClick()
	LogWarning("onShareClick ");
	SDKMgr.Instance:Share()

end

function UILanuchView:onStartRecord()
	LogWarning("onStartRecord ");
	SDKMgr.Instance:StartRecord()

end

function UILanuchView:onStopRecord()
	LogWarning("onStopRecord ");
	SDKMgr.Instance:StopRecord()
end

function UILanuchView:onBindTickTok()
	LogWarning("onBindTickTok ");
	SDKMgr.Instance:BindTickTok()

end

function UILanuchView:onCreateDesk()
	LogWarning("onCreateDesktop ");
	SDKMgr.Instance:CreateInDesktop()

end

function UILanuchView:onShowAd()
	LogWarning("onShowAd ");
	-- SDKMgr.Instance:ShowInterstitialAd()
    ManagerContainer.LuaGameMgr:SdkPay("10001", "test", '感谢您的支付，祝你有个愉快的游戏体验', 1, CommonUtil.GetValidPayPrice(1), "10001001", nil)

end

function UILanuchView:OnHide()

end

function UILanuchView:OnShow(data)
	self.controller:SetData(data)

end

function UILanuchView:OnClose()
end

function UILanuchView:OnDispose()
	self.serverBtnState = nil
	if self.enterTimer then
		self.enterTimer:Stop()
		self.enterTimer = nil
	end
	self.createRole = nil
	self.uiMainOpenWaiting = nil
	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	self.uiNewStoryOpenWaiting = nil
	self.uiNewCreateRoleOpenWaiting = nil
	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end
	self.controller:OnDispose()
end

function UILanuchView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	if ManagerContainer.LoginMgr.relogin then
		if self.enterTimer then
			self.enterTimer.duration = 2
			self.enterTimer.loop = 1
			self.enterTimer.time = 2
		else
			self.enterTimer = Timer.New(slot(self.UpdateEnterTimer, self), 2, 1)
		end
		if not self.enterTimer.running then
			self.enterTimer:Start()
		end
	else
		self:UpdateEnterTimer()
	end
end

function UILanuchView:UIClose()
	self.super.UIClose(self)
	self.loadEndTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
	if self.loadStartTime and self.loadEndTime then
		SDKMgr.Instance:ReportLoad(int64.new(self.loadEndTime) * 1000, (self.loadEndTime - self.loadStartTime))
	end
end

function UILanuchView:OnUIViewOpenAnimEnd(id)
	if not id then return end
	if self.createRole then
		if self.uiNewStoryOpenWaiting then
			if id == Enum.UIPageName.UINewStory then
				self:ReadyCreateRoleUINewStory()
			end
		end
		if self.uiNewCreateRoleOpenWaiting then
			if id == Enum.UIPageName.UINewCreateRole then
				self:ReadyCreateRoleUINewCreateRole()
			end
		end
	else
		if self.uiMainOpenWaiting then
			if id == Enum.UIPageName.UIMain then
				self:BeginEnter()
			end
		end
	end
end

function UILanuchView:OnLoadingBegin()
	LogWarning("lua端启动  开始加载 ")

	self.loginAnim.animator:Play('LoginKeep', -1)
	self.loginAnim.animator:Update(0)
	self.loginAnim.animator.enabled = false
	self.loginRoot:SetActive(false)
	self.loadingRoot:SetActive(true)
	self.text.text.text = string.formatbykey('GameLogin16')
	self.scrollbar.scrollbar.size = 0
	self.numberText.text.text = "0%"
	self.loadStartTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
end

function UILanuchView:OnLoadingProgress(progress)
	LogWarning("lua 加载资源--->  "..progress)

	progress = Mathf.Clamp01(progress)
	if self.createRole then
		progress = progress * 0.5
	end
	local curProgress = self.scrollbar.scrollbar.size
	if progress <= curProgress then return end
	self.scrollbar.scrollbar.size = progress
	self.numberText.text.text = math.floor(progress*100).."%"
end

function UILanuchView:OnLoadingComplete()
	LogWarning("lua端启动  加载完成 ")
	if self.createRole then
		self.scrollbar.scrollbar.size = 0.5
		self.numberText.text.text = "50%"
	else
		self.scrollbar.scrollbar.size = 1
		self.numberText.text.text = "100%"
	end
end

function UILanuchView:OnLoadingClose()
	self.loginRoot:SetActive(false)
	if self.createRole then
		self:ReadyCreateRoleScene()
	else
		if ManagerContainer.DataMgr.UserData:HasPassedNewbie() then
			if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) then
				self.uiMainOpenWaiting = true
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMain)
				return
			end
		end
		self:BeginEnter()
	end
end

function UILanuchView:OnEnterCreateRole()
	self.createRole = true
	self:OnLoadingBegin()
end

function UILanuchView:OnCurrentServerChanged()
	self:RefreshServer()
end

function UILanuchView:OnCurrentSpecialInfoChanged()
	self:RefreshSpecialInfo()
end


function UILanuchView:OnClickEnterBtn()
	ManagerContainer.LoginMgr.waitClicked = true
	LogWarning("OnClickEnterBtn -----------------")

	if not SDKMgr.Instance:IsReportAction() then
		return
	end

	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'ClickStart')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)
end

function UILanuchView:OnClickServerBtn()
	local serverData = ManagerContainer.LuaGameMgr.serverData
	if not serverData or not serverData.id or serverData.id <= 0 then
		return
	end
	if not ManagerContainer.LoginMgr:IsLoginWaiting() then
		return
	end
	
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeServer, true, nil, nil, nil, Enum.UISibling[Enum.UIType.Top] - 2)

	LogWarning("Loading finish -----------------")
	if not SDKMgr.Instance:IsReportAction() then
        return
    end

	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'ChooseArea')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)

end

function UILanuchView:OnClickNoticeBtn()
	if not ManagerContainer.LoginMgr:IsLoginWaiting() then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINotifyTips)
end

function UILanuchView:OnClickCadpaBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISimpleNotice, {'AntiAddictionTitle', 'AntiAddictionTips'}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top] - 2)
end

function UILanuchView:UpdateEnterTimer()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loaded_Page_OK)
	self.loginRoot:SetActive(true)
	self.loadingRoot:SetActive(false)
	self.serverBtnState = 0
	self:RefreshServer()
	self:RefreshVersionCode()
end

function UILanuchView:ReadyCreateRoleScene()
	self.createRoleImg:SetActive(true)
	self.createRoleImg.image.enabled = false
	self.createRoleImg.image.sprite = nil
	CommonUtil.LoadIcon(self, 'NewStory/img_login02', function(sprite)
		self.createRoleImg.image.sprite = sprite
		self.createRoleImg.image.enabled = true
		self:ReadyCreateRoleLanuchImg()
	end)
end

function UILanuchView:ReadyCreateRoleLanuchImg()
	self.scrollbar.scrollbar.size = 0.8
	self.numberText.text.text = "80%"
	-- if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UINewStory) then
	-- 	self.uiNewStoryOpenWaiting = true
	-- 	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINewStory)
	-- 	return
	-- end
	LuaBattleBridge.PlayCamAnim("CM_vcam1",true)

	self:ReadyCreateRoleUINewStory()
end

function UILanuchView:ReadyCreateRoleUINewStory()
	self.uiNewStoryOpenWaiting = nil
	self.scrollbar.scrollbar.size = 0.9
	self.numberText.text.text = "90%"
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UINewCreateRole) then
		self.uiNewCreateRoleOpenWaiting = true
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINewCreateRole)
		return
	end
	self:ReadyCreateRoleUINewCreateRole()
end

function UILanuchView:ReadyCreateRoleUINewCreateRole()
	self.uiNewCreateRoleOpenWaiting = nil
	self.scrollbar.scrollbar.size = 1
	self.numberText.text.text = "100%"

	-- if self.delayTimer then
	-- 	self.delayTimer.duration = 0.1
	-- 	self.delayTimer.loop = 1
	-- 	self.delayTimer.time = 0.1
	-- else
	-- 	self.delayTimer = Timer.New(slot(self.BeginEnterCreateRole, self), 0.1, 1)
	-- end
	-- if not self.delayTimer.running then
	-- 	self.delayTimer:Start()
	-- end

	self:BeginEnterCreateRole()
end

function UILanuchView:BeginEnterCreateRole()
	self.loadingRoot:SetActive(false)
	self.loginAnim.animator.enabled = true
	self.loginAnim.animator:Play('LoginStory', -1)
	self.loginAnim.animator:Update(0)
	self:UIClose()

	-- LuaBattleBridge.BeginTweenPosition(self.loginBG, 4, Vector3.New(0, -1920, 0), false)
	-- if self.closeTimer then
	-- 	self.closeTimer.duration = 7
	-- 	self.closeTimer.loop = 1
	-- 	self.closeTimer.time = 7
	-- else
	-- 	self.closeTimer = Timer.New(slot(self.UIClose, self), 7, 1)
	-- end
	-- if not self.closeTimer.running then
	-- 	self.closeTimer:Start()
	-- end

end

function UILanuchView:BeginEnter()
	self.uiMainOpenWaiting = nil
	self.loadingRoot:SetActive(false)
	self.loginAnim.animator.enabled = true
	self.loginAnim.animator:Play('LoginStart', -1)
	self.loginAnim.animator:Update(0)
	if self.closeTimer then
		self.closeTimer.duration = 2
		self.closeTimer.loop = 1
		self.closeTimer.time = 2
	else
		self.closeTimer = Timer.New(slot(self.UIClose, self), 2, 1)
	end
	if not self.closeTimer.running then
		self.closeTimer:Start()
	end
end

function UILanuchView:RefreshServer()
	local serverData = ManagerContainer.LuaGameMgr.serverData
	if not serverData or not serverData.id or serverData.id <= 0 then
		if self.serverBtnState and self.serverBtnState ~= 1 then
			self.serverRoot.animator:CrossFade('ServerListLoading', 0.2)
			self.serverBtnState = 1
		end
		return
	end
	if self.serverBtnState and self.serverBtnState ~= 2 then
		self.serverRoot.animator:CrossFade('ServerListShow', 0.2)
		self.serverBtnState = 2
	end
	self.serverText.text.text = tostring(serverData.name)
end

function UILanuchView:RefreshVersionCode()
	self.appVol.contentTxt.text.text = tostring(ManagerContainer.LuaGameMgr.GameVersion)
	self.resVol.contentTxt.text.text = tostring(ManagerContainer.LuaGameMgr.ResVersion)
end

function UILanuchView:RefreshSpecialInfo()
	if not ManagerContainer.LoginMgr:IsAgreement() then
		self.agreement:SetActive(false)
		return
	end
	self.agreement:SetActive(true)
	local agreement = ManagerContainer.LoginMgr:GetAgreement()
	self.agreement.text.text.text = tostring(agreement)
	local isOn = ManagerContainer.PlayerPrefsMgr:GetGlobalBoolean(Constant.AGREEMENT_RECORD_KEY, false)
	self.agreement.toggle.toggle.isOn = isOn
	self.uiBase:AddToggleUniqueEventListener(self.agreement.toggle.toggle, self, self.OnClickAgreementTogge)
	self.uiBase:AddButtonUniqueEventListener(self.agreement.text.button, self, self.OnClickAgreementText)
end

function UILanuchView:OnClickAgreementTogge(_, _, isOn)
	local isOnOld = ManagerContainer.PlayerPrefsMgr:GetGlobalBoolean(Constant.AGREEMENT_RECORD_KEY, false)
	if isOnOld == isOn then
		return
	end
	ManagerContainer.PlayerPrefsMgr:SetGlobalBoolean(Constant.AGREEMENT_RECORD_KEY, isOn)
end

function UILanuchView:OnClickAgreementText()
	local text = self.agreement.text.text
	local linkIndex = TMPro.TMP_TextUtilities.FindIntersectingLink(text, UnityEngine.Input.mousePosition, CameraMgr.Instance.UICamera);
	if linkIndex < 0 then
		return
	end
	local linkInfo = text.textInfo.linkInfo[linkIndex]
	if not linkInfo then
		return
	end
	local url = linkInfo:GetLinkID()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISimpleWeb, url, nil, nil, nil, Enum.UISibling[Enum.UIType.Top] - 2)
end

return UILanuchView

