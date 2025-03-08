local UIBattleStatisticsView = require("UIBattle/UIBattleStatisticsView_Generate")

function UIBattleStatisticsView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleStatisticsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleStatisticsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_BattleStatistics,self,self.OnRefreshStatistics);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Enable_Scroll_Skill_Pnl,self,self.OnEnableScrollSkillPnl)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Scroll_Skill_Pnl,self,self.OnScrollSkillPnl);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_FIGHTING_START,self,self.OnFightingStart);
end

function UIBattleStatisticsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleStatisticsView:Init()
	self.pixelPerSecond = 30
	self.timeNodes = {}
	self.curToggleType = 1
	self.beginDrag = false
	self.initStaticsPnl = false
	self.initSkillPnl = false
	self.battleMode = self.controller:GetBattleMode()
	self.battleSubMode = self.controller:GetBattleSubMode()
	self.skillNodeList = {}
	self.data = LuaBattleBridge.GetBattleStatistics(self.battleMode,self.battleSubMode)
	self:InitComs()

	self.speed = 1
	self.StatisticsTog.toggle.isOn = true
	self.SkillTog.toggle.isOn = false
	self:ShowStatisticsPnl()
	self:InitSkillPnl()
	self.leftX = -480
	self.lastPassedTime = 0
end

function UIBattleStatisticsView:InitComs()
	local timeLineNode = self.SkillPnl.skillsInfoNode.content.timelineNode
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode1
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode2
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode3
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode4
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode5
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode6
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode7
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode8
	self.timeNodes[#self.timeNodes+1] = timeLineNode.timeNode9


	self.statisticsActorNodes = {}
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.statisticsPnl.actorNode1
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.statisticsPnl.actorNode2
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.statisticsPnl.actorNode3
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.statisticsPnl.actorNode4

	self.friendSkillActorNodes = {}
	self.friendSkillActorNodes[#self.friendSkillActorNodes+1] = self.SkillPnl.FightersNode.FriendTeam.actorNode1
	self.friendSkillActorNodes[#self.friendSkillActorNodes+1] = self.SkillPnl.FightersNode.FriendTeam.actorNode2
	self.friendSkillActorNodes[#self.friendSkillActorNodes+1] = self.SkillPnl.FightersNode.FriendTeam.actorNode3
	self.friendSkillActorNodes[#self.friendSkillActorNodes+1] = self.SkillPnl.FightersNode.FriendTeam.actorNode4

	self.bossSkillActorNodes = {}
	self.bossSkillActorNodes[#self.bossSkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.bossNode1
	self.bossSkillActorNodes[#self.bossSkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.bossNode2
	self.bossSkillActorNodes[#self.bossSkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.bossNode3
	self.bossSkillActorNodes[#self.bossSkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.bossNode4

	self.enemySkillActorNodes = {}
	self.enemySkillActorNodes[#self.enemySkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.actorNode1
	self.enemySkillActorNodes[#self.enemySkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.actorNode2
	self.enemySkillActorNodes[#self.enemySkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.actorNode3
	self.enemySkillActorNodes[#self.enemySkillActorNodes+1] = self.SkillPnl.FightersNode.EnemyTeam.actorNode4

	self.enemySkillPoints = {}
	self.enemySkillPoints[#self.enemySkillPoints+1] = self.skillList.enemyPoint1
	self.enemySkillPoints[#self.enemySkillPoints+1] = self.skillList.enemyPoint2
	self.enemySkillPoints[#self.enemySkillPoints+1] = self.skillList.enemyPoint3
	self.enemySkillPoints[#self.enemySkillPoints+1] = self.skillList.enemyPoint4

	self.friendSkillPoints = {}
	self.friendSkillPoints[#self.friendSkillPoints+1] = self.skillList.friendPoint1
	self.friendSkillPoints[#self.friendSkillPoints+1] = self.skillList.friendPoint2
	self.friendSkillPoints[#self.friendSkillPoints+1] = self.skillList.friendPoint3
	self.friendSkillPoints[#self.friendSkillPoints+1] = self.skillList.friendPoint4

	for i = 1, #self.statisticsActorNodes do 
		self.statisticsActorNodes[i]:SetActive(false)
	end

	for i = 1, #self.friendSkillActorNodes do 
		self.friendSkillActorNodes[i]:SetActive(false)
	end

	for i = 1, #self.bossSkillActorNodes do 
		self.bossSkillActorNodes[i]:SetActive(false)
	end

	for i = 1, #self.enemySkillActorNodes do 
		self.enemySkillActorNodes[i]:SetActive(false)
	end

	for i = 1, #self.enemySkillPoints do 
		self.enemySkillPoints[i]:SetActive(false)
	end

	for i = 1, #self.friendSkillPoints do 
		self.friendSkillPoints[i]:SetActive(false)
	end
end

function UIBattleStatisticsView:OnFightingStart()
	if self.data == nil then
		self.data = LuaBattleBridge.GetBattleStatistics(self.battleMode,self.battleSubMode)
		self:ShowStatisticsPnl()
	end
	self:InitSkillPnl()
end

function UIBattleStatisticsView:InitSkillPnl()
	if self.data == nil then
		return
	end

	self.SkillPnl.skillsInfoNode.content.timelineNode.endNode:SetActive(false)
	
	local enemyList = self.data.EnemyStatistics
	local friendList = self:GetSlotSortActor(self.data.FriendStatistics)

	if enemyList ~= nil then
		for i = 1, enemyList.Count do
			if self.battleMode == BattleMode.Normal then
				self:ShowSkillPnlBossData(self.bossSkillActorNodes[i],enemyList[i-1])
			elseif self.battleMode == BattleMode.Versus then
				self:ShowSkillPnlActorData(self.enemySkillActorNodes[i],enemyList[i-1])
			elseif self.battleMode == BattleMode.Time then
				self:ShowSkillPnlBossData(self.bossSkillActorNodes[i],enemyList[i-1])
			end 
			self:ResetSkillData(enemyList[i-1].skillStatistics)
			self.enemySkillPoints[i]:SetActive(true)
		end
		self.SkillPnl.FightersNode.EnemyTeam:SetActive(enemyList.Count > 0)
		self.skillList.enemySkillNode:SetActive(enemyList.Count > 0)
	else
		self.SkillPnl.FightersNode.EnemyTeam:SetActive(false)
		self.skillList.enemySkillNode:SetActive(false)
	end

	if friendList ~= nil then
		for i = 1, #friendList do
			self:ShowSkillPnlActorData(self.friendSkillActorNodes[i],friendList[i])
			self:ResetSkillData(friendList[i].skillStatistics)
			self.friendSkillPoints[i]:SetActive(true)
		end
	end

	self.initSkillPnl = (enemyList~=nil and  enemyList.Count  > 0)  or (friendList~=nil and #friendList > 0)
	if self.curToggleType == 2 then
		self.SkillPnl:SetActive(true)
		self.delayShowSkillPnl = ManagerContainer.LuaTimerMgr:AddTimer(100, 1,self,self.DelayShowSkillPnl,nil);
	end
end

function UIBattleStatisticsView:DelayShowSkillPnl()
	if self.curToggleType == 2 then
		self.SkillPnl:SetActive(false)
		self.SkillPnl:SetActive(true)
	end
end

function UIBattleStatisticsView:ResetSkillData(skillStatisticsData)
	if skillStatisticsData == nil or skillStatisticsData.Length < 2 then
		return
	end

	for i = 2, skillStatisticsData.Length do
		local skillData = skillStatisticsData[i-1]
		if skillData ~= nil  and skillData.castingTimeList ~= nil then
			skillData:ResetCreateCnt()
			skillStatisticsData[i-1] = skillData
		end
	end
end

function UIBattleStatisticsView:GetSlotSortActor(tbFriend)
	--伙伴界面排序
	if nil == tbFriend then
		return nil
	end
	local sortedPartnerDatas =  ManagerContainer.DataMgr.PartnerData:SortPartnerData()
	--根据伙伴界面排序 排序
	local sortedData = {}	
	for j =1, tbFriend.Count do--主角第一
		local actor = tbFriend[j-1]	
		local UserId = 1		
		if tostring(UserId)==tostring(actor.fighterId) then	
			table.insert(sortedData,actor)
		end		
	end
	for i=1, #sortedPartnerDatas do	--伙伴排序
		local PartnerData = sortedPartnerDatas[i]		
		for j =1, tbFriend.Count do
			local actor = tbFriend[j-1]					 
			if tostring(PartnerData.id)==tostring(actor.fighterId) then
				table.insert(sortedData,actor)			
			end
		end
	end
	return sortedData
end

function UIBattleStatisticsView:ShowStatisticsPnl()
	if self.data == nil then
		return
	end

	local friendList = self:GetSlotSortActor(self.data.FriendStatistics)
	if friendList == nil then
		return
	end

	for i = 1, #friendList do
		self:ShowFighterStatistics(self.statisticsActorNodes[i],friendList[i])
	end

	self.initStaticsPnl = #friendList  > 0
	self.statisticsPnl:SetActive(true)
	self.SkillPnl:SetActive(false)
end

function UIBattleStatisticsView:OnRefreshStatistics()
	if self.data == nil then
		return
	end

	if self.initSkillPnl == false then
		self:InitSkillPnl()
	end

	if self.initStaticsPnl == false  and self.curToggleType == 1 then
		self:ShowStatisticsPnl()
	end

	local friendList = self:GetSlotSortActor(self.data.FriendStatistics)
	if friendList == nil then
		return
	end

	for i = 1, #friendList do
		self:SetNodeVal(self.statisticsActorNodes[i].damageNode,friendList[i].basedamage + friendList[i].reflectdamage,friendList[i].basedamagePercent)
		self:SetNodeVal(self.statisticsActorNodes[i].defenseNode,friendList[i].naturedamage,friendList[i].naturedamagePercent)
		self:SetNodeVal(self.statisticsActorNodes[i].assistNode,friendList[i].petdamage,friendList[i].petdamagePercent)
	end
end

function UIBattleStatisticsView:ShowSkillPnl()
	if self.data == nil then
		return
	end

	-- LogError("----ShowSkillPnl----")
	self.SkillPnl.skillsInfoNode.content.timelineNode.endNode:SetActive(false)
	self:CheckNewSkills()
	self.statisticsPnl:SetActive(false)
	self.SkillPnl:SetActive(true)

	if self.data.EndTime  < 1  then
		if self.scrollTimer == nil then
			self.scrollTimer = ManagerContainer.LuaTimerMgr:AddTimer(30, -1,self,self.AutoRefreshSkillPnl,nil);
			self:SetStartNode(self.pixelPerSecond - self.data.PassedTime * self.pixelPerSecond)
		end
	else
		self:SetStartNode(-610)
		self:ShowEndNode()
		if self.data.EndTime > 0 then
			local cnt = math.ceil(self.data.EndTime / 5)
			for i= 1, cnt do
				local go = self:GetTimeNode(i)
				go:SetActive(true)
			end
		end
	end
end

function UIBattleStatisticsView:GetTimeNode(idx)
	if idx <= #self.timeNodes then
		return self.timeNodes[idx]
	end

	local go =  UnityEngine.GameObject.Instantiate(self.SkillPnl.skillsInfoNode.content.timelineNode.timeNode9.gameObject)
	local txt = go:GetComponent(Enum.TypeInfo.Text)
	if txt ~= nil then
		txt.text = (idx * 5) .. "s"
	end
	go.name = (idx * 5) .. "s"
	local rectTransform = go:GetComponent(Enum.TypeInfo.RectTransform)
	rectTransform:SetParent(self.SkillPnl.skillsInfoNode.content.timelineNode.transform, false);
	rectTransform.localRotation = Quaternion.identity;
	rectTransform.localScale = Vector3(1,1,1);
	rectTransform.pivot = Vector2 (0.5, 0.5);
	self.timeNodes[#self.timeNodes+1] = go
	return go
end

function UIBattleStatisticsView:SetStartNode(px)
	local pos = self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition
	pos.x = px
	self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition = pos
end

function UIBattleStatisticsView:OnEnableScrollSkillPnl(draging)
	self.beginDrag = draging
	if self.beginDrag then
		self:CleanTimer()
	else
		if self.scrollTimer == nil and self.data.EndTime < 1 then
			self.scrollTimer = ManagerContainer.LuaTimerMgr:AddTimer(30, -1,self,self.AutoRefreshSkillPnl,nil);
			self:SetStartNode(self.pixelPerSecond - self.data.PassedTime * self.pixelPerSecond)
		else
			-- local pos = self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition
			-- if pos.x > self.leftX then
			-- 	self:SetStartNode(self.leftX)
			-- elseif pos.x < -(150+self.data.EndTime * self.pixelPerSecond) then
			-- 	self:SetStartNode(-(150+self.data.EndTime * self.pixelPerSecond))
			-- end
		end
	end
end

function UIBattleStatisticsView:OnScrollSkillPnl()
	local deltaX = self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.currentEventData.delta.x
	local pos = self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition
	pos.x = pos.x + deltaX
	
	if deltaX > 0 then		--往右拖
		if pos.x > 0 then
			pos.x = 0
		end 
	elseif deltaX < 0 then	--往左拖
		if pos.x < -(630+self.data.EndTime * self.pixelPerSecond) then
			pos.x = -(630+self.data.EndTime * self.pixelPerSecond)
		end
	end
	
	self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition = pos
end

function UIBattleStatisticsView:ShowEndNode()
	local pos = self.SkillPnl.skillsInfoNode.content.timelineNode.endNode.rectTransform.anchoredPosition
	pos.x = self.data.EndTime * self.pixelPerSecond
	self.SkillPnl.skillsInfoNode.content.timelineNode.endNode.rectTransform.anchoredPosition = pos
	self.SkillPnl.skillsInfoNode.content.timelineNode.endNode:SetActive(true)
	-- LogError("----ShowEndNode----")
end

function UIBattleStatisticsView:AutoRefreshSkillPnl()
	if self.data.EndTime > 1 then
		self:ShowEndNode()
		self:CheckNewSkills()
		self:CleanTimer()
	else
		local pos = self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition
		if pos then
			pos.x = -self.data.PassedTime * self.pixelPerSecond
			self.SkillPnl.skillsInfoNode.content.rectTransform.anchoredPosition = pos
		end
		self:CheckNewSkills()
		local cnt = #self.timeNodes
		if self.data.PassedTime > cnt * 5 then
			local cnt = math.ceil(self.data.PassedTime / 5)
			for i= 1, cnt + 9 do
				local go = self:GetTimeNode(i)
				go:SetActive(true)
			end
		end
	end
end

function UIBattleStatisticsView:CheckNewSkills()
	local enemyList = self.data.EnemyStatistics
	local friendList = self:GetSlotSortActor(self.data.FriendStatistics)

	if enemyList ~= nil then
		for i = 1, enemyList.Count do
			if self.battleMode == BattleMode.Normal then
				self:ShowSkillData(self.enemySkillPoints[i],enemyList[i-1].skillStatistics)
			else
				self:ShowSkillData(self.enemySkillPoints[i],enemyList[i-1].skillStatistics)
			end 
		end
	end

	if friendList ~= nil then
		for i = 1, #friendList do
			self:ShowSkillData(self.friendSkillPoints[i],friendList[i].skillStatistics)
		end
	end
end

function UIBattleStatisticsView:ShowSkillPnlBossData(node,data)
	node.bossName.text.text = data.actorName
	node.bossLevel.text.text = "Lv." .. data.level
	node:SetActive(true)
end

function UIBattleStatisticsView:ShowSkillPnlActorData(node,data)
	CommonUtil.LoadIcon(self, data.jobIcon, function (sprite)
		node.jobIcon.image.sprite = sprite
		end)
	node.actorName.text.text = data.actorName
	node:SetActive(true)
end

function UIBattleStatisticsView:ShowSkillData(parentNode,skillStatisticsData)
	if skillStatisticsData == nil or skillStatisticsData.Length < 2 then
		return
	end

	for i = 2, skillStatisticsData.Length do
		local skillData = skillStatisticsData[i-1]
		if skillData ~= nil  and skillData.castingTimeList ~= nil then
			for j = skillData.createdCnt, skillData.castingTimeList.Count-1 do
				local castingTime = skillData.castingTimeList[j]
				self:CreateCastingSkillData(parentNode,skillData.skillIcon,skillData.skillId,skillData.skillLevel,castingTime)
				skillData:AddCreateCnt()
			end
			skillStatisticsData[i-1] = skillData
		end
	end
end

function UIBattleStatisticsView:CreateCastingSkillData(parentNode,skilIcon,skillId,skillLevel,time)
	local timeLinePos = self.SkillPnl.skillsInfoNode.content.timelineNode.rectTransform.anchoredPosition
	local py = 0
	local px = timeLinePos.x + time * self.pixelPerSecond

	local skillNode = UnityEngine.GameObject.Instantiate(self.CastingSkillItem.gameObject)
	self.skillNodeList[#self.skillNodeList+1] = skillNode
	local skillLua = CommonUtil.BindGridViewItem2Lua(self, "CastingSkillItem", skillNode)
	skillLua.prefabName = "CastingSkillItem"
	
	skillNode.name = "skillItem"
	skillLua.transform:SetParent(parentNode.transform)
	skillLua.transform.localScale = Vector3(1,1,1)
	skillLua.rectTransform.anchoredPosition3D = Vector3(px,py,0)
	skillLua.skillTime.text.text = CommonUtil.GetPreciseDecimal(time,1) .. "s"
	skillLua:SetActive(true)
	CommonUtil.LoadIcon(self, skilIcon, function (sprite)
		skillLua.skillIcon.image.sprite = sprite
		end)
	self.uiBase:AddButtonUniqueEventListener(skillLua.skillIcon.button, self, self.OnClickSkill, skillId,skillLevel)
end

function UIBattleStatisticsView:OnClickSkill(btn,params)
	local skillId = params[0]
	local skillLv = params[1]
	local data = { tipsType = Enum.UITipsType.Skill, cfgId = skillId, num = skillLv }
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIBattleStatisticsView:ShowFighterStatistics(node,data)
	CommonUtil.LoadIcon(self, data.jobIcon, function (sprite)
		node.jobIcon.image.sprite = sprite
		end)
	node.actorName.text.text = data.actorName
	self:SetNodeVal(node.damageNode,data.basedamage + data.reflectdamage,data.basedamagePercent)
	self:SetNodeVal(node.defenseNode,data.naturedamage,data.naturedamagePercent)
	self:SetNodeVal(node.assistNode,data.petdamage,data.petdamagePercent)
	node:SetActive(true)
end

function UIBattleStatisticsView:SetNodeVal(node,totalVal,percent)
	node.actorVal.image.fillAmount = percent
	node.percentVal.text.text = CommonUtil.FormatNumber(totalVal)
end

function UIBattleStatisticsView:SetNodeValPercent(node,totalVal,actorVal,percent)
	node.totalVal.image.fillAmount = totalVal
	node.actorVal.image.fillAmount = actorVal
	node.percentVal.text.text = CommonUtil.GetPreciseDecimal(percent*100,2) .. "%"
end

function UIBattleStatisticsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleStatisticsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)

	self.uiBase:AddToggleEventListener(self.StatisticsTog.toggle, self, self.OnValueChangedToggle, 1)
	self.uiBase:AddToggleEventListener(self.SkillTog.toggle, self, self.OnValueChangedToggle, 2)

	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onBeginDrag = function()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Enable_Scroll_Skill_Pnl,true)
	end

	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onPointerUp = function()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Enable_Scroll_Skill_Pnl,false)
	end

	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onEndDrag = function()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Enable_Scroll_Skill_Pnl,false)
	end
	-- self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onPointerExit = function()
	-- 	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Enable_Scroll_Skill_Pnl,false)
	-- end

	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onDrag = function()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Scroll_Skill_Pnl)
	end
end

function UIBattleStatisticsView:OnHide()
end

function UIBattleStatisticsView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleStatisticsView:OnClose()
	self:DestroyGOes()
	self.initSkillPnl = false
	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onBeginDrag = nil
	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onDrag = nil
	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onPointerUp = nil
	self.SkillPnl.skillsInfoNode.content.uIEventTriggerListener.onPointerExit = nil
	self.statisticsActorNodes  = nil 
	self.friendSkillActorNodes = nil
	self.bossSkillActorNodes = nil
	self.enemySkillActorNodes = nil
	self.enemySkillPoints = nil
	self.friendSkillPoints = nil
	if self.skillNodeList ~= nil then
		for i= 1, #self.skillNodeList do
			CommonUtil.DestroyGO(self.skillNodeList[i])
		end
		self.skillNodeList = nil
	end
	self.data = nil
	self:CleanTimer()
	if self.delayShowSkillPnl  ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.delayShowSkillPnl)
        self.delayShowSkillPnl = nil
	end
end

function UIBattleStatisticsView:OnDispose()
	self.controller:OnDispose()
end

function UIBattleStatisticsView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleStatistics)
end

function UIBattleStatisticsView:OnValueChangedToggle(toggle,toggleType, isOn)
	if isOn then
		if toggleType == 1 then
			self.curToggleType = 1
			self:ShowStatisticsPnl()
		elseif toggleType == 2 then
			self.curToggleType = 2
			self:ShowSkillPnl()
		end
	end
end

function UIBattleStatisticsView:CleanTimer()
	if self.scrollTimer~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.scrollTimer)
        self.scrollTimer = nil
    end
end

function UIBattleStatisticsView:DestroyGOes()
	if self.timeNodes ~= nil then
		for i = 10, #self.timeNodes do
			CommonUtil.DestroyGO(self.timeNodes[i])
		end
	end

	self.timeNodes = nil
end

return UIBattleStatisticsView

