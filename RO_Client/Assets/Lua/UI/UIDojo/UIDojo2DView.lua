local UIDojo2DView = require("UIDojo/UIDojo2DView_Generate")
local RoleListItemCtr = require("Common/RoleListItemCtr")
local IconItemCtr = require("Common/IconItemCtr")

function UIDojo2DView:OnAwake(data)
	self.controller = require("UIDojo/UIDojo2DCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojo2DView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Season_LeftTime,self,self.OnRefreshSeasonTime);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Team_FightPower,self,self.UpdateTeamFighterPower);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Data_Change,self,self.InitUIData);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Season_End,self,self.InitUIData);
end

function UIDojo2DView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojo2DView:Init()
	self.instGoes = nil
	self.curSelectedUid = 0
	self.lastSelectedIdx = 0
	self:HideAllSelectedActorGO()
	self:InitUIData()
	self:LoadOtherUI()
end

function UIDojo2DView:LoadOtherUI()
	self.isLoading = true
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Dojo_UIPart_Loaded,self,self.OnUIPartLoaded);
	local partResPaths = {"UIDojo/SelectedHero","UIDojo/Portrait"}
	local seqId =  ManagerContainer.ResMgr:LoadAssetGameObjects(Constants.UIPath, ELoadType.OTHER, function(objs)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Dojo_UIPart_Loaded,objs)
	end, unpack(partResPaths))
end

function UIDojo2DView:OnUIPartLoaded(objs)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Dojo_UIPart_Loaded,self,self.OnUIPartLoaded);
	self.instGoes = {}
	self.isLoading = false
	local selectedPrefab = objs[0]
	local rolePrefab = objs[1]
	for i=1, 6 do
		local memberNode = self:GetTeamMemberGo(i)
		local go =  UnityEngine.GameObject.Instantiate(rolePrefab)
		go:SetActive(true)
		local rectTransform = go:GetComponent(Enum.TypeInfo.RectTransform)
		rectTransform:SetParent(memberNode.transform, false);
		rectTransform.localRotation = Quaternion.identity;
		rectTransform.localScale = Vector3(1,1,1);
		rectTransform.anchorMin = Vector2 (0, 0);
		rectTransform.anchorMax = Vector2(1.0, 1.0);
		rectTransform.pivot = Vector2 (0.5, 0.5);
		rectTransform.anchoredPosition3D = Vector3(0,0,0);
		rectTransform.sizeDelta = Vector2(0,0);
		self.instGoes[#self.instGoes+1] = go
		memberNode.roleLua = CommonUtil.BindGridViewItem2Lua(self, "Portrait", go)
	end

	for i=1,4 do
		local charGo = self:GetBattleActorGo(i)
		local go =  UnityEngine.GameObject.Instantiate(selectedPrefab)
		go:SetActive(true)

		local rectTransform = go:GetComponent(Enum.TypeInfo.RectTransform)
		rectTransform:SetParent(charGo.transform, false);
		rectTransform.localRotation = Quaternion.identity;
		rectTransform.localScale = Vector3(1,1,1);
		rectTransform.anchorMin = Vector2 (0, 0);
		rectTransform.anchorMax = Vector2(1.0, 1.0);
		rectTransform.pivot = Vector2 (0.5, 0.5);
		rectTransform.anchoredPosition3D = Vector3(0,0,0);
		rectTransform.sizeDelta = Vector2(0,0);
		self.instGoes[#self.instGoes+1] = go
		charGo.heroLua = CommonUtil.BindGridViewItem2Lua(self, "SelectedHero", go)
	end

	self:SetTeamData()
end

function UIDojo2DView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojo2DView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.matchBtn.button,self, self.OnClickMatchBtn)
	self.uiBase:AddButtonEventListener(self.rankBtn.button,self, self.OnClickRankBtn)
	self.uiBase:AddButtonEventListener(self.shopBtn.button,self, self.OnClickShopBtn)
	self.uiBase:AddButtonEventListener(self.buyTimesBtn.button,self, self.OnClickBuyTimesBtn)
	self.uiBase:AddButtonEventListener(self.playRuleBtn.button, self, self.OnClickPlayRuleBtn)
end

function UIDojo2DView:OnHide()

end

function UIDojo2DView:OnShow(data)
	self.controller:SetData(data)
end

function UIDojo2DView:OnClose()
	for i=1, 6 do
		local go = self:GetTeamMemberGo(i)
		if go~= nil then
			local pos = go.rectTransform.anchoredPosition3D
			pos.y = 0
			go.rectTransform.anchoredPosition3D = pos
		end
	end
	AvatarRTMgr.Instance:Hide()
end

function UIDojo2DView:OnDispose()
	self:DestroyGOes()
	self.controller:OnDispose()
end

function UIDojo2DView:UpdateTeamFighterPower()
	local TotalPower = 0
	local battleActorIds = ManagerContainer.DataMgr.ArenaData:GetTeamActorIds()
	for i = 1, #battleActorIds do      
		local Power = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(battleActorIds[i],false)    
		if nil ~= Power and -1 ~= Power then	
			TotalPower = TotalPower + Power	
			local PetPower = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(battleActorIds[i],true)            
			if nil ~= PetPower and -1 ~= PetPower then
				TotalPower = TotalPower + PetPower
			end
		else
			--local power
			Power = ManagerContainer.DataMgr.UserData:GetSlotFightPower(battleActorIds[i])
			TotalPower = TotalPower + Power
		end    
	end
	self.fighterPowerText.text.text = TotalPower
end

function UIDojo2DView:OnRefreshSeasonTime(leftTime)
	if ManagerContainer.DataMgr.ArenaData:InSeason() then
		self.seasonEndTimeText.text.text = DateTimeUtil.convertSeconds2TimeStr(leftTime,false)
		self.seasonEndTimeText.lbl:SetActive(true)
	else
		self.nextSeasonTimeText.text.text = DateTimeUtil.convertSeconds2TimeStr(leftTime,false)
		self.seasonEndTimeText.text.text = I18N.T("DscSeasonResult6");
		self.seasonEndTimeText.lbl:SetActive(false)
	end
end

function UIDojo2DView:InitUIData()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoExit)
	self:UpdateDanInfo()
	self:UpdateTeamFighterPower()
	self:OnRefreshSeasonTime(ManagerContainer.DataMgr.ArenaData:GetLeftTime())
	self:SetSeasonNode()
	self:ShowCurRewardItem()
end

function UIDojo2DView:ShowCurRewardItem()
	local itemId = ManagerContainer.DataMgr.ArenaData:GetCurShowRewardItemId()
	if itemId == 0 then
		self.rewardItem:SetActive(false)
		self.rewardItemName:SetActive(false)
	else
		IconItemCtr:SetData(self,self.rewardItem,{cfgId = itemId},nil,self,self.OnClickRewardItem)
		local itemData = ManagerContainer.CfgMgr:GetItemById(itemId)
		if itemData~=nil then
			self.rewardItemName.text.text = itemData.Name
		end
	end
end

function UIDojo2DView:OnClickRewardItem()
	local dan = 1;
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoReward, dan)
end

function UIDojo2DView:SetSeasonNode()
	if ManagerContainer.DataMgr.ArenaData:InSeason() then
		self.curSeasonNode:SetActive(true)
		self.nextSeasonNode:SetActive(false)
	else
		self.curSeasonNode:SetActive(false)
		self.nextSeasonNode:SetActive(true)
	end
end

function UIDojo2DView:UpdateDanInfo()
	local arenaData = ManagerContainer.DataMgr.ArenaData

	if arenaData.winRate == 0 then
		self.winRateText.text.text = "无"
	else
		self.winRateText.text.text = CommonUtil.GetPreciseDecimal(arenaData.winRate*100,0) .. "%"
	end

	if arenaData.nextDanScore > 1000000 then
		self.curRankScoreText.text.text = tostring(arenaData.danScore) .. "/--"
	else
		self.curRankScoreText.text.text = tostring(arenaData.danScore) .. "/" .. tostring(arenaData.nextDanScore)
	end
	
	if arenaData.nextDanScore > 0 then
		self.scoreSlider.slider.value = arenaData.danScore / arenaData.nextDanScore
	else
		self.scoreSlider.slider.value = 1
	end

	self.rankName.text.text = tostring(arenaData.danName)

	if arenaData.danIcon~= nil and arenaData.danIcon ~= "" then
		CommonUtil.LoadIcon(self, arenaData.danIcon, function (sprite)
			self.rankIcon.image.sprite = sprite
		end)
	end

	local maxCnt = 5
	if arenaData:GetLeftTimes() > 5 then
		maxCnt = arenaData:GetLeftTimes()
	end
	self.leftTimesText.text.text = tostring(arenaData:GetLeftTimes())
	self.leftRewardTimesText.text.text = I18N.SetLanguageValue("TodayRewardTimes", arenaData:GetLeftRewardTimes()) --"今日还可获得"..tostring(arenaData:GetLeftRewardTimes()).."次积分货币"

	--判断是否要显示段位升级
	local _lastDan, _ = CommonUtil.GetCurDunData(arenaData.lastDanScore);
	local _curDan, _ = CommonUtil.GetCurDunData(arenaData.danScore);
	if _lastDan ~= nil and _curDan ~= nil then
		if _lastDan.ArenaLevelId < _curDan.ArenaLevelId then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBadgeUp);
		end
	end
end

function UIDojo2DView:OnClickShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 2, self.uiData.id) --开启英灵殿商店
end

function UIDojo2DView:OnClickBackBtn()
	if AvatarRTMgr.Instance.IsLoading  or self.isLoading then
		return
	end
	
	AvatarRTMgr.Instance:Hide()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIDojo2DView:OnClickMatchBtn()
	self.controller:SendMatch()
end

function UIDojo2DView:OnClickRankBtn()
	ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(0,1)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoRank)
end

function UIDojo2DView:OnClickBuyTimesBtn()
	local costStr = GlobalConfig.Instance:GetConfigStrValue(109)
	local cost = 0
	if costStr~=nil and costStr~="" then
		local intVals = string.split(costStr,':')
		cost = intVals[2]
	end
	local BuyTimes = ManagerContainer.DataMgr.ArenaData:GetLeftBuyTimes()
	local fucIsCanBuy = function(singlecost,count)	
		return self:IsCanBuyTimes(singlecost,count)
	end
	local fucBuyOk = function(count) 
		self:SureBuyTimes(count) 
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBuyTimes, {cost, BuyTimes ,fucIsCanBuy,fucBuyOk })
end

function UIDojo2DView:IsCanBuyTimes(singlecost,count)
	local AllCost = singlecost * count
	local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
	if Goldcount >= AllCost then
		return true
	end
	return false
end

function UIDojo2DView:SureBuyTimes(count)
	ManagerContainer.DataMgr.ArenaData:SendBuyTimesReq(count)
end

function UIDojo2DView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'ValhallaPlayExplain'})
end

function UIDojo2DView:SetTeamData()
	local teamDatas = self.controller:GetTeams()
	for i = 1, #teamDatas do
		local go = self:GetTeamMemberGo(i)
		self:SetTeamMemberData(i,go,teamDatas[i])
	end


	local ourMembers = {}
	for i = 1, #teamDatas do
		if teamDatas[i].owned then
			local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teamDatas[i].uid,teamDatas[i].cfgId)
			if actor ~= nil then
				ourMembers[#ourMembers+1] = actor
			end
		end
	end
	AvatarRTMgr.Instance:LoadPreviewActors(ourMembers,self)
	
end

function UIDojo2DView:OnLoadCompleted()
	self:ShowBattleHeros()
end

function UIDojo2DView:SetTeamMemberData(idx,node,data)
	if node == nil or data == nil then
		return
	end

	RoleListItemCtr:SetData(self, node.roleLua.role, {idx, data.logicData, data.cfgData},self,self.OnClickHero)

	local _isBattle = ManagerContainer.DataMgr.ArenaData:IsInBattleTeam(data.uid);
	node.roleLua.selectedNode:SetActive(_isBattle)	
	node.roleLua.role.labelUp:SetActive(_isBattle)
	node.roleLua.role.labelLead:SetActive(false)
end

function UIDojo2DView:SetBattleState(uid)
	local idx = self.controller:GetHeroIdx(uid)
	local go = self:GetTeamMemberGo(idx)
	if go == nil then
		return
	end

	local _isBattle = ManagerContainer.DataMgr.ArenaData:IsInBattleTeam(uid);
	go.roleLua.role.labelUp:SetActive(_isBattle)
	go.roleLua.selectedNode:SetActive(_isBattle)	
end

function UIDojo2DView:OnClickHero(btn,params)
	local idx = params[0]
	local uid = params[1]
	local heroData = self.controller:GetHeroData(uid)
	if heroData == nil then
		return
	end

	if heroData.owned == false then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArenaChangePartnerTips2")
		return
	end

	if ManagerContainer.DataMgr.ArenaData:IsInBattleTeam(uid) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArenaChangePartnerTips1")
		return
	end

	if ManagerContainer.DataMgr.ArenaData:CurMemberCnt() >= 4 then
		self:SelectedHero(idx,uid)
	else
		ManagerContainer.DataMgr.ArenaData:OnBattle(uid)
		self:SetBattleState(uid)
		self:ShowBattleHeros()
	end
end

function UIDojo2DView:SelectedHero(idx,uid)
	if self.lastSelectedIdx ~= idx then
		if self.lastSelectedIdx ~= nil then
			local go = self:GetTeamMemberGo(self.lastSelectedIdx)
			if go ~= nil then
				local pos = go.rectTransform.anchoredPosition3D
				pos.y = 0
				LuaBattleBridge.BeginTweenRecTransformPos(go,0.1,pos)
			end
		end

		local curGo = self:GetTeamMemberGo(idx)
		if curGo ~= nil then
			local pos = curGo.rectTransform.anchoredPosition3D
			pos.y = 30
			LuaBattleBridge.BeginTweenRecTransformPos(curGo,0.1,pos)
		end
		self.curSelectedUid = uid
		self.lastSelectedIdx = idx
		self:ShowReplaceBtn(true)
	else
		local curGo = self:GetTeamMemberGo(self.lastSelectedIdx)
		if curGo ~= nil then
			local pos = curGo.rectTransform.anchoredPosition3D
			pos.y = 0
			LuaBattleBridge.BeginTweenRecTransformPos(curGo,0.1,pos)
		end
		self:ShowReplaceBtn(false)
		self.lastSelectedIdx = 0
	end
end

function UIDojo2DView:ShowBattleHeros()
	local battleActorIds = ManagerContainer.DataMgr.ArenaData:GetTeamActorIds()
	if battleActorIds~= nil then
		for i = 1, #battleActorIds do 
			local actorGo = self:GetBattleActorGo(i)
			self:SetBattleHeroData(battleActorIds[i],actorGo)
		end
	end
end

function UIDojo2DView:ShowReplaceBtn(vis)
	local battleActorIds = ManagerContainer.DataMgr.ArenaData:GetTeamActorIds()
	if battleActorIds~= nil then
		for i = 1, #battleActorIds do 
			local actorGo = self:GetBattleActorGo(i)
			actorGo.heroLua.replaceBtn:SetActive(vis)
		end
	end
end

function UIDojo2DView:SetBattleHeroData(uid,node)
	local heroData = self.controller:GetHeroData(uid)
	if heroData == nil  or node == nil then
		return
	end

	if heroData.mainRole then
		node.heroLua.heroName.text.text = ManagerContainer.DataMgr.UserData:GetUserNickname()
	else
		node.heroLua.heroName.text.text = I18N.T(heroData.cfgData.Name)
	end
	node.heroLua.heroLv.text.text = tostring(heroData.logicData.baseLevel)
	CommonUtil.LoadIcon(self, heroData.cfgData.JobIcon2, function (sprite)
        node.heroLua.jobIcon.image.sprite = sprite
	end)
	node.heroLua.heroImg.rawImage.texture = AvatarRTMgr.Instance:GetActorRT(uid)
	node.heroLua.replaceBtn:SetActive(false)
	self.uiBase:AddButtonUniqueEventListener(node.heroLua.replaceBtn.button, self, self.OnClickReplaceBtn, uid)
	node.heroLua.heroImg:SetActive(true)
	node:SetActive(true)
end

function UIDojo2DView:OnClickReplaceBtn(btn,param)
	local uid = param[0]
	if self.curSelectedUid ~= uid then
		ManagerContainer.DataMgr.ArenaData:ReplaceBattleActorId(uid,self.curSelectedUid)
		self:ShowBattleHeros()
		self:RestorePos(self.curSelectedUid)
		self:SetBattleState(self.curSelectedUid)
		self:SetBattleState(uid)
		self.curSelectedUid = 0
	end
end

function UIDojo2DView:RestorePos(uid)
	local idx = self.controller:GetHeroIdx(uid)
	local curGo = self:GetTeamMemberGo(idx)
	if curGo ~= nil then
		local pos = curGo.rectTransform.anchoredPosition3D
		pos.y = 0
		LuaBattleBridge.BeginTweenRecTransformPos(curGo,0.1,pos)
	end
end


function UIDojo2DView:GetTeamMemberGo(idx)
	if idx == 1 then
		return self.hero1
	elseif idx == 2 then
		return self.hero2
	elseif idx == 3 then
		return self.hero3
	elseif idx == 4 then
		return self.hero4
	elseif idx == 5 then
		return self.hero5
	elseif idx == 6 then
		return self.hero6
	end
	return nil
end

function UIDojo2DView:GetBattleActorGo(idx)
	if idx == 1 then
		return self.selectedHero1
	elseif idx == 2  then
		return self.selectedHero2
	elseif idx == 3 then
		return self.selectedHero3
	else
		return self.selectedHero4
	end
end

function UIDojo2DView:HideAllSelectedActorGO()
	for i = 1, 4 do
		local actorGo =  self:GetBattleActorGo(i)
		actorGo:SetActive(false)
	end
end

function UIDojo2DView:DestroyGOes()
	if self.instGoes == nil then
		return
	end

	CommonUtil.ClearGridViewItem(self, "Portrait")
	CommonUtil.ClearGridViewItem(self, "SelectedHero")

	for i = 1, #self.instGoes do
		CommonUtil.DestroyGO(self.instGoes[i])
	end
	self.instGoes = nil
end

return UIDojo2DView

