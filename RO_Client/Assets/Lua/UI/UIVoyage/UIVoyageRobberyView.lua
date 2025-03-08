local UIVoyageRobberyView = require("UIVoyage/UIVoyageRobberyView_Generate")

function UIVoyageRobberyView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyageRobberyCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyageRobberyView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_CHALLENGE_NUM_CHANGED, self, self.RefreshRobNum)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_CHECK_AIRSHIP_CHANGED, self, self.OnCheckAirShipChanged)
end

function UIVoyageRobberyView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyageRobberyView:Init()
	local trans = self.transform:Find('UIAnimator/Window/BG/Content/ShipHolder/AirShipItem')
	local item = {}
	item.gameObject = trans.gameObject
	item.transform = trans
	item.animator = trans:GetComponent(Enum.TypeInfo.Animator)
	item.me = trans:Find("Me").gameObject
	item.fan = trans:Find("Ship/Fan").gameObject
	item.switchSprite = trans:Find("Ship/Body"):GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
	self.airShipItem = item
	self.controller:InitData()
	self:RefreshView()
	self:RefreshRobNum()
end

function UIVoyageRobberyView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIVoyageRobberyView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCancle.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnChallenge.button, self, self.OnClickChallengeBtn)
end

function UIVoyageRobberyView:OnHide()

end

function UIVoyageRobberyView:OnShow(data)
	self.controller:SetData(data)

end

function UIVoyageRobberyView:OnClose()
end

function UIVoyageRobberyView:OnDispose()
	if self.endTimer then
		self.endTimer:Stop()
		self.endTimer = nil
	end
	self.airShipItem = nil
	self.controller:OnDispose()
end

function UIVoyageRobberyView:OnCheckAirShipChanged(uid)
	local airShipData = self.controller:GetAirShipData()
	if airShipData and airShipData.uid == uid then
		local name = airShipData:GetName()
		if not name then
			self.nameSp:SetActive(false)
		else
			self.nameSp:SetActive(true)
			self.nameTxt.text.text = string.formatbykey('RobShipName', airShipData:GetServerId(), name)
		end
	end
end

function UIVoyageRobberyView:OnClickCloseBtn()
	self:UIClose()
end

function UIVoyageRobberyView:OnClickChallengeBtn()
	local airShipData = self.controller:GetAirShipData()
	if not airShipData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips01')
		return
	end
	local selfuid = ManagerContainer.DataMgr.UserData:GetUserId()
	if airShipData.uid == selfuid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips02')
		return
	end
	local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(airShipData.quality)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local sec = (airShipData.endTime - curTime) / 1000
	sec = type(sec) == "number" and sec or #sec
	local time = airShipData.duration or 1
	if sec > time then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips03')
		return
	elseif sec <= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageFinishTips')
		return
	end
	local errorCode = self.controller:SendChallengeReq(airShipData.uid, airShipData.endTime)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyageRobberyView:RefreshRobNum()
	self.robNum.text.text = tostring(self.controller:GetRemindRobNum())
end

function UIVoyageRobberyView:RefreshView()
	if self.endTimer then
		self.endTimer:Stop()
	end
	local airShipData = self.controller:GetAirShipData()
	if airShipData then
		local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(airShipData.quality)
		if cfgData then
			local rewards = cfgData.RobberyReward
			if rewards then
				self:RefreshCurrencyItem(self.currency1, rewards[1])
				self:RefreshCurrencyItem(self.currency2, rewards[2])
				self:RefreshCurrencyItem(self.currency3, rewards[3])
			else
				self:RefreshCurrencyItem(self.currency1, nil)
				self:RefreshCurrencyItem(self.currency2, nil)
				self:RefreshCurrencyItem(self.currency3, nil)
			end
			self.airShipItem.gameObject:SetActive(true)
			self.timer:SetActive(true)
			self:RefreshEndTimer()
			local name = airShipData:GetName()
			if not name then
				self.nameSp:SetActive(false)
				self.controller:SendCheckInfoReq(airShipData.uid, airShipData.endTime)
			else
				self.nameSp:SetActive(true)
				self.nameTxt.text.text = string.formatbykey('RobShipName', airShipData:GetServerId(), name)
			end
			return
		end
	end
	self:RefreshCurrencyItem(self.currency1, nil)
	self:RefreshCurrencyItem(self.currency2, nil)
	self:RefreshCurrencyItem(self.currency3, nil)
	self.beRobNum.text.text = '0/0'
	self.airShipItem.gameObject:SetActive(false)
	self.nameSp:SetActive(false)
	self.timer:SetActive(false)
	self.btnChallenge:SetActive(false)
end

function UIVoyageRobberyView:RefreshEndTimer()
	local airShipData = self.controller:RefreshAndGetAirShipData()
	if not airShipData then
		self:RefreshView()
		return
	end
	local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(airShipData.quality)
	if not cfgData then
		self:RefreshView()
		return
	end
	self.airShipItem.animator:Play('AirShipRun')
	local quality = self.controller:RefreshQuality()
	local beChallengeNum = self.controller:RefreshBeChallengeNum()
	if beChallengeNum then
		self.beRobNum.text.text = tostring(beChallengeNum) .. '/' .. tostring(cfgData.RobberyTimes)
		if beChallengeNum >= cfgData.RobberyTimes then
			quality = 0
		end
	end
	if quality then
		self.airShipItem.switchSprite:ChangeSprite(quality)
		self.airShipItem.fan:SetActive(quality > 0)
	end
	local remainTime = (airShipData.endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()) / 1000
	remainTime = type(remainTime) == "number" and remainTime or #remainTime
	self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
	if remainTime <= 0 then
		if self.endTimer then
			self.endTimer:Stop()
		end
	else
		if not self.endTimer then
			self.endTimer = Timer.New(slot(self.RefreshEndTimer, self), 1, -1)
		end
		if not self.endTimer.running then
			self.endTimer:Start()
		end
	end
end

function UIVoyageRobberyView:RefreshCurrencyItem(currency, reward)
	if not currency then return end
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	if reward then
		local cfgId = reward[1] or 0
		local num = reward[2] or 0
		local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.MiniIcon, function(sprite)
				currency.icon.image.sprite = sprite
				currency.icon.image.enabled = true
			end)
		end
		currency.text.text.text = tostring(num)
		currency:SetActive(true)
	else
		currency:SetActive(false)
	end
end

return UIVoyageRobberyView

