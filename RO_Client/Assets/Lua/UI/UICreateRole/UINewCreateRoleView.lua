local UINewCreateRoleView = require("UICreateRole/UINewCreateRoleView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")
local BoxCollider = typeof(UnityEngine.BoxCollider)

local maleViewSystem = nil
local femaleViewSystem = nil

function UINewCreateRoleView:OnAwake(data)
	self.controller = require("UICreateRole/UINewCreateRoleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINewCreateRoleView:AddEventListener()
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SELECT_ROLE,self,self.OnSelectRole);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_USED_ACTIVATIONCODE,self,self.OnUsedActivationCode)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CLOSED_ACTIVATIONCODE,self,self.OnCloseActivationCode)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CREATE_ROLE_FAILED,self,self.OnCreateRoleFailed)
end

function UINewCreateRoleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self.firstSelected = true
	self:Init()
	self:InitComs(false)
	self.notice:SetActive(false)
	self.delayShowNoticeTimer = ManagerContainer.LuaTimerMgr:AddTimer(3000, 1, self, self.DelayShowNotice, nil)
end

function UINewCreateRoleView:DelayShowNotice()
	self.notice:SetActive(true)
end

function UINewCreateRoleView:Init()
	LuaBattleBridge.SetCreateRoleLuaTable(self.controller)
	
	self.malePos = ManagerContainer.LuaGameMgr.CreateMaleRoot.transform.position
	self.femalePos = ManagerContainer.LuaGameMgr.CreateFemaleRoot.transform.position
	self.showPos = ManagerContainer.LuaGameMgr.CreateShowRoot.transform.position

	LuaBattleBridge.ShowCreateRoleCam()
	self.sendCreateRole = nil
	self.sendCreateRoleTime = nil
	self.IsOpeningActivationCodePage = false
	self.backBtn:SetActive(false)

	if not SDKMgr.Instance:IsReportAction() then
		return
	end

	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'ShowCharacter')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)
	self:StartUpdateCheck()
end

function UINewCreateRoleView:InitComs(vis)
	self.confirmBtn:SetActive(vis)
	-- self.backBtn:SetActive(vis)
	self.shadow:SetActive(vis)
	self.grass:SetActive(vis)
	self.notice:SetActive(not vis)
end

function UINewCreateRoleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINewCreateRoleView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.confirmBtn.button,self, self.OnClickCreateRole)
	-- self.uiBase:AddButtonEventListener(self.backBtn.button,self,self.OnClickBack)
end

function UINewCreateRoleView:OnHide()

end

function UINewCreateRoleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UINewCreateRoleView:OnClose()
	if self.delayCreateRoleTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.delayCreateRoleTimer)
		self.delayCreateRoleTimer = nil
	end

	if self.delayHideRoleTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.delayHideRoleTimer)
		self.delayHideRoleTimer = nil
	end

	if self.delayShowNoticeTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.delayShowNoticeTimer)
		self.delayShowNoticeTimer = nil
	end

	self.selectGo = nil
	ManagerContainer.LuaGameMgr:SetCreateRoleStatus(false)
	LuaBattleBridge.ClearCreateRole()
end

function UINewCreateRoleView:OnDispose()
	self.startAnimEnd = nil
end

function UINewCreateRoleView:OnClickCreateRole()
	if self:IsSendCreating() then
		return
	end
	self.activationCode = nil

	if ManagerContainer.LuaGameMgr.IsActivationCodeMode then
		self:OnOpenActivationCodePage()
	else
		self:HandleCreateRole()
	end
end

function UINewCreateRoleView:OnCloseActivationCode()
	self.IsOpeningActivationCodePage = false
end

function UINewCreateRoleView:OnUsedActivationCode(code)
	self.IsOpeningActivationCodePage = false
	self.activationCode = code
	self:HandleCreateRole()

end

function UINewCreateRoleView:HandleCreateRole()
	if self.controller:GetSexType() == Enum.SexType.Man then
		if self.controller.maleAnimator ~= nil then
			-- self.controller.maleAnimator:Play("f_show")
		end
	else
		if self.controller.femaleAnimator ~= nil then
			-- self.controller.femaleAnimator:Play("f_show")
		end
	end
	if self:IsSendCreating() then return end
	self.sendCreateRole = true
	self.sendCreateRoleTime = ManagerContainer.LuaTimerMgr.GetTimeSecond()
	self.controller:OnCreateClick(self.activationCode)

	
	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'StartGame')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)
end

function UINewCreateRoleView:DelayCreateRole()
	ManagerContainer.DataMgr.UserData:StartEnterGame(true)
end

function UINewCreateRoleView:DelayHideRole()
	LuaBattleBridge.SetGameObjectLayerFrom(ManagerContainer.LuaGameMgr.CreateMaleRoot,"Fighter","Hide")
	LuaBattleBridge.SetGameObjectLayerFrom(ManagerContainer.LuaGameMgr.CreateFemaleRoot,"Fighter","Hide")
end

function UINewCreateRoleView:OnCreateRoleFailed(error)
	if error == Enum.NetErrorCode.ERROR_OK then
		self.sendCreateRoleTime = nil
		LuaBattleBridge.PlayCreateRoleTransferEffect()
		self.delayCreateRoleTimer = ManagerContainer.LuaTimerMgr:AddTimer(GlobalConfig.Instance:GetConfigFloatValue(135)*1000, 1, self, self.DelayCreateRole, nil)
		self.delayHideRoleTimer = ManagerContainer.LuaTimerMgr:AddTimer(GlobalConfig.Instance:GetConfigFloatValue(136)*1000, 1, self, self.DelayHideRole, nil)
	else
		self.sendCreateRole = nil
		self.sendCreateRoleTime = nil
		LuaBattleBridge.SetGameObjectLayerFrom(ManagerContainer.LuaGameMgr.CreateMaleRoot,"Hide","Fighter")
		LuaBattleBridge.SetGameObjectLayerFrom(ManagerContainer.LuaGameMgr.CreateFemaleRoot,"Hide","Fighter")

		-- 激活码错误
		if error == Enum.NetErrorCode.ERROR_ROLE_ACTIVE_CODE_ERROR or error == Enum.NetErrorCode.ERROR_ROLE_ACTIVECODE_USED then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("冒险码错误!")
		end
	end
end

function UINewCreateRoleView:OnOpenActivationCodePage()
	self.IsOpeningActivationCodePage = true
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivationCodePage)
end

function UINewCreateRoleView:OnClickBack()

	-- if self.selectGo == nil then
	-- 	return
	-- end

	-- if self.controller:GetSexType() == Enum.SexType.Man then
	-- 	LuaBattleBridge.PlayCamAnim("CM_vcam5",false)
	-- 	if self.controller.maleAnimator ~= nil then
	-- 		self.controller.maleAnimator:Play("f_go")
	-- 	end
	-- 	if self.controller.femaleAnimator ~= nil then
	-- 		self.controller.femaleAnimator:Play("f_Ahead")
	-- 	end
	-- else
	-- 	LuaBattleBridge.PlayCamAnim("CM_vcam4",false)
	-- 	if self.controller.femaleAnimator ~= nil then
	-- 		self.controller.femaleAnimator:Play("f_go")
	-- 	end
	-- 	if self.controller.maleAnimator ~= nil then
	-- 		self.controller.maleAnimator:Play("f_Ahead")
	-- 	end
	-- end

	-- self.controller:SetSexType(nil)
	-- self:InitComs(false)
	-- LuaBattleBridge.CloseDof()
end

function UINewCreateRoleView:OnSelectRole(isMale,go)
	LogWarning(" OnSelectRole ")

	if self.IsOpeningActivationCodePage then
		return false
	end

	if self:IsSendCreating() then
		return false
	end

	if not self.startAnimEnd then
		if LuaBattleBridge.IsPlayCamAnimEnd("CM_vcam1") then
			self.startAnimEnd = true
		else
			return false
		end
	end
	
	-- if self.controller:GetSexType() ~= nil then
	-- 	self:CancelSelected()
	-- 	return
	-- end

	-- LogError("OnSelectRole = " .. tostring(isMale) .." type=" .. tostring(self.controller:GetSexType()))
	if self.controller:GetSexType() == Enum.SexType.Man and isMale then
		return false
	end

	if self.controller:GetSexType() == Enum.SexType.Woman and isMale == false then
		return false
	end

	self.selectGo = go
	if isMale then
		self.controller:SetSexType(Enum.SexType.Man)
		if self.firstSelected then
			LuaBattleBridge.PlayCamAnim("CM_vcam3",true)
			if self.controller.maleAnimator ~= nil then
				self.controller.maleAnimator:Play("f_Ahead_down")
			end
			if self.controller.femaleAnimator ~= nil then
				self.controller.femaleAnimator:Play("f_Ahead_go")
			end
		else
			LuaBattleBridge.PlayCamAnim("CM_vcam5",true)
			if self.controller.maleAnimator ~= nil then
				self.controller.maleAnimator:Play("f_back")
			end
			if self.controller.femaleAnimator ~= nil then
				self.controller.femaleAnimator:Play("f_Ahead_go")
			end
		end
	else
		self.controller:SetSexType(Enum.SexType.Woman)
		if self.firstSelected then
			LuaBattleBridge.PlayCamAnim("CM_vcam2",true)
			if self.controller.maleAnimator ~= nil then
				self.controller.maleAnimator:Play("f_Ahead_go")
			end
			if self.controller.femaleAnimator ~= nil then
				self.controller.femaleAnimator:Play("f_Ahead_down")
			end
		else
			LuaBattleBridge.PlayCamAnim("CM_vcam4",true)
			if self.controller.femaleAnimator ~= nil then
				self.controller.femaleAnimator:Play("f_back")
			end
			if self.controller.maleAnimator ~= nil then
				self.controller.maleAnimator:Play("f_Ahead_go")
			end
		end
	end
	self:InitComs(true)
	self.firstSelected = false


	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'ConfirmRole')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)

	-- self:OnClickCreateRole()

	return true
end

function UINewCreateRoleView:CancelSelected()
	if self.IsOpeningActivationCodePage then
		return
	end

	self:OnClickBack()
end

function UINewCreateRoleView:IsSendCreating()
	if not self.sendCreateRole then
		return false
	end
	if self.sendCreateRoleTime then
		if ManagerContainer.LuaTimerMgr.GetTimeSecond() - self.sendCreateRoleTime > 10 then
			return false
		end
	end
	return true
end

return UINewCreateRoleView

