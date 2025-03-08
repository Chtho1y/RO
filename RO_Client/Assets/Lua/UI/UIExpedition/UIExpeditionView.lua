local UIExpeditionView = require("UIExpedition/UIExpeditionView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIExpeditionView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Expedition_RefreshData,self,self.SetMapList)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Expedition_RefreshScroe,self,self.RefreshSorce)
end

function UIExpeditionView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Expedition_RefreshData,self,self.SetMapList)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Expedition_RefreshScroe,self,self.RefreshSorce)
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIExpeditionView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionView:Init()
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) == false then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMain)
	end
	ManagerContainer.DataMgr.ExpeditionDataMgr:RefreshUnfold()
	self.lastViewMapItemLua = nil
	self.lastViewMapItemData = nil
	self:SetMapList()
	self:RefreshLeftTimes(ManagerContainer.DataMgr.ExpeditionDataMgr.leftChanllengeNum)
	if self.controller:GetData() then
		if ManagerContainer.DataMgr.ExpeditionDataMgr:IsChallenging() then
			local mapId = ManagerContainer.DataMgr.ExpeditionDataMgr.curChanllengeMapId
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionDungeonInfo, mapId)
		elseif ManagerContainer.DataMgr.ExpeditionDataMgr:GetLastFinishedMapState() then
			local mapId = ManagerContainer.DataMgr.ExpeditionDataMgr.lastFinishedMap
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionDungeonInfo, mapId)
		end
	end
	self:RefreshSorce()
end

function UIExpeditionView:RefreshSorce()	
	local CurMaxScore = ManagerContainer.DataMgr.ExpeditionDataMgr:GetMaxScore()
	if CurMaxScore then
		self.text.text.text = tostring(CurMaxScore)
	end
end

function UIExpeditionView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.BtnRank.button,self, self.OnClickRankBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.helpLogBtn.button,self, self.OnClickHelpLogBtn)
	self.uiBase:AddButtonEventListener(self.ruleBtn.button,self, self.OnClickRuleBtn)
end

function UIExpeditionView:OnHide()

end

function UIExpeditionView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionView:OnClose()
end

function UIExpeditionView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionView:SetMapList()
	local mapList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetAllMaps()
	if mapList ~= nil then
		self.dungeonGroupScrollList:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.dungeonGroupScrollList.loopVerticalScrollRect,
			self.dungeonGroupScrollList.content.verticalLayoutGroup,
			mapList,
			0,
			self, self.SetMapData);
	else
		self.dungeonGroupScrollList:SetActive(false)
	end

	self:RefreshLeftTimes(ManagerContainer.DataMgr.ExpeditionDataMgr.leftChanllengeNum)
end

--移动到最后要打得页面(MoveTo  有问题 后续修改后调用)
function UIExpeditionView:MoveScrollToLast()
	local mapList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetAllMaps()
	local Index = ManagerContainer.DataMgr.ExpeditionDataMgr.lastFinishedMap
	Index = Index + 1
	if Index >= #mapList then
		Index = #mapList
	end
	self.dungeonGroupScrollList.loopVerticalScrollRect:MoveTo(Index-1)
end

function UIExpeditionView:SetMapData(mapItemLua,idx,mapItemData)
	mapItemLua.lockNode:SetActive(not mapItemData.unlocked)
	mapItemLua.lockNode.lbl:SetActive(not mapItemData.unlocked)
	if not mapItemData.unlocked then
		mapItemLua.lockNode.lbl.text.text =  mapItemData.unlockContent
	end

	mapItemLua.completedNode:SetActive(mapItemData.isPassed)
	if mapItemData.isPassed then
		local IsShowReward = not self:IsGetPassReward(mapItemData.mapId)--是否领取
		if IsShowReward then
			mapItemLua.BoxOn:SetActive(true)
			mapItemLua.BoxOff:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(mapItemLua.BoxOn.button, self, self.OnClickReward,mapItemData)
		else
			mapItemLua.BoxOn:SetActive(false)
			mapItemLua.BoxOff:SetActive(true)
		end
		mapItemLua.challengeNode:SetActive(false)
		mapItemLua.onNode:SetActive(false)
		mapItemLua.offNode:SetActive(false)
		mapItemLua.redpoint:SetActive(false)
	else
		mapItemLua.challengeNode:SetActive(mapItemData.isChallenging)
		mapItemLua.onNode:SetActive(mapItemData.isUnfold)
		mapItemLua.offNode:SetActive(not mapItemData.isUnfold)
		mapItemLua.redpoint:SetActive(mapItemData:HasRedPoint())
	end

	if mapItemData.isUnfold then
		self.lastViewMapItemLua = mapItemLua
		self.lastViewMapItemData = mapItemData
	end

	if mapItemData.bannerImg ~= nil and mapItemData.bannerImg ~= "" then
		CommonUtil.LoadIcon(self, mapItemData.bannerImg, function (sprite)
			mapItemLua.bannerImg.image.sprite = sprite
		end, mapItemLua, "ExpeditionBannerIdx")
	else
		mapItemLua.bannerImg.image.sprite = nil
	end

	if mapItemData.showRewards ~= nil and #mapItemData.showRewards > 0 then
		mapItemLua.itemListNode:SetActive(true)
		for i = 1, 4 do
			local iconItem = self:GetIconItem(mapItemLua,i)
			if iconItem ~= nil then
				iconItem:SetActive(false)
			end
		end

		for i = 1, #mapItemData.showRewards do
			if i <= 4 then
				local rewardData = {cfgId = mapItemData.showRewards[i][1], num = mapItemData.showRewards[i][2] }
				local iconItem = self:GetIconItem(mapItemLua,i)
				iconItem:SetActive(true)
				IconItemCtr:SetData(self, iconItem, rewardData, nil, self, self.OnClickItem)
			end
		end
	else
		mapItemLua.itemListNode:SetActive(false)
	end

	self.uiBase:AddButtonUniqueEventListener(mapItemLua.button, self, self.OnClickMap, mapItemLua,mapItemData)
	self.uiBase:AddButtonUniqueEventListener(mapItemLua.gotoBtn.button, self, self.OnClickEnterMap,mapItemData)
end

--点击领取奖励
function UIExpeditionView:OnClickReward(btn,params)	
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendPassRewardReq(params[0].mapId)
end

--是否领取奖励
function UIExpeditionView:IsGetPassReward(mapId)
	return ManagerContainer.DataMgr.ExpeditionDataMgr:IsGetPassReward(mapId)	
end

function UIExpeditionView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIExpeditionView:GetIconItem(mapItemLua,idx)
	if idx == 1 then
		return mapItemLua.iconItem1
	elseif idx == 2 then
		return mapItemLua.iconItem2
	elseif idx == 3 then
		return mapItemLua.iconItem3
	else
		return mapItemLua.iconItem4
	end
end

function UIExpeditionView:RefreshLeftTimes(leftTimes)
	self.timesNode.leftTimesTxt.text.text = tostring(leftTimes)
end

function UIExpeditionView:OnClickHelpLogBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpiditionHelpLog)
end

function UIExpeditionView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIExpeditionView:OnClickRankBtn()	
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIExpeditionRank) then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionRank)
	end
	-- ManagerContainer.DataMgr.ExpeditionDataMgr:SendScoreRankListReq(1)
end

function UIExpeditionView:OnClickRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'ExpeditionRuleTitle', 'ExpeditionText'})
end

function UIExpeditionView:OnClickMap(btn,params)
	local mapItemLua = params[0]
	local mapItemData = params[1]
	if mapItemData.isPassed then
		return
	end

	if self.lastViewMapItemLua == mapItemLua  and  mapItemData.isUnfold then
		mapItemData:SetUnfold(false)
		mapItemLua.offNode:SetActive(true)
		mapItemLua.onNode:SetActive(false)
		self.lastViewMapItemLua = nil
		self.lastViewMapItemData = nil
		return
	end

	if self.lastViewMapItemLua ~= nil then
		self.lastViewMapItemLua.offNode:SetActive(true)
		self.lastViewMapItemLua.onNode:SetActive(false)
	end

	if self.lastViewMapItemData ~= nil then
		self.lastViewMapItemData:SetUnfold(false)
	end

	mapItemData:SetUnfold(true)
	mapItemLua.offNode:SetActive(false)
	mapItemLua.onNode:SetActive(true)
	self.lastViewMapItemLua = mapItemLua
	self.lastViewMapItemData = mapItemData
end

function UIExpeditionView:OnClickEnterMap(btn,params)
	local mapItemData = params[0]
	if not mapItemData.unlocked then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(mapItemData.unlockContent)
		return
	end

	if mapItemData.isPassed then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionDungeonInfo, mapItemData.mapId)
	elseif mapItemData.isChallenging then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionDungeonInfo, mapItemData.mapId)
	else
		if ManagerContainer.DataMgr.ExpeditionDataMgr.curChanllengeMapId > 0 then
			ManagerContainer.DataMgr.ExpeditionDataMgr:SendChallengeMapReq(mapItemData.mapId)
		else
			ManagerContainer.LuaUIMgr:ShowMessageBox("EnterExpeditionMapTip",nil,mapItemData.mapId,self,self.OnConfirmEnterMap,nil)
		end
	end
end

function UIExpeditionView:OnConfirmEnterMap(mapId)
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendChallengeMapReq(mapId)
end

return UIExpeditionView

