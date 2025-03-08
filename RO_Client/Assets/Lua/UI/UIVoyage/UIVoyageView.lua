local UIVoyageView = require("UIVoyage/UIVoyageView_Generate")

function UIVoyageView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyageCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyageView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_NUM_CHANGED, self, self.OnVoyageNumChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_SELF_AIRSHIP_DATA_CHANGED, self, self.OnVoyageAirShipDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_LOCATION_CHANGED, self, self.OnVoyageLocationChanged)
end

function UIVoyageView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyageView:Init()
	self.controller:InitData()
	self:RefreshRemindNum()
	self:RefreshBtnState()
	self.isAlginPos = true
	self.alginUid = self.controller:GetLastAttackUserId()
	self.sourceAirShipItem = self.transform:Find("UIAnimator/Window/AirShipItem").gameObject
	if not self.airShipTimer then
		self.airShipTimer = Timer.New(slot(self.RefreshAirShips, self), 0.3, -1)
	else
		self.airShipTimer.time = 0.3
	end
	if not self.airShipTimer.running then
		self.airShipTimer:Start()
	end
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoExit)
end

function UIVoyageView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIVoyageView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.backBtn.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnRank.button, self, self.OnClickRankBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnShop.button, self, self.OnClickShopBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickLogBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnChat.button, self, self.OnClickChatBtn)

	self.uiBase:AddButtonUniqueEventListener(self.voyageBtn.button, self, self.OnClickVoyageBtn)
	self.uiBase:AddButtonUniqueEventListener(self.rewardBtn.button, self, self.OnClickRewardBtn)
end

function UIVoyageView:OnHide()
	if self.airShipTimer then
		self.airShipTimer:Stop()
	end
end

function UIVoyageView:OnShow(data)
	self.controller:SetData(data)
	if not self.airShipTimer then
		self.airShipTimer = Timer.New(slot(self.RefreshAirShips, self), 0.3, -1)
	else
		self.airShipTimer.time = 0.3
	end
	if not self.airShipTimer.running then
		self.airShipTimer:Start()
	end
end

function UIVoyageView:OnClose()
end

function UIVoyageView:OnDispose()
	self.isAlginPos = nil
	self.alginUid = nil
	if self.btnTimer then
		self.btnTimer:Stop()
		self.btnTimer = nil
	end
	if self.airShipTimer then
		self.airShipTimer:Stop()
		self.airShipTimer = nil
	end
	self:DisposeAirShips()
	self.controller:OnDispose()
end

function UIVoyageView:OnPageInEnd()
	self.super.OnPageInEnd(self)
end

function UIVoyageView:OnVoyageNumChanged()
	self:RefreshRemindNum()
end

function UIVoyageView:OnVoyageAirShipDataChanged()
	self:RefreshBtnState()
end

function UIVoyageView:OnVoyageLocationChanged(uid)
	local scrollRect = self.traceGroup.scrollRect
	if scrollRect.velocity ~= Vector2.zero then return end
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIVoyageRobbery) then
		return
	end
	self.isAlginPos = true
	self.alginUid = uid
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageRobbery, uid)
end

function UIVoyageView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIVoyageView:OnClickInfoBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'VoyageExplain'})
end

function UIVoyageView:OnClickRankBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageRank)
end

function UIVoyageView:OnClickShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 12)
end

function UIVoyageView:OnClickLogBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageLog)
end

function UIVoyageView:OnClickChatBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChat)
end

function UIVoyageView:OnClickVoyageBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyagePrepare)
end

function UIVoyageView:OnClickRewardBtn()
	local airShipData = self.controller:GetSelfAirShipData()
	if not airShipData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips01')
		return
	else
		if airShipData.awardReceived then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips04')
			return
		elseif ManagerContainer.LuaTimerMgr:CurLuaServerTime() < airShipData.endTime then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips05')
			return
		end
	end
	local errorCode = self.controller:SendGetRewardReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end


function UIVoyageView:OnClickAirShipItem(_, params)
	local item = params[0]
	if not item then return end
	local uid = item.uid
	if not uid then return end
	local selfuid = ManagerContainer.DataMgr.UserData:GetUserId()
	if uid == selfuid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips02')
		return
	end
	local airShipData = self.controller:GetAirShipDataByUid(uid)
	if not airShipData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('VoyageErrorTips01')
		return
	end
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
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageRobbery, uid)
end

function UIVoyageView:RefreshRemindNum()
	self.remindNumTxt.text.text = tostring(self.controller:GetRemindNum())
end

function UIVoyageView:RefreshBtnState()
	local airShipData = self.controller:GetSelfAirShipData()
	if not airShipData then
		self.voyageBtn.button.interactable = true
		self.voyageBtn.text.text.text = string.formatbykey('BtnAirShipPrepare')
		self.voyageBtn:SetActive(true)
		self.rewardBtn:SetActive(false)
		if self.btnTimer then
			self.btnTimer:Stop()
			self.btnTimer = nil
		end
	else
		if airShipData.awardReceived then
			self.voyageBtn.button.interactable = true
			self.voyageBtn.text.text.text = string.formatbykey('BtnAirShipPrepare')
			self.voyageBtn:SetActive(true)
			self.rewardBtn:SetActive(false)
			if self.btnTimer then
				self.btnTimer:Stop()
				self.btnTimer = nil
			end
		elseif ManagerContainer.LuaTimerMgr:CurLuaServerTime() < airShipData.endTime then
			self.voyageBtn.button.interactable = false
			self.voyageBtn:SetActive(true)
			self.rewardBtn:SetActive(false)
			local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			local remainTime = (airShipData.endTime - curTime) / 1000
			remainTime = type(remainTime) == "number" and remainTime or #remainTime
			self.voyageBtn.text.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
			if not self.btnTimer then
				self.btnTimer = Timer.New(slot(self.RefreshBtnState, self), 1, -1)
			end
			if not self.btnTimer.running then
				self.btnTimer:Start()
			end
		else
			self.voyageBtn.button.interactable = false
			self.voyageBtn:SetActive(false)
			self.rewardBtn:SetActive(true)
			if self.btnTimer then
				self.btnTimer:Stop()
				self.btnTimer = nil
			end
		end
	end
end

function UIVoyageView:RefreshAirShips()
	local oldShowAirShipMap = self.showAirShipMap or {}
	local newShowAirShipMap = {}
	-- 缓慢显示，一次刷新，不要去实例化太多对象
	local createNum = 0
	local airShipDatas = self.controller:GetAirShipDatas()
	local lastId = nil
	local airShipData = nil
	local item = nil
	local alginItem = nil
	local alginUid = self.alginUid
	local len = #airShipDatas
	for i = len, 1, -1 do
		airShipData = airShipDatas[i]
		if not airShipData:GetSlotId() then
            if lastId then
                lastId = lastId + 1
                if lastId > 10 then
                    lastId = 1
                end
            else
                lastId = len % 10 + 1
            end
            airShipData:SetSlotId(lastId)
        else
            lastId = airShipData:GetSlotId()
        end
		item = oldShowAirShipMap[airShipData.uid]
		if not item then
			createNum = createNum + 1
			if createNum <= 30 then
				item = self:GetOneAirShip()
				item.transform:SetParent(self['airShipRoot' .. tostring(lastId)].transform)
				item.transform:SetAsFirstSibling()
				item.transform.localRotation = Quaternion.identity
				item.transform.localScale = Vector3.one
			end
		end
		if item then
			oldShowAirShipMap[airShipData.uid] = nil
			newShowAirShipMap[airShipData.uid] = item
			local state = self:RefreshAirShipItem(item, airShipData, false)
			if state == 5 and airShipData.uid == alginUid then
				alginItem = item
			end
		end
	end
	airShipData = self.controller:GetSelfAirShipData()
	if airShipData then
		item = oldShowAirShipMap[airShipData.uid]
		if not item then
			lastId = airShipData:GetSlotId()
			if not lastId then
				lastId = Mathf.Random(1, 10)
				airShipData:SetSlotId(lastId)
			end
			item = self:GetOneAirShip()
			item.transform:SetParent(self['airShipRoot' .. tostring(lastId)].transform)
			item.transform:SetAsFirstSibling()
			item.transform.localRotation = Quaternion.identity
			item.transform.localScale = Vector3.one
			if not self.isAlginPos then
				self.isAlginPos = true
				alginItem = nil
			end
		end
		if item then
			oldShowAirShipMap[airShipData.uid] = nil
			newShowAirShipMap[airShipData.uid] = item
			local state = self:RefreshAirShipItem(item, airShipData, true)
			if state == 5 and not alginItem then
				alginItem = item
			end
		end
	end
	for _, olditem in pairs(oldShowAirShipMap) do
		self:ReleaseAirShip(olditem)
	end
	self.showAirShipMap = newShowAirShipMap
	if self.isAlginPos and not CommonUtil.TableIsEmpty(newShowAirShipMap) then
		self.isAlginPos = false
		if alginItem then
			local scrollRect = self.traceGroup.scrollRect
			local viewport = scrollRect.viewport
			local content = scrollRect.content
			local viewportRect = viewport.rect
			local contentRect = content.rect
			local viewportW = viewportRect.width
			local contentW = contentRect.width
			local validW = contentW - viewportW
			scrollRect.horizontalNormalizedPosition = Mathf.Clamp01((alginItem.transform.localPosition.x / validW) + 0.5)
		end
	end
end

function UIVoyageView:RefreshAirShipItem(item, data, isSelf)
	local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(data.quality)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local sec = (data.endTime - curTime) / 1000
	sec = type(sec) == "number" and sec or #sec
	local time = (data.duration or 1)
	if not item.uid or item.uid ~= data.uid then
		item.uid = data.uid
		item.me:SetActive(isSelf)
		local quality = data.quality
		if data.beChallengeNum >= cfgData.RobberyTimes then
			quality = 0
		end
		if quality then
			item.switchSprite:ChangeSprite(quality)
			item.fan:SetActive(quality > 0)
		end
		if not isSelf then
			self.uiBase:AddButtonUniqueEventListener(item.button, self, self.OnClickAirShipItem, item)
		else
			item.button.onClick:RemoveAllListeners()
		end
	else
		if data:IsChange() then
			local quality = nil
			if data:IsChangeQuality() then
				quality = data.quality
			end
			if data:IsChangeNum() then
				if data.beChallengeNum >= cfgData.RobberyTimes then
					quality = 0
				else
					quality = data.quality
				end
			end
			if quality then
				item.switchSprite:ChangeSprite(quality)
				item.fan:SetActive(quality > 0)
			end
			data:ResetChange()
		end
	end
	local state = 0
	local race = self['race' .. tostring(data:GetSlotId())]
	local pos = race.start.transform.position
	if sec < -1 then
		pos.x = pos.x + 400
		item.animator:Play('AirShipKeep')
		state = 1
	elseif sec > time + 1 then
		pos.x = pos.x - 400
		item.animator:Play('AirShipKeep')
		state = 2
	else
		if sec <= 0 then
			item.animator:Play('AirShipFinish')
			state = 3
		elseif sec > time then
			item.animator:Play('AirShipStart')
			state = 4
		else
			item.animator:CrossFade('AirShipRun', 0.2)
			state = 5
		end
		local raceLength = Mathf.Abs(pos.x - race.finsh.transform.position.x)
		pos.x = pos.x + (1 - (sec / time)) * raceLength
	end
	item.transform.position = pos
	return state
end


function UIVoyageView:GetOneAirShip()
	if self.airShipPool then
		local len = #self.airShipPool
		if len > 0 then
			local item = self.airShipPool[len]
			self.airShipPool[len] = nil
			return item
		end
	end
	local newGo = UnityEngine.GameObject.Instantiate(self.sourceAirShipItem)
	newGo:SetActive(true)
	local newTrans = newGo.transform
	local item = {}
	item.gameObject = newGo
	item.transform = newTrans
	item.animator = newGo:GetComponent(Enum.TypeInfo.Animator)
	item.button = newGo:GetComponent(Enum.TypeInfo.Button)
	item.me = newTrans:Find("Me").gameObject
	item.fan = newTrans:Find("Ship/Fan").gameObject
	item.switchSprite = newTrans:Find("Ship/Body"):GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
	return item
end

function UIVoyageView:ReleaseAirShip(item)
	if not item then return end
	item.uid = nil
	item.gameObject:SetActive(false)
	if not self.airShipPool then
		self.airShipPool = { item }
	else
		self.airShipPool[#self.airShipPool+1] = item
	end
end

function UIVoyageView:DisposeAirShips()
	if self.airShipPool then
		for _, item in pairs(self.airShipPool) do
			if item then
				local go = item.gameObject
				item.gameObject = nil
				item.transform = nil
				item.animator = nil
				item.button = nil
				item.me = nil
				item.fan = nil
				item.switchSprite = nil
				CommonUtil.DestroyGO(go)
			end
		end
		self.airShipPool = nil
	end
	if self.showAirShipMap then
		for _, item in pairs(self.showAirShipMap) do
			if item then
				local go = item.gameObject
				item.gameObject = nil
				item.transform = nil
				item.animator = nil
				item.button = nil
				item.me = nil
				item.fan = nil
				item.switchSprite = nil
				CommonUtil.DestroyGO(go)
			end
		end
		self.showAirShipMap = nil
	end
end

return UIVoyageView

