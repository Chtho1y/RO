local UINewbieBattleView = require("UINewbie/UINewbieBattleView_Generate")

function UINewbieBattleView:OnAwake(data)
	self.controller = require("UINewbie/UINewbieBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINewbieBattleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Life,self,self.OnRefreshBossLife);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Skill,self,self.OnRefreshBossSkill);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Cast_Skill,self,self.RefreshFighterSkill);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Fighter_Life,self,self.RefreshFighterLife);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Fighter_Sp,self,self.RefreshFighterSp);
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Show_Fighter,self,self.OnShowFighter)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SHOW_SKIP_BATTLE,self,self.OnShowSkipBattle)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Set_UINode_Vis,self,self.OnSetUINodeVis)
end

function UINewbieBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINewbieBattleView:Init()
	self.skipBtn:SetActive(ManagerContainer.LuaBossBattleMgr.ShowSkip)
	self.minDeltaBlood = GlobalConfig.Instance:GetConfigFloatValue(137)
	self:SetData()

	self.bossBloodNode:SetActive(false)
	-- self.playerNode1:SetActive(false)
	self.playerNode2:SetActive(false)
	self.playerNode3:SetActive(false)
	self.playerNode4:SetActive(false)
	self.playerNode5:SetActive(false)
	self.playerNode6:SetActive(false)
end

function UINewbieBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UINewbieBattleView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.skipBtn.button,self, self.OnClickSkipBattle)
end

function UINewbieBattleView:OnHide()

end

function UINewbieBattleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UINewbieBattleView:OnClose()
	self:ClearBattleSkillTimer()
	self.actorHeadMapping = nil

	if self.bossBuffLoadHandlers ~= nil then
		for k,p in pairs(self.bossBuffLoadHandlers) do
			if p > 0 then
				ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(p)
			end
		end
		self.bossBuffLoadHandlers = nil
	end

	if self.bossBuffs ~= nil then
		for i = 1, #self.bossBuffs do
			CommonUtil.DestroyGO(self.bossBuffs[i].go)
		end
	end

	if self.bossDebuffs ~= nil then
		for i = 1, #self.bossDebuffs do
			CommonUtil.DestroyGO(self.bossDebuffs[i].go)
		end
	end

	self.bossBuffs = nil
	self.bossDebuffs = nil
end

function UINewbieBattleView:OnDispose()

end

function UINewbieBattleView:SetData()
	self.lastLife = ManagerContainer.LuaBossBattleMgr.bossMaxLife
	self.bossBlood2.image.fillAmount = 1
	self.bossBlood.image.fillAmount = 1
	self.bossBloodNode.animator:Play("BossBloddShow")

	self:SetBossBattleInfo(ManagerContainer.LuaBossBattleMgr.bossName)
	self:OnRefreshBossSkill(ManagerContainer.LuaBossBattleMgr.bossSkillParam)
end

function UINewbieBattleView:SetBossBattleInfo(bossName)
	self.actorHeadMapping = {}
	self.bossBuffs = {}
	self.bossDebuffs = {}
	self.skillCDTimers = {}
	self.bossBuffLoadHandlers = {}

	local teamData =  ManagerContainer.LuaGameMgr.newbieActors

	for i =0, teamData.Count-1 do
		local actor = teamData[i]
		local go = self:GetHeadGo(i+1)
		self.actorHeadMapping[i+1] = {id = actor.ID, headGo = go}
		self:SetPlayerData(go,actor)
		go:SetActive( i==0 )
	end

	self.bossName.text.text = bossName
end

function UINewbieBattleView:SetPlayerData(playerNode,actorData)
	self:SetPlayerHead(playerNode.headBoxItem.headNode,actorData)
	-- self:RefreshHPAndSp(playerNode.headBoxItem.barNode,actorData.Life,actorData.Life,actorData.Sp,actorData.Sp)
	self:SetCurSkillInfo(playerNode.headBoxItem.skillNode,actorData.CastSkillParam)
	playerNode.headBoxItem.deadNode:SetActive(false)
	playerNode.playerName.text.text = actorData.Name
	-- playerNode:SetActive(true)
end

function UINewbieBattleView:SetPlayerHead(headNode,actorData)
	if headNode == nil  or actorData == nil then
		return
	end

	headNode.levelText.text.text = tostring(actorData.Level)
	CommonUtil.LoadIcon(self, actorData.ProfessionIcon, function (sprite)
		headNode.jobIcon.image.sprite = sprite
		end)

	CommonUtil.LoadIcon(self, actorData.HeadIcon, function (sprite)
		headNode.head.image.sprite = sprite
		end)
end

function UINewbieBattleView:SetCurSkillInfo(skillNode,skillInfo)
	CommonUtil.SetCurSkillInfo(skillNode,skillInfo,self,self.UpdateSkillCDTimer)
end

function UINewbieBattleView:UpdateSkillCDTimer(sequence,params)
	local skillParam = params.skillParam
	local totalTime = params.totalTime
	skillParam.cdTime  = skillParam.cdTime - 0.1
	local leftTime = skillParam.cdTime;
	if leftTime < 0 then
		leftTime = 0
	end

	local headGo = self:GetActorHeadGo(skillParam.actorId)
	if headGo ~= nil then
		CommonUtil.UpdateSkillCD(headGo.headBoxItem.skillNode,leftTime,totalTime)
	end
end

function UINewbieBattleView:RefreshHPAndSp(barNode,hp,maxHp,sp,maxSp)
	if barNode == nil then
		return
	end

	if hp ~= nil and maxHp ~= nil then
		barNode.hp.image.fillAmount = hp/maxHp
	end

	if sp~=nil and maxSp~=nil then
		barNode.sp.image.fillAmount = sp/maxSp
	end
end

function UINewbieBattleView:RefreshFighterSkill(skillParam)
	if skillParam == nil then
		return
	end

	local headGo = self:GetActorHeadGo(skillParam.actorId)
	CommonUtil.SetFighterSkill(headGo.headBoxItem,skillParam,self,self.UpdateSkillCDTimer)
end

function UINewbieBattleView:RefreshFighterLife(actorId,life,maxLife)
	local headGo = self:GetActorHeadGo(actorId)
	if headGo ~= nil then
		self:RefreshHPAndSp(headGo.headBoxItem.barNode,life,maxLife,nil,nil)
		headGo.headBoxItem.deadNode:SetActive(life == 0)
		if life == 0 then
			headGo.headBoxItem.animator:Play("Dead")
		end
	end
end

function UINewbieBattleView:RefreshFighterSp(actorId,sp,maxSp)
	local headGo = self:GetActorHeadGo(actorId)
	if headGo ~= nil then
		self:RefreshHPAndSp(headGo.headBoxItem.barNode,nil,nil,sp,maxSp)
	end
end

function UINewbieBattleView:OnShowFighter(actorId)
	local headGo = self:GetActorHeadGo(actorId)
	if headGo ~= nil then
		headGo:SetActive(true)
	end
end

function UINewbieBattleView:GetActorHeadGo(actorId)
	if self.actorHeadMapping == nil then
		return nil
	end

	for i=1, #self.actorHeadMapping do
		if self.actorHeadMapping[i].id == actorId then
			return self.actorHeadMapping[i].headGo
		end
	end
	return nil
end

function UINewbieBattleView:GetHeadGo(idx)
	if idx == 1 then
		return self.playerNode1
	end

	if idx == 2 then
		return self.playerNode2
	end

	if idx == 3 then
		return self.playerNode3
	end

	if idx == 4 then
		return self.playerNode4
	end

	if idx == 5 then
		return self.playerNode5
	end

	if idx == 6 then
		return self.playerNode6
	end

	return nil
end

function UINewbieBattleView:OnRefreshBossLife(life,maxLife)
	local deltaLife = (self.lastLife - life)/maxLife
	if deltaLife>0 and deltaLife < self.minDeltaBlood and life > 0 then
		return
	end

	self.lastLife = life
	self.bossBlood.image.fillAmount = life / maxLife
	LuaBattleBridge.TweemFillAmount(self.bossBlood2,life / maxLife,0.5)

	if life == 0 then
		self.bossBloodNode.animator:Play("BossBloddClose");
	end
end

function UINewbieBattleView:OnRefreshBossSkill(skillParam)
	if self.bossSkillNode == nil or skillParam == nil then
		return
	end

	CommonUtil.LoadIcon(self, skillParam.skillIcon, function (sprite)
		self.bossSkillIcon.image.sprite = sprite
		end)

	self.bossSkillNode.forbidNode:SetActive(skillParam.IsForbidden)
	self.bossSkillNode.extraNode:SetActive(skillParam.IsEnhance)

	if skillParam.IsCasting then
		self.bossSkillProgress:SetActive(false)
		self.bossSkillCD:SetActive(false)

		self.bossSkillNode.releaseNode:SetActive(true)
		self.bossSkillNode.keepNode:SetActive(true)
		self.bossSkillNode.waitNode:SetActive(false)

		self:ClearBossSkillTimer()
		self.bossSkillNode.animator:Play("BossSkillRelease")
	else

		if skillParam.IsForbidden then
			self.bossSkillNode.animator:Play("SkillForbidden");
		else
			self.bossSkillNode.animator:Play("BossWait");
		end

		self:UpdateBossSkillCD(skillParam.cdTime,skillParam.cdTime)
		self.bossSkillProgress:SetActive(true)
		self.bossSkillCD:SetActive(true)
		self.bossSkillNode.releaseNode:SetActive(false)
		self.bossSkillNode.keepNode:SetActive(false)

		local cnt = skillParam.cdTime * 1000 / 100
		self:ClearBossSkillTimer()
		self.bossSkillTimer = ManagerContainer.LuaTimerMgr:AddTimer(100, cnt, self, self.UpdateBossSkillCDTimer, {skillParam = skillParam,totalTime = skillParam.cdTime})
	end
end

function UINewbieBattleView:UpdateBossSkillCD(leftTime,totalTime)
	local time = CommonUtil.GetPreciseDecimal(leftTime,1)
	if totalTime > 0 and time > 0 then
		self.bossSkillProgress.image.fillAmount = time/totalTime
		-- self.bossSkillCD.text.text = tostring(time)
		self.bossSkillCD.text.text = ""
	else
		self.bossSkillProgress.image.fillAmount = 0
		self.bossSkillCD.text.text = ""
	end
	self.bossSkillNode.waitNode:SetActive(time == 0)
end

function UINewbieBattleView:UpdateBossSkillCDTimer(sequence,params)
	local skillParam = params.skillParam
	local totalTime = params.totalTime
	skillParam.cdTime  = skillParam.cdTime - 0.1
	local leftTime = skillParam.cdTime;
	if leftTime < 0 then
		leftTime = 0
	end
	self:UpdateBossSkillCD(leftTime,totalTime)
end

function UINewbieBattleView:ClearBossSkillTimer()
	if self.bossSkillTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.bossSkillTimer)
		self.bossSkillTimer = nil
	end
end

function UINewbieBattleView:OnRefreshBossBuff(buffIcon,isDebuff)
	if self:HasBuffIconGo(buffIcon,isDebuff) then
		return
	end

	if isDebuff then
		local buffGo =  UnityEngine.GameObject.Instantiate(self.bossDebuffTemp)
		buffGo:SetActive(true)
		buffGo.transform:SetParent(self.bossDebuffTemp.transform.parent)
		buffGo.transform.localScale = Vector3.one
		buffGo.transform.localPosition = Vector3.zero
		buffGo.name = buffIcon

		self.bossDebuffs[#self.bossDebuffs+1] = {icon = buffIcon, go = buffGo }
		self:LoadBuffIcon(buffGo,buffIcon)
	else
		local buffGo =  UnityEngine.GameObject.Instantiate(self.bossBuffTemp)
		buffGo:SetActive(true)
		buffGo.transform:SetParent(self.bossBuffTemp.transform.parent)
		buffGo.transform.localScale = Vector3.one
		buffGo.transform.localPosition = Vector3.zero
		buffGo.name = buffIcon

		self.bossBuffs[#self.bossBuffs+1] = {icon = buffIcon, go = buffGo }
		self:LoadBuffIcon(buffGo,buffIcon)
	end
end

function UINewbieBattleView:HasBuffIconGo(buffIcon,isDebuff)
	if isDebuff then
		if self.bossBuffs == nil then
			return false
		end

		for i = 1, #self.bossBuffs do
			if self.bossBuffs[i].icon == buffIcon then
				return true
			end
		end
	else
		if self.bossDebuffs == nil then
			return false
		end

		for i = 1, #self.bossDebuffs do
			if self.bossDebuffs[i].icon == buffIcon then
				return true
			end
		end
	end
	return false
end

function UINewbieBattleView:LoadBuffIcon(buffGo,buffIcon)
	if buffGo == nil or buffIcon == nil then
		return
	end

	local img = buffGo:GetComponent(Enum.TypeInfo.Image)
	if img == nil then
		return
	end

	local handler =  CommonUtil.LoadIcon(self, buffIcon, function (sprite)
			self.bossBuffLoadHandlers[buffIcon] = nil
			if img ~= nil and sprite ~= nil then
				img.sprite = sprite
			end
		end)

	self.bossBuffLoadHandlers[buffIcon] = handler
end

function UINewbieBattleView:RemoveBuffIconGo(buffIcon,isDebuff)
	if isDebuff then
		if self.bossBuffs ~= nil then
			for i = 1, #self.bossBuffs do
				if self.bossBuffs[i].icon == buffIcon then
					self:RemoveBuffLoadHandler(buffIcon)
					CommonUtil.DestroyGO(self.bossBuffs[i].go)
					self.bossBuffs[i].go = nil
					table.remove(self.bossBuffs, i)
					return
				end
			end
		end
	else
		if self.bossDebuffs ~= nil then
			for i = 1, #self.bossDebuffs do
				if self.bossDebuffs[i].icon == buffIcon then
					self:RemoveBuffLoadHandler(buffIcon)
					CommonUtil.DestroyGO(self.bossDebuffs[i].go)
					self.bossDebuffs[i].go = nil
					table.remove(self.bossDebuffs, i)
					return
				end
			end
		end
	end
end

function UINewbieBattleView:RemoveBuffLoadHandler(buffIcon)
	if self.bossBuffLoadHandlers[buffIcon] ~= nil then
		ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(self.bossBuffLoadHandlers[buffIcon])
		self.bossBuffLoadHandlers[buffIcon] =  nil
	end
end

function UINewbieBattleView:OnRefreshRemoveBossBuff(buffIcon)
	if self:HasBuffIconGo(buffIcon,true) then
		self:RemoveBuffIconGo(buffIcon,true)
	elseif self:HasBuffIconGo(buffIcon,false) then
		self:RemoveBuffIconGo(buffIcon,false)
	end
end

function UINewbieBattleView:ClearBattleSkillTimer()
	if self.skillCDTimers ~= nil then
		for v,p in pairs(self.skillCDTimers) do
			ManagerContainer.LuaTimerMgr:RemoveTimer(p)
		end
		self.skillCDTimers = nil
	end

	if self.bossSkillTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.bossSkillTimer)
		self.bossSkillTimer = nil
	end

	if self.actorHeadMapping ~= nil then
		for i= 1, #self.actorHeadMapping do
			CommonUtil.UpdateSkillCD(self.actorHeadMapping[i].headGo.headBoxItem.skillNode,0,1)
		end
	end

	self:UpdateBossSkillCD(0,0)
end

function UINewbieBattleView:OnShowSkipBattle()
	self.skipBtn:SetActive(true)
end

function UINewbieBattleView:OnSetUINodeVis(nodePath)
	if nodePath == nil then
		return
	end

	local nodeTrans = self.transform:Find(nodePath)
	if nodeTrans ~= nil then
		nodeTrans.gameObject:SetActive(true)
	end
end

function UINewbieBattleView:OnClickSkipBattle()
	LuaBattleBridge.SkipNewbieBattle()
end

return UINewbieBattleView

