local UIHundredDojoChallengeView = require("UIHundredDojo/UIHundredDojoChallengeView_Generate")
local ColorExtension = require('ColorExtension')

function UIHundredDojoChallengeView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoChallengeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoChallengeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_SELF_AREA_DATA_CHANGED, self, self.OnSelfAreaDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, self, self.OnOtherAreaDataChanged)
end

function UIHundredDojoChallengeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoChallengeView:Init()
	self.controller:InitData()
	self:RefreshView()
end

function UIHundredDojoChallengeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIHundredDojoChallengeView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCancle.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnChallenge.button, self, self.OnClickChallengeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCapture.button, self, self.OnClickCaptureBtn)
end

function UIHundredDojoChallengeView:OnHide()

end

function UIHundredDojoChallengeView:OnShow(data)
	self.controller:SetData(data)

end

function UIHundredDojoChallengeView:OnClose()
end

function UIHundredDojoChallengeView:OnDispose()
	if self.occupyTimer then
		self.occupyTimer:Stop()
		self.occupyTimer = nil
	end
	self.controller:OnDispose()
end

function UIHundredDojoChallengeView:OnSelfAreaDataChanged(oldId, newId)
	local curId = self.controller:GetData()
	if curId == oldId or curId == newId then
		self:RefreshView()
	end
end

function UIHundredDojoChallengeView:OnOtherAreaDataChanged(areaChangeIds)
	if not areaChangeIds then return end
	local curId = self.controller:GetData()
	for _, Id in pairs(areaChangeIds) do
		if curId == Id then
			self:RefreshView()
			break
		end
	end
end

function UIHundredDojoChallengeView:OnClickCloseBtn()
	self:UIClose()
end

function UIHundredDojoChallengeView:OnClickChallengeBtn()
	local errorCode = self.controller:SendChallengeReq()
	if errorCode == 0 then
		self:OnClickCloseBtn()
	else
		if errorCode == 1 then
			self:OnClickCloseBtn()
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView5')
		elseif errorCode == 2 then
			local costCfgId, costNum = self.controller:GetBuyChallengeCountCost()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBuyTimes, {costNum, nil, self.SureBuyChallengeNum, self})
		else
			self:OnClickCloseBtn()
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIHundredDojoChallengeView:SureOpenRuneShop()
	self:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, Enum.UIPageName.UIHundredDojo)
end

function UIHundredDojoChallengeView:SureBuyChallengeNum()
	local errorCode, costCfgId = self.controller:SendBuyChallengeNumReq()
	if errorCode ~= 0 then
		if errorCode == 1 then
			if Constant.OpenPay then
				local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
				if cfgData then
					if cfgData.ResType == Enum.ItemType.Diamond then
						local data = {"NoDiamondTip", nil, nil, self, self.SureOpenRuneShop}
						ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
						return
					end
				end
			end
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(costCfgId))
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIHundredDojoChallengeView:OnClickCaptureBtn()
	local errorCode = self.controller:SendChallengeReq()
	if errorCode == 0 then
		self:OnClickCloseBtn()
	else
		if errorCode == 1 then
			self:OnClickCloseBtn()
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView5')
		elseif errorCode == 2 then
			local costCfgId, costNum = self.controller:GetBuyChallengeCountCost()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBuyTimes, {costNum, nil, self.SureBuyChallengeNum, self})
		else
			self:OnClickCloseBtn()
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end


function UIHundredDojoChallengeView:RefreshView()
	if self.occupyTimer then
		self.occupyTimer:Stop()
	end
	local curId = self.controller:GetData()
	local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(curId)
	if areaCfgData then
		self.titleTxt.text.text = string.formatbykey(areaCfgData.Name)
		local rewards = areaCfgData.ShowRewardList
		local rewardRate = self.controller:GetRewardRate()
		self:RefreshCurrencyItem(self.currency1, rewards[1], rewardRate)
		self:RefreshCurrencyItem(self.currency2, rewards[2], rewardRate)
		self:RefreshCurrencyItem(self.currency3, rewards[3], rewardRate)
		local areaData = self.controller:GetAreaData()
		self.itemLua = self:GetAreaItemLua(areaCfgData.FunType, areaCfgData.AreaType)
		local playName = nil
		if self.itemLua then
			self.itemLua:SetActive(true)
			local slogan = nil
			if areaCfgData.FunType == Enum.HundredDojoFunType.Normal then
				local heroCutePath = nil
				if areaData and areaData:IsOccupy() then
					local robotId = areaData:GetRobotId()
					local atkPower = 0
					local color = nil
					if robotId and robotId > 0 then
						heroCutePath = self.controller:GetRobotHeroCute()
						local robotCfgData = ManagerContainer.CfgMgr:GetRobotDataByCfgId(robotId)
						if robotCfgData then
							playName = robotCfgData.RobotName
							atkPower = robotCfgData.FightPower and robotCfgData.FightPower[1] or 0
						end
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID4'))
					else
						local isSelfArea = self.controller:IsSelfArea(curId)
						local uid = nil
						if isSelfArea then
							slogan = self.controller:GetSelfSlogan()
							playName = self.controller:GetUserNickname()
							atkPower = self.controller:GetTotalFightPower()
							local roleId = self.controller:GetUserRoleId()
							local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
							if roleCfgData then
								heroCutePath = roleCfgData.HeroCute
							end
						else
							slogan = areaData:GetSlogan()
							local playBrief = areaData:GetPlayBrief()
							if playBrief then
								playName = playBrief.nickName
								atkPower = playBrief.fightPower
								uid = playBrief.uid
								local roleId = CommonUtil.JobIdToRoleId(playBrief.configId, playBrief.gender)
								local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
								if roleCfgData then
									heroCutePath = roleCfgData.HeroCute
								end
							end
						end
						if isSelfArea then
							color = ColorExtension.HexStringToColor(string.formatbykey('ColorID2'))
						elseif self.controller:IsLastBeAtkArea(uid) then
							color = ColorExtension.HexStringToColor(string.formatbykey('ColorID6'))
						elseif self.controller:IsSameGuild(areaData:GetGuildId()) then
							color = ColorExtension.HexStringToColor(string.formatbykey('ColorID3'))
						else
							color = ColorExtension.HexStringToColor(string.formatbykey('ColorID5'))
						end
					end
					if not color then
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID1'))
					end
					if areaData:IsProtected() then
						self.itemLua.animator:Play('ShieldKeep')
					elseif areaData:IsFighting() then
						self.itemLua.animator:Play('BattleKeep')
					else
						self.itemLua.animator:Play('NormalKeep')
					end
					self.itemLua.nameBoard.bG.image.color = color
					self.itemLua.nameBoard.nameTxt.text.text = (playName and tostring(playName) or '')
					self.itemLua.nameBoard.power.text.text = tostring(atkPower)
					self.itemLua.nameBoard:SetActive(true)
					if not heroCutePath or heroCutePath == '' then
						heroCutePath = self.controller:GetDefaultHeroCute()
					end
				elseif not areaData or not areaData:IsValidData() then
					if not heroCutePath or heroCutePath == '' then
						heroCutePath = self.controller:GetDefaultHeroCute()
					end
					self.itemLua.animator:Play('NormalKeep')
					self.itemLua.nameBoard:SetActive(false)
				else
					if areaData:IsFighting() then
						self.itemLua.animator:Play('BattleKeep')
					else
						self.itemLua.animator:Play('EmptyKeep')
					end
					self.itemLua.nameBoard:SetActive(false)
				end
				self.itemLua.player.image.enabled = false
				self.itemLua.player.image.sprite = nil
				self.itemLua.shadow:SetActive(false)
				CommonUtil.LoadIcon(self, heroCutePath, function(sprite)
					self.itemLua.player.image.sprite = sprite
					self.itemLua.player.image.enabled = true
					self.itemLua.shadow:SetActive(true)
				end, self.itemLua, 'AreaItemHeroCute')
			end
			if not slogan or slogan == '' then
				self.bubble:SetActive(false)
			else
				self.bubble:SetActive(true)
				self.bubble.slogan.text.text = tostring(slogan)
			end
		else
			self.bubble:SetActive(false)
		end
		if areaData and areaData:IsValidData() then
			if areaData:IsOccupy() then
				self.btnChallenge:SetActive(true)
				self.btnCapture:SetActive(false)
				local robotId = areaData:GetRobotId()
				self.timer:SetActive(not (robotId and robotId > 0))
				self:RefreshOccupyTimer()
				local guildName = areaData:GetGuildName()
				if guildName and guildName ~= '' then
					self.tipsTxt.text.text = string.formatbykey('HundredDojoChallengeView1', tostring(areaCfgData.Name), tostring(playName), tostring(guildName))
				else
					self.tipsTxt.text.text = string.formatbykey('HundredDojoChallengeView2', tostring(areaCfgData.Name), tostring(playName), tostring(guildName))
				end
				self.questionTxt.text.text = string.formatbykey('HundredDojoChallengeView4')
			else
				self.btnChallenge:SetActive(false)
				self.btnCapture:SetActive(true)
				self.timer:SetActive(false)
				self.tipsTxt.text.text = string.formatbykey('HundredDojoChallengeView3', tostring(areaCfgData.Name), tostring(playName), tostring(guildName))
				self.questionTxt.text.text = string.formatbykey('HundredDojoChallengeView5')
			end
		else
			self.btnChallenge:SetActive(false)
			self.btnCapture:SetActive(true)
			self.timer:SetActive(false)
			self.tipsTxt.text.text = string.formatbykey('HundredDojoView2')
			self.questionTxt.text.text = string.formatbykey('HundredDojoView2')
		end
		return
	end
	self:RefreshCurrencyItem(self.currency1, nil, 0)
	self:RefreshCurrencyItem(self.currency2, nil, 0)
	self:RefreshCurrencyItem(self.currency3, nil, 0)
	self.titleTxt.text.text = string.formatbykey('HundredDojoView5')
	self.tipsTxt.text.text = string.formatbykey('HundredDojoView5')
	self.questionTxt.text.text = string.formatbykey('HundredDojoView5')
	self.timer:SetActive(false)
	self.btnChallenge:SetActive(false)
	self.btnCapture:SetActive(false)
	if self.itemLua then
		self.itemLua:SetActive(false)
		self.itemLua = nil
	end
	self.bubble:SetActive(false)
end

function UIHundredDojoChallengeView:RefreshOccupyTimer()
	local areaData = self.controller:GetAreaData()
	if not areaData or not areaData:IsOccupy() then
		self:RefreshView()
		return
	end
	local isProtected = areaData:IsProtected()
	local remainTime = 0
	if isProtected then
		local endTime = areaData:GetProtectEndTime()
		if endTime and endTime > 0 then
			remainTime = endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
		end
		self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
	else
		local endTime = areaData:GetEndTime()
		if endTime and endTime > 0 then
			remainTime = endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
		end
		self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
	end
	if remainTime <= 0 then
		if self.occupyTimer then
			self.occupyTimer:Stop()
		end
	else
		local validTime = nil
		if remainTime >= 86400 then
			validTime = remainTime % 3600
			if validTime == 0 then validTime = 3600 end
		elseif remainTime >= 3600 then
			validTime = remainTime % 60
			if validTime == 0 then validTime = 60 end
		else
			validTime = 1
		end
		if self.occupyTimer then
			self.occupyTimer.time = 0
			self.occupyTimer.duration = validTime
		else
			self.occupyTimer = Timer.New(slot(self.RefreshOccupyTimer, self), validTime, -1)
		end
		if not self.occupyTimer.running then
			self.occupyTimer:Start()
		end
	end
end

function UIHundredDojoChallengeView:RefreshCurrencyItem(currency, reward, rewardRate)
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
		if rewardRate and rewardRate > 0 then
			currency.text.text.text = tostring(Mathf.Floor(num * rewardRate))
		else
			currency.text.text.text = '-'
		end
		currency:SetActive(true)
	else
		currency:SetActive(false)
	end
end

function UIHundredDojoChallengeView:GetAreaItemLua(funType, areaType)
	local itemLua = nil
	if funType == Enum.HundredDojoFunType.Box then
		itemLua = self.hundredDojoBoxSlotItem
	elseif funType == Enum.HundredDojoFunType.Normal then
		if areaType == Enum.HundredDojoAreaType.FirstArea then
			itemLua = self.hundredDojoSlotItem1
		elseif areaType == Enum.HundredDojoAreaType.SuperArea then
			itemLua = self.hundredDojoSlotItem2
		elseif areaType == Enum.HundredDojoAreaType.OneLvArea then
			itemLua = self.hundredDojoSlotItem3
		elseif areaType == Enum.HundredDojoAreaType.TwoLvArea then
			itemLua = self.hundredDojoSlotItem4
		elseif areaType == Enum.HundredDojoAreaType.ThreeArea then
			itemLua = self.hundredDojoSlotItem5
		elseif areaType == Enum.HundredDojoAreaType.FourArea then
			itemLua = self.hundredDojoSlotItem6
		else
			itemLua = self.hundredDojoSlotItem6
		end
	end
	return itemLua
end

return UIHundredDojoChallengeView

