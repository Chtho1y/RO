local UIGuildWarMatchMapView = require("UIGuildWar/UIGuildWarMatchMapView_Generate")

local MatchMapState = Enum.GuildWarMatchMapState
local SlotPoss =
{
	Vector2(0, 200),
	Vector2(0, -160),
	Vector2(-266, 380),
	Vector2(266, 380),
	Vector2(-266, -355),
	Vector2(266, -355),
	Vector2(-402, 650),
	Vector2(-131, 650),
	Vector2(-402, -615),
	Vector2(-131, -615),
	Vector2(131, -615),
	Vector2(402, -615),
	Vector2(131, 650),
	Vector2(402, 650),
}

local HandleSlotPoss =
{
	Vector2(0, 65),
	Vector2(0, 435),
	Vector2(0, -300),
	Vector2(-265, 705),
	Vector2(-265, -560),
	Vector2(265, -560),
	Vector2(265, 705),
}

local LoseNameBgColor = Color(0.47, 0.486, 0.596)
local DefaultHandleBgColor = Color(0.333, 0.369, 0.455)
local BattleHandleBgColor = Color(0.8, 0.259, 0.259)



function UIGuildWarMatchMapView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarMatchMapCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarMatchMapView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_MATCH_MAP_CHANGED, self, self.OnMatchMapChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.OnOpenStateChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ENTER_SUCCESS, self, self.OnGuildEnterSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildWarMatchMapView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarMatchMapView:Init()
	self:InitBaseSlots()
	self:InitSlots()
	self:InitCheckHandles()
	self:InitBattleHandles()
	self:RefreshMatchMap(true)
end

function UIGuildWarMatchMapView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildWarMatchMapView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnHelp.button, self, self.OnClickHelpBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnMatchShop.button, self, self.OnClickMatchShopBtn)
end

function UIGuildWarMatchMapView:OnHide()
	if self.refreshTimer then
		if self.refreshTimer.running then
			self.refreshTimer:Stop()
		end
	end
end

function UIGuildWarMatchMapView:OnShow(data)
	self.controller:SetData(data)
	self:RefreshMatchMap(true)
end

function UIGuildWarMatchMapView:OnClose()
end

function UIGuildWarMatchMapView:OnDispose()
	if self.refreshTimer then
		if self.refreshTimer.running then
			self.refreshTimer:Stop()
		end
		self.refreshTimer = nil
	end
	self:DisposeBaseSlots()
	self:DisposeSlots()
	self:DisposeCheckHandles()
	self:DisposeBattleHandles()
	self.controller:OnDispose()
end

function UIGuildWarMatchMapView:OnMatchMapChanged()
	self:RefreshMatchMap()
end

function UIGuildWarMatchMapView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	self:UIClose()
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, nil, nil, false)
	end
end

function UIGuildWarMatchMapView:OnGuildEnterSuccess()
	self:RefreshMatchMap()
end

function UIGuildWarMatchMapView:OnGuildCreateSuccess()
	self:RefreshMatchMap()
end

function UIGuildWarMatchMapView:OnGuildDisBandSuccess()
	self:RefreshMatchMap()
end

function UIGuildWarMatchMapView:OnGuildQuitSuccess()
	self:RefreshMatchMap()
end

function UIGuildWarMatchMapView:OnGuildKickoutSuccess()
	self:RefreshMatchMap()
end


function UIGuildWarMatchMapView:OnClickBackBtn()
	self:UIClose()
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, nil, nil, false)
	end
end

function UIGuildWarMatchMapView:OnClickHelpBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'GuildWarDiagramText'})
end

function UIGuildWarMatchMapView:OnClickMatchShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarActivityShop)
end

function UIGuildWarMatchMapView:OnClickSlotItem(_, params)
	local id = params[0]
	if not id then return end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildInfo, id)
end

function UIGuildWarMatchMapView:OnClickBattleHandle(_, params)
	local idx = params[0]
	if idx then
		local matchMapData = self.controller:GetMatchMapData()
		if matchMapData and matchMapData:HasValid() then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWar, idx)
			return
		end
	end
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarDiagram14')
end

function UIGuildWarMatchMapView:OnClickCheckHandle(_, params)
	local idx = params[0]
	if idx then
		local matchMapData = self.controller:GetMatchMapData()
		if matchMapData and matchMapData:HasValid() then
			local battleData = matchMapData:GetBattleDataById(idx)
			if battleData then
				if not battleData.id1 or battleData.id1 <= 0 then
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('GuildWarDiagram32', tostring(battleData.name2))
					return
				end
				if not battleData.id2 or battleData.id2 <= 0 then
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('GuildWarDiagram32', tostring(battleData.name1))
					return
				end
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarRank, idx)
				return
			end
		end
	end
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarDiagram14')
end

function UIGuildWarMatchMapView:RefreshMatchMap(isFirst)
	local matchMapData = self.controller:GetMatchMapData()
	if matchMapData then
		local valid = matchMapData:HasValid()
		if valid then
			self.matchMap:SetActive(true)
			self.bottom:SetActive(true)
			self.btnMatchShop:SetActive(Constant.OpenPay or false)
			self:RefreshTimeList(matchMapData)
			self:RefreshBattles(matchMapData)
		else
			if isFirst then
				self.matchMap:SetActive(false)
				self.bottom:SetActive(false)
				self.btnMatchShop:SetActive(false)
			else
				self.matchMap:SetActive(true)
				self.bottom:SetActive(true)
				self.btnMatchShop:SetActive(Constant.OpenPay or false)
				self:RefreshTimeList(matchMapData)
				self:RefreshBattles(matchMapData)
			end
		end
		if not isFirst then
			local remainTime = matchMapData:GetNextRefreshRemainTime()
			if remainTime and remainTime > 0 then
				if self.refreshTimer then
					self.refreshTimer.time = remainTime
					self.refreshTimer.duration = remainTime
					self.refreshTimer.loop = 1
				else
					self.refreshTimer = Timer.New(slot(self.RefreshTimer, self), remainTime, 1)
				end
				if not self.refreshTimer.running then
					self.refreshTimer:Start()
				end
			else
				if self.refreshTimer and self.refreshTimer.running then
					self.refreshTimer:Stop()
				end
			end
		end
	else
		self.matchMap:SetActive(false)
		self.bottom:SetActive(false)
		self.btnMatchShop:SetActive(false)
		if self.refreshTimer and self.refreshTimer.running then
			self.refreshTimer:Stop()
		end
	end
	if isFirst then
		self.controller:SendGetGuildWarMatchMapReq()
	end
end

function UIGuildWarMatchMapView:RefreshTimer()
	if self.refreshTimer and self.refreshTimer.running then
		self.refreshTimer:Stop()
	end
	self.controller:SendGetGuildWarMatchMapReq()
end


function UIGuildWarMatchMapView:RefreshTimeList(matchMapData)
	local curMatchMapState = matchMapData.curMatchMapState
	self:RefreshTimeItem(self.matchTime1, curMatchMapState, MatchMapState.One, 'GuildWarDiagram7', 'GuildWarDiagram10')
	self:RefreshTimeItem(self.matchTime2, curMatchMapState, MatchMapState.Two, 'GuildWarDiagram8', 'GuildWarDiagram11')
	self:RefreshTimeItem(self.matchTime3, curMatchMapState, MatchMapState.Three, 'GuildWarDiagram9', 'GuildWarDiagram12')
end

function UIGuildWarMatchMapView:RefreshTimeItem(matchTime, curState, validState, nameLangKey, timeLangKey)
	matchTime.nameTxt.text.text = string.formatbykey(nameLangKey)
	if curState == validState then
		matchTime.bar.uIImageSwitchSprite:ChangeSprite(1)
		matchTime.title.uIImageSwitchSprite:ChangeSprite(1)
		matchTime.timeTxt.text.text = string.formatbykey(timeLangKey)
	elseif curState > validState then
		matchTime.bar.uIImageSwitchSprite:ChangeSprite(1)
		matchTime.title.uIImageSwitchSprite:ChangeSprite(0)
		matchTime.timeTxt.text.text = string.formatbykey('GuildWarDiagram13')
	else
		matchTime.bar.uIImageSwitchSprite:ChangeSprite(0)
		matchTime.title.uIImageSwitchSprite:ChangeSprite(0)
		matchTime.timeTxt.text.text = string.formatbykey(timeLangKey)
	end
end

function UIGuildWarMatchMapView:RefreshBattles(matchMapData)
	local battleData = nil
	local baseSlotOffset = 1
	local slotOffset = 1
	local checkHandleOffset = 1
	local battleHandleOffset = 1
	for i = 1, 7 do
		battleData = matchMapData:GetBattleDataById(i)
		self:RefreshLineItem(i, battleData)
		baseSlotOffset, slotOffset, checkHandleOffset, battleHandleOffset = self:RefreshBattle(i, battleData, baseSlotOffset, slotOffset, checkHandleOffset, battleHandleOffset)
		if i == 1 then
			if not battleData or battleData.state ~= 3 then
				self:RefreshSlotItem(self.championItem, nil, nil, nil, false, true)
			else
				if battleData.isWin then
					self:RefreshSlotItem(self.championItem, battleData.id1, battleData.name1, battleData.badge1, false, true)
				else
					self:RefreshSlotItem(self.championItem, battleData.id2, battleData.name2, battleData.badge2, false, true)
				end
			end
		end
	end
	if self.baseSlots and self.baseSlotNum then
		for i = baseSlotOffset, self.baseSlotNum do
			local baseSlot = self.baseSlots[i]
			if baseSlot then
				baseSlot:SetActive(false)
			end
		end
	end
	if self.slots and self.slotNum then
		for i = slotOffset, self.slotNum do
			local slot = self.slots[i]
			if slot then
				slot:SetActive(false)
			end
		end
	end
	if self.checkHandles and self.checkHandleNum then
		for i = checkHandleOffset, self.checkHandleNum do
			local checkHandle = self.checkHandles[i]
			if checkHandle and checkHandle.go then
				checkHandle.go:SetActive(false)
			end
		end
	end
	if self.battleHandles and self.battleHandleNum then
		for i = battleHandleOffset, self.battleHandleNum do
			local battleHandle = self.battleHandles[i]
			if battleHandle and battleHandle.go then
				battleHandle.go:SetActive(false)
			end
		end
	end
end

function UIGuildWarMatchMapView:RefreshLineItem(idx, battleData)
	local line = self['line' .. idx]
	if not line then return end
	if battleData then
		if battleData.state == 3 then
			if battleData.isWin then
				line.lineL:SetActive(true)
				line.lineR:SetActive(false)
				return
			else
				line.lineL:SetActive(false)
				line.lineR:SetActive(true)
				return
			end
		end
	end
	line.lineL:SetActive(false)
	line.lineR:SetActive(false)
end

function UIGuildWarMatchMapView:RefreshBattle(idx, battleData, baseSlotOffset, slotOffset, checkHandleOffset, battleHandleOffset)
	local posIdx = (idx - 1) * 2
	if not battleData or battleData.id1 <= 0 then
		local base = self:GetBaseSlot(baseSlotOffset)
		baseSlotOffset = baseSlotOffset + 1
		if base then
			base.transform.anchoredPosition = SlotPoss[posIdx + 1]
			base:SetActive(true)
		end
	else
		local slot = self:GetSlot(slotOffset)
		slotOffset = slotOffset + 1
		if slot then
			slot.transform.anchoredPosition = SlotPoss[posIdx + 1]
			slot:SetActive(true)
			self:RefreshSlotItem(slot, battleData.id1, battleData.name1, battleData.badge1, (battleData.state == 3 and not battleData.isWin or false))
		end
	end
	if not battleData or battleData.id2 <= 0 then
		local base = self:GetBaseSlot(baseSlotOffset)
		baseSlotOffset = baseSlotOffset + 1
		if base then
			base.transform.anchoredPosition = SlotPoss[posIdx + 2]
			base:SetActive(true)
		end
	else
		local slot = self:GetSlot(slotOffset)
		slotOffset = slotOffset + 1
		if slot then
			slot.transform.anchoredPosition = SlotPoss[posIdx + 2]
			slot:SetActive(true)
			self:RefreshSlotItem(slot, battleData.id2, battleData.name2, battleData.badge2, (battleData.state == 3 and battleData.isWin or false))
		end
	end

	if battleData then
		if battleData.state == 2 then
			local battleHandle = self:GetBattleHandle(battleHandleOffset)
			battleHandleOffset = battleHandleOffset + 1
			if battleHandle then
				local hasSelfGuild = (self.controller:IsSameGuild(battleData.id1) or self.controller:IsSameGuild(battleData.id2))
				if battleHandle.desBgImg then
					battleHandle.desBgImg.color = hasSelfGuild and BattleHandleBgColor or DefaultHandleBgColor
				end
				if battleHandle.desTxt then
					battleHandle.desTxt.text = string.formatbykey( hasSelfGuild and 'GuildWarDiagram3' or 'GuildWarDiagram2')
				end
				if battleHandle.trans then
					battleHandle.trans.anchoredPosition = HandleSlotPoss[idx]
				end
				if battleHandle.go then
					battleHandle.go:SetActive(true)
				end
				if battleHandle.button then
					self.uiBase:AddButtonUniqueEventListener(battleHandle.button, self, self.OnClickBattleHandle, idx)
				end
			end
		elseif battleData.state == 3 then
			local checkHandle = self:GetCheckHandle(checkHandleOffset)
			checkHandleOffset = checkHandleOffset + 1
			if checkHandle then
				if checkHandle.desTxt then
					checkHandle.desTxt.text = string.formatbykey('GuildWarDiagram4')
				end
				if checkHandle.trans then
					checkHandle.trans.anchoredPosition = HandleSlotPoss[idx]
				end
				if checkHandle.go then
					checkHandle.go:SetActive(true)
				end
				if checkHandle.button then
					self.uiBase:AddButtonUniqueEventListener(checkHandle.button, self, self.OnClickCheckHandle, idx)
				end
			end
		end
	end

	return baseSlotOffset, slotOffset, checkHandleOffset, battleHandleOffset
end

function UIGuildWarMatchMapView:RefreshSlotItem(itemLua, id, name, badge, isLose, isFirst)
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	if not id or id <= 0 then
		itemLua.guildFlag:SetActive(false)
		itemLua.nameTxt.text.text = string.formatbykey('GuildWarDiagram5')
		itemLua.tagMy:SetActive(false)
		itemLua.tagChamp:SetActive(true)
		itemLua.button.onClick:RemoveAllListeners()
		return
	end
	itemLua.guildFlag:SetActive(true)
	itemLua.nameTxt.text.text = tostring(name)
	if badge then
        local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(badge)
        if badgeCfgData then
			CommonUtil.LoadIcon(self, badgeCfgData.Pic, function (sprite)
				if sprite then
					itemLua.badge.image.sprite = sprite
					itemLua.badge.image.enabled = true
				end
			end, itemLua, 'BadgeIconAsyncIdx')
        end
	end
	itemLua.loseTag:SetActive(isLose)
	if isFirst then
		itemLua.tagMy:SetActive(false)
		itemLua.tagChamp:SetActive(true)
	elseif self.controller:IsSameGuild(id) then
		itemLua.tagMy:SetActive(true)
		itemLua.tagChamp:SetActive(false)
		itemLua.nameBg.image.color = isLose and LoseNameBgColor or Color.white
	else
		itemLua.tagMy:SetActive(false)
		itemLua.tagChamp:SetActive(false)
		itemLua.nameBg.image.color = isLose and LoseNameBgColor or Color.white
	end
	self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickSlotItem, id)
end

function UIGuildWarMatchMapView:GetBaseSlot(idx)
	local baseSlot = self.baseSlots[idx]
	if not baseSlot then
		if self.baseSlot then
			baseSlot = UnityEngine.GameObject.Instantiate(self.baseSlot)
			local baseSlotTrans = baseSlot.transform
			baseSlotTrans:SetParent(self.baseSlotParent.transform)
			baseSlotTrans.localPosition = Vector3.zero
			baseSlotTrans.localRotation = Quaternion.identity
			baseSlotTrans.localScale = Vector3(0.8, 0.8, 1)
			self.baseSlots[idx] = baseSlot
			if not self.baseSlotNum or self.baseSlotNum < idx then
				self.baseSlotNum = idx
			end
		end
	end
	return baseSlot
end

function UIGuildWarMatchMapView:InitBaseSlots()
	if not self.baseSlots then
		if not self.baseSlot then
			self.baseSlot = self.baseSlotParent.transform:Find('BaseSlot').gameObject
			self.baseSlot:SetActive(false)
		end
		self.baseSlotNum = 1
		self.baseSlots = {self.baseSlot}
	end
end

function UIGuildWarMatchMapView:DisposeBaseSlots()
	if self.baseSlots then
		for _, baseSlot in pairs(self.baseSlots) do
			if baseSlot and baseSlot ~= self.baseSlot then
				CommonUtil.DestroyGO(baseSlot)
			end
		end
	end
	self.baseSlot = nil
	self.baseSlotNum = nil
end

function UIGuildWarMatchMapView:GetSlot(idx)
	local slot = self.slots[idx]
	if not slot then
		if self.slots then
			local slotGo = UnityEngine.GameObject.Instantiate(self.guildWarMatchMapSlotItem.gameObject)
			local slotTrans = slotGo.transform
			slotTrans:SetParent(self.guildSlotParent.transform)
			slotTrans.localPosition = Vector3.zero
			slotTrans.localRotation = Quaternion.identity
			slotTrans.localScale = Vector3.one
			slot = CommonUtil.BindGridViewItem2Lua(self, 'GuildWarMatchMapSlotItem', slotGo)
			self.slots[idx] = slot
			if not self.slotNum or self.slotNum < idx then
				self.slotNum = idx
			end
		end
	end
	return slot
end

function UIGuildWarMatchMapView:InitSlots()
	if not self.slots then
		self.guildWarMatchMapSlotItem:SetActive(false)
		self.slotNum = 1
		self.slots = {self.guildWarMatchMapSlotItem}
	end
end

function UIGuildWarMatchMapView:DisposeSlots()
	if self.slots then
		for _, slot in pairs(self.slots) do
			if slot and slot ~= self.guildWarMatchMapSlotItem then
				local slotGo = slot.gameObject
				CommonUtil.ClearBindGridViewItem2Lua(self, 'GuildWarMatchMapSlotItem', slot.gameObject)
				CommonUtil.DestroyGO(slotGo)
			end
		end
	end
	self.slot = nil
	self.slotNum = nil
end


function UIGuildWarMatchMapView:GetCheckHandle(idx)
	local checkHandle = self.checkHandles[idx]
	if not checkHandle then
		if self.checkHandles then
			local go = UnityEngine.GameObject.Instantiate(self.checkHandle.go)
			local checkHandleTrans = go.transform
			checkHandle =
			{
				trans = checkHandleTrans,
				go = go,
				button = go:GetComponent(Enum.TypeInfo.Button),
				desTxt = checkHandleTrans:Find('Text'):GetComponent(Enum.TypeInfo.Text),
				
			}
			checkHandleTrans:SetParent(self.handleSlotParent.transform)
			checkHandleTrans.localPosition = Vector3.zero
			checkHandleTrans.localRotation = Quaternion.identity
			checkHandleTrans.localScale = Vector3.one
			self.checkHandles[idx] = checkHandle
			if not self.checkHandleNum or self.checkHandleNum < idx then
				self.checkHandleNum = idx
			end
		end
	end
	return checkHandle
end

function UIGuildWarMatchMapView:InitCheckHandles()
	if not self.checkHandles then
		if not self.checkHandle then
			local trans = self.handleSlotParent.transform:Find('BtnCheck')
			local go = trans.gameObject
			go:SetActive(false)
			self.checkHandle =
			{
				trans = trans,
				go = go,
				button = trans:GetComponent(Enum.TypeInfo.Button),
				desTxt = trans:Find('Text'):GetComponent(Enum.TypeInfo.Text),
			}
		end
		self.checkHandleNum = 1
		self.checkHandles = {self.checkHandle}
	end
end

function UIGuildWarMatchMapView:DisposeCheckHandles()
	if self.checkHandles then
		for _, checkHandle in pairs(self.checkHandles) do
			if checkHandle and checkHandle ~= self.checkHandle then
				local go = checkHandle.go
				checkHandle.trans = nil
				checkHandle.go = nil
				checkHandle.button = nil
				CommonUtil.DestroyGO(go)
			end
		end
	end
	self.checkHandle = nil
	self.checkHandleNum = nil
end

function UIGuildWarMatchMapView:GetBattleHandle(idx)
	local battleHandle = self.battleHandles[idx]
	if not battleHandle then
		if self.battleHandles then
			local go = UnityEngine.GameObject.Instantiate(self.battleHandle.go)
			local battleHandleTrans = go.transform
			battleHandle =
			{
				trans = battleHandleTrans,
				go = go,
				button = go:GetComponent(Enum.TypeInfo.Button),
				desBgImg = battleHandleTrans:Find('Button'):GetComponent(Enum.TypeInfo.Image),
				desTxt = battleHandleTrans:Find('Text'):GetComponent(Enum.TypeInfo.Text),
			}
			battleHandleTrans:SetParent(self.handleSlotParent.transform)
			battleHandleTrans.localPosition = Vector3.zero
			battleHandleTrans.localRotation = Quaternion.identity
			battleHandleTrans.localScale = Vector3.one
			self.battleHandles[idx] = battleHandle
			if not self.battleHandleNum or self.battleHandleNum < idx then
				self.battleHandleNum = idx
			end
		end
	end
	return battleHandle
end

function UIGuildWarMatchMapView:InitBattleHandles()
	if not self.battleHandles then
		if not self.battleHandle then
			local trans = self.handleSlotParent.transform:Find('BtnBattle')
			local go = trans.gameObject
			go:SetActive(false)
			self.battleHandle =
			{
				trans = trans,
				go = go,
				button = trans:GetComponent(Enum.TypeInfo.Button),
				desBgImg = trans:Find('Button'):GetComponent(Enum.TypeInfo.Image),
				desTxt = trans:Find('Text'):GetComponent(Enum.TypeInfo.Text),
			}
		end
		self.battleHandleNum = 1
		self.battleHandles = {self.battleHandle}
	end
end

function UIGuildWarMatchMapView:DisposeBattleHandles()
	if self.battleHandles then
		for _, battleHandle in pairs(self.battleHandles) do
			if battleHandle and battleHandle ~= self.battleHandle then
				local go = battleHandle.go
				battleHandle.trans = nil
				battleHandle.go = nil
				battleHandle.button = nil
				CommonUtil.DestroyGO(go)
			end
		end
	end
	self.battleHandle = nil
	self.battleHandleNum = nil
end



return UIGuildWarMatchMapView