local UIChangeServerView = require("UIRoleMessage/UIChangeServerView_Generate")

local BgColor1 = Color(0.8862745, 0.9294118, 0.9921569)
local BgColor2 = Color.white
local NameColor1 = Color(0.3333333, 0.3686275, 0.454902)
local NameColor2 = Color.white

function UIChangeServerView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIChangeServerCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChangeServerView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIChangeServerView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChangeServerView:Init()
	self.controller:InitData()
	self.lastClickToggle = nil
	local pageType = self.controller:GetCurPageType()
	self:RefreshServerGroupToggle(pageType)

	self.recommendServerLoop.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetServerItemByRowColumn(gridView, itemIndex, row, column)
	end, function(gridView, itemIndex, row, column, loopGridViewItem)
		self:RecycleServerItem(gridView, itemIndex, row, column, loopGridViewItem)
	end)
	self.allServerLoop.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetServerItemByRowColumn(gridView, itemIndex, row, column)
	end, function(gridView, itemIndex, row, column, loopGridViewItem)
		self:RecycleServerItem(gridView, itemIndex, row, column, loopGridViewItem)
	end)
	self.allServerGroupLoop.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetServerGroupItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.recommendServerLoop.loopGridView.ScrollRect.enabled = false
	self.allServerLoop.loopGridView.ScrollRect.enabled = false
	self.allServerGroupLoop.loopGridView.ScrollRect.enabled = false
end

function UIChangeServerView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChangeServerView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickAnyBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddToggleUniqueEventListener(self.recommendToggle.toggle, self, self.OnClickToggle, Enum.ChangeServerPageType.Recommend)
	self.uiBase:AddToggleUniqueEventListener(self.allToggle.toggle, self, self.OnClickToggle, Enum.ChangeServerPageType.All)
end

function UIChangeServerView:OnHide()

end

function UIChangeServerView:OnShow(data)
	self.controller:SetData(data)

end

function UIChangeServerView:OnClose()
end

function UIChangeServerView:OnDispose()
	if self.waitingCo then
		coroutine.stop(self.waitingCo)
		self.waitingCo = nil
	end
	self:ClearServerWWW()
	self.recommendServerLoop.loopGridView:Dispose()
	self.allServerLoop.loopGridView:Dispose()
	self.allServerGroupLoop.loopGridView:Dispose()
	if self.newRpSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.newRpSeqId)
		self.newRpSeqId = nil
	end
	self:DisposeNewRPGo()
	self.controller:OnDispose()
end

function UIChangeServerView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.recommendServerLoop.loopGridView.ScrollRect.enabled = true
	self.allServerLoop.loopGridView.ScrollRect.enabled = true
	self.allServerGroupLoop.loopGridView.ScrollRect.enabled = true
end


function UIChangeServerView:OnClickAnyBtn()
	self:UIClose()
end

function UIChangeServerView:OnClickCloseBtn()
	self:UIClose()
end

function UIChangeServerView:OnClickToggle(tog, params, isOn)
	if not isOn then
		local pageType = self.controller:GetCurPageType()
		local curPage = params[0]
		if curPage == pageType then
			tog.isOn = true
		end
		return
	end
	local curPage = params[0]
	if not self.controller:SetCurPageType(curPage) then
		return
	end
	self:RefreshServerGroupToggle(curPage)
end

function UIChangeServerView:OnClickServerItem(btn, params)
	local itemIndex = params[0]
	if not itemIndex then
		return
	end
	local serverData = self.controller:GetServerItemDataByItemIdx(itemIndex)
	if not serverData then
		return
	end
	if self.controller:IsCurServer(serverData.ServerId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ServerSwitching01')
		return
	end
	if serverData.State == Enum.ServerState.Full then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ServerSwitching03')
		return
	elseif serverData.State == Enum.ServerState.Maintain then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ServerSwitching02')
		return
	end
	if self.controller:IsOnlyChangeServer() then
		if ManagerContainer.LoginMgr:IsLoginWaiting() then
			ManagerContainer.LuaGameMgr:ClearServerData()
			ManagerContainer.LuaGameMgr:InitServerData(serverData.ServerId, serverData.ServerName, serverData.Ip, serverData.Port, serverData.State)
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SERVER_CHANGED)
		end
		self:UIClose()
		return
	end

	local data = {"SureChangeServerTip", {serverData.ServerName}, serverData, self, self.SureChangeServer}
	local sortingOrder = nil
	if self.uiBase.initSortingOrder ~= Enum.UISibling[self.uiData.type + 1] then
		sortingOrder = self.uiBase.initSortingOrder + 1
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data, nil, nil, nil, sortingOrder)
end

function UIChangeServerView:SureChangeServer(serverData)
	self.waitingCo = RegisterDelayStep(function()
		self.waitingCo = nil
		self:UIClose()
		if ManagerContainer.DataMgr.UserData:IsInitedOver() then
            ManagerContainer.DataMgr.UserData:SDKExitGame()
		end
		if ManagerContainer.LoginMgr:IsLoginWaiting() then
			ManagerContainer.LuaGameMgr:ClearServerData()
			ManagerContainer.LuaGameMgr:InitServerData(serverData.ServerId, serverData.ServerName, serverData.Ip, serverData.Port, serverData.State)
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CURRENT_SERVER_CHANGED)
			ManagerContainer.LuaGameMgr:ReLogin()
		end
	end)
end

function UIChangeServerView:OnClickServerGroupItem(btn, params)
	local itemIndex = params[0]
	if not itemIndex then
		return
	end
	if not self.controller:SetCurSelectGroupIdx(itemIndex) then
		return
	end
	self:RefreshView(true, false)
	self:RefreshData()
end

function UIChangeServerView:RefreshServerGroupToggle(pageType)
	self.recommendToggle.toggle.isOn = (pageType == Enum.ChangeServerPageType.Recommend)
	self.allToggle.toggle.isOn = (pageType == Enum.ChangeServerPageType.All)
	self:RefreshView(true, true)
	self:RefreshData()
end


function UIChangeServerView:RefreshData()
	local needUpdate = self.controller:CheckCacheData()
	if not needUpdate then
		return
	end
	local pageType = self.controller:GetCurPageType()
	if not self.reqServerMap then
		self.reqServerMap = {}
	end
	if pageType == Enum.ChangeServerPageType.Recommend then
		local reqServerInfo = self.reqServerMap[pageType]
		if reqServerInfo then
			return
		end
		local openId = ManagerContainer.LuaGameMgr.openId
		local url = PlatformPack.SERVERLIST_URL .. '?type=22'
		url = ManagerContainer.LuaGameMgr:ComposeCommonServerInfo(url)
		self.reqServerMap[pageType] = UnityEngine.WWW(url)
	elseif pageType == Enum.ChangeServerPageType.All then
		local pageId = self.controller:GetCurSelectServerGroupIdx()
		local openId = ManagerContainer.LuaGameMgr.openId
		local url = PlatformPack.SERVERLIST_URL .. '?type=23'
		if pageId then
			url = url .. '&page=' .. tostring(pageId)
		else
			pageId = 0
		end
		url = ManagerContainer.LuaGameMgr:ComposeCommonServerInfo(url)
		local reqServerInfos = self.reqServerMap[pageType]
		if reqServerInfos then
			local reqServerInfo = reqServerInfos[pageId]
			if reqServerInfo then
				return
			end
		else
			reqServerInfos = {}
			self.reqServerMap[pageType] = reqServerInfos
		end
		reqServerInfos[pageId] = {
			reqWWW = UnityEngine.WWW(url),
			pageId = pageId,
		}
	else
		return
	end
	if not self.serverCheckTimer then
		self.serverCheckTimer = FrameTimer.New(slot(self.CheckServerWWW, self), 1, -1)
	end
	if not self.serverCheckTimer.running then
		self.serverCheckTimer:Start()
	end
end

function UIChangeServerView:CheckServerWWW()
	local allDone = true
	local hasError = false
	local hasValid = false
	if self.reqServerMap then
		local reqWWW = self.reqServerMap[Enum.ChangeServerPageType.Recommend]
		if reqWWW then
			if reqWWW.isDone then
				if not reqWWW.error or reqWWW.error == '' then
					local ok, result = RO_XPCALL(JSON.decode, debug.traceback, JSON, reqWWW.text)
					if ok then
						self.controller:UpdateServerData(result, Enum.ChangeServerPageType.Recommend)
						hasValid = true
					else
						LogError('[wboy] CheckServerFail ' .. tostring(result))
					end
				else
					hasError = true
				end
				self.reqServerMap[Enum.ChangeServerPageType.Recommend] = nil
				reqWWW:Dispose()
				reqWWW = nil
			else
				allDone = false
			end
		end
		local reqServerInfos = self.reqServerMap[Enum.ChangeServerPageType.All]
		if reqServerInfos then
			for key, reqServerInfo in pairs(reqServerInfos) do
				reqWWW = reqServerInfo.reqWWW
				if reqWWW then
					if reqWWW.isDone then
						if not reqWWW.error or reqWWW.error == '' then
							local ok, result = RO_XPCALL(JSON.decode, debug.traceback, JSON, reqWWW.text)
							if ok then
								self.controller:UpdateServerData(result, Enum.ChangeServerPageType.All, reqServerInfo.pageId)
								hasValid = true
							else
								LogError('[wboy] CheckServerFail ' .. tostring(result))
							end
						else
							hasError = true
						end
						reqServerInfos[key] = nil
						reqServerInfo.reqWWW = nil
						reqWWW:Dispose()
						reqWWW = nil
					else
						allDone = false
					end
				end
			end
		end
	end
	if allDone then
		if self.serverCheckTimer then
			self.serverCheckTimer:Stop()
		end
	end
	if hasError then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ServerSwitching04')
	end
	if hasValid then
		self:RefreshView()
	end
end

function UIChangeServerView:ClearServerWWW()
	if self.serverCheckTimer then
		self.serverCheckTimer:Stop()
		self.serverCheckTimer = nil
	end
	if self.reqServerMap then
		local reqWWW = self.reqServerMap[Enum.ChangeServerPageType.Recommend]
		if reqWWW then
			self.reqServerMap[Enum.ChangeServerPageType.Recommend] = nil
			reqWWW:Dispose()
			reqWWW = nil
		end
		local reqServerInfos = self.reqServerMap[Enum.ChangeServerPageType.All]
		if reqServerInfos then
			for key, reqServerInfo in pairs(reqServerInfos) do
				reqWWW = reqServerInfo.reqWWW
				if reqWWW then
					reqServerInfos[key] = nil
					reqServerInfo.reqWWW = nil
					reqWWW:Dispose()
					reqWWW = nil
				end
			end
		end
	end
	self.reqServerMap = nil
end

function UIChangeServerView:IsSomeFrameCount(keyName)
	local value = self[keyName]
	if value and value >= Time.frameCount then
		return true
	end
	self[keyName] = Time.frameCount
	return false
end


function UIChangeServerView:GetServerItemByRowColumn(gridView, itemIndex, row, column)
	local serverData, playerData = self.controller:GetServerItemDataByItemIdx(itemIndex)
	if not serverData then return nil end
	local item = gridView:NewListViewItem('AllServerItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'AllServerItem', item.gameObject)
	if itemLua then
		itemLua.serverName.text.text = tostring(serverData.ServerName)
		local jobCfgId = nil
		local lv = nil
		local heroFrameId = nil
		local sex = nil
		local playerName = nil
		local curServer = self.controller:IsCurServer(serverData.ServerId)
		if serverData.State == Enum.ServerState.Maintain then
			itemLua.labelCurrent:SetActive(false)
			itemLua.labelMaintaining:SetActive(true)
		elseif curServer then
			itemLua.labelCurrent:SetActive(true)
			itemLua.labelMaintaining:SetActive(false)
		else
			itemLua.labelCurrent:SetActive(false)
			itemLua.labelMaintaining:SetActive(false)
		end
		if serverData.State == Enum.ServerState.Beta then
			itemLua.redPointTesting:SetActive(true)
			self:RecycleNew(itemLua)
		elseif serverData.New then
			itemLua.redPointTesting:SetActive(false)
			if serverData.STime then
				local timesamp = self:DecodeDataToTimestamp(serverData.STime)
				timesamp = os.difftime(os.time(), timesamp)
				if self.controller:IsValidNew(timesamp) then
					self:AddNew(itemLua)
				else
					self:RecycleNew(itemLua)
				end
			else
				self:RecycleNew(itemLua)
			end
		else
			itemLua.redPointTesting:SetActive(false)
			self:RecycleNew(itemLua)
		end
		if curServer then
			local userData = ManagerContainer.DataMgr.UserData
			if userData and userData:IsInitedOver() then
				jobCfgId = userData:GetJobCfgId()
				lv = userData:GetRoleLv()
				heroFrameId = userData:GetHeadFrameId()
				sex = userData:GetSex()
				playerName = userData:GetUserNickname()
			end
		end

		if not jobCfgId then
			jobCfgId = playerData.JobCfgId
		end
		if not lv then
			lv = playerData.Level
		end
		if not sex then
			sex = playerData.Gender
		end
		if (sex and sex > 0 and jobCfgId and jobCfgId > 0 and lv and lv > 0) then
			if not heroFrameId then
				heroFrameId = playerData.HeadFrameId
			end
			if not playerName then
				playerName = CommonUtil.GetVaildNickName(playerData.NickName)
			end
			itemLua.playerBox:SetActive(true)
			itemLua.playerBox.nameTxt.text.text = tostring(playerName)
			itemLua.playerBox.num.text.text = string.formatbykey('Lv') .. tostring(lv)
			itemLua.playerBox.jobIcon.image.enabled = false
			itemLua.playerBox.jobIcon.image.sprite = nil
			itemLua.playerBox.headIcon.image.enabled = false
			itemLua.playerBox.headIcon.image.sprite = nil
			if jobCfgId then
				local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
				if jobCfg then
					CommonUtil.LoadIcon(self, jobCfg.JobIcon, function (sprite)
						if sprite then
							itemLua.playerBox.jobIcon.image.sprite = sprite
							itemLua.playerBox.jobIcon.image.enabled = true
						end
					end)
				end
				local roleCfg = ManagerContainer.CfgMgr:GetRoleDataById(CommonUtil.JobIdToRoleId(jobCfgId, sex))
				if roleCfg then
					CommonUtil.LoadIcon(self, roleCfg.HeadId or '', function (sprite)
						if sprite then
							itemLua.playerBox.headIcon.image.sprite = sprite
							itemLua.playerBox.headIcon.image.enabled = true
						end
					end)
				end
			end
			itemLua.playerBox.frame.image.enabled = false
			itemLua.playerBox.frame.image.sprite = nil
			if heroFrameId then
				local headFramePath = CommonUtil.GetHeadFrameName(heroFrameId)
				CommonUtil.LoadIcon(self, headFramePath, function (sprite)
					if sprite then
						itemLua.playerBox.frame.image.sprite = sprite
						itemLua.playerBox.frame.image.enabled = true
					end
				end)
			end
		else
			itemLua.playerBox:SetActive(false)
		end
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickServerItem, itemIndex)
	end
	return item
end

function UIChangeServerView:RecycleServerItem(gridView, itemIndex, row, column, loopGridViewItem)
	local itemLua = CommonUtil.GetBindGridViewItem2Lua(self, 'AllServerItem', loopGridViewItem.gameObject)
	self:RecycleNew(itemLua)
end

function UIChangeServerView:AddNew(itemLua)
	if not itemLua then return end
	if itemLua.newGo then return end
	local newRPGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, 'UINewRP')
	if not newRPGo then
		if not self.preNewRPGos then
			self.preNewRPGos = {}
		end
		self.preNewRPGos[itemLua] = itemLua
		if not self.newRpSeqId then
			self.newRpSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UICommonPath, {'UINewRP'}, self, self.NewRPLoadComplete)
		end
		return
	end
	itemLua.newGo = newRPGo
	newRPGo.transform:SetParent(itemLua.labelNew.transform)
	newRPGo.transform.localPosition = Vector3.zero
	newRPGo.transform.localRotation = Quaternion.identity
	newRPGo.transform.localScale = Vector3.one
	newRPGo:SetActive(true)
	if not self.newRPGos then
		self.newRPGos = {}
	end
	self.newRPGos[#self.newRPGos+1] = newRPGo
end

function UIChangeServerView:NewRPLoadComplete()
	self.newRpSeqId = nil
	if not self.preNewRPGos then return end
	for _, parent in pairs(self.preNewRPGos) do
		self:AddNew(parent)
	end
end

function UIChangeServerView:DisposeNewRPGo()
	if self.newRPGos then
		for _, newGo in pairs(self.newRPGos) do
			ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, 'UINewRP', newGo)
		end
	end
	self.newRPGos = nil
	self.preNewRPGos = nil
end

function UIChangeServerView:RecycleNew(itemLua)
	if not itemLua then return end
	if itemLua.newGo then
		if self.newRPGos then
			for i = 1, #self.newRPGos do
				if self.newRPGos[i] == itemLua.newGo then
					table.remove(self.newRPGos, i)
				end
			end
		end
		if self.preNewRPGos then
			self.preNewRPGos[itemLua] = nil
		end
		ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, 'UINewRP', itemLua.newGo)
		itemLua.newGo = nil
	end
end

function UIChangeServerView:GetServerGroupItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('AllServerGroupItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'AllServerGroupItem', item.gameObject)
	if itemLua then
		local gray = ((itemIndex % 2) == 1)
		itemLua.bGColor.image.color = (gray and BgColor1 or BgColor2)
		local startId, endId = self.controller:GetServerGroupItemDataByItemIdx(itemIndex)
		if not startId or not endId then
			itemLua.serverGroupName.text.text = ''
			itemLua.allChosenTagImage:SetActive(false)
			itemLua.button.onClick:RemoveAllListeners()
		else
			itemLua.serverGroupName.text.text = string.formatbykey('ServerGroupName', endId, startId)
			if self.controller:IsCurSelectGroup(itemIndex) then
				itemLua.allChosenTagImage:SetActive(true)
				itemLua.serverGroupName.text.color = NameColor2
			else
				itemLua.allChosenTagImage:SetActive(false)
				itemLua.serverGroupName.text.color = NameColor1
			end
			self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickServerGroupItem, itemIndex)
		end
	end
	return item
end

function UIChangeServerView:RefreshView(resetPos1, resetPos2)
	local curPage = self.controller:GetCurPageType()
	if curPage == Enum.ChangeServerPageType.Recommend then
		self.recommendRoot:SetActive(true)
		self.allRoot:SetActive(false)
		self:RefreshRecommendView(resetPos1)
	elseif curPage == Enum.ChangeServerPageType.All then
		self.recommendRoot:SetActive(false)
		self.allRoot:SetActive(true)
		self:RefreshAllGroupView(resetPos2)
		self:RefreshAllItemView(resetPos1)
	else
		self.recommendRoot:SetActive(false)
		self.allRoot:SetActive(false)
	end
end

function UIChangeServerView:RefreshRecommendView(resetPos)
	local loopGridView = self.recommendServerLoop.loopGridView
	local length = self.controller:GetServerItemDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end

function UIChangeServerView:RefreshAllGroupView(resetPos)
	local loopGridView = self.allServerGroupLoop.loopGridView
	local length = self.controller:GetServerGroupItemDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end

function UIChangeServerView:RefreshAllItemView(resetPos)
	local loopGridView = self.allServerLoop.loopGridView
	local length = self.controller:GetServerItemDataLength()
	if resetPos or length ~= loopGridView.RealItemTotalCount then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end


function UIChangeServerView:DecodeDataToTimestamp(dataStr)
	local matchFun = string.gmatch(dataStr, '%d+')
	local time = {}
	time.year = matchFun()
	time.month = matchFun()
	time.day = matchFun()
	time.hour = matchFun()
	time.min = matchFun()
	time.sec = matchFun()
	return os.time(time)
end





return UIChangeServerView

