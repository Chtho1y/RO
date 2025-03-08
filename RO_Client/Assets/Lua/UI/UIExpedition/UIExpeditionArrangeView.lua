local UIExpeditionArrangeView = require("UIExpedition/UIExpeditionArrangeView_Generate")
local RoleListItemCtr = require("Common/RoleListItemCtr")

function UIExpeditionArrangeView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionArrangeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionArrangeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Expedition_RefreshData,self,self.RefreshData)
end

function UIExpeditionArrangeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionArrangeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionArrangeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.helpBtn.button,self, self.OnClickHelpBtn)
	self.uiBase:AddButtonEventListener(self.helpLogBtn.button,self, self.OnClickHelpLogBtn)
end

function UIExpeditionArrangeView:OnHide()

end

function UIExpeditionArrangeView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionArrangeView:OnClose()
	self:DestroyGOes()
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

function UIExpeditionArrangeView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionArrangeView:Init()
	self.instGoes = nil
	self.curSelectedUid = 0
	self.lastSelectedIdx = 0
	self:HideAllSelectedActorGO()
	self:LoadOtherUI()
end

function UIExpeditionArrangeView:LoadOtherUI()
	self.isLoading = true
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Expedition_UIPart_Loaded,self,self.OnUIPartLoaded);
	local partResPaths = {"UIExpedition/SelectedHeroExp","UIExpedition/PortraitExp"}
	local seqId =  ManagerContainer.ResMgr:LoadAssetGameObjects(Constants.UIPath, ELoadType.OTHER, function(objs)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_UIPart_Loaded,objs)
	end, unpack(partResPaths))
end

function UIExpeditionArrangeView:OnUIPartLoaded(objs)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Expedition_UIPart_Loaded,self,self.OnUIPartLoaded);
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
		memberNode.roleLua = CommonUtil.BindGridViewItem2Lua(self, "PortraitExp", go)
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
		charGo.heroLua = CommonUtil.BindGridViewItem2Lua(self, "SelectedHeroExp", go)
	end

	self:SetTeamData()
end

function UIExpeditionArrangeView:HideAllSelectedActorGO()
	for i = 1, 4 do
		local actorGo =  self:GetBattleActorGo(i)
		actorGo:SetActive(false)
	end
end

function UIExpeditionArrangeView:RefreshData()
	local teamDatas = self.controller:GetTeams()
	for i = 1, #teamDatas do
		local go = self:GetTeamMemberGo(i)
		self:SetTeamMemberData(i,go,teamDatas[i])
	end

	self:ShowBattleHeros()
end

function UIExpeditionArrangeView:ShowBattleHeros()
	local battleActorIds = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurrBattleTeamMembers()
	if battleActorIds~= nil then
		for i = 1, #battleActorIds do 
			local actorGo = self:GetBattleActorGo(i)
			self:SetBattleHeroData(battleActorIds[i],actorGo)
		end
	end

	self.fighterPowerText.text.text = tostring(ManagerContainer.DataMgr.ExpeditionDataMgr:GetTeamTotalFightPower())
end

function UIExpeditionArrangeView:GetBattleActorGo(idx)
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

function UIExpeditionArrangeView:SetBattleHeroData(uid,node)
	local heroData = self.controller:GetHeroData(uid)
	if heroData == nil  or node == nil then
		return
	end

	local hpPercent,spPercent = ManagerContainer.DataMgr.ExpeditionDataMgr:GetHeroHPAndSP(uid)
	node.heroLua.helpNode:SetActive(hpPercent == 0)
	if hpPercent == 0 then
		AvatarRTMgr.Instance:PlayAnim(uid,"f_Injured")
	else
		AvatarRTMgr.Instance:PlayAnim(uid,"f_idle")
	end
	CommonUtil.NeedUIGray(node.heroLua.heroImg.rawImage,hpPercent == 0)

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

function UIExpeditionArrangeView:OnClickReplaceBtn(btn,param)
	local uid = param[0]
	if self.curSelectedUid ~= uid then
		local hpPercent,spPercent = ManagerContainer.DataMgr.ExpeditionDataMgr:GetHeroHPAndSP(self.curSelectedUid)
		if hpPercent == 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionDead")
			return
		end

		ManagerContainer.DataMgr.ExpeditionDataMgr:ReplaceBattleActorId(uid,self.curSelectedUid)
		self:ShowBattleHeros()
		self:RestorePos(self.curSelectedUid)
		self:SetBattleState(self.curSelectedUid)
		self:SetBattleState(uid)
		self.curSelectedUid = 0
	end
end

function UIExpeditionArrangeView:RestorePos(uid)
	local idx = self.controller:GetHeroIdx(uid)
	local curGo = self:GetTeamMemberGo(idx)
	if curGo ~= nil then
		local pos = curGo.rectTransform.anchoredPosition3D
		pos.y = 0
		LuaBattleBridge.BeginTweenRecTransformPos(curGo,0.1,pos)
	end
end

function UIExpeditionArrangeView:SetTeamData()
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

function UIExpeditionArrangeView:OnLoadCompleted()
	self:ShowBattleHeros()
end

function UIExpeditionArrangeView:GetTeamMemberGo(idx)
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

function UIExpeditionArrangeView:SetTeamMemberData(idx,node,data)
	if node == nil or data == nil then
		return
	end

	RoleListItemCtr:SetData(self, node.roleLua.role, {idx, data.logicData, data.cfgData},self,self.OnClickHero)

	local _isBattle = ManagerContainer.DataMgr.ExpeditionDataMgr:IsInBattleTeam(data.uid);
	node.roleLua.statusNode:SetActive(data.owned)
	node.roleLua.selectedNode:SetActive(_isBattle)	
	node.roleLua.role.labelUp:SetActive(_isBattle)
	node.roleLua.role.labelLead:SetActive(false)

	local hpPercent,spPercent = ManagerContainer.DataMgr.ExpeditionDataMgr:GetHeroHPAndSP(data.uid)
	node.roleLua.hp.image.fillAmount = hpPercent * 0.01
	node.roleLua.sp.image.fillAmount = spPercent * 0.01
end

function UIExpeditionArrangeView:OnClickHero(btn,params)
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

	if ManagerContainer.DataMgr.ExpeditionDataMgr:IsInBattleTeam(uid) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArenaChangePartnerTips1")
		return
	end

	if ManagerContainer.DataMgr.ExpeditionDataMgr:CurMemberCnt() >= 4 then
		self:SelectedHero(idx,uid)
	else
		ManagerContainer.DataMgr.ExpeditionDataMgr:OnBattle(uid)
		self:SetBattleState(uid)
		self:ShowBattleHeros()
	end
end

function UIExpeditionArrangeView:SelectedHero(idx,uid)
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

function UIExpeditionArrangeView:ShowReplaceBtn(vis)
	local battleActorIds = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurrBattleTeamMembers()
	if battleActorIds~= nil then
		for i = 1, #battleActorIds do 
			local actorGo = self:GetBattleActorGo(i)
			actorGo.heroLua.replaceBtn:SetActive(vis)
		end
	end
end

function UIExpeditionArrangeView:SetBattleState(uid)
	local idx = self.controller:GetHeroIdx(uid)
	local go = self:GetTeamMemberGo(idx)
	if go == nil then
		return
	end

	local _isBattle = ManagerContainer.DataMgr.ExpeditionDataMgr:IsInBattleTeam(uid);
	go.roleLua.role.labelUp:SetActive(_isBattle)
	go.roleLua.selectedNode:SetActive(_isBattle)	
end

function UIExpeditionArrangeView:OnClickBackBtn()
	if AvatarRTMgr.Instance.IsLoading  or self.isLoading then
		return
	end
	
	AvatarRTMgr.Instance:Hide()
	self:UIClose()
end

function UIExpeditionArrangeView:OnClickHelpBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionHelp)
end

function UIExpeditionArrangeView:OnClickHelpLogBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpiditionHelpLog)
end

function UIExpeditionArrangeView:DestroyGOes()
	if self.instGoes == nil then
		return
	end

	CommonUtil.ClearGridViewItem(self, "PortraitArrange")
	CommonUtil.ClearGridViewItem(self, "SelectedHeroArrange")

	for i = 1, #self.instGoes do
		CommonUtil.DestroyGO(self.instGoes[i])
	end
	self.instGoes = nil
end


return UIExpeditionArrangeView

